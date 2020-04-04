FROM rust:1.42

RUN rustup default nightly
RUN mkdir -p /backend_internal

WORKDIR /app
RUN USER=root cargo new cache
WORKDIR /app/cache
ADD backend_internal/Cargo.toml /app/cache
ADD backend_internal/Cargo.lock /app/cache
RUN cargo build --release

ADD backend_internal/Rocket.toml /backend_internal
ADD backend_internal/src /app/cache/src

RUN cargo build --release

RUN mv target/release/backend_internal /backend_internal

RUN rm -rf /app

ENV ROCKET_ENV=production

WORKDIR /backend_internal
ADD .wait.sh .
CMD ["./.wait.sh", "postgres:5432", "--", "./backend_internal"]