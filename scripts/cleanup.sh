#!/usr/bin/env bash
#

#### If this says command not found run `chmod u+x ./scripts/cleanup.sh` - adjust path if you're not in the parent directory.
LINE="__________________________________________________________________"

echo "${LINE} Starting docker images cleanup..."
set -Eeuo pipefail
# kills = $(docker ps -q | wc -c)
if [[ $(docker ps -q | wc -c) -ne 0 ]]; then
    echo "Killing docker containers..."
    docker kill $(docker ps -q)
    echo "Done."
else
    echo "No Docker containers found to kill off."
fi

if [[ $(docker ps -a -q | wc -c) -ne 0 ]]; then
    echo "Removing Docker containers..."
    docker rm $(docker ps -aq)
    echo "Done."
else
    echo "No Docker containers found to remove."
fi

if [[ $(docker images -q | wc -c) -ne 0 ]]; then
    echo "Removing Docker images..."
    docker rmi $(docker images -q)
    echo "Done."
else
    echo "No Docker images found to remove."
fi

# if [(docker ps -q)]
# then 
# docker kill $(docker ps -q)
# fi
# docker rm $(docker ps -a -q)
# docker rmi $(docker images -q) -f

echo "${LINE} Cleanup is complete!"
