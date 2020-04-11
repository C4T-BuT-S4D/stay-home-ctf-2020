import requests
import random
from checklib import *

PORT = 17171

class PlanetType:
    Unknown = 0
    Terrestrial = 1
    Protoplanet = 2
    GasGiant = 3

class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, checker):
        self.c = checker
        self.port = PORT

    def health_check(self, s):
        url = self.url

        r = s.get(self.url)

        self.c.assert_eq(r.status_code, 200, "Can't get the main page")

    def add_star(self, s, name, location):
        url = f"{self.url}/api/stars"

        star = {
            'name': name,
            'location': location
        }

        r = s.post(url, json=star)

        d = self.c.get_json(r, "Can't add star")

        self.c.assert_nin("status", d, "Can't add star")
        self.c.assert_in("id", d, 'Incorrect star model')

        return d

    def add_planet(self, s, star_id, name, location, type_=PlanetType.Unknown, is_hidden=False):
        url = f'{self.url}/api/planets/'

        planet = {
            'starId': star_id,
            'name': name,
            'location': location,
            'planetType': type_,
            'isHidden': is_hidden
        }

        r = s.post(url, json=planet)

        d = self.c.get_json(r, "Can't add planet")

        self.c.assert_nin("status", d, "Can't add planet")
        self.c.assert_in("id", d, 'Incorrect planet model')
        self.c.assert_in("location", d, "Can't add planet")

        self.c.assert_eq(location, d["location"], "Can't add planet")

        return d

    def get_stars(self, s, star_id, planet_id):
        url = f'{self.url}/api/stars/'

        r = s.get(url)

        d = self.c.get_json(r, "Can't list stars")

        self.c.assert_eq(type(d), type([]), "Can't list stars")

        for s in d:
            self.c.assert_eq(type(s), type({}), "Invalid stars on list")
            self.c.assert_in("id", s, "Invalid stars on list")
            self.c.assert_in("planets", s, "Invalid stars on list")
            self.c.assert_eq(type(s["planets"]), type([]), "Invalid stars on list")
            if s["id"] == star_id:
                self.c.assert_in(planet_id, s["planets"], "Can't find star", status=Status.CORRUPT)
                break
        else:
            self.c.cquit(Status.CORRUPT, "Can't find star")

    def get_planet(self, s, planet_id, flag):
        url = f'{self.url}/api/planets/{planet_id}'

        r = s.get(url)

        d = self.c.get_json(r, "Can't get planet", status=Status.CORRUPT)

        self.c.assert_eq(type(d), type({}), "Can't get planet", status=Status.CORRUPT)
        self.c.assert_nin("status", d, "Can't get planet", status=Status.CORRUPT)
        self.c.assert_in("location", d, "Can't get planet", status=Status.CORRUPT)

        self.c.assert_eq(d["location"], flag, "Can't get flag in planet", status=Status.CORRUPT)

        return d

    def _random_name(self, length=32):
        return rnd_string(length)

    def _random_location(self, length=32):
        return rnd_string(length)

    def _random_type(self) -> PlanetType:
        return random.choice([
            PlanetType.Terrestrial,
            PlanetType.Protoplanet,
            PlanetType.GasGiant
        ])