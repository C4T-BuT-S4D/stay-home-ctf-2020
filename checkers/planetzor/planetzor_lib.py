from checklib import *
from bs4 import BeautifulSoup

PORT = 4000


class CheckMachine:
    @property
    def url(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, c: BaseChecker):
        self.c = c
        self.port = PORT

    def register_user(self, username=None, password=None):
        username = username or rnd_username()
        password = password or rnd_password()

        sess = get_initialized_session()

        r = sess.post(f'{self.url}/register', data={'login': username, 'password': password})
        self.c.check_response(r, 'Could not register')
        return username, password, sess

    def login_user(self, username, password):
        sess = get_initialized_session()
        r = sess.post(f'{self.url}/login', data={'login': username, 'password': password})
        self.c.check_response(r, 'Could not login')
        return sess

    def add_review(self, sess, planet, content, score, private=True):
        data = {'content': content, 'planet': planet, 'score': str(score), "private": "on" if private else "off"}
        response = sess.post(f'{self.url}/add', data=data)
        self.c.check_response(response, 'Could not add review')
        return

    def get_home_page(self, sess):
        response = sess.get(f'{self.url}/home')
        self.c.check_response(response, 'Could not get home page')
        return response

    def get_publish_link(self, response):
        sp = BeautifulSoup(response.text, features="lxml")
        p = sp.find('p', {'id': 'tokenLink'})
        token = p.find('a').get('href')
        if not token:
            self.c.cquit(status.Status.MUMBLE, "failed to find access token", 'failed to find access token in: ' + p)
        return token

    def get_public_reviews_response(self, session, planet=None, score=None):
        if score:
            score = str(score)
        response = session.get(f'{self.url}/reviews', params={'planet': planet, 'score': score})
        self.c.check_response(response, 'Failed to get public reviews')
        return response

    def use_token_link(self, session, link):
        response = session.get(f'{self.url}{link}')
        self.c.check_response(response, 'Failed to use publisher link')
        return response
