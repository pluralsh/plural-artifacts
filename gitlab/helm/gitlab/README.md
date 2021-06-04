# Gitlab

Deploys an off the shelf hosted version of gitlab EE.  This chart is based on gitlab's own chart, details are available here: https://gitlab.com/gitlab-org/charts/gitlab

In addition, we'll deploy plural specific features like dashboards, proxies, etc.  We'll also configure backend storage using the cloud specific object store and ensure you're using the best available database solution we have on the platform.

## Configuration

For configuration of the gitlab chart itself, see https://docs.gitlab.com/charts/charts


## SSH setup

To configure ssh, you need to do a bit of manual work to open port 22 on the ingress resource.  Since plural uses ingress-nginx with TCP support by default, you can follow its guidelines about opening TCP services.  This amounts to adding configuration in your bootstrap application config like

```yaml
bootstrap:
  ...
  ingress-nginx:
    tcp:
      22: gitlab/gitlab-gitlab-shell:22 # add :PROXY to the end of the string for AWS, which requires proxy-protocol to be enabled
```

You might see a message like `Host key verification failed` as a result of attempting to push via ssh.  Simply run:

```bash
ssh -Tvvv -o StrictHostKeyChecking=no git@gitlab.plural.sh
```

To bypass initially to add the hostkey to your known_hosts file 

## Sentry setup

To enable sentry, go to your sentry instance, create a rails project for gitlab, and copy it's dsn address.  Then in the helm values for this application put in configuration like:

```yaml
global:
  ...
  appConfig:
    sentry:
      dsn: https://my-sentry-dsn
      enabled: true
      environment: production
```

## Runner fleet

The gitlab runner will mainly schedule sporadic, fleeting pods to perform CI/CD jobs in your cluster.  This is a great use case for a cheap, ephemeral instances.  The runner is configured by default with an affinity for nodes labeled with `usage-intention: ci` so if you create a node group with those specs using a preemptible instance type, you can run your CI/CD very efficiently.  

This can be figured in our bootstrap chart for the major providers like

### AWS

in the aws-bootstrap module's manual section add

```terraform
node_groups = {
  main = {
    name = "main"
  }

  ci = {
    name = "ci"
    capacity_type = "SPOT"
    desired_capacity = 1
    min_capacity = 1
    instance_types = ["m5.xlarge"]
    k8s_labels = {
      "usage-intention" = "ci"
    }
  }
}
```