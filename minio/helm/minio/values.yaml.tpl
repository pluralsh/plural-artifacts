{{ if eq .Provider "aws" }}
{{ $minioNamespace := namespace "minio" }}
{{ $awsCreds := secret $minioNamespace "minio-s3-secret" }}
secret:
  accessKey: {{ ( index $awsCreds "access-key") }}
  secretKey: {{ ( index $awsCreds "secret-key") }}

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
