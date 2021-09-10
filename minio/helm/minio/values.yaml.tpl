secret:
  rootUser: {{ dedupe . "minio.secret.rootUser" (randAlphaNum 20) }}
  rootPassword: {{ dedupe . "minio.secret.rootPassword" (randAlphaNum 30) }}


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

minio:
  ingress:
    enabled: true
    hosts:
      - {{ .Values.hostname }}
    tls:
    - secretName: minio-gateway-tls
      hosts:
        - {{ .Values.hostname }}
  consoleIngress:
    enabled: true
    hosts:
      - {{ .Values.consoleHostname }}
    tls:
    - secretName: minio-console-tls
      hosts:
        - {{ .Values.consoleHostname }}
