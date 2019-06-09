import sys

from helpers import request
from settings import BASE_HOST, KONG_URL

DATA_CORS = {
    'name': 'cors',
    'config.credentials': 'true',
    'config.exposed_headers': 'Authorization',
    'config.headers': 'Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, Authorization',
    'config.max_age': 3600,
    'config.methods': ['HEAD', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    'config.origins': f'{BASE_HOST}/*',
}


def register_app(name, url):
    # Register Client with Kong
    # Single API Service
    data = {
        'name': name,
        'url': url,
    }
    client_info = request(method='post', url=f'{KONG_URL}/services/', data=data)
    client_id = client_info['id']

    # ADD CORS Plugin to Kong for whole domain CORS
    PLUGIN_URL = f'{KONG_URL}/services/{name}/plugins'
    request(method='post', url=PLUGIN_URL, data=DATA_CORS)

    # Routes
    # Add a route which we will NOT protect
    ROUTE_URL = f'{KONG_URL}/services/{name}/routes'
    data_route = {
        'paths': [f'/{name}'],
        'strip_path': 'false',
        'preserve_host': 'false',  # This is keycloak specific.
    }
    request(method='post', url=ROUTE_URL, data=data_route)

    return client_id


if __name__ == '__main__':
    # add service
    name = sys.argv[1]
    url = sys.argv[2]

    print(f'Exposing service "{name}" @ {url}')
    _id = register_app(name, url)
    print(f'Service "{name}" @ {url} now being served by kong @ {BASE_HOST}/{name}')
    print(f'Service id: {_id}')
