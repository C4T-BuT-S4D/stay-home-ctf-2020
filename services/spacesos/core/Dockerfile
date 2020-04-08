FROM google/dart

WORKDIR /app

ADD src/pubspec.* /app/
RUN pub get
ADD src /app
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "main.dart"]
