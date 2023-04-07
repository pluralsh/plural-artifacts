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
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-externaldns"
    {{- end }}
  domainFilters:
  - {{ .Network.Subdomain }}
  {{- if eq .Provider "google" }}
  google:
    project: {{ .Project }}
  {{- end }}
  {{- if eq .Provider "aws" }}
  aws:
    region: {{ .Region }}
  {{- end }}
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

{{ if .Acme }}
acme:
  kid: {{ .Acme.KeyId }}
  secret: {{ .Acme.Secret }}
{{ end }}

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

{{ if eq (default "google" .Provider) "aws" }}
{{- if not .Values.disable_cluster_autoscaler }} 
cluster-autoscaler:
  enabled: true
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
{{- end }}
{{ end }}

{{ if eq .Provider "aws"}}
{{- if not .Values.disable_calico}}
tigera-operator:
  enabled: true
  installation:
    kubernetesProvider: EKS
{{- end }}
{{- if not .Values.disable_aws_lb_controller }}
aws-load-balancer-controller:
  enabled: true
  clusterName: {{ .Cluster }}
  serviceAccount:
    create: true
    name: alb-operator
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-alb"
{{- end }}
{{- if not .Values.disable_ebs_csi_driver}}
aws-ebs-csi-driver:
  enabled: true
  controller:
    serviceAccount:
      name: ebs-csi-controller
      annotations:
        eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-ebs-csi"
{{- end}}
{{- if not .Values.disable_metrics_server}}
metrics-server:
  enabled: true
{{- end}}
{{- if not .Values.disable_snapshot_controller}}
snapshot-validation-webhook:
  enabled: true
snapshot-controller:
  enabled: true
{{- end}}
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

bootstrapoperator:
  clusterName: {{ .Cluster }}
  secret:
{{ if eq .Provider "aws" }}
    AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | b64enc | quote }}
    AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | b64enc | quote }}
    AWS_SESSION_TOKEN: {{ .Context.SessionToken | b64enc | quote }}
  cloud:
    aws:
      region: eu-central-1
      version: v2.0.2
      machinePoolReplicas: 3
      instanceType: t2.large
      addons:
        - name: kube-proxy
          version: v1.23.15-eksbuild.1
        - name: vpc-cni
          version: v1.12.5-eksbuild.1
        - name: coredns
          version: v1.8.7-eksbuild.4
      serviceAccounts:
      - metadata:
          name: cluster-autoscaler
          namespace: bootstrap
        roleOnly: true
        roleName: test-aws-cluster-autoscaler
        wellKnownPolicies:
          autoScaler: true
      - metadata:
          name: ebs-csi-controller
          namespace: bootstrap
        roleOnly: true
        roleName: test-aws-ebs-csi
        wellKnownPolicies:
          ebsCSIController: true
      - metadata:
          name: external-dns
          namespace: bootstrap
        roleOnly: true
        roleName: test-aws-externaldns
        wellKnownPolicies:
          externalDNS: true
      - metadata:
          name: certmanager
          namespace: bootstrap
        roleOnly: true
        roleName: test-aws-certmanager
        wellKnownPolicies:
          certManager: true
      - metadata:
          name: alb-operator
          namespace: bootstrap
        roleOnly: true
        roleName: test-aws-alb
        wellKnownPolicies:
          awsLoadBalancerController: true
      accessKeyIdRef:
        name: variables
        key: AWS_ACCESS_KEY_ID
      secretAccessKeyRef:
        name: variables
        key: AWS_SECRET_ACCESS_KEY
      sessionTokenRef:
        name: variables
        key: AWS_SESSION_TOKEN
{{ end }}