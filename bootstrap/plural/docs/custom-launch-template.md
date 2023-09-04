# Using a Custom EC2 Launch Template

EKS provides a lot of freedom for creating node groups, and its sometimes useful for security reasons (creating a golden AMI or tuning specific settings) to dive deeper into node setup.  The best way to do this is to use a custom launch template tuned to your exact specifications.  This will walk you through how to set that up, as it'll require a few minor terraform modifications.

## Register the new launch template

In `bootstrap/terraform` create a new file `launch-template.tf` where you can use one of our pre-made modules like this:

```tf
module "launch_template" {
  source   = "github.com/pluralsh/module-library//terraform/eks-node-groups/launch-template?ref=eks-node-groups-v1.0.0"
  launch_template_name = "sysbox-launch-template"
  ami_filter_name      = "plural/sysbox-eks_0.6.2/k8s_1.23/ubuntu-focal-20.04-amd64-server/0.1.1"
  ami_owners           = ["654897662046"]
  create_key_pair      = true
  block_device_mappings = {
    device_name = "/dev/xvda"
    ebs = {
        volume_size           = 50
        volume_type           = "gp2"
        delete_on_termination = true
    }
  }
  enable_bootstrap_user_data = true
  bootstrap_extra_args       = "--use-max-pods true"
  max_pods_per_node          = 69
}
```

I'd recommend going to https://github.com/pluralsh/module-library/terraform/eks-node-groups/launch-template to see the exact settings you might want to add.  I just included the defaults in our sysbox launch template as a demonstration.

## Wire up node group defaults to use that launch template

In `bootstrap/terraform/main.tf` you'll want to rewire `aws-bootstrap` to set that as the default launch template, you'll want to do that in the `MANUAL SECTION` that should be explicitly marked something like so:

```tf
module "aws-bootstrap" {
### BEGIN MANUAL SECTION <<aws-bootstrap>>
  node_group_defaults = {
    launch_template_id = module.launch_template.launch_template_id

    # existing defaults to preserve
    desired_capacity = 0
    min_capacity = 0
    max_capacity = 27

    instance_types = ["t3.large", "t3a.large"]
    disk_size = 50
    ami_release_version = "1.24.15-20230816"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }
### END MANUAL SECTION <<aws-bootstrap>>
}
```

## Apply changes

Once both those files have been set up, you should be able to apply the change.  If you want to be safe you can run a terraform plan first by doing:

```sh
cd bootstrap/terraform && terraform plan
```

And if you're confident you want to apply the change, then simply do a `plural deploy --commit "apply new launch templates".

Note this will rotate your entire worker fleet so some apps might be temporarily unavailable as the node groups are replaced.
