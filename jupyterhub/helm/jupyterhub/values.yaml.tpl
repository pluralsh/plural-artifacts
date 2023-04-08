{{ $hostname := default "example.com" .Values.hostname }}
{{ $password := dedupe . "jupyterhub.jupyterhub.hub.password" (randAlphaNum 30) }}

global:
  application:
    links:
    - description: jupyterhub instance
      url: {{ $hostname }}

jupyterhub:
  hub:
    password: {{ $password }}
    {{ if .OIDC }}
    config:
      GenericOAuthenticator:
        client_id: {{ .OIDC.ClientId }}
        client_secret: {{ .OIDC.ClientSecret }}
        oauth_callback_url: https://{{ $hostname }}/hub/oauth_callback
        authorize_url: {{ .OIDC.Configuration.AuthorizationEndpoint }}
        token_url: {{ .OIDC.Configuration.TokenEndpoint }}
        userdata_url: {{ .OIDC.Configuration.UserinfoEndpoint }}
        scope:
          - openid
          - profile
        username_key: email
      JupyterHub:
        authenticator_class: generic-oauth
    {{ end }}

  proxy:
    ingress:
      hostname: {{ $hostname }}
      extraTls:
        - hosts:
          - {{ $hostname }}
          secretName: jupyterhub-tls
