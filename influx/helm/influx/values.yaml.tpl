chronograf:
  enabled: {{ .Values.enableChronograf }}
  ingress:
    hostname: {{ .Values.chronografHostname }}
  {{ if .OIDC }}
  oauth:
    enabled: true
    token_secret: {{ dedupe . "influx.chronograf.oauth.token_secret" (randAlphaNum 20) }}
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
  {{ if .Values.influxdbHostname }}
  ingress:
    enabled: true
    hostname: {{ .Values.influxdbHostname }}
  {{ end }}
  {{ if .Values.databaseName }}
  env:
  - name: INFLUXDB_DB
    value: {{ .Values.databaseName }}
  {{ end }}
  setDefaultUser:
    enabled: true
    user:
      username: admin
      password: {{ dedupe . "influx.influxdb.setDefaultUser.user.password" (randAlphaNum 25) }}
  {{ if .Values.influxDbStorageClass }}
  persistence:
    storageClass: {{ .Values.influxDbStorageClass }}
  {{ end }}