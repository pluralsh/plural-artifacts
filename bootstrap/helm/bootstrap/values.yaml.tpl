external-dns:
  provider: {{ .Provider }}
  txtOwnerId: {{ .Values.txt_owner }}
{{ if eq .Provider "azure" }}
  podLabels:
    aadpodidbinding: externaldns
{{ end }}
  rbac:
    create: true
  serviceAccount:
{{ if eq .Provider "google"}}
    create: false
{{ end }}
    name: {{ default "external-dns" .Values.externaldns_service_account }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-externaldns"
  domainFilters:
  - {{ .Values.dns_domain }}
  google:
    project: {{ .Project }}
  aws:
    region: {{ .Region }}
  {{ if eq .Provider "azure" }}
  azure:
    useManagedIdentityExtension: true
    resourceGroup: {{ .Project }}
    tenantId: {{ .Context.TenantId }}
    subscriptionId: {{ .Context.SubscriptionId }}
  {{ end }}

{{ if eq .Provider "azure" }}
externalDnsIdentityId: {{ importValue "Terraform" "externaldns_msi_id" }}
externalDnsIdentityClientId: {{ importValue "Terraform" "externaldns_msi_client_id" }}
{{ end }}

regcreds:
  auths:
    dkr.plural.sh:
      username: {{ .Config.Email }}
      password: {{ .Config.Token }}
      auth: {{ list .Config.Email .Config.Token | join ":" | b64enc | quote }}


grafana_dns: {{ .Values.grafana_dns }}
provider: {{ .Provider }}
ownerEmail: {{ .Values.ownerEmail }}

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
ingress-nginx:
  controller:
    service:
      externalTrafficPolicy: Local
    config:
      compute-full-forwarded-for: 'true'
      use-forwarded-headers: 'true'
      use-proxy-protocol: 'true'
aws-load-balancer-controller:
  enabled: true
  clusterName: {{ .Cluster }}
  serviceAccount:
    create: true
    name: alb-operator
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-alb"
{{ end }}

grafana:
  admin:
    password: {{ dedupe . "bootstrap.grafana.admin.password" (randAlphaNum 14) }}
    user: admin
  ingress:
    tls:
    - hosts:
      - {{ .Values.grafana_dns }}
      secretName: grafana-tls
    hosts:
    - {{ .Values.grafana_dns }}

{{ if eq .Provider "aws" }}
metrics-server:
  enabled: true
{{ end }}

{{ if eq .Provider "aws" }}
cert-manager:
  serviceAccount:
    create: true
    name: certmanager
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-certmanager"

dnsSolver:
  route53:
    region: {{ .Region }}
{{ end }}

{{ if eq .Provider "azure" }}
dnsSolver:
  azureDNS:
    subscriptionID: {{ .Context.SubscriptionId }}
    resourceGroupName: {{ .Project }}
    hostedZoneName: {{ .Values.dns_domain }}
    # Azure Cloud Environment, default to AzurePublicCloud
    environment: AzurePublicCloud
{{ end }}

{{ if eq .Provider "google" }}
cert-manager:
  serviceAccount:
    create: false
    name: certmanager

dnsSolver:
  cloudDNS:
    project: {{ .Project }}
{{ end }}