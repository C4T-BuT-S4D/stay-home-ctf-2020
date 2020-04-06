import asyncio
import asyncpg
import math
import datetime
import logging
import uuid
from aiochannel import Channel
from asyncpg.pgproto.types import Point
from aiohttp import web

logging.basicConfig(level=logging.DEBUG)


class Universe:
    MU = 50e8
    ANT_MAX_ANGLE = 0.5
    DROP_ORBIT_H_MIN = 5000
    DROP_ORBIT_H_MID = 10000
    DROP_ORBIT_H_MAX = 900000
    MAX_DT = datetime.timedelta(seconds=5)
    LAG_TPS = 5
    GOOD_TPS = 30


def object_from_row(row):
    return Object(
        idx=row['id'],
        position=row['position'],
        velocity=row['velocity'],
        mass=row['mass'],
        refreshed_at=row['refreshed_at'],
        narrow_beam_response=row['narrow_beam_response'],
        antenna=row['antenna'],
    )


def normalize_height(a):

    return max(Universe.DROP_ORBIT_H_MIN, min(Universe.DROP_ORBIT_H_MAX, a))


def object_from_config(cfg):

    phase = math.radians(cfg['phase'])
    Ph = normalize_height(cfg.get('height', 0))
    pos = Point(Ph * math.sin(phase), Ph * math.cos(phase))
    speed = math.sqrt(Universe.MU / Ph)
    vel = Point(
        speed * math.sin(phase + math.pi / 2),
        speed * math.cos(phase + math.pi / 2),
    )

    ant_a = Universe.DROP_ORBIT_H_MAX * 2
    if Ph >= Universe.DROP_ORBIT_H_MID:
        ant_a = 0
        ant_b = 0
    else:
        ant_angl = min(Universe.ANT_MAX_ANGLE,
                       math.radians(cfg['antenna_focus']))
        ant_b = ant_a * math.sin(ant_angl)

    obj = Object(
        idx=str(uuid.uuid4()),
        position=pos,
        velocity=vel,
        mass=cfg['mass'],
        refreshed_at=now(),
        narrow_beam_response=cfg['narrow_beam_response'],
        antenna=Point(ant_a, ant_b),
    )

    return obj


def now():
    return datetime.datetime.now(datetime.timezone.utc)


