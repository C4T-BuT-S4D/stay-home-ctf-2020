FROM ubuntu:18.04

COPY fcgiwrap /usr/sbin

COPY ./install.sh /install.sh
RUN chmod +x /install.sh && ./install.sh && rm -rf /install.sh

COPY ./initialize.sh /initialize.sh
RUN chmod +x /initialize.sh && ./initialize.sh && rm -rf /initialize.sh
