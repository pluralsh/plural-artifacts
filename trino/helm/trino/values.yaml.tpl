global:
  application:
    links:
    - description: trinodb web ui
      url: {{ .Values.hostname }}

trino:
  server:
    {{ if .OIDC }}
    config:
      authenticationType: OAUTH2
    {{ end }}
  additionalConfigProperties:
    [
    "http-server.authentication.oauth2.issuer={{ $.OIDC.Configuration.Issuer }}",
    "http-server.authentication.oauth2.auth-url={{ $.OIDC.Configuration.AuthorizationEndpoint }}",
    "http-server.authentication.oauth2.token-url={{ $.OIDC.Configuration.TokenEndpoint }}",
    "http-server.authentication.oauth2.jwks-url={{ $.OIDC.Configuration.JwksUri }}",
    "http-server.authentication.oauth2.client-id={{ $.OIDC.ClientId }}",
    "http-server.authentication.oauth2.client-secret={{ $.OIDC.ClientSecret }}",
    "web-ui.authentication.type=oauth2",
    "internal-communication.shared-secret=Plural"
    ]
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