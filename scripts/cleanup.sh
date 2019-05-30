#!/usr/bin/env bash
#

#### If this says command not found run `chmod u+x ./scripts/cleanup.sh` - adjust path if you're not in the parent directory.
LINE="__________________________________________________________________"

echo "${LINE} Starting docker images cleanup..."
set -Eeuo pipefail
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q) -f

echo "${LINE} Cleanup is complete!"
