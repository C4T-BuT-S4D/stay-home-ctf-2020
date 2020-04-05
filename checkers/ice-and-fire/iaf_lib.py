import requests
from proto.structs_pb2 import *
from checklib import *
from random import random

PORT = 31337

class User:
    def __init__(self, u=None, p=None, coordinates=None, contact=None):
        self.username = u if u is not None else rnd_username()
        self.password = p if p is not None else rnd_password()
        self.coordinates = coordinates if coordinates is not None else [
            self.rnd_coord() for _ in range(16)
        ]
        self.contact = contact if contact is not None else rnd_string(20)

    def rnd_coord(self):
        return 10000 * (random() - 0.5)

class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, checker):
        self.c = checker
        self.port = PORT

    def register(self, s, u):
        url = f'{self.url}/register/'

        req = RegisterRequest()
        req.user.username = u.username
        req.user.password = u.password
        for c in u.coordinates:
            req.coordinates.append(c)
        req.contact.text = u.contact

        req = req.SerializeToString()

        r = s.post(url, data=req)

        self.c.assert_eq(r.status_code, 200, "Can't register")

    def login(self, s, u):
        url = f'{self.url}/login/'

        req = LoginRequest()
        req.user.username = u.username
        req.user.password = u.password

        req = req.SerializeToString()

        r = s.post(url, data=req)

        self.c.assert_eq(r.status_code, 200, "Can't login")

    def me(self, s, u):
        url = f'{self.url}/me/'

        data = s.get(url).content
        req = MyData()
        req.ParseFromString(data)

        self.c.assert_eq(req.user.username, u.username, "Invalid username on /me/", Status.CORRUPT)
        self.c.assert_eq(req.user.password, u.password, "Invalid password on /me/", Status.CORRUPT)
        self.c.assert_eq(req.contact.text, u.contact, "Invalid contact on /me/", Status.CORRUPT)

    def users(self, s, u):
        url = f'{self.url}/users/'

        data = s.get(url).content
        req = UserList()
        req.ParseFromString(data)

        user_list = [
            u for u in req.username
        ]

        self.c.assert_in(u.username, user_list, "Can't find user", Status.CORRUPT)