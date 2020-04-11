#!/usr/bin/env python3.7

from gevent import monkey
monkey.patch_all()

import os
import sys
import json
import enum
import random
import requests

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from exo_lib import *


class PlanetType(enum.IntEnum):
    Unknown = 0
    Terrestrial = 1
    Protoplanet = 2
    GasGiant = 3


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
        session = get_initialized_session()

        self.mch.health_check(session)

        starObj = Checker.generate_star()
        star = self.mch.add_star(session, starObj)

        planetObj = Checker.generate_planet(star['id'])
        planet = self.mch.add_planet(session, planetObj)

        self.mch.get_star(session, star['id'], starObj)
        self.mch.get_planet(session, planet['id'], planetObj)

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        session = get_initialized_session()

        star = self.mch.add_star(session, Checker.generate_star())
        planet = self.mch.add_planet(session, Checker.generate_planet(star['id'], flag))

        self.cquit(Status.OK, planet['id'], json.dumps([session.cookies.items(), star['id'], planet['id']]))

    def get(self, flag_id, flag, vuln):
        session = get_initialized_session()

        cookies, star_id, planet_id = json.loads(flag_id)

        star = self.mch.get_star(session, star_id)

        for name, value in cookies:
            session.cookies.set(name, value)

        planet = self.mch.get_planet(session, planet_id)

        self.assert_eq(planet['location'], flag, "Can't get flag", status=Status.CORRUPT)

        self.cquit(Status.OK)

    @staticmethod
    def generate_star():
        return {
            'name': rnd_string(32),
            'location': rnd_string(32)
        }

    @staticmethod
    def generate_planet(star_id, flag=None):
        type_ = random.choice([
            PlanetType.Protoplanet,
            PlanetType.Terrestrial,
            PlanetType.GasGiant
        ])

        return {
            'starId': star_id,
            'name': rnd_string(32),
            'location': flag or rnd_string(32),
            'type': type_,
            'isHidden': flag is not None
        }


if __name__ == '__main__':
    action, hostname, params = sys.argv[1], sys.argv[2], sys.argv[3:]

    checker = Checker(hostname)

    try:
        checker.action(action, *params)
    except checker.get_check_finished_exception():
        cquit(Status(checker.status), checker.public, checker.private)