class Object():
    def __init__(self, idx, position, velocity, mass, refreshed_at,
                 narrow_beam_response, antenna):

        self.idx = idx
        self.position = position
        self.velocity = velocity
        self.mass = mass
        self.narrow_beam_response = narrow_beam_response
        self.antenna = antenna
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
            antenna_a=self.antenna[0],
            antenna_b=self.antenna[1],
        )

    def angle(self):

        return math.atan2(self.position[1], self.position[0])

    def distance_to_sun(self):

        return math.hypot(self.position[0], self.position[1])

    def acceleration(self):

        dist = self.distance_to_sun()

        force = -Universe.MU / (dist * dist)

        angle = self.angle()

        return Point(
            force * math.cos(angle),
            force * math.sin(angle),
        )

    def update(self):

        T = now()
        dt = (T - self.refreshed_at).total_seconds()

        maxdt = Universe.MAX_DT
        if dt > maxdt.total_seconds():
            dt = maxdt.total_seconds()
            T = self.refreshed_at + maxdt

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

        self.app = web.Application(middlewares=[self.middleware])
        self.app.add_routes([
            web.get('/telemetry/{id}', self.telemetry),
            web.post('/beam/{id}', self.beam),
            web.post('/launch/', self.launch),
            web.static('/', './ui/'),
        ])

    @web.middleware
    async def middleware(self, request, handler):
        try:
            response = await handler(request)
            return response
        except Exception as e:
            self.logger.error('Error while processing request', str(e))
            return web.json_response(dict(error=str(e)))

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

    async def launch(self, request):

        config = await request.json()
        obj = object_from_config(config)

        async with self.conn.acquire() as conn:
            await conn.execute(
                '''INSERT INTO objects
            (id, position, velocity, mass, antenna, narrow_beam_response)
            VALUES
            ($1, $2, $3, $4, $5, $6)''',
                obj.idx,
                obj.position,
                obj.velocity,
                obj.mass,
                obj.antenna,
                obj.narrow_beam_response,
            )

        return web.json_response({
            "id": obj.idx,
            "position": list(obj.position)
        })

    async def beam(self, request):
        object_id = request.match_info['id']
        config = await request.json()
        angle = math.radians(config.get('angle', 0.0))

        async with self.conn.acquire() as conn:
            row = await conn.fetchrow('SELECT * FROM objects WHERE id=$1',
                                      object_id)

        if row is None:
            return web.json_response(dict(error="not found"))

        obj = object_from_row(row)

        A = obj.antenna[0]
        B = obj.antenna[1]
        s = math.sin(angle)
        c = math.cos(angle)

        p1 = Point(obj.position[0], obj.position[1])
        p2 = Point(p1[0] + A * s - B * c, p1[0] + A * c + B * s)
        p3 = Point(p1[0] + A * s + B * c, p1[0] + A * c - B * s)

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
                    polygon($1::text::path) @> position
                    order by created_at desc limit 128""", pathStr)

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
        self.queue = Channel(32)

    async def run(self):

        # avoid problems at startup
        async with self.conn.acquire() as conn:
            self.logger.info('Clock fast-forward')
            await conn.execute('UPDATE objects SET refreshed_at = NOW()')

        asyncio.ensure_future(self._dequeue())

        try:
            while True:
                await self._calc_stats()
                await self._tick()

        except asyncio.CancelledError:
            self.logger.info("Terminating gravity worker")
            self.queue.close()
            await self.queue.join()
            return

    async def _calc_stats(self):
        dt = now() - self.last_health_check
        if dt > Worker.HEALTH_CHECK_INTERVAL:
            tps = int(self.ticks /
                      Worker.HEALTH_CHECK_INTERVAL.total_seconds())
            self.logger.debug('Current TPS: {} ({} ticks)'.format(
                tps,
                self.ticks,
            ))
            self.last_health_check = now()
            self.ticks = 0

            if tps <= Universe.LAG_TPS:
                await self._cleanup()

    async def _cleanup(self):
        async with self.conn.acquire() as conn:
            await conn.execute('''
            DELETE FROM objects
            WHERE id IN
            (SELECT id FROM objects
             WHERE created_at < now() - interval '15 minutes'
             ORDER BY created_at asc)''')

    async def _dequeue(self):

        async with self.conn.acquire() as conn:
            async for obj in self.queue:
                await conn.execute(
                    '''
                    UPDATE objects SET
                        position = $2,
                        velocity = $3,
                        refreshed_at = $4
                    WHERE
                        id = $1
                ''', obj.idx, obj.position, obj.velocity, obj.refreshed_at)

    async def _tick(self):

        async with self.conn.acquire() as conn:
            rows = await conn.fetch('''
            SELECT * FROM objects
            ORDER BY refreshed_at asc
            LIMIT 128
            ''')

            if len(rows) == 0:
                await asyncio.sleep(1 / Universe.GOOD_TPS)

            for row in rows:

                obj = object_from_row(row)
                obj.update()
                await self.queue.put(obj)

            self.ticks += 1


async def run():

    conn = await asyncpg.create_pool(user='msp',
                                     password='msp',
                                     database='msp',
                                     host='db')

    logging.info('Connected to database')

    server = Webserver(conn, '0.0.0.0', '5001')
    worker = Worker(conn)

    await asyncio.wait([
        asyncio.create_task(server.run()),
        asyncio.create_task(worker.run()),
    ])

    await conn.close()


loop = asyncio.get_event_loop()
loop.run_until_complete(run())
