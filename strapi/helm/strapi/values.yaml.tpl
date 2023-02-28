{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: strapi web ui
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: strapi-tls
     hosts:
       - {{ $hostname }}

secretEnvs:
  APP_KEYS: {{ dedupe . "strapi.secretEnvs.APP_KEYS" (randAlphaNum 32) }}
  API_TOKEN_SALT: {{ dedupe . "strapi.secretEnvs.API_TOKEN_SALT" (randAlphaNum 32) }}
  ADMIN_JWT_SECRET: {{ dedupe . "strapi.secretEnvs.ADMIN_JWT_SECRET" (randAlphaNum 32) }}
  JWT_SECRET: {{ dedupe . "strapi.secretEnvs.JWT_SECRET" (randAlphaNum 32) }}

{{- if eq .Provider "aws" }}
extraEnv:
- name: S3_BUCKET_NAME
  value: {{ .Values.strapiBucket }}
- name: AWS_REGION
  value: {{ .Region }}
- name: S3_URL
  value: {{ .Values.strapiBucket }}.s3.{{ .Region }}.amazonaws.com

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-strapi"
{{- end }}
