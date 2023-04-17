{{ $hostname := default "example.com" .Values.hostname }}
{{ $jupyterPassword := dedupe . "jupyterhub.postgres.password" (randAlphaNum 20) }}
{{ $jupyterDsn := default (printf "postgresql://jupyter:%s@plural-postgres-jupyter:5432/jupyter" $jupyterPassword) .Values.jupyterDsn }}

global:
  application:
    links:
    - description: jupyterhub instance
      url: {{ $hostname }}

postgres:
  password: {{ $jupyterPassword }}

jupyterhub:
  hub:
    db:
      url: {{ $jupyterDsn }}
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
          - code
          - offline
          - offline_access
          - profile
        username_key: email
      JupyterHub:
        authenticator_class: generic-oauth
    {{ end }}

  ingress:
    hosts:
    - {{ $hostname }}
    tls:
    - hosts:
      - {{ $hostname }}
      secretName: jupyter-tls
