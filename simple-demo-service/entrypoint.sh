#!/bin/bash
#
set -Eeuo pipefail

show_help () {
    echo """
    Commands
    ----------------------------------------------------------------------------
    bash          : run bash
    eval          : eval shell command

    register_app  : register floramedia app in Kong.

    start         : start service webserver
    """
}

case "$1" in
    bash )
        bash
    ;;

    eval )
        eval "${@:2}"
    ;;

    register_app )
        python /code/src/register_app.py $2 ${APP_NAME} ${APP_INTERNAL}
    ;;

    start )
        python /code/src/app.py
    ;;

    help )
        show_help
    ;;

    * )
        show_help
    ;;
esac
