import sys

from typing import Callable, Dict

from keycloak import KeycloakAdmin
from keycloak.exceptions import KeycloakError

from helpers import load_json_file

from settings import (
    BASE_HOST,
    KC_URL,
    KC_ADMIN_USER,
    KC_ADMIN_PASSWORD,
    KC_MASTER_REALM,
    KONG_PUBLIC_REALM,
    REALM_TEMPLATES,
)


def client():
    # connect to master realm
    try:
        keycloak_admin = KeycloakAdmin(server_url=KC_URL,
                                       username=KC_ADMIN_USER,
                                       password=KC_ADMIN_PASSWORD,
                                       realm_name=KC_MASTER_REALM,
                                       )
        return keycloak_admin
    except KeycloakError as ke:
        raise RuntimeError(f'Could not get info from keycloak  {str(ke)}')


def client_for_realm(realm):
    keycloak_admin = client()
    try:
        keycloak_admin.realm_name = realm
        return keycloak_admin
    except Exception as e:
        raise RuntimeError(
            f'Unexpected error, do the realm and the client exist?  {str(e)}'
        )


def create_realm(realm, description=None, login_theme=None):
    print(f'\nAdding realm "{realm}" to keycloak')
    keycloak_admin = client()

    config = load_json_file(REALM_TEMPLATES['realm'])
    config['realm'] = realm
    if description:
        config['displayName'] = description
    if login_theme:
        config['loginTheme'] = login_theme

    keycloak_admin.create_realm(config, skip_exists=True)
    print(f'    + Added realm {realm} >> keycloak')
    return


def create_client(realm, config):
    keycloak_admin = client_for_realm(realm)
    keycloak_admin.create_client(config, skip_exists=True)


def create_confidential_client(realm, name):
    print(f'Creating confidential client [{name}] in realm [{realm}]...')
    _create_realm_client(realm, name, False)


def create_public_client(realm, name):
    print(f'Creating public client [{name}] in realm [{realm}]...')
    _create_realm_client(realm, name, True)


def _create_realm_client(realm, name, isPublic):
    REALM_URL = f'{BASE_HOST}/{realm}/'
    PUBLIC_URL = f'{BASE_HOST}/{KONG_PUBLIC_REALM}/*'

    config = load_json_file(REALM_TEMPLATES['client'])
    config['clientId'] = name
    config['baseUrl'] = REALM_URL
    config['publicClient'] = isPublic
    config['redirectUris'] = ['*', PUBLIC_URL] if isPublic else ['*']

    create_client(realm, config)


def create_user(
    realm,
    user,
    password=None,
    admin=False,
    email=None,
    temporary_password=False
):
    print(f'\nAdding user "{user}" to {realm}')

    user_type = 'admin' if bool(admin) else 'standard'
    config = load_json_file(REALM_TEMPLATES['user'][user_type])
    config['username'] = user
    config['email'] = email

    keycloak_admin = client_for_realm(realm)
    keycloak_admin.create_user(config)
    if password:
        user_id = keycloak_admin.get_user_id(username=user)
        keycloak_admin.set_user_password(
            user_id,
            password,
            temporary=bool(temporary_password)
        )
    print(f'    + Added user {user} >> {realm}')


def keycloak_ready():
    try:
        client()
        print(f'Keycloak is ready.')
    except RuntimeError:
        sys.exit(1)


if __name__ == '__main__':
    commands: Dict[str, Callable] = {
        'ADD_REALM': create_realm,
        'ADD_USER': create_user,
        'ADD_CONFIDENTIAL_CLIENT': create_confidential_client,
        'ADD_PUBLIC_CLIENT': create_public_client,
        'KEYCLOAK_READY': keycloak_ready
    }
    command = sys.argv[1]
    args = sys.argv[2:]
    if command.upper() not in commands.keys():
        raise KeyError(f'No command: {command}')
    fn = commands[command]
    fn(*args)
