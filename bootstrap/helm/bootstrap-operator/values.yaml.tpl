provider: {{ .Provider }}
{{ if eq .Provider "azure" }}
kubernetesVersion: v1.26.3
{{ end }}
operator:
  clusterName: {{ .Cluster }}
  bootstrapMode: false
  moveCluster: false
{{ if eq .Provider "aws" }}
  secret:
    AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | b64enc | quote }}
    AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | b64enc | quote }}
    AWS_SESSION_TOKEN: {{ .Context.SessionToken | b64enc | quote }}
  cloud:
    aws:
      region: {{ .Region }}
      iamServiceAccount:
        roleNamePrefix: {{ .Cluster }}
{{ end }}
{{ if eq .Provider "azure" }}
  clientSecret: {{ .Context.ClientSecret | b64enc | quote }}
  cloud:
    azure:
      version: v1.8.2
      clusterIdentity: 
        name: azure-cluster-identity
        allowedNamespaces: {}
        clientID: {{ .Context.ClientId }}
        clientSecret:
          name: cluster-identity-secret
          namespace: bootstrap
        tenantID: {{ .Context.TenantId }}
        type: ServicePrincipal
      managedCluster: {}
      controlPlane:
        version: v1.26.3
        resourceGroupName: {{ .Project }}
        location: {{ .Region }}
        sshPublicKey: ''
        subscriptionID: {{ .Context.SubscriptionId }}
        identityRef:
          apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
          kind: AzureClusterIdentity
          name: azure-cluster-identity
          namespace: bootstrap
      machinePools:
      - name: pool0
        replicas: 1
        mode: System
        sku: Standard_D2s_v3
      - name: pool1
        replicas: 2
        mode: User
        sku: Standard_D2s_v3
{{ end }}
{{ if eq .Provider "google" }}
  secret:
    GCP_B64ENCODED_CREDENTIALS: {{ .Context.Credentials | quote }}
  cloud:
    gcp:
      version: v1.3.1
      fetchConfigUrl: https://github.com/pluralsh/cluster-api-provider-gcp/releases
      credentialsRef:
        name: variables
        key: GCP_B64ENCODED_CREDENTIALS
      managedCluster:
        project: pluralsh
        region: europe-central2
        network:
          autoCreateSubnetworks: true
          name: plrl-clusterapi-demo-network
          subnets:
            - name: plrl-clusterapi-demo-subnetwork
              cidrBlock: 10.0.32.0/20
              region: europe-central2
      controlPlane:
        location: europe-central2
        project: pluralsh
        enableAutopilot: false
      machinePool:
        replicas: 3
{{ end }}