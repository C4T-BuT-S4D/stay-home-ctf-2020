#!/bin/bash

mount -o remount,rw,hidepid=2 /proc
mount --bind /dev /var/jail/dev
mount --bind /proc /var/jail/proc
echo "[*] Mounted!"

echo "[*] Chrooting"
chroot /var/jail /usr/sbin/fcgiwrap -c 32 -s tcp:0.0.0.0:31337 -p /app/main