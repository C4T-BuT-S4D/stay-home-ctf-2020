FROM pomomondreganto/ice-and-fire:latest

RUN mkdir -p /var/jail/dev \
	&& mkdir -p /var/jail/etc \
	&& mkdir -p /var/jail/lib \
	&& mkdir -p /var/jail/lib64 \
	&& mkdir -p /var/jail/usr/local/lib \
	&& mkdir -p /var/jail/usr \
	&& mkdir -p /var/jail/bin \
	&& mkdir -p /var/jail/usr/sbin \
	&& mkdir -p /var/jail/app \
	&& chown -R root:root /var/jail

RUN cp /etc/ld.so.cache /var/jail/etc \
	&& cp /etc/ld.so.conf /var/jail/etc \
	&& cp /etc/nsswitch.conf /var/jail/etc \
	&& cp /etc/hosts /var/jail/etc \
	&& cp /usr/sbin/fcgiwrap /var/jail/usr/sbin \
	&& cp /bin/sh /var/jail/bin \
	&& cp /bin/ls /var/jail/bin

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
