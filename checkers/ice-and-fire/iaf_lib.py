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

    def me(self, s, u, status=Status.MUMBLE):
        url = f'{self.url}/me/'

        data = s.get(url).content
        req = MyData()
        req.ParseFromString(data)

        self.c.assert_eq(req.user.username, u.username, "Invalid username on me", status)
        self.c.assert_eq(req.user.password, u.password, "Invalid password on me", status)
        self.c.assert_eq(req.contact.text, u.contact, "Invalid contact on me", status)

    def users(self, s, u):
        url = f'{self.url}/users/'

        data = s.get(url).content
        req = UserList()
        req.ParseFromString(data)

        user_list = [
            u for u in req.username
        ]

        return user_list

    def match(self, s, username):
        url = f'{self.url}/match/'

        req = MatchRequest()
        req.username = username

        req = req.SerializeToString()

        data = s.post(url, data=req).content

        match = Match()
        match.ParseFromString(data)

        return match

    def check_metric(self):
        for i in range(15):
            s1 = get_initialized_session()
            u1 = User()
            self.register(s1, u1)
            self.login(s1, u1)
            self.me(s1, u1)

            s2 = get_initialized_session()
            u2 = User()
            self.register(s2, u2)
            self.login(s2, u2)
            self.me(s2, u2)

            s3 = get_initialized_session()
            u3 = User()
            self.register(s3, u3)
            self.login(s3, u3)
            self.me(s3, u3)

            a = self.match(s1, u2.username)
            b = self.match(s1, u3.username)
            c = self.match(s2, u3.username)

            self.c.assert_eq(a.ok, False, "Invalid distance function")
            self.c.assert_eq(b.ok, False, "Invalid distance function")
            self.c.assert_eq(c.ok, False, "Invalid distance function")

            if b.distance >= a.distance + c.distance:
                self.c.cquit(Status.MUMBLE, "Distance function is not metric")