{{ $providerArgs := dict "provider" .Provider "cluster" .Cluster }}
{{ if eq .Provider "google" }}
  {{ $_ := set $providerArgs "provider" "gcp" }}
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
{{ if eq $providerArgs.provider "gcp" }}
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