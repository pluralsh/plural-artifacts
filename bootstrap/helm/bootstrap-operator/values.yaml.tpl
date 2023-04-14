operator:
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