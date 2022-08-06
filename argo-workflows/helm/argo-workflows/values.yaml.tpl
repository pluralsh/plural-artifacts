{{- if .OIDC }}
oidcSecret:
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
{{- end }}

{{ if eq .Provider "azure" }}
minioSecret:
  access-key: {{ importValue "Terraform" "access_key_id" }}
  secret-key: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}

argo-workflows:
  server:
    ingress:
      enabled: true
      annotations:
        kubernetes.io/tls-acme: "true"
        kubernetes.io/ingress.class: "nginx"
        cert-manager.io/cluster-issuer: letsencrypt-prod
        nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
        nginx.ingress.kubernetes.io/use-regex: "true"
        {{- if .OIDC }}
        nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
        {{- end }}
      hosts:
        - {{ .Values.hostname }}
      paths:
        - /
      pathType: Prefix
      tls:
        - secretName: argoworkflows-tls
          hosts:
            - {{ .Values.hostname }}
      https: true
  {{- if .OIDC }}
    extraArgs:
    - --auth-mode=sso
    secure: true
    sso:
      issuer: {{ .OIDC.Configuration.Issuer }}
      clientId:
        name: oidc-secret
        key: clientID
      clientSecret:
        name: oidc-secret
        key: clientSecret
      redirectUrl: https://{{ .Values.hostname }}/oauth2/callback
      rbac:
        enabled: true
      scopes:
      - openid
      - profile
  {{- end }}
  {{- if eq .Provider "aws" }}
    podSecurityContext:
      fsGroup: 65534
  useStaticCredentials: false
  {{- end }}
artifactRepository:
  archiveLogs: true
  {{ if eq .Provider "aws" }}
  s3:
    insecure: false
    bucket: {{ .Values.workflowBucket | quote }}
    endpoint: s3.amazonaws.com
    useSDKCreds: true
    roleARN: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-argo-workflows"
  {{ end }}
  {{ if eq .Provider "azure" }}
  s3:
    insecure: false
    bucket: {{ .Values.workflowBucket | quote }}
    endpoint: {{ .Configuration.minio.hostname | quote }}
    accessKeySecret:
      name: minio-secret
      key: access-key
    secretKeySecret:
      name: minio-secret
      key: secret-key
  {{ end }}
  {{ if eq .Provider "google" }}
  gcs:
    bucket: {{ .Values.workflowBucket | quote }}
  {{ end }}
serviceAccount:
  create: true
  annotations:
    {{- if .OIDC }}
    {{ if .Values.adminGroup }}
    workflows.argoproj.io/rbac-rule: "'{{ .Values.adminGroup }}' in groups"
    {{ else }}
    workflows.argoproj.io/rbac-rule: "email in ['{{ .Values.adminEmail }}']"
    {{ end }}
    workflows.argoproj.io/rbac-rule-precedence: "1"
    {{- end }}
    {{- if eq .Provider "aws" }}
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-argo-workflows"
    {{- end }}
    {{ if eq .Provider "google" }}
    iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
    {{ end }}
