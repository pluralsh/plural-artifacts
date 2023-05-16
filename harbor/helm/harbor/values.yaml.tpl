{{ $hostname := .Values.hostname }}
{{ $notaryHostname := .Values.notaryHostname }}
{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
{{ $postgresPass := dedupe . "harbor.postgres.password" (randAlphaNum 32) }}

postgres:
  password: {{ $postgresPass }}
harbor:
  jobservice:
    secret: {{ dedupe . "harbor.harbor.jobservice.secret" (randAlphaNum 32) }}
  registry:
    credentials:
      password: {{ dedupe . "harbor.harbor.registry.credentials.password" (randAlphaNum 32) }}
    {{- if eq .Provider "aws" }}
    registry:
      image:
        tag: v2.8.1-irsa-0.1.0
    {{- end }}
  core:
  {{- if .OIDC }}
    extraEnvVars:
    - name: CONFIG_OVERWRITE_JSON
      valueFrom:
        secretKeyRef:
          name: harbor-oidc-secret
          key: config
  {{- end }}
    xsrfKey: {{ dedupe . "harbor.harbor.core.xsrfKey" (randAlphaNum 32) }}
    secret: {{ dedupe . "harbor.harbor.core.secret" (randAlphaNum 32) }}
  harborAdminPassword:  {{ dedupe . "harbor.harbor.harborAdminPassword" (randAlphaNum 32) }}
  secretKey: {{ dedupe . "harbor.harbor.secretKey" (randAlphaNum 16) }}
  externalURL: https://{{ $hostname }}
  database:
    external:
      password: {{ $postgresPass }}
  expose:
    ingress:
      hosts:
        core: {{ $hostname }}
        notary: {{ $notaryHostname }}
  redis:
    external:
      addr: redis-master.{{ $redisNamespace }}:6379
      password: {{ $redisValues.redis.password }}
  persistence:
    imageChartStorage:
      {{- if eq .Provider "aws" }}
      type: s3
      {{- else if eq .Provider "google" }}
      type: gcs
      {{- else if eq .Provider "azure" }}
      type: azure
      {{- end }}
      {{- if eq .Provider "aws" }}
      s3:
        region: {{ .Region }}
        bucket: {{ .Values.bucket }}
      {{- else if eq .Provider "google" }}
      gcs:
        bucket: {{ .Values.bucket }}
        useWorkloadIdentity: true
      {{- else if eq .Provider "azure" }}
      azure:
        accountname: {{ .Context.StorageAccount }}
        container: {{ .Values.bucket }}
        existingSecret: harbor-azure-secret
      {{- end }}
{{- if or (eq .Provider "aws") (eq .Provider "google") }}
serviceAccount:
  annotations:
    {{- if eq .Provider "aws" }}
    eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
    {{- else if eq .Provider "google" }}
    iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
    {{- end }}
{{- end }}
{{- if .OIDC }}
oidc:
  enabled: true
  client_id: {{ .OIDC.ClientId }}
  client_secret: {{ .OIDC.ClientSecret }}
  endpoint: {{ .OIDC.Configuration.Issuer }}
{{- end }}