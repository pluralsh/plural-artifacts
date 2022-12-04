global:
  application:
    links:
    - description: prefect orion web ui
      url: {{ .Values.hostname }}

prefect-orion:
  {{- if not .OIDC }}
  ingress:
    enabled: true
    host:
      hostname: {{ .Values.hostname}}
  {{- end }}
  orion:
    env:
    - name: PREFECT_API_URL
      value: https://{{ .Values.hostname}}/api
    {{- if .OIDC }}
    podLabels:
      security.plural.sh/inject-oauth-sidecar: "true"
    podAnnotations:
      security.plural.sh/oauth-env-secret: "prefect-proxy-config"
    {{- if .Values.users }}
      security.plural.sh/htpasswd-secret: httpaswd-users
    {{- end }}
    {{- end }}

{{- if .OIDC }}
ingress:
  enabled: true
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls:
  - hosts:
    - {{ .Values.hostname }}
    secretName: {{ .Values.hostname }}-tls
{{- end }}

{{- if .OIDC }}
oidc-config:
  enabled: true
  secret:
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "prefect.oidc-config.secret.cookieSecret" (randAlphaNum 32) }}
  {{- if .Values.users }}
  users:
  {{- toYaml .Values.users | nindent 4 }}
  {{- end }}
{{- end }}
