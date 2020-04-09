#!/usr/bin/env python3
import sys

from gevent import monkey

monkey.patch_all()

import random
import os
import string

from spacesos_lib import *


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.cm = CheckMachine(self)
        self.planets = self._read_planets()

    def _read_planets(self):
        planets_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'planets.txt')
        with open(planets_file) as f:
            return [x.strip() for x in f.readlines()]

    def shitty_payload(self):
        return random.choice([
            '{}..',
            'php_{}',
            '{}/',
            '{}',
            '{}',
            '{}',
            '{}',
            '{}',
        ])

    def random_user(self):
        return self.shitty_payload().format(rnd_username())

    def _random_planet(self):
        return random.choice(self.planets)

    def random_coordinates(self):
        return {
            'planet': self._random_planet(),
            'longitude': random.random() * 50,
            'latitude': random.random() * 50,
            'distance': random.randint(0, 50),
        }

    def check(self):
        try:
            # Register first user.
            username = self.random_user()
            password = rnd_password()
            _, _, sessionId = self.cm.register_user(username, password)

            # Register second user.
            secondUser = self.random_user()
            password = rnd_password()
            _, _, secondSessionId = self.cm.register_user(secondUser, password)

            # Add friendship request
            assert_eq(False, self.cm.add_to_friends(secondSessionId, username), 'Incorrect friendship response',
                      'should be not mutual')

            # Check friendship request
            assert_in(secondUser, self.cm.list_friendship_requests(sessionId), 'Failed to receive friendship requests')

            # Confirm friendship request
            assert_eq(True, self.cm.add_to_friends(sessionId, secondUser), 'Incorrect friendship response',
                      'should be mutual')

            # Assert friend's list can be received
            assert_in(secondUser, self.cm.get_friends(sessionId), "Failed to receive user's friends")
            assert_in(username, self.cm.get_friends(secondSessionId), "Failed to receive user's friends")

            token = self.shitty_payload().format(rnd_string(32, string.ascii_uppercase + string.digits))
            res = self.cm.add_crush(sessionId, token, self.random_coordinates())
            assert_in(secondUser, res, 'Incorrect response on crash send')
            crashes = self.cm.get_latest_crushes()
            names = [x.user for x in crashes]
            self.assert_in(username, names, "Failed to find latest crushes")


        except grpc.RpcError as rpc_error:
            details = rpc_error.details()
            if rpc_error.code() in [grpc.StatusCode.UNAVAILABLE, grpc.StatusCode.DEADLINE_EXCEEDED]:
                self.cquit(status.Status.DOWN, "Connection error", str(rpc_error))
                return
            self.cquit(status.Status.MUMBLE, details, str(rpc_error))
        except Exception as e:
            self.cquit(status.Status.ERROR, 'Error', str(e))
        else:
            self.cquit(status.Status.OK)

    def put(self, flag_id, flag, vuln):
        try:
            username = self.random_user()
            password = rnd_password()
            _, _, sessionId = self.cm.register_user(username, password)

            # Register second user.
            secondUser = self.random_user()
            second_password = rnd_password()
            _, _, secondSessionId = self.cm.register_user(secondUser, second_password)

            # Add friendship request
            assert_eq(False, self.cm.add_to_friends(secondSessionId, username), 'Incorrect friendship response',
                      'should be not mutual')

            # Confirm friendship request
            assert_eq(True, self.cm.add_to_friends(sessionId, secondUser), 'Incorrect friendship response',
                      'should be mutual')

            res = self.cm.add_crush(sessionId, flag, self.random_coordinates())

            assert_in(username, res, "Failed to receive crash response")
            assert_in(secondUser, res, "Failed to receive crash response")
        except grpc.RpcError as rpc_error:
            details = rpc_error.details()
            if rpc_error.code() in [grpc.StatusCode.UNAVAILABLE, grpc.StatusCode.DEADLINE_EXCEEDED]:
                self.cquit(status.Status.DOWN, "Connection error", str(rpc_error))
                return
            self.cquit(status.Status.MUMBLE, details, str(rpc_error))
        except Exception as e:
            self.cquit(status.Status.ERROR, 'Error', str(e))
        else:
            self.cquit(Status.OK, f'{username}:{password}:{secondUser}:{second_password}')

    def get(self, flag_id, flag, vuln):
        try:
            u, p, u2, p2 = flag_id.strip().split(':')
            user_1 = (u, p)
            user_2 = (u2, p2)
            for u in [user_1, user_2]:
                sessionId = self.cm.login_user(u[0], u[1])
                tokens = [x.spaceship_access_token for x in self.cm.get_crush(sessionId)]
                assert_in(flag, tokens, 'Failed to receive spaceship_access_token', status=status.Status.CORRUPT)
            crashes = self.cm.get_latest_crushes()
            names = [x.user for x in crashes]
            assert_in(user_1[0], names, 'Failed to receive public crash information', status=status.Status.CORRUPT)
        except grpc.RpcError as rpc_error:
            details = rpc_error.details()
            if rpc_error.code() in [grpc.StatusCode.UNAVAILABLE, grpc.StatusCode.DEADLINE_EXCEEDED]:
                self.cquit(status.Status.DOWN, "Connection error", str(rpc_error))
                return
            self.cquit(status.Status.MUMBLE, details, str(rpc_error))
        except Exception as e:
            self.cquit(status.Status.ERROR, 'Error', str(e))
        else:
            self.cquit(Status.OK)

if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)
    c.cm.chan.close()