FROM pomomondreganto/ice-and-fire:latest

COPY ./l2chroot /l2chroot
RUN chmod +x /l2chroot

COPY ./Makefile /app/Makefile
COPY ./src /app/src
WORKDIR /app
RUN make all \
	&& cp main /var/jail/app/main

RUN /l2chroot /var/jail/usr/sbin/fcgiwrap \
	&& /l2chroot /var/jail/bin/ls \
	&& /l2chroot /var/jail/bin/sh \
	&& /l2chroot /var/jail/app/main

COPY ./static /var/jail/app/static
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
