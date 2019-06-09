FROM kong:1.1.1-alpine

ADD ./oidc-plugin /usr/local/share/lua/5.1/kong/plugins/kong-oidc-auth
ADD ./error-logs /usr/local/share/lua/5.1/kong/plugins/nginx-error-logs
ADD ./jwt-validate /usr/local/share/lua/5.1/kong/plugins/jwt-validate
RUN apk -U add --no-cache --virtual .build-deps git unzip gcc libc-dev openssl-dev
RUN (cd /usr/local/share/lua/5.1/kong/plugins/kong-oidc-auth && USER=root luarocks make *.rockspec)
RUN (cd /usr/local/share/lua/5.1/kong/plugins/nginx-error-logs && USER=root luarocks make *.rockspec)
RUN (cd /usr/local/share/lua/5.1/kong/plugins/jwt-validate && USER=root luarocks make *.rockspec)
RUN apk del .build-deps