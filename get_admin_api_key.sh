#!/usr/bin/env bash

APP_ROOT=$(cd $(dirname $0); pwd)
(
    cd $APP_ROOT
    docker-compose exec postgres psql \
        -c 'select api_key from users where id = 1' \
        -At \
        postgresql://postgres@postgres/postgres
)
