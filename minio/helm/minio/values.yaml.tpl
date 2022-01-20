{{ $monitoringNamespace := namespace "monitoring" }}
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
  environment:
    MINIO_PROMETHEUS_URL: http://monitoring-prometheus.{{ $monitoringNamespace }}.svc.cluster.local:9090
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
    annotations:
      annotations:
      kubernetes.io/tls-acme: "true"
      kubernetes.io/ingress.class: "nginx"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
      nginx.ingress.kubernetes.io/use-regex: "true"
    hosts:
      - {{ .Values.hostname }}
    tls:
    - secretName: minio-gateway-tls
      hosts:
        - {{ .Values.hostname }}
  consoleIngress:
    enabled: true
    annotations:
      annotations:
      kubernetes.io/tls-acme: "true"
      kubernetes.io/ingress.class: "nginx"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
      nginx.ingress.kubernetes.io/use-regex: "true"
    hosts:
      - {{ .Values.consoleHostname }}
    tls:
    - secretName: minio-console-tls
      hosts:
        - {{ .Values.consoleHostname }}
