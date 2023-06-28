{{ $urlSignatureKey := dedupe . "imgproxy.imgproxy.features.urlSignature.key" (printf "%x" (randAlphaNum 20 | b64enc))  }}
{{ $urlSignatureSalt := dedupe . "imgproxy.imgproxy.features.urlSignature.salt" (printf "%x" (randAlphaNum 20 | b64enc))  }}

global:
  application:
    links:
    - description: imgproxy
      url: {{ .Values.hostname }}

imgproxy:
  resources:
    ingress:
      enabled: true
      className: "nginx"
      annotations:
        kubernetes.io/tls-acme: "true"
        cert-manager.io/cluster-issuer: letsencrypt-prod
      hosts:
        - {{ .Values.hostname }}
      tls:
      - secretName: imgproxy-tls
        hosts:
          - {{ .Values.hostname }}
  features:
    urlSignature:
      key: {{ $urlSignatureKey }}
      salt: {{ $urlSignatureSalt }}