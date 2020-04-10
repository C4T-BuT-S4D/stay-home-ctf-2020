FROM ubuntu:18.04

COPY fcgiwrap /usr/sbin

COPY ./lib_install.sh /lib_install.sh
RUN chmod +x /lib_install.sh && ./lib_install.sh && rm -rf /lib_install.sh

COPY ./initialize.sh /initialize.sh
RUN chmod +x /initialize.sh && ./initialize.sh && rm -rf /initialize.sh
