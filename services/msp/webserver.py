import math
import logging
from asyncpg.pgproto.types import Point
from aiohttp import web
from obj import object_from_row
from obj import object_from_config


class Webserver():
    def __init__(self, conn, host, port, tm):

        self.conn = conn
        self.host = host
        self.port = port
        self.logger = logging.getLogger('webserver')
        self.tm = tm

        self.app = web.Application(middlewares=[self.middleware])
        self.app.add_routes([
            web.get('/telemetry/{id}', self.telemetry),
            web.post('/beam/{id}', self.beam),
            web.post('/launch/', self.launch),
            web.post('/thrust/{id}', self.thrust),
            web.get('/{element}/health', self.health),
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
        focus = config.get('focus', 0.0)

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
        p1 = Point(p1[0] + focus * s, p1[1] + focus * c)

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
                    and narrow_beam_response != ''
                    order by created_at desc limit 128""", pathStr)

        responses = [row['narrow_beam_response'] for row in rows]
        self.logger.debug('Got {} narrow beam responses from {}'.format(
            len(responses), object_id))

        return web.json_response({"responses": responses})

    async def thrust(self, request):
        object_id = request.match_info['id']
        config = await request.json()

        angle = math.radians(config.get('angle', 0.0))
        duration = float(config.get('duration', 0.0))

        self.logger.debug(
            f'adding thrust command to {object_id}: angle={angle} duration={duration}'
        )

        await self.tm.push(object_id, dict(
            angle=angle,
            duration=duration,
        ))

        return web.json_response({})

    async def health(self, request):
        element = request.match_info['element']
        return web.json_response(
            dict(
                result="responsive",
                stats=list(getattr(self, element).health),
            ))
