FROM pomomondreganto/ice-and-fire-base

ADD ./Makefile /app/Makefile
ADD ./src /app/src
WORKDIR /app

RUN make all

USER nobody

CMD ["fcgiwrap", "-c", "32", "-s", "tcp:0.0.0.0:31337", "-p", "/app/main"]
