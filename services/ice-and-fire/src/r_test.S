	.text
	.global	test_route
test_route:
	call	get_users_listing
	call	return_200
	retl