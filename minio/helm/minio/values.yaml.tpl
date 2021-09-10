secret:
  rootUser: {{ dedupe . "minio.secrets.rootUser" (randAlphaNum 20) }}
  rootPassword: {{ dedupe . "minio.secrets.rootUser" (randAlphaNum 30) }}


{{ if eq .Provider "aws" }}
storageClass: gp2
minio:
  mode: gateway
  gateway:
    type: "s3"
  envFrom:
  - secretRef:
      name: minio-s3-secret
{{ end }}

{{ if eq .Provider "azure" }}
storageClass: "managed-csi-premium"
minio:
  mode: gateway
  gateway:
    type: "azure"
  envFrom:
  - secretRef:
      name: minio-azure-secret
{{ end }}