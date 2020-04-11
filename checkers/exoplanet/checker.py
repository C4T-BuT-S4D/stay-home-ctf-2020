#!/usr/bin/env python3.7

from gevent import monkey
monkey.patch_all()

import os
import sys
import json
import enum
import random
import requests
import traceback

from typing import List, Dict
from checklib import BaseChecker, Status, cquit, rnd_string


sys.path.append(os.path.dirname(os.path.abspath(__file__)))

with open('user_agents.txt', 'r') as file:
    USER_AGENTS = [line.strip() for line in file.readlines()]


class PlanetType(enum.IntEnum):
    Unknown = 0
    Terrestrial = 1
    Protoplanet = 2
    GasGiant = 3


class API:
    PORT = 17171

    def __init__(self, hostname: str):
        self._url = f'http://{hostname}:{API.PORT}'
        self._session = requests.session()
        self._session.default_timeout = 60
        self._session.headers = {'User-Agent': random.choice(USER_AGENTS)}
        return

    def close(self):
        self._session.close()
        return

    def get_cookies(self) -> List:
        return self._session.cookies.items()

    def set_cookies(self, cookies: List):
        for name, value in cookies:
            self._session.cookies.set(name, value)
        return

    def health_check(self) -> int:
        return self._session.get(self._url).status_code

    def get_all_stars(self) -> List[Dict]:
        return self._session.get(f'{self._url}/api/stars/').json()

    def get_star(self, star_id: str) -> Dict:
        return self._session.get(f'{self._url}/api/stars/{star_id}').json()

    def get_planet(self, planet_id: str) -> Dict:
        return self._session.get(f'{self._url}/api/planets/{planet_id}').json()

    def add_star(self, name: str, location: str) -> Dict:
        star = {
            'name': name,
            'location': location
        }
        return self._session.post(f'{self._url}/api/stars/', json=star).json()

    def add_planet(self, star_id: str, name: str, location: str, type_: PlanetType=PlanetType.Unknown, is_hidden: bool=False) -> Dict:
        planet = {
            'starId': star_id,
            'name': name,
            'location': location,
            'planetType': type_,
            'isHidden': is_hidden
        }
        return self._session.post(f'{self._url}/api/planets/', json=planet).json()


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self._api = API(self.host)
        return

    def check(self):
        try:
            status = self._api.health_check()
        except requests.RequestException:
            return self.cquit(Status.DOWN, 'Connection error', traceback.format_exc())

        if status != 200:
            return self.cquit(Status.MUMBLE, 'Failed to get the main page')

        return self.cquit(Status.OK)

    def put(self, flag_id: str, flag: str, vuln: str):
        star = self._api.add_star(
            self._random_name(), 
            self._random_location())

        if 'status' in star:
            return self.cquit(Status.MUMBLE, 'Failed to add a star', str(star))
        
        if 'id' not in star:
            return self.cquit(Status.MUMBLE, 'Incorrect star model')

        planet = self._api.add_planet(
            star['id'], 
            self._random_name(), 
            flag, 
            self._random_type(),
            True)

        if 'status' in planet:
            return self.cquit(Status.MUMBLE, 'Failed to add a planet', str(planet))

        if 'id' not in planet:
            return self.cquit(Status.MUMBLE, 'Incorrect planet model')

        if planet.get('location', '') != flag:
            return self.cquit(Status.MUMBLE, 'Failed to put a flag')

        return self.cquit(Status.OK, json.dumps([self._api.get_cookies(), star['id'], planet['id']]))

    def get(self, flag_id: str, flag: str, vuln: str):
        cookies, star_id, planet_id = json.loads(flag_id)

        stars = self._api.get_all_stars()
        if 'status' in stars:
            return self.cquit(Status.MUMBLE, 'Failed to get all stars', str(stars))

        for star in stars:
            if star['id'] == star_id:
                break
        else:
            return self.cquit(Status.CORRUPT, 'Failed to find a star', str(star))

        if planet_id not in star['planets']:
            return self.cquit(Status.CORRUPT, 'Failed to find a planet in star')

        self._api.set_cookies(cookies)

        planet = self._api.get_planet(planet_id)
        if 'status' in planet:
            return self.cquit(Status.MUMBLE, 'Failed to get a planet', str(planet))

        if planet.get('location', '') != flag:
            return self.cquit(Status.CORRUPT, 'Incorrect flag')

        return self.cquit(Status.OK)

    def action(self, action: str, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.exceptions.ContentDecodingError as e:
            self.cquit(Status.MUMBLE, 'Bad json', traceback.format_exc())
        except requests.RequestException as e:
            self.cquit(Status.DOWN, 'Connection error', traceback.format_exc())
        finally:
            self._api.close()

    def _random_name(self, length: int=32) -> str:
        return rnd_string(length)

    def _random_location(self, length: int=32) -> str:
        return rnd_string(length)

    def _random_type(self) -> PlanetType:
        return random.choice([
            PlanetType.Terrestrial,
            PlanetType.Protoplanet,
            PlanetType.GasGiant
        ])


if __name__ == '__main__':
    action, hostname, params = sys.argv[1], sys.argv[2], sys.argv[3:]
    
    checker = Checker(hostname)

    try:
        checker.action(action, *params)
    except checker.get_check_finished_exception():
        cquit(Status(checker.status), checker.public, checker.private)
