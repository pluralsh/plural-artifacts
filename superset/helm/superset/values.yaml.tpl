{{ $splitName := list "" "" }}
{{ if .Values.name }}
  {{ $splitName = regexSplit " " .Values.name 2 }}
{{ end }}

superset:
  init:
    adminUser:
      username: {{ .Values.username }}
      firstname: {{ index $splitName 0 }}
    {{ if gt (len $splitName) 2 }}
      lastName: {{ index $splitName 1 }}
      email: {{ .Values.adminEmail }}
      password: {{ dedupe . "superset.superset.init.adminUser.password" (randAlphaNum 26) }}
    {{ end }}
  ingress:
    hosts:
    - {{ .Values.hostname | quote }}
    tls:
    - secretName: superset-tls
      hosts:
      - {{ .Values.hostname | quote }}
  {{ if .OIDC }}
  configOverrides:
    plural_oidc: |
      import jwt
      from superset.security import SupersetSecurityManager
      from flask_appbuilder.security.manager import AUTH_OAUTH

      class PluralSecurityManager(SupersetSecurityManager):
        def _get_oauth_user_info(self, provider, response):
            if provider == "plural":
                me = self._azure_jwt_token_parse(response["id_token"])
                split_name = me["name"].split()
                return {
                    "username": me["name"],
                    "name": me["name"],
                    "first_name": split_name[0],
                    "last_name": " ".join(split_name[1:]),
                    "email": me["email"],
                    "role_keys": [],
                }
            else:
                return {}
        oauth_user_info = _get_oauth_user_info
      
      CUSTOM_SECURITY_MANAGER = PluralSecurityManager
      
      AUTH_TYPE = AUTH_OAUTH
      
      # registration configs
      AUTH_USER_REGISTRATION = True  # allow users who are not already in the FAB DB
      AUTH_USER_REGISTRATION_ROLE = "Admin"  # this role will be given in addition to any AUTH_ROLES_MAPPING

      # the list of providers which the user can choose from
      OAUTH_PROVIDERS = [
          {
              'name': 'plural',
              'icon': 'fa-square-o',
              'token_key': 'access_token',
              'remote_app': {
                  'client_id': '{{ .OIDC.ClientId }}',
                  'client_secret': '{{ .OIDC.ClientSecret }}',
                  'api_base_url': '{{ .OIDC.Configuration.Issuer }}oauth2/',
                  'client_kwargs': {
                      'scope': 'openid'
                  },
                  'redirect_uri': 'https://{{ .Values.hostname }}/oauth-authorized/plural',
                  'access_token_url': '{{ .OIDC.Configuration.TokenEndpoint }}',
                  'authorize_url': '{{ .OIDC.Configuration.AuthorizationEndpoint }}',
                  'token_endpoint_auth_method': 'client_secret_post',
              }
          }
      ]
      
      # force users to re-auth after 30min of inactivity (to keep roles in sync)
      PERMANENT_SESSION_LIFETIME = 1800

      ENABLE_PROXY_FIX = True
  {{ end }}