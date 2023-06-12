provider: {{ .Provider }}
{{ if eq .Provider "azure" }}
kubernetesVersion: v1.26.3
{{ end }}
operator:
  clusterName: {{ .Cluster }}
  bootstrapMode: false
  moveCluster: false
  secret: {}
  cloud: {}
{{ if eq .Provider "aws" }}
  secret:
    AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | b64enc | quote }}
    AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | b64enc | quote }}
    AWS_SESSION_TOKEN: {{ .Context.SessionToken | b64enc | quote }}
    AWS_ACCOUNT_ID: {{ .Context.AWSAccountID | b64enc | quote }}
  cloud:
    aws:
      region: {{ .Region }}
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
        roleName: {{ .Cluster }}-cluster-autoscaler
        wellKnownPolicies:
          autoScaler: true
      - metadata:
          name: ebs-csi-controller
          namespace: bootstrap
        roleOnly: true
        roleName: {{ .Cluster }}-ebs-csi
        wellKnownPolicies:
          ebsCSIController: true
      - metadata:
          name: external-dns
          namespace: bootstrap
        roleOnly: true
        roleName: {{ .Cluster }}-externaldns
        wellKnownPolicies:
          externalDNS: true
      - metadata:
          name: certmanager
          namespace: bootstrap
        roleOnly: true
        roleName: {{ .Cluster }}-certmanager
        wellKnownPolicies:
          certManager: true
      - metadata:
          name: alb-operator
          namespace: bootstrap
        roleOnly: true
        roleName: {{ .Cluster }}-alb
        wellKnownPolicies:
          awsLoadBalancerController: true
      - metadata:
          name: capa-controller-manager
          namespace: bootstrap
        roleOnly: true
        roleName: capa-controller-manager
        attachPolicyARNs:
        - "arn:aws:iam::aws:policy/AdministratorAccess"
      accessKeyIdRef:
        name: variables
        key: AWS_ACCESS_KEY_ID
      secretAccessKeyRef:
        name: variables
        key: AWS_SECRET_ACCESS_KEY
      sessionTokenRef:
        name: variables
        key: AWS_SESSION_TOKEN
      accountIDRef:
        name: variables
        key: AWS_ACCOUNT_ID
{{ end }}
{{ if eq .Provider "azure" }}
  clientSecret: {{ .Context.ClientSecret | b64enc | quote }}
  cloud:
    azure:
      version: v1.9.6
      fetchConfigUrl: https://github.com/pluralsh/cluster-api-provider-azure/releases
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
      project: {{ .Project }}
      region: {{ .Region }}
      version: v1.3.2
      fetchConfigUrl: https://github.com/pluralsh/cluster-api-provider-gcp/releases
      credentialsRef:
        name: variables
        key: GCP_B64ENCODED_CREDENTIALS
      cluster:
        network:
          autoCreateSubnetworks: true
          name: plrl-clusterapi-demo-network
          subnets:
            - name: plrl-clusterapi-demo-subnetwork
              cidrBlock: 10.0.32.0/20
      controlPlane:
        enableAutopilot: false
        enableWorkloadIdentity: true
      machinePool:
        replicas: 3
{{ end }}