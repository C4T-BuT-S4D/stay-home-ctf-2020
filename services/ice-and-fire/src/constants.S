	.data
	.global	httpok
httpok:	.asciz	"HTTP/1.0 200 OK\r\n"

	.global	red_a,red_p
red_a:	.asciz	"redis"
red_p:	.int	6379

	.global	redctx
redctx:	.int	0
