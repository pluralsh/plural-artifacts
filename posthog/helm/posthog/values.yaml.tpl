posthog:
  {{ if or (eq .Provider "equinix") (eq .Provider "kind") }}
  cloud: other
  {{- else if eq .Provider "google" }}
  cloud: "gcp"
  {{- else }}
  cloud: {{ .Provider }}
  {{- end }}
