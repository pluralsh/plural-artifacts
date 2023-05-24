provider: {{ .Provider }}
{{ if eq .Provider "azure" }}
kubernetesVersion: v1.26.3
{{ end }}
operator:
  clusterName: {{ .Cluster }}
  secret: {}
  cloud: {}
{{ if eq .Provider "aws" }}
  secret:
    AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | b64enc | quote }}
    AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | b64enc | quote }}
    AWS_SESSION_TOKEN: {{ .Context.SessionToken | b64enc | quote }}
  cloud:
    aws:
      region: eu-central-1
      version: v2.0.2
      machinePools:
        - name: {{ .Cluster }}-pool-0
          replicas: 1
          instanceType: t2.large
          scaling:
            minSize: 1
            maxSize: 11
        - name: {{ .Cluster }}-pool-1
          replicas: 1
          instanceType: t2.large
          scaling:
            minSize: 1
            maxSize: 11
        - name: {{ .Cluster }}-pool-2
          replicas: 1
          instanceType: t2.large
          scaling:
            minSize: 1
            maxSize: 11
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
      version: v1.3.2
      fetchConfigUrl: https://github.com/pluralsh/cluster-api-provider-gcp/releases
      credentialsRef:
        name: variables
        key: GCP_B64ENCODED_CREDENTIALS
{{ end }}