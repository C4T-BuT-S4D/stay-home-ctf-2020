FROM fl3x3dd/ice-and-fire-base

ADD ./static /app/static
ADD ./Makefile /app/Makefile
ADD ./src /app/src
WORKDIR /app

RUN make all

CMD ["fcgiwrap", "-c", "32", "-s", "tcp:0.0.0.0:31337", "-p", "/app/main"]
