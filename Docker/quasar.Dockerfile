FROM node:18

RUN yarn global add @quasar/cli

RUN mkdir /cache
WORKDIR /cache

COPY ./frontend/package.json ./
RUN yarn install

RUN mkdir /app
WORKDIR /app/
COPY ./frontend/ /app/

COPY ./Docker/quasar-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/quasar-entrypoint.sh