#!/usr/bin/env bash
#
# Copyright (C) 2018 by eHealth Africa : http://www.eHealthAfrica.org
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
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
