FROM python:alpine

WORKDIR /app

ADD requirements.txt /app

RUN set -ex && \
  apk add --virtual remove --no-cache build-base && \
  pip install --no-cache-dir -r requirements.txt && \
  apk del remove

ADD . /app

USER nobody

CMD python3 main.py
