FROM kong:1.1.1-alpine

# Kong install dir
# ENV KONG_OIDC_HOME /usr/local/share/lua/5.1/kong/plugins/kong-oidc-auth
# ENV KONG_OIDC_REPO {{REPO_FOR_OIDC_PLUGIN_HERE}}

# # Install OIDC plugin
# RUN apk -U add --no-cache --virtual .build-deps git unzip gcc libc-dev openssl-dev && \
#     git clone $KONG_OIDC_REPO $KONG_OIDC_HOME && \
#     cd $KONG_OIDC_HOME && \
#     luarocks make *.rockspec && \
#     apk del .build-deps


ENV KONG_HOME /usr/local/share/lua/5.1/kong/plugins/kong-oidc-auth
ADD ./kong-oidc-auth /usr/local/share/lua/5.1/kong/plugins/kong-oidc-auth
RUN apk -U add git unzip gcc libc-dev openssl-dev
RUN (cd $KONG_HOME/plugins/kong-oidc-auth/ && luarocks make *.rockspec)