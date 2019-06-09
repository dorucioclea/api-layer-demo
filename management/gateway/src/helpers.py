#!/usr/bin/env python

import json
import requests
from requests.exceptions import HTTPError

from settings import DEBUG


def request(method, url, data={}):
    try:
        res = requests.request(method=method, url=url, data=data, verify=False)
        res.raise_for_status()
        if res.status_code != 204:
            data = res.json()
            __print(json.dumps(data, indent=2))
            return data
        return None
    except HTTPError as he:
        __handle_exception(he, res)
    except Exception as e:
        __handle_exception(e)


def __print(msg):
    if DEBUG:
        print(msg)


def __handle_exception(exception, res=None):
    __print('---------------------------------------')
    print(' >> ', str(exception))

    if res:
        print(' >>> ', res)
        if res.status_code != 204:
            __print(json.dumps(res.json(), indent=2))
    __print('---------------------------------------')
    raise exception
