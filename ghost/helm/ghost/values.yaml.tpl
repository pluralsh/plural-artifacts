
{{ $dbPwd := dedupe . "ghost.db.password" (randAlphaNum 26) }}

global:
  application:
    links:
    - description: ghost web address
      url: {{ .Values.ghostDomain }}
    - description: ghost admin interface
      url: {{ .Values.ghostDomain }}/ghost

ghost:
  env:
    {{- if .Values.ghostPath }}
    url: https://{{ .Values.ghostDomain }}/{{ .Values.ghostPath }}/
    {{- else }}
    url: https://{{ .Values.ghostDomain }}/
    {{- end }}
    database__connection__password: {{ $dbPwd }}
    mail__from: {{ .Values.ghostEmail }}

ingress:
  {{- if .Values.ghostPath }}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  {{- end }}
  hosts:
    - host: {{ .Values.ghostDomain }}
      paths:
      {{- if .Values.ghostPath }}
        - path: /{{ .Values.ghostPath }}(/|$)(.*)
          pathType: Prefix
      {{- else }}
        - path: /
          pathType: ImplementationSpecific
      {{- end }}
  tls:
   - secretName: ghost-tls
     hosts:
       - {{ .Values.ghostDomain }}

db:
  password: {{ $dbPwd }}
  rootPassword: {{ dedupe . "ghost.db.rootPassword" (randAlphaNum 26) }}
