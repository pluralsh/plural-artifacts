global:
  application:
    links:
    - description: trinodb web ui
      url: {{ .Values.hostname }}

trino:
  server:
    {{- if .OIDC }}
    config:
      authenticationType: OAUTH2
    {{- end }}
    coordinatorExtraConfig: |
      http-server.process-forwarded=true
    {{- if .OIDC }}
      http-server.authentication.allow-insecure-over-http=true
      http-server.authentication.oauth2.issuer={{ .OIDC.Configuration.Issuer }}
      http-server.authentication.oauth2.auth-url={{ .OIDC.Configuration.AuthorizationEndpoint }}
      http-server.authentication.oauth2.token-url={{ .OIDC.Configuration.TokenEndpoint }}
      http-server.authentication.oauth2.jwks-url={{ .OIDC.Configuration.JwksUri }}
      http-server.authentication.oauth2.userinfo-url={{ .OIDC.Configuration.UserinfoEndpoint }}
      http-server.authentication.oauth2.client-id={{ .OIDC.ClientId }}
      http-server.authentication.oauth2.client-secret={{ .OIDC.ClientSecret }}
      http-server.authentication.oauth2.scopes=openid
      http-server.authentication.oauth2.principal-field=email
      http-server.authentication.oauth2.groups-field=groups
      web-ui.authentication.type=oauth2
    {{- end }}
  additionalConfigProperties:
  - internal-communication.shared-secret={{ dedupe . "trino.trino.additionalConfigProperties[0]" (randAlphaNum 32) }}
ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: trinodb-tls
     hosts:
       - {{ .Values.hostname }}