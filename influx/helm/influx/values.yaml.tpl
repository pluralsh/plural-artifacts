chronograf:
  enabled: {{ .Values.enableChronograf }}
  ingress:
    hostname: {{ .Values.chronografHostname }}
  {{ if .OIDC }}
  oauth:
    generic:
      enabled: true
      client_id: {{ .OIDC.ClientId }}
      client_secret: {{ .OIDC.ClientSecret }}
      scopes: openid profile
      name: plural
      auth_url: {{ .OIDC.Configuration.AuthorizationEndpoint }}
      token_url: {{ .OIDC.Configuration.TokenEndpoint }}
      api_url: {{ .OIDC.Configuration.UserinfoEndpoint }}
      public_url: https://{{ .Values.chronografHostname }}
      api_key: email
  {{ end }}

telegraf:
  enabled: {{ .Values.enableTelegraf }}

kapacitor:
  enabled: {{ .Values.enableKapacitor }}

influxdb:
  fullnameOverride: influxdb
  setDefaultUser:
    enabled: true
    user:
      username: admin
      password: {{ dedupe . "influx.influxdb.setDefaultUser.user.password" (randAlphaNum 25) }}
