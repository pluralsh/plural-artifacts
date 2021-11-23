airbyte:
  airbyte:
  {{ if eq .Provider "aws" }}
    airbyteS3Bucket: {{ .Values.airbyteBucket }}
    airbyteS3Region: {{ .Values.Region }}
    minio:
      accessKey:
        password: {{ importValue "Terraform" "access_key_id" }}
      secretKey:
        password: {{ importValue "Terraform" "secret_access_key" }}
  {{ end }}
    webapp:
      ingress:
        tls:
        - hosts:
          - {{ .Values.hostname }}
          secretName: airbyte-tls
        hosts:
        - host: {{ .Values.hostname }}
          paths:
          - '/.*'
