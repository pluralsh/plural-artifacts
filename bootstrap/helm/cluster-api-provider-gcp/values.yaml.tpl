cluster-api-provider-gcp:
  serviceAccounts:
    manager:
      annotations:
        iam.gke.io/gcp-service-account: {{ importValue "Terraform" "capi_sa_workload_identity_email" }}
