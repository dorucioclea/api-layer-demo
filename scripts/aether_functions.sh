#!/usr/bin/env bash
#
set -Eeuo pipefail

source .env

LINE="__________________________________________________________________"
FLORAMEDIA_APPS=( kernel odk ui )

# Usage:    create_kc_floramedia_clients <realm-name>
function create_kc_floramedia_clients {
    REALM=$1

    echo "${LINE} Creating floramedia clients in realm [$REALM]..."
    for CLIENT in "${FLORAMEDIA_APPS[@]}"; do
        CLIENT_URL="${BASE_HOST}/${REALM}/${CLIENT}/"
        REDIRECT_URI="${BASE_HOST}/${PUBLIC_REALM}/${CLIENT}/accounts/login/"

        echo "${LINE} Creating client [${CLIENT}] in realm [$REALM]..."
        $KCADM \
            create clients \
            -r "${REALM}" \
            -s clientId="${CLIENT}" \
            -s publicClient=true \
            -s directAccessGrantsEnabled=true \
            -s rootUrl="${CLIENT_URL}" \
            -s baseUrl="${CLIENT_URL}" \
            -s 'redirectUris=["'${REDIRECT_URI}'"]' \
            -s enabled=true
    done
}
