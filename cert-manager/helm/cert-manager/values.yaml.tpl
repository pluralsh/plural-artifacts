{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $pluraldns := .Network.PluralDns }}
{{ $providerArgs := dict "provider" .Provider "cluster" .Cluster }}
cert-manager:
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- else if $isGcp }}
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
      {{- else if eq .Provider "azure" }}
      azure.workload.identity/client-id: {{ importValue "Terraform" "msi_client_id" }}
      {{- end }}
  {{- if eq .Provider "azure" }}
  podLabels:
    azure.workload.identity/use: "true"
  {{- end }}

{{ if $pluraldns }}
{{ $eab := eabCredential $providerArgs.cluster $providerArgs.provider }}
acmeEAB:
  secret: {{ $eab.HmacKey }}
{{ end }}