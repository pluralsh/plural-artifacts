global:
  application:
    links:
    - description: calendso web ui
      url: {{ .Values.hostname }}

{{ $postgresPwd := dedupe . "calendso.postgres.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

user:
  USER_EMAIL: {{ .Values.email }}
  USER_NAME: {{ .Values.name }}
  USER_HANDLE: {{ .Values.handle }}
  USER_PASSWORD: {{ dedupe . "calendso.user.USER_PASSWORD" (randAlphaNum 25) }}

{{ if .SMTP }}
smtp:
  EMAIL_SERVER_HOST: {{ .SMTP.Server }}
  EMAIL_SERVER_USER: {{ .SMTP.User }}
  EMAIL_SERVER_PASSWORD: {{ .SMTP.Password }}
  EMAIL_SERVER_PORT: {{ .SMTP.Port }}
  EMAIL_FROM: {{ .SMTP.Sender }}
{{ end }}

ingress:
  tls:
  - hosts:
    - {{ .Values.hostname }}
    secretName: calendso-tls
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: '/.*'
      pathType: ImplementationSpecific

secrets:
  databaseUrl: postgres://calendso:{{ $postgresPwd }}@plural-calendso:5432/calendso?sslmode=require
  baseUrl: https://{{ .Values.hostname }}
  jwtSecret: {{ randAlphaNum 32 }}
  calendsoEncryptionKey: {{ randAlphaNum 32 }}