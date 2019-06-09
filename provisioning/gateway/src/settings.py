import os


def get_env(name, default=None):
    return os.environ.get(name, default)


DEBUG = bool(get_env('DEBUG'))

BASE_HOST = get_env('BASE_HOST')  # External URL for host
BASE_DOMAIN = get_env('BASE_DOMAIN')


SERVICES_PATH = '/code/service'
SOLUTIONS_PATH = '/code/solution'

_REALMS_PATH = '/code/realm'
REALM_TEMPLATES = {
    'realm': get_env('REALM_TEMPLATE_PATH',
                     f'{_REALMS_PATH}/realm_template.json'),

    'client': get_env('CLIENT_TEMPLATE_PATH',
                      f'{_REALMS_PATH}/client_template.json'),

    'user': {
        'admin': get_env('ADMIN_TEMPLATE_PATH',
                         f'{_REALMS_PATH}/user_admin_template.json'),

        'standard': get_env('USER_TEMPLATE_PATH',
                            f'{_REALMS_PATH}/user_standard_template.json'),
    },
}

LOGIN_THEME = get_env('LOGIN_THEME', None)

# Keycloak Information
KEYCLOAK_INTERNAL = get_env('KEYCLOAK_INTERNAL')

KC_URL = f'{KEYCLOAK_INTERNAL}/keycloak/auth/'  # internal
KC_ADMIN_USER = get_env('KEYCLOAK_GLOBAL_ADMIN')
KC_ADMIN_PASSWORD = get_env('KEYCLOAK_GLOBAL_PASSWORD')
KC_MASTER_REALM = 'master'

# Kong Information
KONG_URL = get_env('KONG_INTERNAL')
KONG_OIDC_PLUGIN = 'kong-oidc-auth'
KONG_PUBLIC_REALM = get_env('PUBLIC_REALM', '-')

KONG_JWT_PLUGIN = 'jwt-keycloak'

# Konga information 
KONGA_INTERNAL = get_env('KONGA_INTERNAL')
