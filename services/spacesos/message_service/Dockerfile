FROM trafex/alpine-nginx-php7:latest

RUN mkdir -p /tmp/messages

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY src /var/www/html
