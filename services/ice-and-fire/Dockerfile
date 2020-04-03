FROM pomomondreganto/ice-and-fire-base

RUN apt-get -y update && apt-get -y install gdb wget
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ADD ./static /app/static
ADD ./Makefile /app/Makefile
ADD ./src /app/src
WORKDIR /app

RUN make all

CMD ["fcgiwrap", "-c", "32", "-s", "tcp:0.0.0.0:31337", "-p", "/app/main"]
