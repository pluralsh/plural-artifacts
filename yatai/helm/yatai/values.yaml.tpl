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
    
  s3: # TODO: fill this out, try to make it use IRSA
    region: {{ .Region }}
    bucketName: {{ .Values.bucket }}