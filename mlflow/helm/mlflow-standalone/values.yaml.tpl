{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:9090
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "mlflow-standalone.oidcProxy.cookieSecret" (randAlphaNum 32) }}
{{- end }}

mlflow:
  defaultArtifactRoot: {{ .Values.mlflow_bucket }}

ingress:
  enabled: true
  hosts:
    - host: {{ .Values.hostname }}
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: mlflow-standalone-tls
      hosts:
        - {{ .Values.hostname }}
