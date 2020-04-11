#!/usr/bin/env python3.7

from gevent import monkey
monkey.patch_all()

import os
import sys
import json

from typing import List, Dict

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from exo_lib import *



class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.mch = CheckMachine(self)

    def action(self, action, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.RequestException as e:
            self.cquit(Status.DOWN, 'Connection error', 'Got requests connection error')

    def check(self):
        s = get_initialized_session()

        self.mch.health_check(s)

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        s = get_initialized_session()

        star = self.mch.add_star(
            s,
            self.mch._random_name(),
            self.mch._random_location())

        planet = self.mch.add_planet(
            s,
            star['id'],
            self.mch._random_name(),
            flag,
            self.mch._random_type(),
            True)

        self.mch.get_stars(s, star['id'], planet['id'])

        self.cquit(Status.OK, star['id'], json.dumps([s.cookies.items(), star['id'], planet['id']]))

    def get(self, flag_id, flag, vuln):
        s = get_initialized_session()

        cookies, star_id, planet_id = json.loads(flag_id)

         # TODO
         # CHECK THAT PLANET_ID IS IN PLANETS LIST FOR STAR

        for name, value in cookies:
            s.cookies.set(name, value)

        planet = self.mch.get_planet(s, planet_id, flag)

        self.cquit(Status.OK)




if __name__ == '__main__':
    action, hostname, params = sys.argv[1], sys.argv[2], sys.argv[3:]

    checker = Checker(hostname)

    try:
        checker.action(action, *params)
    except checker.get_check_finished_exception():
        cquit(Status(checker.status), checker.public, checker.private)
