cluster:
  name: {{ .Cluster }}
  {{ if eq .Provider "aws" }}
  kubernetesVersion: v1.23
  {{ end }}
  {{ if eq .Provider "azure" }}
  kubernetesVersion: v1.26.3
  {{ end }}
  aws:
    region: eu-central-1
