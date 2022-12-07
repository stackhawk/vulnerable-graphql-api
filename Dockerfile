FROM node:latest

RUN apt update && apt upgrade -y

RUN apt install python sqlite3 libsqlite3-dev -y \
  && wget https://github.com/mapbox/node-sqlite3/archive/v4.1.1.zip -O /opt/sqlite3.zip \
  && mkdir -p /opt/sqlite3 \
  && unzip /opt/sqlite3.zip -d /opt/sqlite3 \
  && cd /opt/sqlite3/node-sqlite3-4.1.1 \
  && npm install \
  && ./node_modules/.bin/node-pre-gyp install --fallback-to-build --build-from-source --sqlite=/usr/bin --python=$(which python) \
  && mkdir -p /graphql/node_modules/sqlite3 \
  && mv /opt/sqlite3/node-sqlite3-4.1.1 /graphql/node_modules/sqlite3 \
  && apt remove python \
  && rm -Rf /opt/sqlite3 /opt/sqlite3.zip

# RUN yum module install -y nodejs

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN useradd -m app

COPY --chown=app ./app /graphql

DEL /graphql/node_modules

WORKDIR /graphql

ENV SERVER_PORT=3000

EXPOSE 3000:3000

RUN sed -i'' -e "s/%SERVER_PORT%/${SERVER_PORT}/g" /graphql/app.ts

#RUN npm config set python "$(which python3)"

#RUN npm install sqlite3

RUN npm install

RUN npm run tsc

RUN npm run sequelize db:migrate

RUN npm run sequelize db:seed:all

RUN chown app /graphql

USER app

ENTRYPOINT [ "docker-entrypoint.sh" ]
