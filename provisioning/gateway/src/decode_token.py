
import json
import jwt
import sys

from helpers import request
from settings import BASE_HOST


def check_jwt(token):
    tokeninfo = jwt.decode(token, verify=False)
    print_json(tokeninfo)

    iss_url = tokeninfo['iss']
    if not iss_url.startswith(BASE_HOST):
        raise RuntimeError(f'This token does not belong to our host {BASE_HOST}')

    # go to iss
    realminfo = request(method='get', url=iss_url)
    print_json(realminfo)

    # if this call fails the token is not longer valid
    userinfo = request(
        method='get',
        url=realminfo['token-service'] + '/userinfo',
        headers={'Authorization': '{} {}'.format(tokeninfo['typ'], token)},
    )
    print_json(userinfo)


def print_json(data):
    print(json.dumps(data, indent=2))
    print('---------------------------------------')


if __name__ == '__main__':
    token = sys.argv[1]

    check_jwt(token)
