#!/usr/bin/env bash
#

#### If this says command not found run `chmod u+x ./provisioning/scripts/cleanup.sh` - adjust path if you're not in the parent directory.
LINE="__________________________________________________________________"

echo "${LINE} Docker-compose Stopping services"
set -Eeuo pipefail
docker-compose down
echo "${LINE} Done"