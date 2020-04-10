#!/usr/bin/env python3

from gevent import monkey

monkey.patch_all()

import sys
import os
import requests
import google.protobuf.message
import copy

from checklib import *
from random import random

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from iaf_lib import *


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.mch = CheckMachine(self)

    def action(self, action, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.exceptions.ConnectionError:
            self.cquit(Status.DOWN, 'Connection error', 'Got requests connection error')
        except google.protobuf.message.DecodeError:
            self.cquit(Status.MUMBLE, 'Protobuf parsing error')

    def check(self):
        s1 = get_initialized_session()

        u1 = User()

        self.mch.register(s1, u1)
        self.mch.login(s1, u1)
        self.mch.me(s1, u1)

        s2 = get_initialized_session()

        u2 = User()

        self.mch.register(s2, u2)
        self.mch.login(s2, u2)
        self.mch.me(s2, u2)

        s3 = get_initialized_session()

        coords_noise = copy.copy(u2.coordinates)
        for i in range(16):
            coords_noise[i] += random() * 1e-9

        u3 = User(coordinates=coords_noise)

        self.mch.register(s3, u3)
        self.mch.login(s3, u3)
        self.mch.me(s3, u3)

        match1 = self.mch.match(s1, u2.username)
        match2 = self.mch.match(s2, u3.username)

        self.assert_eq(match1.ok, False, "Invalid user matching")
        self.assert_eq(match2.ok, True, "Invalid user matching")
        self.assert_eq(match2.contact.text, u3.contact, "Invalid contact on match")

        users = self.mch.users(s2)

        self.assert_in(u1.username, users, "Can't find user in user list", Status.MUMBLE)

        self.mch.check_metric()

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        s = get_initialized_session()

        u = User(contact=flag)

        self.mch.register(s, u)

        self.cquit(Status.OK, f'{u.username}', f'{u.username}:{u.password}:{",".join(map(str, u.coordinates))}')

    def get(self, flag_id, flag, vuln):
        s1 = get_initialized_session()
        uu, up, coordinates = flag_id.split(':')
        coordinates = list(map(float, coordinates.split(',')))
        u1 = User(u=uu, p=up, coordinates=coordinates, contact=flag)

        self.mch.login(s1, u1, status=Status.CORRUPT)
        self.mch.me(s1, u1, status=Status.CORRUPT)

        coords_noise = copy.copy(coordinates)
        for i in range(16):
            coords_noise[i] += random() * 1e-9

        s2 = get_initialized_session()
        u2 = User(coordinates=coords_noise)

        self.mch.register(s2, u2)
        self.mch.login(s2, u2)

        match = self.mch.match(s2, u1.username)

        self.assert_eq(match.ok, True, "Invalid user matching", status=Status.CORRUPT)
        self.assert_eq(match.contact.text, u1.contact, "Invalid contact on match", status=Status.CORRUPT)

        self.cquit(Status.OK)


if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)
