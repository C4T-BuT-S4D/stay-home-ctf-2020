FROM fl3x3dd/grox:latest

ADD backend_internal/src /app/cache/src

RUN cargo build --bin graph --release

RUN mv target/release/graph /graph

RUN rm -rf /app

ENV ROCKET_ENV=production

WORKDIR /
ADD .wait.sh .
CMD ["./.wait.sh", "postgres:5432", "--", "./graph"]