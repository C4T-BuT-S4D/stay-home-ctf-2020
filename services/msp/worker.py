import asyncio
import datetime
import logging
from aiochannel import Channel
from utils import now
from universe import Universe
from obj import object_from_row
import multiprocessing


class Worker():

    HEALTH_CHECK_INTERVAL = datetime.timedelta(seconds=60)

    def __init__(self, conn, tm):

        self.conn = conn
        self.logger = logging.getLogger('universe')
        self.last_health_check = now()
        self.ticks = 0
        self.queue = Channel(128)
        self.tm = tm
        self.health = []

    async def run(self):

        async with self.conn.acquire() as conn:
            self.logger.info('Clock fast-forward')
            await conn.execute('UPDATE objects SET refreshed_at = NOW()')

        for i in range(min(multiprocessing.cpu_count(), 4)):
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
            self.health = [tps, self.ticks]
            self.last_health_check = now()
            self.ticks = 0

            if tps <= Universe.LAG_TPS:
                await self._solar_flare()

    async def _solar_flare(self):
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
                        mass = $4,
                        refreshed_at = $5
                    WHERE
                        id = $1
                ''', obj.idx, obj.position, obj.velocity, obj.mass,
                    obj.refreshed_at)

    async def _tick(self):

        async with self.conn.acquire() as conn:
            rows = await conn.fetch('''
            SELECT * FROM objects
            ORDER BY refreshed_at asc
            LIMIT 1024
            ''')

            if len(rows) == 0:
                await asyncio.sleep(1 / Universe.GOOD_TPS)

            for row in rows:
                obj = object_from_row(row)
                tc = await self.tm.pop(obj.idx)
                obj.update(tc)
                await self.queue.put(obj)

            # avoid dupes in queue
            while not self.queue.empty():
                await asyncio.sleep(1 / Universe.GOOD_TPS)

            self.ticks += 1
