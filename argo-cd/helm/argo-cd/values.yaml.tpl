{{ $hostname := .Values.hostname }}
{{ $redisNamespace := namespace "redis" }}
{{ $redisValues := .Applications.HelmValues "redis" }}

global:
  application:
    links:
    - description: argo cd web ui
      url: {{ .Values.hostname }}

argo-cd:
  externalRedis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
  server:
    certificate:
      domain: {{ $hostname }}
    ingress:
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod
        kubernetes.io/ingress.class: nginx
        kubernetes.io/tls-acme: "true"
        nginx.ingress.kubernetes.io/ssl-passthrough: "true"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      hosts:
        - {{ $hostname }}
      tls:
        - secretName: argocd-ingress-server-tls
          hosts:
            - {{ $hostname }}
  {{- if .OIDC }}
  dex:
    enabled: false
    metrics:
      enabled: false
      serviceMonitor:
        enabled: false
  {{- end }}
  configs:
    cm:
      url: https://{{ $hostname }}
      {{- if .OIDC }}
      admin.enabled: "false"
      oidc.config: |
        name: Plural
        issuer: {{ .OIDC.Configuration.Issuer }}
        clientID: {{ .OIDC.ClientId }}
        clientSecret: $oidc.plural.clientSecret
        requestedScopes: ["openid", "profile"]
        requestedIDTokenClaims:
          email:
            essential: true
          groups:
            essential: true
    rbac:
      policy.csv: |
        p, role:org-admin, applications, *, */*, allow
        p, role:org-admin, clusters, *, *, allow
        p, role:org-admin, projects, *, *, allow
        p, role:org-admin, certificates, *, *, allow
        p, role:org-admin, repositories, *, *, allow
        p, role:org-admin, accounts, *, *, allow
        p, role:org-admin, gpgkeys, *, *, allow
        p, role:org-admin, exec, *, *, allow
        g, {{ .Values.adminGroup }}, role:org-admin
    secret:
      extra:
        oidc.plural.clientSecret: {{ .OIDC.ClientSecret }}
    {{- end }}
    {{- if .Values.credentialTemplateURL }}
    credentialTemplates:
      https-creds:
        url: {{ .Values.credentialTemplateURL }}
        username: {{ .Values.credentialUsername }}
        password: {{ .Values.credentialPassword }}
    {{- end }}
    {{- if .Values.privateRepoName }}
    repositories:
      {{ .Values.privateRepoName }}:
        url: {{ .Values.privateRepoURL }}
    {{- end }}

{{- if .Values.enableImageUpdater }}
argocd-image-updater:
  enabled: true
  config:
    argocd:
      serverAddress: {{ $hostname }}
{{- end }}
