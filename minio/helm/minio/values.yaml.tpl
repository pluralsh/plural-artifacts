secret:
  accessKey: {{ dedupe . "minio.secret.accessKey" (randAlphaNum 20) }}
  secretKey: {{ dedupe . "minio.secret.secretKey" (randAlphaNum 30) }}

{{ if eq .Provider "aws" }}
{{ $minioNamespace := namespace "minio" }}
{{ $awsCreds := secret $minioNamespace "minio-secret" }}
minio:
  gateway:
    enabled: true
    auth:
      s3:
        accessKey: {{ ( index $awsCreds "access-key") }}
        secretKey: {{ ( index $awsCreds "secret-key") }}
        serviceEndpoint: https://s3.amazonaws.com
{{ end }}

minio:
  ingress: 
    hostname: {{ .Values.hostname }}
