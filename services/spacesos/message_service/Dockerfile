FROM trafex/alpine-nginx-php7:latest

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY src /var/www/html

USER root

RUN mkdir /tmp/messages

RUN chown -R nobody.nobody /tmp/messages

USER nobody
