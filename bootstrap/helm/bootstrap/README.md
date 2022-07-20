# Helm Chart for basic kubernetes dependencies

Includes core dependencies you likely need per provider, and installs plurals base CRDs:

* external-dns
* cert-manager

For aws, we optionally install:

* cluster-autoscaler
* aws-load-balancer-controller

Since both are not truly supported within EKS, in particular NLB support is substantially diminished without aws-load-balancer-controller.

## Plural-specific dependencies

A number of tools to improve the experience using plural applications are also installed, including the kube-app-controller to provide application-level health checks and kubed to sync plural's pull secrets across namespaces.

## Example Configuration

```yaml
external-dns:
  provider: google
  txtOwnerId: myservice
  rbac:
    create: true
    serviceAccountName: external-dns
  domainFilters:
  - myservice.com
  google:
    project: gcp-project-id
    serviceAccountSecret: externaldns
```
