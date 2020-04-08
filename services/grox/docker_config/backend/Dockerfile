FROM node:9.6.1

ADD backend /backend

WORKDIR /backend
ADD .run.sh .
ADD .wait.sh .
CMD ["./.wait.sh", "-t", "0", "postgres:5432", "--", "./.run.sh"]