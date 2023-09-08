global:
  application:
    links:
    - description: temporal web ui
      url: {{ .Values.hostname }}

temporal:
  web:
    {{ if .OIDC }}
    config:
      auth:
        issuerUrl: {{ .OIDC.Configuration.Issuer }}
        clientID: {{ .OIDC.ClientId }}
        clientSecret: {{ .OIDC.ClientSecret }}
        callbackUrl: https://{{ .Values.hostname }}/auth/sso/callback
    ingress:
      enabled: true
      hosts:
      - {{ .Values.hostname }}
      tls:
      - secretName: temporal-tls
        hosts:
        - {{ .Values.hostname }}
    {{ end }}
    