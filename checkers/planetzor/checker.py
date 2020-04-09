#!/usr/bin/env python3
import random

from gevent import monkey

monkey.patch_all()

import sys
import requests
import string
import os
from planetzor_lib import *

sys.path.append(os.path.dirname(os.path.abspath(__file__)))


class Checker(BaseChecker):
    def __init__(self, *args, **kwargs):
        super(Checker, self).__init__(*args, **kwargs)
        self.mch = CheckMachine(self)
        self.planets = []
        self.reviews = []
        self._read_planets()
        self._read_reviews()

    def _read_planets(self):
        planets_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'planets.txt')
        with open(planets_file) as f:
            self.planets = [x.strip() for x in f.readlines()]

    def _read_reviews(self):
        reviews_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'reviews.txt')
        with open(reviews_file) as f:
            self.reviews = [x.strip() for x in f.readlines()]

    def _random_planet(self):
        return random.choice(self.planets)

    def _random_score(self):
        return random.randint(1, 5)

    def _random_review(self):
        return random.choice(self.reviews)

    def action(self, action, *args, **kwargs):
        try:
            super(Checker, self).action(action, *args, **kwargs)
        except requests.exceptions.ConnectionError:
            self.cquit(Status.DOWN, 'Connection error', 'Got requests connection error')

    def check(self):
        # Create user.
        username, password, sess = self.mch.register_user()

        # Create public review.
        planet = self._random_planet()
        score = self._random_score()
        content = self._random_review()
        self.mch.add_review(sess, planet, content, score, private=False)

        # Find public review.
        public_response = self.mch.get_public_reviews_response(sess, planet, score)
        self.assert_in(content, public_response.text, "Failed to find public review")

        # Create private review.
        private_review = rnd_string(30)
        self.mch.add_review(sess, self._random_planet(), private_review, self._random_score(), private=True)

        # Find private review and access_token.
        home_page_resp = self.mch.get_home_page(sess)
        self.assert_in(private_review, home_page_resp.text, "Failed to get private review")
        access_link = self.mch.get_publish_link(home_page_resp)

        # Register a 'friend'.
        username, password, sess = self.mch.register_user()
        # Follow publisher link to get feed.
        feed_response = self.mch.use_token_link(sess, access_link)
        # Assert both reviews are in feed.
        self.assert_in(private_review, feed_response.text, 'Failed to get user feed')
        self.assert_in(content, feed_response.text, 'Failed to get user feed')

        self.cquit(Status.OK)

    def put(self, flag_id, flag, vuln):
        username, password, sess = self.mch.register_user()

        # Add flag review.
        self.mch.add_review(sess, self._random_planet(), flag, self._random_score(), private=True)

        # Add public review.
        public_review = rnd_string(32, string.ascii_uppercase + string.digits)
        public_planet = self._random_planet()
        self.mch.add_review(sess, public_planet, public_review, self._random_score(), private=False)

        # Return username, password, public planet and review.
        self.cquit(Status.OK, f'{username}:{password}:{public_planet}:{public_review}')

    def get(self, flag_id, flag, vuln):
        u, p, p_planet, p_review = flag_id.split(':')

        sess = self.mch.login_user(u, p)

        home_response = self.mch.get_home_page(sess)

        self.assert_in(flag, home_response.text, 'Failed to get private review', status.Status.CORRUPT)
        self.assert_in(p_review, home_response.text, 'Failed to get public review', status.Status.CORRUPT)

        # response = self.mch.get_public_reviews_response(sess, planet=p_planet)
        #
        # self.assert_in(p_review, response.text, 'Failed to find public review', status.Status.CORRUPT)

        self.cquit(Status.OK)


if __name__ == '__main__':
    c = Checker(sys.argv[2])

    try:
        c.action(sys.argv[1], *sys.argv[3:])
    except c.get_check_finished_exception():
        cquit(Status(c.status), c.public, c.private)
