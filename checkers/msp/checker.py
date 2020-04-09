#!/usr/bin/env python3

from gevent import monkey
monkey.patch_all()

import sys
import os
import requests
import math
import string
import random
from base64 import b32encode
from time import sleep

from client import CheckMachine
from checklib import BaseChecker, Status, get_initialized_session
from checklib import rnd_username, rnd_password
from checklib import cquit

sys.path.append(os.path.dirname(os.path.abspath(__file__)))


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.mch = CheckMachine(self)

    def action(self, action, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.exceptions.ConnectionError:
            self.cquit(Status.DOWN, 'Connection error',
                       'Got requests connection error')
        except KeyError as e:
            self.cquit(Status.DOWN, 'Invalid response', 'KeyError: ' + str(e))

    def check(self):
        def yesno():
            return random.choice([True, False])

        do_health_check = yesno()
        do_height_check = yesno()
        do_thrust_check = not do_height_check and yesno()

        # simple health check first
        if do_health_check:
            s = get_initialized_session()
            self.mch.health_check(s)

        # gravity check
        s = get_initialized_session()

        # create a message
        msg = ''.join(random.choice(string.ascii_lowercase) for i in range(14))
        msg = b32encode(bytes(msg, 'ascii')).decode('ascii')

        # launch a craft
        idx, height, pos_x, pos_y = self.mch.launch(s, msg, False)
        target_telemetry = self.mch.telemetry(s, idx)

        old_velocity = target_telemetry.get('velocity', None)
        if old_velocity is None:
            self.cquit(Status.MUMBLE, "GROUND EQUIPMENT NOISE",
                       f'Object {idx} returned telemetry without velocity')

        # wait a bit
        if do_height_check:
            sleep(random.randint(5, 10))

            # receive a new telemetry
            target_telemetry = self.mch.telemetry(s, idx)
            new_pos = target_telemetry.get('position')
            new_x, new_y = new_pos[0], new_pos[1]
            old_velocity = target_telemetry.get('velocity', None)
            if old_velocity is None:
                self.cquit(
                    Status.MUMBLE, "GROUND EQUIPMENT NOISE",
                    f'Object {idx} returned telemetry without velocity')

            # ensure height did not change
            new_height = CheckMachine.dist(new_x, new_y, 0, 0)
            if abs(new_height - height) > 100:
                self.cquit(Status.MUMBLE, "DRAG DETECTED",
                           f'Object {idx} changed orbit without a reason')

            movement = CheckMachine.dist(pos_x, pos_y, new_x, new_y)

            # ensure position changed
            if movement == 0:
                self.cquit(Status.MUMBLE, "GRAVITY FAILURE",
                           f'Object {idx} did not move since creation')

        # thrust command
        # TODO
        # temporary disabled because it's retarded
        if False and do_thrust_check:
            thrust = random.randint(20, 40)
            self.mch.thrust(s, idx, CheckMachine.random_angle(), thrust)
            sleep(random.randint(5, 10))

            target_telemetry = self.mch.telemetry(s, idx)
            new_velocity = target_telemetry.get('velocity', (0, 0))

            # ensure speed actually changed
            speed_difference = CheckMachine.dist(old_velocity[0],
                                                 old_velocity[1],
                                                 new_velocity[0],
                                                 new_velocity[1])

            # TODO
            # ensure other orbital parameters also changed

            if speed_difference < thrust:
                self.cquit(
                    Status.MUMBLE, "ENGINE FAILURE",
                    f'Object {idx} did not change speed after the burn;' +
                    f'wanted dv: {thrust}; real dv: {speed_difference}')

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        s = get_initialized_session()
        idx, height, pos_x, pos_y = self.mch.launch(s, flag, False)
        self.mch.thrust(s, idx, CheckMachine.random_angle(), 10)
        self.cquit(Status.OK, f'{idx}:{height}:{pos_x}:{pos_y}')

    def get(self, flag_id, flag, vuln):

        s = get_initialized_session()
        idx, old_height, target_old_pos_x, target_old_pos_y = flag_id.split(
            ':')

        if random.choice([False] * 5 + [True]):
            self.mch.thrust(s, idx, CheckMachine.random_angle(), 1)

        old_height = float(old_height)

        # STEP0: launch a new craft
        source, _, source_pos_x, source_pos_y = self.mch.launch(s, flag, True)

        # STEP1: receive the telemetry, check stuff
        target_telemetry = self.mch.telemetry(s, idx)
        new_pos = target_telemetry.get('position')
        target_pos_x = new_pos[0]
        target_pos_y = new_pos[1]

        # orbit height should not really change
        if abs(
                CheckMachine.dist(target_pos_x, target_pos_y, 0, 0) -
                old_height) > 100:
            self.cquit(Status.MUMBLE, "GRAVITY FAILURE",
                       'Object orbit shifted too much since creation')

        # STEP2: create a beam request
        angle = math.degrees(
            math.atan2(
                source_pos_x - target_pos_x,
                source_pos_y - target_pos_y,
            ) + math.pi)

        focus = CheckMachine.dist(
            source_pos_x,
            source_pos_y,
            target_pos_x,
            target_pos_y,
        ) * 0.9

        beam_str = self.mch.beam(s, source, angle, focus)
        if flag not in beam_str:
            self.cquit(
                Status.MUMBLE,
                "FLAG NOT FOUND",
                f'Flag not found in beam reponse: {source}->{idx} at {angle}',
            )

        self.cquit(Status.OK)


if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)
