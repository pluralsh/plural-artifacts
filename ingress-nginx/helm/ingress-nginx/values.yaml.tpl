{{- if eq .Provider "aws"}}
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
    config:
      compute-full-forwarded-for: 'true'
      use-forwarded-headers: 'true'
      use-proxy-protocol: 'true'
{{- end }}
