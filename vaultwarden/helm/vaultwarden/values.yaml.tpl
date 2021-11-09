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
    tls:
      - secretName: vaultwarden-host-tls
        hosts:
          - {{ .Values.hostname }}
