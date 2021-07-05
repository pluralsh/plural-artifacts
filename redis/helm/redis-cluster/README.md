# Redis Cluster

Typed in-memory database deployable on plural kubernetes.

We use bitnami's redis chart as our base, as it's the best supported open source k8s redis deployment at the moment.

This will deploy a sharded redis setup, with sentinel support available also