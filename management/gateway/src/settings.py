import os


def get_env(name, default=None):
    return os.environ.get(name, default)


DEBUG = bool(get_env('DEBUG'))

BASE_HOST = get_env('BASE_HOST')  # External URL for host
DOMAIN = get_env('BASE_DOMAIN')
PLATFORM_NAME = get_env('PLATFORM_NAME')
REALM_TEMPLATE_PATH = get_env(
    'REALM_TEMPLATE_PATH',
    '/code/realm/realm_template.json'
)

LOGIN_THEME = get_env('LOGIN_THEME', None)

# Keycloak Information
KEYCLOAK_INTERNAL = get_env('KEYCLOAK_INTERNAL')

KC_URL = f'{KEYCLOAK_INTERNAL}/keycloak/auth/'  # internal
KC_ADMIN_USER = get_env('KEYCLOAK_GLOBAL_ADMIN')
KC_ADMIN_PASSWORD = get_env('KEYCLOAK_GLOBAL_PASSWORD')
KC_MASTER_REALM = 'master'
KEYCLOAK_FLORA_CLIENT = get_env('KEYCLOAK_FLORA_CLIENT', 'flora')
KEYCLOAK_KONG_CLIENT = get_env('KEYCLOAK_KONG_CLIENT', 'kong')


# Kong Information
PUBLIC_REALM = get_env('PUBLIC_REALM', '-')
KONG_URL = get_env('KONG_INTERNAL')
KONG_OIDC_PLUGIN = 'kong-oidc-auth'
KONG_JWT_PLUGIN = 'jwt-keycloak'

REALMS_PATH = '/code/realm'
SERVICES_PATH = '/code/service'
SOLUTIONS_PATH = '/code/solution'

# Minio
MINIO_INTERNAL = get_env('MINIO_INTERNAL')
KONGA_INTERNAL = get_env('KONGA_INTERNAL')
