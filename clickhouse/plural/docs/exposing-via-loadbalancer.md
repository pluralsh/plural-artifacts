# Expose your clickhouse installation via a load balancer

You can opt into using a load balancer service to expose your clickhouse installation.  This can be especially useful if you'd like services outside your k8s cluster to access it.  It requires a minor change to your ClickhouseInstallation crd, like so:

```yaml
apiVersion: "clickhouse.altinity.com/v1"
kind: "ClickHouseInstallation"
metadata:
  
  # your clickhouse metadata

spec:
  
  # additional clickhouse spec

  templates:
    serviceTemplates:
      - name: chi-service-template
        generateName: "service-{chi}"
        # type ObjectMeta struct from k8s.io/meta/v1
        metadata:
          labels:
            custom.label: "custom.value"
          annotations:
            # For more details on Internal Load Balancer check
            # https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
            external-dns.alpha.kubernetes.io/hostname: "your.dns.name" # NOTE: this should be under the domain specified in `workspace.yaml`

            service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing # can also be "internal" if you'd rather it be only accessible w/in your vpc
            service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
            service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
            service.beta.kubernetes.io/aws-load-balancer-type: external
            service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
            service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"

            ## aws and gcp annotations to opt into private network load balancing
            networking.gke.io/load-balancer-type: "Internal"
            service.beta.kubernetes.io/azure-load-balancer-internal: "true"

            # NLB Load Balancer
            service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
        # type ServiceSpec struct from k8s.io/core/v1
        spec:
          ports:
            - name: http
              port: 8123
            - name: tcp
              port: 9000
          type: LoadBalancer
```

