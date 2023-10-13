## Running Airbyte Workloads on Custom Node Group

There may be a desire to run your Airbyte workloads on a specific node size for large workloads, or maybe even 
[spot instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html) to achieve higher cost 
savings.

### create custom node group

In order to run your Airbyte Workloads on custom configured nodes, you will need to first follow [these docs](https://docs.plural.sh/operations/cluster-configuration#modifying-node-types)
to create your desired nodes. For example, if you were on AWS and wanted to use spot instances you would add something 
like this to your `bootstrap/terraform/main.tf` file:

```yaml
multi_az_node_groups = {
  medium_burst_spot = {
      name = "medium-burst-spot"
      min_capacity = 3
      desired_capacity = 3
      instance_types = ["t3.xlarge", "t3a.xlarge"]
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "medium-burst-spot"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
}
```

Then run `plural deploy --commit "add more spot nodes"` to update your cluster.

> ! If you get an error like `InvalidParameterException: Minimum capacity 3 can't be greater than desired size 0` you 
> may have to use your cloud CLI or console to enact the change manually and then try running again.

### update airbyte to use node group

After creating your custom node group, you can point configure Airbyte to use it by adding the following to your 
`./airbyte/helm/values.yaml` (this can also be done in the plural application console)

```yaml
global:
  jobs:
    kube:
      nodeSelector:
        plural.sh/capacityType: SPOT
      tolerations:
      - effect: NoSchedule
        key: plural.sh/capacityType
        operator: Equal
        value: SPOT
```

### redeploy

From there, you should be able to run `plural build --only airbyte && plural deploy --commit "run on spot instances"` to 
use the custom node group to execute your workloads.