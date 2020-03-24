#!/bin/bash 

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "[*] Building the image"
docker build --no-cache -t pomomondreganto/ice-and-fire-base:latest "${DIR}"

echo "[*] Pushing the image"
docker push pomomondreganto/ice-and-fire-base:latest

echo "[+] Done!"
