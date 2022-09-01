global:
  application:
    links: []
{{ if .Values.enablePolicies }}
kyverno-policies:
  enabled: true
{{ end }}
