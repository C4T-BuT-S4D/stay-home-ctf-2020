#!/usr/bin/env python3

from gevent import monkey

monkey.patch_all()

import sys
import os
import requests

from checklib import *
from time import sleep

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from grox_lib import *


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.mch = CheckMachine(self)

    def action(self, action, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.exceptions.ConnectionError:
            self.cquit(Status.DOWN, 'Connection error', 'Got requests connection error')

    def check(self):
        sleep(2)
        s1 = get_initialized_session()
        u1, p1 = rnd_username(), rnd_password()

        self.mch.register(s1, u1, p1)
        self.mch.login(s1, u1, p1)
        uid1 = self.mch.get_me(s1, u1)
        self.mch.get_users(s1, u1, uid1)

        ename1 = rnd_string(10)
        eid1 = self.mch.create_empire(s1, ename1)

        pname1 = rnd_string(10)
        pinfo1 = rnd_string(10)
        pid1 = self.mch.create_planet(s1, pname1, pinfo1, eid1)

        pname2 = rnd_string(10)
        pinfo2 = rnd_string(10)
        pid2 = self.mch.create_planet(s1, pname2, pinfo2, eid1)

        lid1 = self.mch.create_alliance(s1, pid1, pid2)

        self.mch.get_user_empires(s1, uid1, eid1)

        self.mch.get_empire(s1, eid1, ename1, [pid1, pid2], [[lid1, pid1, pid2]])

        self.mch.get_planet(s1, pid1, pname1, pinfo1)

        sleep(3)

        s2 = get_initialized_session()
        u2, p2 = rnd_username(), rnd_password()

        self.mch.register(s2, u2, p2)
        self.mch.login(s2, u2, p2)
        uid2 = self.mch.get_me(s2, u2)
        self.mch.get_users(s2, u2, uid2)
        self.mch.get_users(s2, u1, uid1)

        ename3 = rnd_string(10)
        eid3 = self.mch.create_empire(s2, ename3)

        pname3 = rnd_string(10)
        pinfo3 = rnd_string(10)
        pid3 = self.mch.create_planet(s2, pname3, pinfo3, eid3)

        self.mch.create_alliance(s1, pid2, pid3)
        self.mch.create_alliance(s2, pid3, pid2)

        self.mch.get_user_empires(s2, uid1, eid1)
        self.mch.get_empire(s2, eid1, ename1, [pid1, pid2], [[lid1, pid1, pid2]])
        self.mch.get_planet(s2, pid2, pname2, pinfo2)

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        sleep(2)
        s = get_initialized_session()
        u, p = rnd_username(), rnd_password()

        self.mch.register(s, u, p)
        self.mch.login(s, u, p)
        uid = self.mch.get_me(s, u)

        ename = rnd_string(10)
        eid = self.mch.create_empire(s, ename)

        pname1 = rnd_string(10)
        pinfo1 = rnd_string(10)
        pid1 = self.mch.create_planet(s, pname1, pinfo1, eid)

        pname2 = rnd_string(10)
        pinfo2 = flag
        pid2 = self.mch.create_planet(s, pname2, pinfo2, eid)

        pname3 = rnd_string(10)
        pinfo3 = rnd_string(10)
        pid3 = self.mch.create_planet(s, pname3, pinfo3, eid)

        lid1 = self.mch.create_alliance(s, pid1, pid2)
        lid2 = self.mch.create_alliance(s, pid2, pid3)
        lid3 = self.mch.create_alliance(s, pid3, pid1)

        self.cquit(Status.OK, f'{uid}', f'{u}:{p}:{uid}:{eid}:{ename}:{pid1}:{pid2}:{pname2}:{pid3}:{lid1}:{lid2}:{lid3}')

    def get(self, flag_id, flag, vuln):
        sleep(2)
        s = get_initialized_session()
        u, p, uid, eid, ename, pid1, pid2, pname2, pid3, lid1, lid2, lid3 = flag_id.split(':')

        uid, eid, pid1, pid2, pid3, lid1, lid2, lid3 = map(int, [uid, eid, pid1, pid2, pid3, lid1, lid2, lid3])

        self.mch.get_user_empires(s, uid, eid, Status.CORRUPT)
        self.mch.get_empire(s, eid, ename, [pid1, pid2, pid3], [[lid1, pid1, pid2], [lid2, pid2, pid3], [lid3, pid3, pid1]], Status.CORRUPT)

        s_help = get_initialized_session()

        u_help, p_help = rnd_username(), rnd_password()

        self.mch.register(s_help, u_help, p_help)
        self.mch.login(s_help, u_help, p_help)

        self.mch.login(s, u, p, Status.CORRUPT)
        self.mch.get_planet(s, pid2, pname2, flag, Status.CORRUPT)

        ename_help = rnd_string(10)
        eid_help = self.mch.create_empire(s_help, ename_help)

        pname_help = rnd_string(10)
        pinfo_help = rnd_string(10)
        pid_help = self.mch.create_planet(s_help, pname_help, pinfo_help, eid_help)

        self.mch.create_alliance(s, pid2, pid_help, Status.CORRUPT)
        self.mch.create_alliance(s_help, pid_help, pid2, Status.CORRUPT)

        self.mch.get_planet(s_help, pid2, pname2, flag, Status.CORRUPT)

        self.cquit(Status.OK)


if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)