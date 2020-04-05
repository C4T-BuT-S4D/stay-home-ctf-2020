import requests
from structs_pb2 import *
from checklib import *

PORT = 31337


class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, checker):
        self.c = checker
        self.port = PORT

    def register(self):
        url = f'{self.url}/register/'

        req = RegisterRequest()
        req.user.username = rnd_username()
        req.user.password = rnd_password()
        for i in range(16):
            req.coordinates.append(1)
        req.contact.text = rnd_string(20)

        s = req.SerializeToString()

        r = requests.post(url, data=s)
        print(r.content)

    def list(self):
        url = f'{self.url}/users/'

        r = requests.get(url)

        req = UserList()
        req.ParseFromString(r.content)
        print(req)