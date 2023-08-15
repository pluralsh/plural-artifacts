{{ $encryptionPassword := dedupe . "appsmith.appsmith.applicationConfig.APPSMITH_ENCRYPTION_PASSWORD" (randAlphaNum 20) }}
{{ $encryptionSalt := dedupe . "appsmith.appsmith.applicationConfig.APPSMITH_ENCRYPTION_SALT" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: appsmith web ui
      url: {{ .Values.hostname }}

mongoNamespace: {{ namespace "mongodb" }}

appsmith:
  ingress:
    hosts:
      - host: {{ .Values.hostname }}
    certManagerTls:
      - secretName: appsmith-tls
        hosts:
          - {{ .Values.hostname }}

  applicationConfig:
    {{ if .SMTP }}
    APPSMITH_MAIL_ENABLED: "true"
    APPSMITH_MAIL_HOST: {{ .SMTP.Server }}
    APPSMITH_MAIL_PORT: {{ .SMTP.Port }}
    APPSMITH_MAIL_USERNAME: {{ .SMTP.User }}
    APPSMITH_MAIL_PASSWORD: {{ .SMTP.Password }}
    APPSMITH_MAIL_FROM: {{ .SMTP.Sender }}
    APPSMITH_MAIL_SMTP_AUTH: "true"
    APPSMITH_MAIL_SMTP_TLS_ENABLED: "true"
    {{ end }}
    APPSMITH_ENCRYPTION_PASSWORD: {{ $encryptionPassword }}
    APPSMITH_ENCRYPTION_SALT: {{ $encryptionSalt }}

    # Enabling monbo subchart for the moment, we have a "MongoDB Replica Set is not enabled" error
    # APPSMITH_MONGODB_URI: {{ index (secret (namespace "mongodb") "mongo-admin-admin") "connectionString.standard" }}
