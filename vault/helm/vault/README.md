Hashicorp Vault
===============

Deploys a highly available Hashicorp Vault cluster backed by their
[Integrated
Storage](https://www.vaultproject.io/docs/concepts/integrated-storage).

Please note that this Helm chart does not create or manage any Vault
namespace for you. If you think you need namespaces, please think
again. There is only one real use case for the use of namespaces:
Vault namespaces exist to allow delegating the ability to configure
Vault policies, within a subtree of the Vault path space. Apart from
that, you should be fine just setting up correct policies. If you are
sure you need namespaces, then you will need to configure them once
Vault is deployed.
