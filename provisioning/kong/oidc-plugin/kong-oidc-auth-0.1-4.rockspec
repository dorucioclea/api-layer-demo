package = "kong-oidc-auth"
version = "0.1-4"
source = {
   url = "git+https://[REPO_HERE].git"
}
description = {
   summary = "OpenID Connect authentication with Kong gateway",
   homepage = "",
   license = "Apache 2.0"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.kong-oidc-auth.access"] = "src/access.lua",
      ["kong.plugins.kong-oidc-auth.handler"]  = "src/handler.lua",
      ["kong.plugins.kong-oidc-auth.schema"]= "src/schema.lua"
   }
}
