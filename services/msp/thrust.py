import asyncio


class ThrustManager():
    def __init__(self):

        self._requests = dict()
        self._lock = asyncio.Lock()

    async def pop(self, idx):
        async with self._lock:
            return self._requests.pop(str(idx), None)

    async def push(self, idx, cmd):
        async with self._lock:
            self._requests[str(idx)] = cmd
