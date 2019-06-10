#!/usr/bin/env bash

set -Eeo pipefail

IDEMPIERE_HOME=${IDEMPIERE_HOME:-/idempiere-server}
KEY_STORE_PASS=${KEY_STORE_PASS:-myPassword}
KEY_STORE_ON=${KEY_STORE_ON:-idempiere.org}
KEY_STORE_OU=${KEY_STORE_OU:-iDempiere Docker}
KEY_STORE_O=${KEY_STORE_O:-iDempiere}
KEY_STORE_L=${KEY_STORE_L:-myTown}
KEY_STORE_S=${KEY_STORE_S:-CA}
KEY_STORE_C=${KEY_STORE_C:-US}
IDEMPIERE_HOST=${IDEMPIERE_HOST:-0.0.0.0}
IDEMPIERE_PORT=${IDEMPIERE_PORT:-8080}
IDEMPIERE_SSL_PORT=${IDEMPIERE_SSL_PORT:-8443}
DB_HOST=${DB_HOST:-postgres}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-idempiere}
DB_USER=${DB_USER:-adempiere}
DB_PASS=${DB_PASS:-adempiere}
DB_ADMIN_PASS=${DB_ADMIN_PASS:-postgres}
MAIL_HOST=${MAIL_HOST:-localhost}
MAIL_USER=${MAIL_USER:-info}
MAIL_PASS=${MAIL_PASS:-info}
MAIL_ADMIN=${MAIL_ADMIN:-info@localhost}

function waitForPostgres() {
    RETRIES=10

    until PGPASSWORD=$DB_ADMIN_PASS psql -h $DB_HOST -U postgres -c "\q" > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
        echo "Waiting for postgres server, $((RETRIES--)) remaining attempts..."
        sleep 1
    done

    if [ "$RETRIES" = 0 ]; then
        echo "Shutting down..."
        exit 1
    fi
}

function importPostgresDB() {
    if ! PGPASSWORD=$DB_PASS psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\q" > /dev/null 2>&1 ; then
        echo "Database '$DB_NAME' not found, starting import..."
        cd utils
        ./RUN_ImportIdempiere.sh
        echo "Synchronizing database..."
        ./RUN_SyncDB.sh
    else
        echo "Database '$DB_NAME' is found..."
    fi
}

if [ "$1" = 'idempiere' ]; then
    waitForPostgres
    echo -e "$JAVA_HOME\n$IDEMPIERE_HOME\n$KEY_STORE_PASS\n$KEY_STORE_ON\n$KEY_STORE_OU\n$KEY_STORE_O\n$KEY_STORE_L\n$KEY_STORE_S\n$KEY_STORE_C\n$IDEMPIERE_HOST\n$IDEMPIERE_PORT\n$IDEMPIERE_SSL_PORT\nN\n2\n$DB_HOST\n$DB_PORT\n$DB_NAME\n$DB_USER\n$DB_PASS\n$DB_ADMIN_PASS\n$MAIL_HOST\n$MAIL_USER\nY\n" | ./console-setup.sh
    importPostgresDB
fi

exec "$@"
