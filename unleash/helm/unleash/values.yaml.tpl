{{ $unleashPgPwd := dedupe . "unleash.postgres.password" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: unleash web ui
      url: {{ .Values.hostname }}

postgres:
  password: {{ $unleashPgPwd }}

unleash:
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