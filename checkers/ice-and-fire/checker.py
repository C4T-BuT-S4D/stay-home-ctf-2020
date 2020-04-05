#!/usr/bin/env python3

from gevent import monkey

monkey.patch_all()

import sys
import os
import requests
import google.protobuf.message

from checklib import *

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
        s = get_initialized_session()

        u = User()

        self.mch.register(s, u)
        self.mch.login(s, u)
        self.mch.me(s, u)

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        s = get_initialized_session()

        u = User(contact=flag)

        self.mch.register(s, u)

        self.cquit(Status.OK, f'{u.username}:{u.password}')

    def get(self, flag_id, flag, vuln):
        s = get_initialized_session()
        uu, up = flag_id.split(':')
        u = User(u=uu, p=up, contact=flag)

        self.mch.login(s, u)
        self.mch.me(s, u)

        self.mch.users(s, u)

        self.cquit(Status.OK)


if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)