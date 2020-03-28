import asyncio
import asyncpg
import math
import datetime
import logging

from asyncpg.pgproto.types import Point
from aiohttp import web

logging.basicConfig(level=logging.DEBUG)


class Universe:
    SUN_MASS = 50000
    GRAVITY_CONST = 1
    TIME_WARP = 1000
    TARGET_TPS = 60

    A_A = 10000
    A_B = 5


def object_from_row(row):
    return Object(
        idx=row['id'],
        position=row['position'],
        velocity=row['velocity'],
        mass=row['mass'],
        refreshed_at=row['refreshed_at'],
        narrow_beam_response=row['narrow_beam_response'],
        antenna_a=row['antenna_a'],
        antenna_b=row['antenna_b'],
    )


def now():
    return datetime.datetime.now(datetime.timezone.utc)


class Object():
    def __init__(self, idx, position, velocity, mass, refreshed_at,
                 narrow_beam_response, antenna_a, antenna_b):

        self.idx = idx
        self.position = position
        self.velocity = velocity
        self.mass = mass
        self.narrow_beam_response = antenna_a,
        self.antenna_a = antenna_a
        self.antenna_b = antenna_b
        self.refreshed_at = refreshed_at
        self.logger = logging.getLogger('object::' + str(idx))

    def debug(self):

        self.logger.debug('Object data', self.encode())

    def encode(self):
        return dict(
            idx=str(self.idx),
            position=self.position,
            velocity=self.velocity,
            mass=self.mass,
            dist=self.distance_to_sun(),
            acc=self.acceleration(),
            angle=self.angle(),
            refreshed_at=self.refreshed_at.isoformat(),
            antenna_a=self.antenna_a,
            antenna_b=self.antenna_b,
        )

    def angle(self):

        return math.atan2(self.position[1], self.position[0])

    def distance_to_sun(self):

        return math.hypot(self.position[0], self.position[1])

    def acceleration(self):

        dist = self.distance_to_sun()

        force = -Universe.GRAVITY_CONST * Universe.SUN_MASS / (dist * dist)

        angle = self.angle()

        return Point(
            force * math.cos(angle),
            force * math.sin(angle),
        )

    def update(self):

        T = now()

        dt = (T - self.refreshed_at).total_seconds() * Universe.TIME_WARP

        acc = self.acceleration()

        # update velocity

        self.velocity = Point(
            self.velocity[0] + acc[0] * dt,
            self.velocity[1] + acc[1] * dt,
        )

        # update position

        self.position = Point(
            self.position[0] + self.velocity[0] * dt,
            self.position[1] + self.velocity[1] * dt,
        )

        # update refreshed_at
        self.refreshed_at = T


class Webserver():
    def __init__(self, conn, host, port):

        self.conn = conn
        self.host = host
        self.port = port
        self.logger = logging.getLogger('webserver')

        self.app = web.Application(middlewares=[self.cors_middleware])
        self.app.add_routes([
            web.get('/telemetry/{id}', self.telemetry),
            web.get('/beam/{id}', self.beam),
            web.static('/', './ui/'),
        ])

    @web.middleware
    async def cors_middleware(self, request, handler):
        response = await handler(request)
        # response.headers['Access-Control-Allow-Origin'] = '*'
        return response

    async def run(self):
        runner = web.AppRunner(self.app)
        await runner.setup()
        self.logger.info('Starting web server on {}:{}'.format(
            self.host, self.port))
        self.site = web.TCPSite(runner, self.host, self.port)

        await self.site.start()

    async def close(self):
        if self.site:
            await self.site.cleanup()

    async def telemetry(self, request):

        object_id = request.match_info['id']

        async with self.conn.acquire() as conn:
            row = await conn.fetchrow('SELECT * FROM objects WHERE id=$1',
                                      object_id)

        if row is None:
            return web.json_response(dict(error="not found"))

        obj = object_from_row(row)

        return web.json_response({"object": obj.encode()})

    async def beam(self, request):
        object_id = request.match_info['id']
        angle = math.radians(float(request.query.get('angle', '0')))

        async with self.conn.acquire() as conn:
            row = await conn.fetchrow('SELECT * FROM objects WHERE id=$1',
                                      object_id)

        if row is None:
            return web.json_response(dict(error="not found"))

        obj = object_from_row(row)

        A = obj.antenna_a
        B = obj.antenna_b
        s = math.sin(angle)
        c = math.cos(angle)

        p1 = Point(
            obj.position[0],
            obj.position[1],
        )

        p2 = Point(
            p1[0] + A * s - B * c,
            p1[0] + A * c + B * s,
        )

        p3 = Point(
            p1[0] + A * s + B * c,
            p1[0] + A * c - B * s,
        )

        pathStr = '(({}, {}), ({}, {}), ({}, {}))'.format(
            p1[0],
            p1[1],
            p2[0],
            p2[1],
            p3[0],
            p3[1],
        )

        async with self.conn.acquire() as conn:
            rows = await conn.fetch(
                """select narrow_beam_response from objects where
                    polygon($1::text::path) @> position""", pathStr)

        responses = [row['narrow_beam_response'] for row in rows]
        self.logger.debug('Got {} narrow beam responses from {}'.format(
            len(responses), object_id))

        return web.json_response({"responses": responses})


class Worker():

    HEALTH_CHECK_INTERVAL = datetime.timedelta(seconds=60)

    def __init__(self, conn):

        self.conn = conn
        self.logger = logging.getLogger('universe')
        self.last_health_check = now()
        self.ticks = 0

    async def run(self):

        # avoid problems at startup
        async with self.conn.acquire() as conn:
            self.logger.info('Clock fast-forward')
            await conn.execute('UPDATE objects SET refreshed_at = NOW()')

        try:
            while True:
                await self._tick()
                await asyncio.sleep(1 / Universe.TARGET_TPS)
        except asyncio.CancelledError:
            self.logger.info("Terminating gravity worker")
            return

    async def _tick(self):

        if now() - self.last_health_check > Worker.HEALTH_CHECK_INTERVAL:
            self.logger.debug('Current TPS: {}/{}'.format(
                int(self.ticks / Worker.HEALTH_CHECK_INTERVAL.total_seconds()),
                Universe.TARGET_TPS,
            ))
            self.last_health_check = now()
            self.ticks = 0

        async with self.conn.acquire() as conn:
            rows = await conn.fetch('SELECT * FROM objects')

            for row in rows:

                obj = object_from_row(row)

                # obj.debug()
                obj.update()

                await conn.execute(
                    '''
                    UPDATE objects SET
                        position = $2,
                        velocity = $3,
                        refreshed_at = $4
                    WHERE
                        id = $1
                ''', obj.idx, obj.position, obj.velocity, obj.refreshed_at)

            self.ticks += 1


async def run():
    conn = await asyncpg.create_pool(user='msp',
                                     password='msp',
                                     database='msp',
                                     host='127.0.0.1')
    logging.info('Connected to database')

    server = Webserver(conn, 'localhost', '5001')
    worker = Worker(conn)

    await asyncio.wait([
        asyncio.create_task(server.run()),
        asyncio.create_task(worker.run()),
    ])

    await conn.close()


loop = asyncio.get_event_loop()
loop.run_until_complete(run())
