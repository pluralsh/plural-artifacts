{{ $kratosHost := .Values.hostname }}
{{ $adminHost := .Values.adminHostname }}
{{ $kratosPassword := dedupe . "kratos.postgres.password" (randAlphaNum 20) }}
{{ $kratosDsn := default (printf "postgres://kratos:%s@plural-postgres-kratos:5432/kratos" $kratosPassword) .Values.postgresDsn }}

global:
  application:
    links:
    - description: kratos api
      url: {{ $kratosHost }}
    {{ if $adminHost }}
    - description: kratos admin api
      url: {{ $adminHost }}
    {{ end }}

postgres:
  password: {{ $kratosPassword }}
  dsn: {{ $kratosDsn }}

{{ $defaultSecret := dig "kratos" "kratos" "kratos" "config" "secrets" "default" (list ) . }}

kratos:
  kratos:
    config:
      dsn: {{ $kratosDsn }}
      {{ if .SMTP }}
      courier:
        smtp:
          connection_uri: smtps://{{ .SMTP.User}}:{{ .SMTP.Password }}@{{ .SMTP.Server }}}:{{ .SMTP.Port }}/?skip_ssl_verify=true
          from_address: {{ .SMTP.Sender }}
      {{ end }}
      secrets:
      {{ if not $defaultSecret }}
        default: [{{ (randAlphaNum 20 )}}]
      {{ else }}
        default: 
        {{ toYaml $defaultSecret | nindent 8 }}
      {{ end }}
        cookie: {{ dedupe . "kratos.kratos.kratos.config.secrets.cookie" (randAlphaNum 20) }}
  ingress:
    public:
      hosts:
      - host: {{ $kratosHost }}
        paths: 
        - path: "/.*"
          pathType: ImplementationSpecific
      tls:
      - hosts:
        - {{ $kratosHost }}
        secretName: kratos-tls
    {{ if $adminHost }}
    admin:
      enabled: true
      hosts:
      - host: {{ $adminHost }}
        paths: 
        - path: "/.*"
          pathType: ImplementationSpecific
      tls:
      - hosts:
        - {{ $adminHost }}
        secretName: kratos-admin-tls
    {{ end }}