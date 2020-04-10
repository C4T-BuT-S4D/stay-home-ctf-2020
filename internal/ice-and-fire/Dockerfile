FROM ubuntu:18.04

ADD fcgiwrap /usr/sbin

COPY ./initialize.sh /initialize.sh
RUN chmod +x /initialize.sh && ./initialize.sh && rm -rf /initialize.sh