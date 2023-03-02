retool:
  config:
    licenseKey: {{ .Values.licenseKey }}
    encryptionKey: {{ dedupe . "retool.retool.config.encryptionKey" (randAlphaNum 26) }}
    jwtSecret: {{ dedupe . "retool.retool.config.jwtSecret" (randAlphaNum 26) }}

  ingress:
    hosts:
    - host: {{ .Values.hostname | quote }}
      paths:
      - path: /
    tls:
    - secretName: retool-tls
      hosts:
      - {{ .Values.hostname | quote }}
   