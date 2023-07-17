config:
  infrastructure:
    clusterName: {{ .Cluster }}
    {{- if eq .Provider "google"}}
    provider: GCP
    {{- else }}
    provider: {{ upper .Provider }}
    {{ end }}
    providerConfig:
      accountID: {{ .Project | quote }}
      region: {{ .Region }}
    {{ if eq .Provider "aws" }}
      clusterOIDCIssuer: {{ importValue "Terraform" "oidc_issuer_url" }}
    {{- end }}
    storage:
      provider: S3
      bucketName: {{ .Values.pipelines_bucket }}
  network:
    hostname: {{ .Values.hostname }}
  security:
    oidc:
      issuer: https://oidc.plural.sh/
      jwksURI: https://oidc.plural.sh/.well-known/jwks.json
