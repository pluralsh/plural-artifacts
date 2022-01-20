secret:
  rootUser: {{ dedupe . "minio.secret.rootUser" (randAlphaNum 20) }}
  rootPassword: {{ dedupe . "minio.secret.rootPassword" (randAlphaNum 30) }}

{{- if eq .Provider "azure" }}
storageClass: "managed-csi-premium"
{{- else if eq .Provider "aws" }}
storageClass: ebs-csi
{{- else if eq .Provider "equinix" }}
storageClass: ceph-block
{{- end }}

minio:
  {{- if eq .Provider "azure" }}
  mode: gateway
  gateway:
    type: "azure"
  envFrom:
  - secretRef:
      name: minio-azure-secret
  {{- else if eq .Provider "aws" }}
  mode: gateway
  gateway:
    type: "s3"
  envFrom:
  - secretRef:
      name: minio-s3-secret
  {{- else if eq .Provider "equinix" }}
  mode: gateway
  gateway:
    type: "s3"
    s3:
      serviceEndpoint: http://rook-ceph-rgw-ceph-objectstore.{{ namespace "rook" }}.svc
  envFrom:
  - secretRef:
      name: minio-s3-secret
  {{- end }}
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
