#!/usr/bin/env bash
set -Eeuo pipefail

function show_help {
    echo """
    Commands
    ----------------------------------------------------------------------------

    help:
        Shows this message.

    bash:
        Run bash.

    eval:
        Eval shell command.

    decode_token:
        Decodes a JSON Web Token (JWT).

        Usage: decode_token {token}


    Keycloak & Kong
    ----------------------------------------------------------------------------

    setup_auth:
        Register Keycloak in Kong.

        Shortcut of: register_app keycloak {keycloak-internal-url}


    setup_konga:
        Register Konga in Kong.

        Shortcut of: register_app konga {konga-internal-url}

    register_app:
        Register App in Kong.

        Usage: register_app {app-name} {app-internal-url}


    add_realm:
        Adds a new realm using a default realm template.

        Usage: add_realm {realm} {description (optional)} {login theme (optional)}


    add_user:
        Adds a user to an existing realm.

        Usage: add_user {realm} {username}
                        {*password} {*is_administrator}
                        {*email} {*reset_password_on_login}


    add_confidential_client :
        Adds a confidential client to a realm.
        Required for any realm that will use OIDC for authentication.

        Usage: add_confidential_client {realm} {client-name}


    add_public_client:
        Adds a public client client to a realm.
        Allows token generation.

        Usage: add_public_client {realm} {client-name}


    add_service:
        Adds a service to an existing realm in Kong,
        using the service definition in /service directory.

        Usage: add_service {service} {realm} {oidc-client}


    remove_service:
        Removes a service from an existing realm in Kong,
        using the service definition in /service directory.

        Usage: remove_service {service} {realm}


    add_solution:
        Adds a package of services to an existing realm in Kong,
        using the solution definition in /solution directory.

        Usage: add_solution {solution} {realm} {oidc-client}


    remove_solution:
        Removes a package of services from an existing realm in Kong,
        using the solution definition in /solution directory.

        Usage: remove_solution {solution} {realm}


    keycloak_ready:
        Checks the keycloak connection. Returns status 0 on success.

        Usage: keycloak_ready
    """
}

case "$1" in
    bash )
        bash
    ;;

    eval )
        eval "${@:2}"
    ;;

    decode_token )
        python /code/src/decode_token.py "${@:2}"
    ;;

    setup_auth )
        python /code/src/register_app.py keycloak $KEYCLOAK_INTERNAL
    ;;

    setup_konga )
        python /code/src/register_app.py konga $KONGA_INTERNAL
    ;;

    register_app )
        python /code/src/register_app.py "${@:2}"
    ;;

    add_realm )
        python /code/src/manage_realm.py ADD_REALM "${@:2}"
    ;;

    add_user )
        python /code/src/manage_realm.py ADD_USER "${@:2}"
    ;;

    add_confidential_client )
        python /code/src/manage_realm.py ADD_CONFIDENTIAL_CLIENT "${@:2}"
    ;;

    add_public_client )
        python /code/src/manage_realm.py ADD_PUBLIC_CLIENT "${@:2}"
    ;;

    add_service )
        python /code/src/manage_service.py ADD SERVICE "${@:2}"
    ;;

    remove_service )
        python /code/src/manage_service.py REMOVE SERVICE "${@:2}"
    ;;

    add_solution )
        python /code/src/manage_service.py ADD SOLUTION "${@:2}"
    ;;

    remove_solution )
        python /code/src/manage_service.py REMOVE SOLUTION "${@:2}"
    ;;

    keycloak_ready )
        python /code/src/manage_realm.py KEYCLOAK_READY
    ;;

    help )
        show_help
    ;;

    * )
        show_help
    ;;
esac
