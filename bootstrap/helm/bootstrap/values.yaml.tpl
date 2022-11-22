{{ $pluraldns := .Network.PluralDns }}
{{ $providerArgs := dict "provider" .Provider "cluster" .Cluster }}
{{ if eq .Provider "google" }}
  {{ $_ := set $providerArgs "provider" "gcp" }}
{{ end }}

external-dns:
  {{ if $pluraldns }}
  provider: plural
  extraArgs:
    plural-cluster: {{ $providerArgs.cluster }}
    plural-provider: {{ $providerArgs.provider }}
  {{ else }}
  provider: {{ .Provider }}
  {{ end }}
  txtOwnerId: {{ default .Cluster .Values.txt_owner }}
{{ if eq .Provider "azure" }}
  podLabels:
    aadpodidbinding: externaldns
{{ end }}
  rbac:
    create: true
  serviceAccount:
{{ if eq .Provider "google" }}
    create: false
{{ end }}
    name: {{ default "external-dns" .Values.externaldns_service_account }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-externaldns"
  domainFilters:
  - {{ .Network.Subdomain }}
  google:
    project: {{ .Project }}
  aws:
    region: {{ .Region }}
  {{ if and (not $pluraldns) (eq .Provider "azure")}}
  azure:
    useManagedIdentityExtension: true
    resourceGroup: {{ .Project }}
    tenantId: {{ .Context.TenantId }}
    subscriptionId: {{ .Context.SubscriptionId }}
  {{ end }}
  sources:
  - service
  - ingress
  {{ if .Configuration.istio }}
  - istio-gateway
  - istio-virtualservice
  {{ end }}

{{ if and (not $pluraldns) (eq .Provider "azure") }}
externalDnsIdentityId: {{ importValue "Terraform" "externaldns_msi_id" }}
externalDnsIdentityClientId: {{ importValue "Terraform" "externaldns_msi_client_id" }}
{{ end }}

pluralToken: {{ .Config.Token }}

{{ if $pluraldns }}
{{ $eab := eabCredential $providerArgs.cluster $providerArgs.provider }}
acmeServer: https://acme.zerossl.com/v2/DV90
acmeEAB:
  kid: {{ $eab.KeyId }}
  secret: {{ $eab.HmacKey }}
{{ end }}

regcreds:
  auths:
    dkr.plural.sh:
      username: {{ .Config.Email }}
      password: {{ .Config.Token }}
      auth: {{ list .Config.Email .Config.Token | join ":" | b64enc | quote }}

provider: {{ .Provider }}
ownerEmail: {{ .Config.Email }}

cluster-autoscaler:
{{ if eq (default "google" .Provider) "aws" }}
  enabled: true
{{ end }}
  awsRegion: {{ .Region }}

  rbac:
    create: true
    serviceAccount:
      # This value should match local.k8s_service_account_name in locals.tf
      name: cluster-autoscaler
      annotations:
        # This value should match the ARN of the role created by module.iam_assumable_role_admin in irsa.tf
        eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-cluster-autoscaler"

  autoDiscovery:
    clusterName: {{ .Cluster }}
    enabled: true

{{ if eq .Provider "aws"}}
aws-ebs-csi-driver:
  enabled: true
  controller:
    serviceAccount:
      name: ebs-csi-controller
      annotations:
        eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-ebs-csi"
{{ end }}

{{ if eq .Provider "aws" }}
metrics-server:
  enabled: true
snapshot-validation-webhook:
  enabled: true
snapshot-controller:
  enabled: true
{{ end }}

{{ if $pluraldns }}
dnsSolver:
  webhook:
    groupName: acme.plural.sh
    solverName: plural-solver
    config:
      cluster: {{ $providerArgs.cluster }}
      provider: {{ $providerArgs.provider }}
{{ end }}

{{ if eq .Provider "aws" }}
cert-manager:
  serviceAccount:
    create: true
    name: certmanager
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-certmanager"

{{ if not $pluraldns }}
dnsSolver:
  route53:
    region: {{ .Region }}
{{ end }}
{{ end }}

{{ if and (not $pluraldns) (eq .Provider "azure") }}
dnsSolver:
  azureDNS:
    subscriptionID: {{ .Context.SubscriptionId }}
    resourceGroupName: {{ .Project }}
    hostedZoneName: {{ .Network.Subdomain }}
    # Azure Cloud Environment, default to AzurePublicCloud
    environment: AzurePublicCloud
{{ end }}

{{ if eq .Provider "google" }}
cert-manager:
  serviceAccount:
    create: false
    name: certmanager

{{ if not $pluraldns }}
dnsSolver:
  cloudDNS:
    project: {{ .Project }}
{{ end }}
{{ end }}
