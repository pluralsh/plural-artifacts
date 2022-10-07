global:
  application:
    links:
    - description: ray web ui
      url: {{ .Values.hostname }}

dashboard:
  ingress:
    enabled: true
    hosts:
     - host: {{ .Values.hostname }}
       paths:
         - path: /
           pathType: ImplementationSpecific
    tls:
     - secretName: ray-dashboard-tls
       hosts:
         - {{ .Values.hostname }}

{{ if .OIDC }}
oauth2-proxy:
  enabled: true
  config:
    clientID: {{ .OIDC.ClientID }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "ray.oauth2-proxy.config.cookieSecret" (randAlphaNum 32) }}
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
