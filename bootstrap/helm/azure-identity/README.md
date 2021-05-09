# Azure Identity

Configures azure managed pod identity to securely assume Azure credentials in-cluster.  AKS is currently a bit behind both EKS and GKE in rolling out proper workload identity solutions connected to the k8s api, so we need to use this shim in the meantime.