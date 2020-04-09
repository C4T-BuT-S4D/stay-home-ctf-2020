FROM python

WORKDIR /app

ADD requirements.txt /app

RUN set -ex && \
  pip install --no-cache-dir -r requirements.txt

ADD . /app

USER nobody

CMD python3 main.py
