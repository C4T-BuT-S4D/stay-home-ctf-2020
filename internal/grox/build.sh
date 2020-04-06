#!/bin/bash

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "[*] Building the image"
docker build -t fl3x3dd/grox:latest "${DIR}"

echo "[*] Pushing the image"
docker push fl3x3dd/grox:latest

echo "[+] Done!"
