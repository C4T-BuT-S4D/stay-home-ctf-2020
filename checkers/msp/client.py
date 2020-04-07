import math
import random
from checklib import Status
from fun_payloads import payloads

PORT = 5001


class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, checker):
        self.c = checker
        self.port = PORT

    def telemetry(self, s, idx):
        url = f'{self.url}/telemetry/{idx}'

        response = s.get(url)

        self.c.assert_eq(response.status_code, 200, "GROUND TERMINAL ERROR")

        response_body = self.c.get_json(response, "GROUND TERMINAL ERROR",
                                        Status.MUMBLE)

        if 'error' in response_body or 'object' not in response_body:
            self.c.cquit(Status.MUMBLE, "GROUND TERMINAL ERROR",
                         '/telemetry/ error: ' + response['error'])

        return response_body['object']

    def beam(self, s, idx, angle):
        url = f'{self.url}/beam/{idx}'

        response = s.post(url, json=dict(angle=angle))

        self.c.assert_eq(response.status_code, 200, "RELAY ERROR")

        response_body = self.c.get_json(response, "RELAY ERROR", Status.MUMBLE)

        if 'error' in response_body or 'responses' not in response_body:
            self.c.cquit(Status.MUMBLE, "RELAY ERROR",
                         '/beam/ error: ' + response['error'])

        return ' '.join(response_body['responses'])

    def health_check(self, s):
        url = f'{self.url}/worker/health'
        response = s.get(url)
        response_body = self.c.get_json(response, "GROUND EQUIPMENT ERROR",
                                        Status.MUMBLE)
        self.c.assert_in('result', response_body, "GROUND EQUIPMENT ERROR",
                         Status.MUMBLE)

        self.c.assert_eq(response_body['result'], "responsive",
                         "GROUND EQUIPMENT ERROR", Status.MUMBLE)

    def thrust(self, s, idx, angle, duration):
        url = f'{self.url}/thrust/{idx}'

        response = s.post(url, json=dict(
            angle=angle,
            duration=duration,
        ))

        self.c.assert_eq(response.status_code, 200, "ENGINE ERROR")

        response_body = self.c.get_json(response, "ENGINE ERROR",
                                        Status.MUMBLE)

        if 'error' in response_body:
            self.c.cquit(Status.MUMBLE, "ENGINE ERROR",
                         '/thrust/ error: ' + response['error'])

    @staticmethod
    def dist(x1, y1, x2, y2):
        return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

    @staticmethod
    def random_angle():
        return round(math.degrees(random.random() * math.pi * 2), 2)

    def launch(self, s, msg, low_orbit):
        url = f'{self.url}/launch/'

        if low_orbit:
            height = random.randint(5e3, 1e4)
            msg = random.choice(payloads)  # try to generate some fun
            af = random.choice([
                0.0041,
                0.0045,
                0.0051,
                0.0040,
                0.0044,
                0.0059,
            ])
        else:
            height = random.randint(1e8, 9e8)
            af = 0

        response = s.post(url,
                          json=dict(
                              phase=CheckMachine.random_angle(),
                              height=height,
                              antenna_focus=af,
                              narrow_beam_response=msg,
                              mass=100,
                          ))

        self.c.assert_eq(response.status_code, 200, "LAUNCH ABORT")

        response_body = self.c.get_json(response, "LAUNCH ABORT",
                                        Status.MUMBLE)

        if 'error' in response_body:
            self.c.cquit(Status.MUMBLE, "LAUNCH FAILURE",
                         '/launch/ error: ' + response['error'])

        if 'id' not in response_body:
            self.c.cquit(Status.MUMBLE, "LAUNCH FAILURE",
                         '/launch/ error: id not in response')

        idx = response_body['id']

        if 'position' not in response_body or len(
                response_body['position']) != 2:
            self.c.cquit(Status.MUMBLE, "LAUNCH FAILURE",
                         '/launch/ error: position has invalid format')

        pos_x, pos_y = response_body['position']

        if abs(CheckMachine.dist(0, 0, pos_x, pos_y) - height) > 10:
            self.c.cquit(Status.MUMBLE, "ORBIT NOT REACHED",
                         '/launch/ error: position with invalid height')

        return idx, height, pos_x, pos_y
