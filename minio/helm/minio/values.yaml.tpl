global:
  application:
    links:
    - description: minio url
      url: {{ .Values.hostname }}
    - description: minio object browser
      url: {{ .Values.consoleHostname }}

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
{{- else if eq .Provider "kind" }}
storageClass: standard
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
  {{- else if eq .Provider "kind" }}
  persistence:
    enabled: true
    size: 20Gi
  mode: standalone
  {{- end }}
  ingress:
    enabled: true
    annotations:
      kubernetes.io/tls-acme: "true"
      kubernetes.io/ingress.class: "nginx"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
      nginx.ingress.kubernetes.io/use-regex: "true"
      {{- if eq .Provider "kind" }}
      external-dns.alpha.kubernetes.io/target: "127.0.0.1"
      {{- end }}
    hosts:
      - {{ .Values.hostname }}
    tls:
    - secretName: minio-gateway-tls
      hosts:
        - {{ .Values.hostname }}
  consoleIngress:
    enabled: true
    annotations:
      kubernetes.io/tls-acme: "true"
      kubernetes.io/ingress.class: "nginx"
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
      nginx.ingress.kubernetes.io/use-regex: "true"
      {{- if eq .Provider "kind" }}
      external-dns.alpha.kubernetes.io/target: "127.0.0.1"
      {{- end }}
    hosts:
      - {{ .Values.consoleHostname }}
    tls:
    - secretName: minio-console-tls
      hosts:
        - {{ .Values.consoleHostname }}
