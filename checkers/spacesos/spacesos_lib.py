import grpc
from checklib import *
from contextlib import contextmanager
from datetime import datetime
import spacesos_pb2_grpc
import spacesos_pb2

PORT = 3333


class CheckMachine:
    @property
    def host(self):
        return f'http://{self.c.host}:{self.port}'

    def __init__(self, c: BaseChecker):
        self.c = c
        self.port = PORT
        self.chan = grpc.insecure_channel(f'{self.c.host}:{self.port}')
        self.stub = spacesos_pb2_grpc.SpaceSosStub(self.chan)

    def register_user(self, username=None, password=None):
        username = username or rnd_username()
        password = password or rnd_password()

        response = self.stub.Register(spacesos_pb2.AuthRequest(login=username, password=password))
        return username, password, response.sessionId

    def login_user(self, username, password):
        response = self.stub.Login(spacesos_pb2.AuthRequest(login=username, password=password))
        return response.sessionId

    def add_crush(self, session_id, token, coordinates, dtime=None):
        c = spacesos_pb2.Crash(spaceship_access_token=token)
        c.coordinates.nearest_planet = coordinates['planet']
        c.coordinates.longitude = coordinates['longitude']
        c.coordinates.latitude = coordinates['latitude']
        c.coordinates.distance = coordinates['distance']
        if dtime is None:
            c.time.GetCurrentTime()
        else:
            c.time.FromDateTime(dtime)
        response = self.stub.Crash(spacesos_pb2.CrashRequest(sessionId=session_id, crash=c, expose=True))
        return response.result

    def add_to_friends(self, session_id, friend):
        c = spacesos_pb2.AddToFriendRequest(sessionId=session_id, username=friend)
        response = self.stub.AddToFriend(c)
        return response.mutual

    def list_friendship_requests(self, session_id):
        c = spacesos_pb2.FriendshipRequestsRequest(sessionId=session_id)
        response = self.stub.FriendshipRequests(c)
        return response.users[:]

    def get_friends(self, session_id):
        c = spacesos_pb2.FriendshipRequestsRequest(sessionId=session_id)
        response = self.stub.GetFriends(c)
        return response.users[:]

    def get_latest_crushes(self):
        response = self.stub.GetLatestCrashes(spacesos_pb2.GetLatestCrashesRequest())
        return response.crashes[:]

    def get_crush(self, session_id):
        response = self.stub.GetCrashes(spacesos_pb2.CrashRequest(sessionId=session_id))
        return response.crashes[:]


