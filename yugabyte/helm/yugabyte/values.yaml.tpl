{{ if .OIDC }}
oidc-config:
  enabled: true
  secret:
    name: yugabyte-proxy-config
    upstream: http://localhost:7000
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "yugabyte.oidc-config.secret.cookieSecret" (randAlphaNum 32) }}
  service:
    name: yugabyte-oauth2-proxy
    selector:
      app.kubernetes.io/name: yb-master
      release: yugabyte
  {{ if .Values.users }}
  users:
  {{ toYaml .Values.users | nindent 4 }}
  {{ end }}
{{ end }}

yugabyte:
  autoMultiAz:
    cloud: {{ .Provider }}
  {{- if .OIDC }}
  ingress:
    enabled: true
    className: "nginx"
    annotations:
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
    hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: /
            pathType: ImplementationSpecific
            service:
              name: yugabyte-oauth2-proxy
              port: 80
    tls:
    - secretName: yugabyte-tls
      hosts:
      - {{ .Values.hostname }}
  master:
    podLabels:
      security.plural.sh/inject-oauth-sidecar: "true"
    podAnnotations:
      security.plural.sh/oauth-env-secret: "yugabyte-proxy-config"
    {{ if .Values.users }}
      security.plural.sh/htpasswd-secret: httpaswd-users
    {{ end }}
  {{- end }}
