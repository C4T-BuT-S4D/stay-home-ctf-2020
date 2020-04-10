#!/bin/bash

set +e

USERS=32
echo "[*] Creating $USERS users"
for ((i = 0; i < USERS; i++)); do
    CUID=$(( 1100 + $i ))
    useradd -u "$CUID" "runner$CUID"
done

echo "[*] Users:"
cat /etc/passwd

echo "[*] Prepairing jail base..."
mkdir -p /var/jail/dev \
    && mkdir -p /var/jail/etc \
    && mkdir -p /var/jail/lib \
    && mkdir -p /var/jail/lib64 \
    && mkdir -p /var/jail/lib32 \
    && mkdir -p /var/jail/usr/local/lib \
    && mkdir -p /var/jail/usr \
    && mkdir -p /var/jail/bin \
    && mkdir -p /var/jail/usr/sbin \
    && mkdir -p /var/jail/app \
    && chown -R root:root /var/jail

echo "[*] Copying files..."
cp /etc/ld.so.cache /var/jail/etc \
    && cp /etc/ld.so.conf /var/jail/etc \
    && cp /etc/nsswitch.conf /var/jail/etc \
    && cp /etc/resolv.conf /var/jail/etc \
    && cp /etc/hosts /var/jail/etc \
    && cp /etc/passwd /var/jail/etc \
    && cp /etc/group /var/jail/etc \
    && cp /etc/shadow /var/jail/etc \
    && cp -r /lib/* /var/jail/lib \
    && cp -r /lib32/* /var/jail/lib32 \
    && cp /usr/sbin/fcgiwrap /var/jail/usr/sbin \
    && cp /bin/sh /var/jail/bin \
    && cp /bin/ls /var/jail/bin

echo "[+] Done!"
