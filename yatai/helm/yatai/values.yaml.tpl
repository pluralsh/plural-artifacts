{{ $hostname := .Values.hostname }}
yatai:
  ingress:
    hosts:
      - host: {{ $hostname }}
        paths:
        - /
    tls:
    - secretName: yatai-ingress-tls
      hosts:
        - {{ $hostname }}
  s3:
    region: {{ .Region }}
    bucketName: {{ .Values.bucket }}

yatai-deployment:
  layers:
    network:
      domainSuffix: {{ $hostname }}