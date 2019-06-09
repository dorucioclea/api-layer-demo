#!/usr/bin/env bash
set -Eeuo pipefail

scripts/generate_env_vars.sh
source ./scripts/setup_functions.sh
source ./scripts/floramedia_functions.sh

echo ""
echo "========================================================================="
echo "    Initializing Gateway environment, this will take about 60 seconds."
echo "========================================================================="
echo ""

docker-compose kill
create_docker_assets
source .env


DC_AUTH="docker-compose -f docker-compose.yml"
AUTH_CMD="$DC_AUTH run --rm auth"

function connect_to_keycloak {
    n=0
    until [ $n -ge 10 ]
    do
        $AUTH_CMD keycloak_ready && break
        echo "waiting for keycloak..."        
        sleep 3
    done
}

LINE="__________________________________________________________________"

echo "${LINE} Pulling docker images..."
docker-compose pull db auth
echo ""

start_db

# Initialize the kong & keycloak databases in the postgres instance

# THESE COMMANDS WILL ERASE PREVIOUS DATA!!!
rebuild_database kong     kong     ${KONG_PG_PASSWORD}
start_db
rebuild_database keycloak keycloak ${KEYCLOAK_PG_PASSWORD}
echo ""

echo "${LINE} Building custom docker images..."
docker-compose build --no-cache --force-rm --pull keycloak kong
$DC_AUTH       build --no-cache --force-rm --pull auth
echo ""


echo "${LINE} Preparing kong..."
#
# https://docs.konghq.com/install/docker/
#
# Note for Kong < 0.15: with Kong versions below 0.15 (up to 0.14),
# use the up sub-command instead of bootstrap.
# Also note that with Kong < 0.15, migrations should never be run concurrently;
# only one Kong node should be performing migrations at a time.
# This limitation is lifted for Kong 0.15, 1.0, and above.
docker-compose run kong kong migrations bootstrap 2>/dev/null || true
docker-compose run kong kong migrations up
echo ""
start_kong


echo "${LINE} Registering keycloak in kong..."
$AUTH_CMD setup_auth
echo ""


echo "${LINE} Preparing keycloak..."
start_keycloak
connect_to_keycloak

echo "${LINE} Creating initial realms in keycloak..."
REALMS=( dev ) ##DORU: Simplify only for dev environment. put prod back in.
for REALM in "${REALMS[@]}"; do
    $AUTH_CMD add_realm         $REALM
    $AUTH_CMD add_oidc_client   $REALM
    $AUTH_CMD add_user          $REALM \
                                $KEYCLOAK_INITIAL_USER_USERNAME \
                                $KEYCLOAK_INITIAL_USER_PASSWORD            

    echo "${LINE} Adding [demo] solution in kong..."
    $AUTH_CMD add_solution demo $REALM
done
echo ""

$DC_AUTH down
docker-compose kill
docker-compose down

echo ""
echo "========================================================================="
echo "                                 Done!"
echo "========================================================================="
echo ""
