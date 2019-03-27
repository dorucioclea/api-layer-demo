from functools import wraps
import flask
import json
import jwt


app = flask.current_app


def decode_jwt(encoded):
    # the jwt we get from the middleware isn't encrypted or signed
    return jwt.decode(encoded, verify=False)


def get_realm(f):
    @wraps(f)
    def wrapped(*args, **kwargs):
        request = flask.request
        res = decode_jwt(request.headers.get('X-Oauth-Token'))
        try:
            azp = res['azp']
            realm = azp.split('-oidc')[0]
        except KeyError:
            realm = None
        kwargs['realm'] = realm
        return f(*args, **kwargs)
    return wrapped


def require_role(*allowed_roles):
    allowed_roles = allowed_roles[0]  # Allowed roles is a tuple wrapping a list
    def wrapper(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            request = flask.request
            res = decode_jwt(request.headers.get('X-Oauth-Token'))
            try:
                user_roles = res['realm_access'].get('roles', [])
                kwargs['roles'] = user_roles
                overlap = [i for i in allowed_roles if i in user_roles]
            except KeyError:
                overlap = None
            if not overlap:
                return app.response_class(
                    response=json.dumps(
                        {'error': f'user lacks one any of the following roles: {allowed_roles}'}
                    ),
                    status=401,
                    mimetype='application/json'
                )
            return f(*args, **kwargs)
        return wrapped
    return wrapper
