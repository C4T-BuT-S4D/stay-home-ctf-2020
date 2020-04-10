#!/bin/bash

mount --bind /dev /var/jail/dev
echo "[*] Mounted!"

echo "[*] Chrooting"
chroot /var/jail /usr/sbin/fcgiwrap -c 32 -s tcp:0.0.0.0:31337 -p /app/main