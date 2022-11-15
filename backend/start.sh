#!/bin/bash

echo "[database]
MYSQL_HOST = ${MYSQL_HOST}
MYSQL_PORT = 3306
MYSQL_DB = ${MYSQL_DATABASE}
MYSQL_USER = ${MYSQL_USER}
MYSQL_PASSWORD = ${MYSQL_PASSWORD}
" > backend.conf

wait-for-it -h ${MYSQL_HOST} -p 3306 -t 0 -- hostname

/app/.local/bin/gunicorn wsgi:app -b 0.0.0.0:8080 &

wait-for-it -h localhost -p 8080 -t 0 -- hostname

curl -X POST ${BACKEND_URL}/add -H "Content-Type: application/json" -d '{"name": "Qi", "bcit_id": "A01207761"}'

wait
