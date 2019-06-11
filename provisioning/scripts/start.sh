#!/usr/bin/env bash
set -Eeuo pipefail

DCA="docker-compose -f ./docker-compose.yml"
$DCA kill

containers=( db kong keycloak demo-service nginx )
for container in "${containers[@]}"
do
    echo "_____________________________________________ Starting $container"
    $DCA up -d $container
    $DCA logs $container
    echo "_____________________________________________ $container started!"
    sleep 5
done
