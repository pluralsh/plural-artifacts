cluster-api-provider-aws:
  configVariables:
    awsControllerIamRole: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
