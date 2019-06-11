#!/usr/bin/env bash
set -Eeuo pipefail

source .env

KC_URL="${KEYCLOAK_INTERNAL}/keycloak/auth"
LINE="__________________________________________________________________"

NETWORK_NAME=$PLATFORM_NAME-internal
DATABASE_NAME=$PLATFORM_NAME-database_data

function create_docker_assets {
    echo "${LINE} Generating docker network and database volume..."

    {
        docker network create ${NETWORK_NAME} \
            --attachable \
            --subnet=${NETWORK_SUBNET} \
            --gateway=${NETWORK_GATEWAY}
    } || { # catch
        echo "$NETWORK_NAME network is ready."
    }

    {
        docker volume create $DATABASE_NAME
    } || { # catch
        echo "$DATABASE_NAME volume is ready."
    }

    ./provisioning/scripts/generate_env_vars.sh

    echo ""
}


function start_db {
    echo "${LINE} Starting database server..."
    docker-compose up -d db
    until docker-compose ps -q db >/dev/null; do
        >&2 echo "Waiting for database..."
        sleep 2
    done
    echo ""
}


function start_kong {
    echo "${LINE} Starting kong server..."
    docker-compose up -d kong
    until docker-compose ps -q kong >/dev/null; do
        >&2 echo "Waiting for kong..."
        sleep 2
    done
    echo ""
}

function start_keycloak {
    echo "${LINE} Starting keycloak server..."
    docker-compose up -d keycloak
    until docker-compose ps -q keycloak >/dev/null; do
        >&2 echo "Waiting for keycloak..."
        sleep 2
    done
    echo ""
}


# Usage:    rebuild_database <database> <user> <password>
function rebuild_database {
    DB_NAME=$1
    DB_USER=$2
    DB_PWD=$3

    DB_ID=$(docker-compose ps -q db)
    PSQL="docker container exec -i $DB_ID psql"

    echo "${LINE} Recreating $1 database..."

    # drops database (terminating any previous connection) and creates it again
    $PSQL <<- EOSQL
        UPDATE pg_database SET datallowconn = 'false' WHERE datname = '${DB_NAME}';
        SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${DB_NAME}';

        DROP DATABASE ${DB_NAME};
        DROP USER ${DB_USER};

        CREATE USER ${DB_USER} PASSWORD '${DB_PWD}';
        CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};
EOSQL
}
