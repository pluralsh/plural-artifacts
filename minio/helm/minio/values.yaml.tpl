secret:
  rootUser: {{ dedupe . "minio.secrets.rootUser" (randAlphaNum 20) }}
  rootPassword: {{ dedupe . "minio.secrets.rootUser" (randAlphaNum 30) }}


{{ if eq .Provider "aws" }}
minio:
  mode: gateway
  gateway:
    type: "s3"
  envFrom:
  - secretRef:
    name: minio-s3-secret
{{ end }}

minio:
  ingress: 
    hostname: {{ .Values.hostname }}
