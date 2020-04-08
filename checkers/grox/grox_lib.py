import requests
from checklib import *

PORT = 6666

class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}/api'

    def __init__(self, checker):
        self.c = checker
        self.port = PORT

    def register(self, s, u, p):
        url = f'{self.url}/register/'

        r = s.post(url, json={
            'username': u,
            'password': p
        })

        d = self.c.get_json(r, "Can't register")
        self.c.assert_eq(type(d), type({}), "Can't register")
        self.c.assert_in("ok", d, "Can't register")

    def login(self, s, u, p, status=Status.MUMBLE):
        url = f'{self.url}/login/'

        r = s.post(url, json={
            'username': u,
            'password': p
        })

        d = self.c.get_json(r, "Can't login", status=status)
        self.c.assert_eq(type(d), type({}), "Can't login", status=status)
        self.c.assert_in("ok", d, "Can't login", status=status)

    def get_me(self, s, u):
        url = f'{self.url}/me/'

        r = s.get(url)
        d = self.c.get_json(r, "Can't get me")
        self.c.assert_eq(type(d), type({}), "Can't get me")
        self.c.assert_in("ok", d, "Can't get me")
        self.c.assert_eq(type(d["ok"]), type({}), "Can't get me")
        self.c.assert_in("id", d["ok"], "Can't get me")
        self.c.assert_in("username", d["ok"], "Can't get me")
        self.c.assert_eq(u, d["ok"]["username"], "Can't get me")
        self.c.assert_eq(type(d["ok"]["id"]), type(0), "Can't get me")

        return d["ok"]["id"]

    def get_users(self, s, u, uid, status=Status.MUMBLE):
        url = f'{self.url}/user/list/'

        r = s.get(url)
        d = self.c.get_json(r, "Can't get user list", status=status)
        self.c.assert_eq(type(d), type({}), "Can't get user list", status=status)
        self.c.assert_in("ok", d, "Can't get user list", status=status)
        self.c.assert_eq(type(d["ok"]), type([]), "Can't get user list", status=status)
        self.c.assert_in({
            "username": u,
            "id": uid,
        }, d["ok"], "Can't find myself in user list", status=status)

    def get_user_empires(self, s, uid, eid, status=Status.MUMBLE):
        url = f'{self.url}/user/{uid}/empires/'

        r = s.get(url)
        d = self.c.get_json(r, "Can't get user empires", status=status)
        self.c.assert_eq(type(d), type({}), "Can't get user empires", status=status)
        self.c.assert_in("ok", d, "Can't get user empires", status=status)
        self.c.assert_eq(type(d["ok"]), type([]), "Can't get user empires", status=status)
        self.c.assert_in(eid, d["ok"], "Can't find empire in empires list", status=status)

    def create_empire(self, s, name):
        url = f'{self.url}/empire/create/'

        r = s.post(url, json={
            "name": name
        })

        d = self.c.get_json(r, "Can't create empire")
        self.c.assert_eq(type(d), type({}), "Can't create empire")
        self.c.assert_in("ok", d, "Can't create empire")
        self.c.assert_eq(type(d["ok"]), type(0), "Can't create empire")

        return d["ok"]

    def create_planet(self, s, name, info, graph):
        url = f'{self.url}/planet/create/'

        r = s.post(url, json={
            "name": name,
            "info": info,
            "graph": graph
        })

        d = self.c.get_json(r, "Can't create planet")
        self.c.assert_eq(type(d), type({}), "Can't create planet")
        self.c.assert_in("ok", d, "Can't create planet")
        self.c.assert_eq(type(d["ok"]), type(0), "Can't create planet")

        return d["ok"]

    def create_alliance(self, s, l, r, status=Status.MUMBLE):
        url = f'{self.url}/alliance/create/'

        r = s.post(url, json={
            "l": l,
            "r": r,
        })

        d = self.c.get_json(r, "Can't create alliance", status=status)
        self.c.assert_eq(type(d), type({}), "Can't create alliance", status=status)
        self.c.assert_in("ok", d, "Can't create alliance", status=status)
        self.c.assert_eq(type(d["ok"]), type(0), "Can't create alliance", status=status)

        return d["ok"]

    def get_empire(self, s, eid, name, nodes, links, status=Status.MUMBLE):
        url = f'{self.url}/empire/{eid}/'

        r = s.get(url)

        d = self.c.get_json(r, "Can't get empire", status=status)
        self.c.assert_eq(type(d), type({}), "Can't get empire", status=status)
        self.c.assert_in("ok", d, "Can't get empire", status=status)
        self.c.assert_eq(type(d["ok"]), type({}), "Can't get empire", status=status)
        self.c.assert_in("name", d["ok"], "Can't get empire", status=status)
        self.c.assert_in("nodes", d["ok"], "Can't get empire", status=status)
        self.c.assert_in("links", d["ok"], "Can't get empire", status=status)

        self.c.assert_eq(d["ok"]["name"], name, "Can't get empire", status=status)

        self.c.assert_eq(type(d["ok"]["nodes"]), type([]), "Can't get empire", status=status)
        for i in d["ok"]["nodes"]:
            self.c.assert_eq(type(i), type(0), "Can't get empire", status=status)
        self.c.assert_eq(sorted(d["ok"]["nodes"]), sorted(nodes), "Can't get empire", status=status)

        self.c.assert_eq(type(d["ok"]["links"]), type([]), "Can't get empire", status=status)
        for i in d["ok"]["links"]:
            self.c.assert_eq(type(i), type([]), "Can't get empire", status=status)
            for j in i:
                self.c.assert_eq(type(j), type(0), "Can't get empire", status=status)
        self.c.assert_eq(sorted(d["ok"]["links"]), sorted(links), "Can't get empire", status=status)

    def get_planet(self, s, pid, name, info, status=Status.MUMBLE):
        url = f'{self.url}/planet/{pid}/'

        r = s.get(url)

        d = self.c.get_json(r, "Can't get planet", status=status)
        self.c.assert_eq(type(d), type({}), "Can't get planet", status=status)
        self.c.assert_in("ok", d, "Can't get planet", status=status)
        self.c.assert_eq(type(d["ok"]), type({}), "Can't get planet", status=status)

        self.c.assert_in("name", d["ok"], "Can't get planet", status=status)
        self.c.assert_eq(d["ok"]["name"], name, "Can't get planet", status=status)

        self.c.assert_in("info", d["ok"], "Can't get planet", status=status)
        self.c.assert_eq(d["ok"]["info"], info, "Can't get planet", status=status)