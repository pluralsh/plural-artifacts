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
      22: gitlab/gitlab-gitlab-shell:22:PROXY # only include :PROXY for AWS, which requires proxy-protocol to be enabled
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