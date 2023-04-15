{{ $unleashPgPwd := dedupe . "unleash.postgres.password" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: unleash web ui
      url: {{ .Values.hostname }}

postgres:
  password: {{ $unleashPgPwd }}

unleash:
  {{- if .OIDC }}
  ingress:
    enabled: false
  {{ else }}
  ingress:
    enabled: true
    className: "nginx"
    annotations:
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
    - host: {{ .Values.hostname }}
      paths:
        - path: '/'
          pathType: ImplementationSpecific
    tls:
    - secretName: unleash-tls
      hosts:
        - {{ .Values.hostname }}
  {{ end }}
  env:
    - name: UNLEASH_URL
      value: {{ .Values.hostname }}
    {{ if .SMTP }}
    - name: EMAIL_SERVER_HOST
      value: {{ .SMTP.Server }}
    - name: EMAIL_SERVER_USER
      value: {{ .SMTP.User }}
    - name: EMAIL_SERVER_PASSWORD
      value: {{ .SMTP.Password }}
    - name: EMAIL_SERVER_PORT
      value: {{ .SMTP.Port }}
    - name: EMAIL_FROM
      value: {{ .SMTP.Sender }}
    {{ end }}
{{ if .OIDC }}
    - name: AUTH_TYPE
      value: none
  podLabels:
    security.plural.sh/inject-oauth-sidecar: "true"
  podAnnotations:
    security.plural.sh/oauth-env-secret: "unleash-proxy-config"
  {{ if .Values.users }}
    security.plural.sh/htpasswd-secret: httpaswd-users
  {{ end }}
{{ $prevSecret := dedupe . "unleash.oidc-config.cookieSecret" (randAlphaNum 32) }}
oidc-config:
  enabled: true
  secret:
    name: unleash-proxy-config
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "unleash.oidc-config.secret.cookieSecret" $prevSecret }}
  {{ if .Values.users }}
  users:
  {{ toYaml .Values.users | nindent 4 }}
  {{ end }}
ingress:
  enabled: true
  className: "nginx"
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
  - host: {{ .Values.hostname }}
    paths:
      - path: '/'
        pathType: ImplementationSpecific
  tls:
  - secretName: unleash-tls
    hosts:
      - {{ .Values.hostname }}
{{ end }}