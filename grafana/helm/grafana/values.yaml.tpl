grafana:
  admin:
    password: {{ dedupe . "grafana.grafana.admin.password" (randAlphaNum 14) }}
    user: admin
  ingress:
    tls:
    - hosts:
      - {{ .Values.hostname }}
      secretName: grafana-tls
    hosts:
    - {{ .Values.hostname }}
  {{ if .OIDC }}
  grafana.ini:
    server:
      root_url: https://{{ .Values.hostname }}
    auth.generic_oauth:
      name: Plural
      enabled: true
      allow_sign_up: true
      client_id: {{ .OIDC.ClientId }}
      client_secret: {{ .OIDC.ClientSecret }}
      scopes: openid profile
      auth_url: {{ .OIDC.Configuration.AuthorizationEndpoint }}
      token_url: {{ .OIDC.Configuration.TokenEndpoint }}
      api_url: {{ .OIDC.Configuration.UserinfoEndpoint }}
      role_attribute_path: "\"'Editor'\""
      groups_attribute_path: groups
  {{ end }}
