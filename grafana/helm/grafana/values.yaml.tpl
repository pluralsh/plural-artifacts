global:
  application:
    links:
    - description: grafana web ui
      url: {{ .Values.hostname }}

{{- if .SMTP }}
secret:
  smtp:
    enabled: true
    user: {{ .SMTP.User }}
    password: {{ .SMTP.Password }}
{{- end }}

grafana:
  admin:
    password: {{ dedupe . "grafana.grafana.admin.password" (randAlphaNum 14) }}
    user: admin
  ingress:
    {{- if eq .Provider "kind" }}
    annotations:
      external-dns.alpha.kubernetes.io/target: "127.0.0.1"
    {{- end }}
    tls:
    - hosts:
      - {{ .Values.hostname }}
      secretName: grafana-tls
    hosts:
    - {{ .Values.hostname }}
  {{- if .SMTP }}
  smtp:
    existingSecret: grafana-smtp-credentials
    userKey: "user"
    passwordKey: "password"
  {{- end }}
  grafana.ini:
    server:
      root_url: https://{{ .Values.hostname }}
    {{- if .SMTP }}
    smtp:
      enabled: true
      host: "{{ .SMTP.Server }}:{{ .SMTP.Port }}"
      from_address: {{ .SMTP.Sender }}∂
    {{- end }}
    {{- if .OIDC }}
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
      role_attribute_path: "null"
      groups_attribute_path: groups
    {{- end }}
  {{- if .Configuration.loki }}
  datasources:
    datasources.yaml:
      apiVersion: 1
      deleteDatasources:
      - name: Loki
        orgId: 1
{{- end }}
