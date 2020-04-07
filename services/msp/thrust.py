import asyncio
import random


class ThrustManager():
    def __init__(self):

        self.requests = dict()
        self.lock = asyncio.Lock()
        self.health = set()

    async def pop(self, idx):
        async with self.lock:
            return self.requests.pop(str(idx), None)

    async def push(self, idx, cmd):
        async with self.lock:

            # cricial mechanism that allows to control
            # thrust QoS when the service is overloaded with requests
            self.health.add(idx)
            if len(self.health) > 128:
                self.health.remove(random.choice(list(self.health)))

            self.requests[str(idx)] = cmd
