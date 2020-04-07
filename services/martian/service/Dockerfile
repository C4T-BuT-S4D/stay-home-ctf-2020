FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -yyq
RUN apt-get install socat libstdc++6 build-essential -yyq

ADD --chown=root ./martian /martian
ADD --chown=root ./items.txt /items.txt
ADD --chown=root ./libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

WORKDIR /

CMD ["socat", "TCP-LISTEN:1337,reuseaddr,fork,keepalive", "EXEC:./martian"]

