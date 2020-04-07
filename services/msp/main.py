import asyncio
import asyncpg
import logging
from worker import Worker
from webserver import Webserver
from thrust import ThrustManager

logging.basicConfig(level=logging.DEBUG)


async def run():

    conn = await asyncpg.create_pool(user='msp',
                                     password='msp',
                                     database='msp',
                                     host='db')

    logging.info('Connected to database')

    tm = ThrustManager()
    server = Webserver(conn, '0.0.0.0', '5001', tm)
    worker = Worker(conn, tm)

    await asyncio.wait([
        asyncio.create_task(server.run()),
        asyncio.create_task(worker.run()),
    ])

    await conn.close()


loop = asyncio.get_event_loop()
loop.run_until_complete(run())
