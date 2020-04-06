FROM rust:1.42

RUN rustup default nightly
RUN mkdir -p /backend_internal

WORKDIR /app
RUN USER=root cargo new cache
WORKDIR /app/cache
ADD Cargo.toml /app/cache
ADD Cargo.lock /app/cache

ADD ./initialize.sh initialize.sh
RUN chmod +x ./initialize.sh && ./initialize.sh && rm -rf /initialize.sh