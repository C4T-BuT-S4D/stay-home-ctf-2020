FROM node:9.6.1

ADD backend/package.json /backend/package.json
ADD backend/yarn.lock /backend/yarn.lock
WORKDIR /backend
RUN yarn install

ADD backend /backend

ADD backend/.run.sh .

USER nobody

CMD ["./.run.sh"]