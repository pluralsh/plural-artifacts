{{ if .OIDC }}
oauth2-proxy:
  enabled: true
  ingress:
    enabled: true
    hosts:
    - {{ .Values.hostname }}
    tls:
    - secretName: mysql-oauth2-proxy-tls
      hosts:
      - {{ .Values.hostname }}
  config:
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "mysql.oauth2-proxy.config.cookieSecret" (randAlphaNum 32) }}
  alphaConfig:
    configData:
      providers:
      - id: plural
        name: Plural
        provider: "oidc"
        clientID: {{ .OIDC.ClientId }}
        clientSecretFile: /etc/oidc-secret/client-secret
        scope: "openid profile offline_access"
        oidcConfig:
          issuerURL: {{ .OIDC.Configuration.Issuer }}
          emailClaim: email
          groupsClaim: groups
          userIDClaim: email
          audienceClaims:
          - aud
  {{ if .Values.users }}
  htpasswdFile:
    enabled: true
  {{ end }}
{{ end }}

{{ if .Values.users }}
users:
{{ toYaml .Values.users | nindent 2 }}
{{ end }}

mysql-operator:
  orchestrator:
    topologyPassword: {{ dedupe . "mysql.mysql-operator.orchestrator.topologyPassword" (randAlphaNum 32) }}
