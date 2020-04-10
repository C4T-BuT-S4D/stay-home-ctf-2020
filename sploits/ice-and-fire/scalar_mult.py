#!/usr/bin/env python3

import requests
import sys
from checklib import *
from iaf_lib import *

ip = sys.argv[1]
username = sys.argv[2]
url = f"http://{ip}:31337/api"

mch = CheckMachine(BaseChecker(ip))

def restore_coord(num):
    coordinates = [0.0 for _ in range(16)]

    s1 = get_initialized_session()
    u1 = User(coordinates=coordinates)
    mch.register(s1, u1)
    mch.login(s1, u1)
    d1 = mch.match(s1, username).distance ** 2

    coordinates[num] = 1000
    s2 = get_initialized_session()
    u2 = User(coordinates=coordinates)
    mch.register(s2, u2)
    mch.login(s2, u2)
    d2 = mch.match(s2, username).distance ** 2

    return (d1 - d2 + 1000000.0) / 2000.0


answer = [0.0 for _ in range(16)]
for coord in range(16):
    answer[coord] = restore_coord(coord)

s = get_initialized_session()
u = User(coordinates=answer)
mch.register(s, u)
mch.login(s, u)
m = mch.match(s, username)
print(m)
