vaultwarden:
  config:
    domain: {{ .Values.hostname }}
    signupDomainsWhitelist: {{ .Values.signupDomains }}

{{- if eq .Provider "aws" }}
  storage:
    storageClassName: efs-csi
    accessModes:
    - ReadWriteMany
{{- end }}

  ingress:
    enabled: true
    hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: /
            pathType: Prefix
          - path: /notifications/hub/negotiate
            pathType: Prefix
          - path: /notifications/hub
            pathType: Prefix
    tls:
      - secretName: vaultwarden-host-tls
        hosts:
          - {{ .Values.hostname }}
