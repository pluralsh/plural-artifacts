istio-operator:
  watchedNamespaces: {{ namespace "istio" }}
istio:
  namespace: {{ namespace "istio" }}
  {{- if .Values.enableEgressGateway }}
  egressGateway:
   enabled: true
   {{- end }}
  istioComponents:
    ingressGateways:
    - name: istio-ingressgateway
      k8s:
        service:
          type: LoadBalancer
        {{- if eq .Provider "aws" }}
        serviceAnnotations:
          service.beta.kubernetes.io/aws-load-balancer-name: {{ .Cluster }}-istio-nlb
          service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'
          service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
          service.beta.kubernetes.io/aws-load-balancer-type: external
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: instance
          proxy.istio.io/config: '{"gatewayTopology" : { "numTrustedProxies": 2 } }'
        {{- end }}
    # Cluster-local gateway for KFServing
    {{ if or .Configuration.kubeflow .Configuration.knative }}
    - name: knative-local-gateway
      enabled: true
      label:
        app: knative-local-gateway
        istio: knative-local-gateway
      k8s:
        env:
        - name: ISTIO_META_ROUTER_MODE
          value: sni-dnat
        hpaSpec:
          maxReplicas: 5
          metrics:
          - resource:
              name: cpu
              targetAverageUtilization: 80
            type: Resource
          minReplicas: 1
          scaleTargetRef:
            apiVersion: apps/v1
            kind: Deployment
            name: knative-local-gateway
        resources:
          limits:
            cpu: 2000m
            memory: 1024Mi
          requests:
            cpu: 100m
            memory: 128Mi
        service:
          type: ClusterIP
          ports:
          - name: status-port
            port: 15020
            targetPort: 15020
          - name: http2
            port: 80
            targetPort: 8080
    {{ end }}
    {{- if .Values.enableEgressGateway }}
    egressGateways:
    - name: istio-egressgateway
      enabled: true
      k8s:
        service:
          ports:
          - port: 443
            targetPort: 8443
            name: tls-https
        overlays:
        - kind: Deployment
          name: istio-egressgateway
          patches:
          - path: spec.template.spec.containers[-1]
            value: |
              name: sni-proxy
              image: dkr.plural.sh/istio/nginx:1.21.6
              volumeMounts:
              - name: sni-proxy-config
                mountPath: /etc/nginx
                readOnly: true
              securityContext:
                runAsNonRoot: true
                runAsUser: 101
          - path: spec.template.spec.volumes[-1]
            value: |
              name: sni-proxy-config
              configMap:
                name: egress-sni-proxy-configmap
                defaultMode: 292 # 0444
    {{- end }}

provider: {{ .Provider }}

{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
{{- if index .Configuration "grafana-tempo" }}
{{ $tempoNamespace := namespace "grafana-tempo" }}
{{- end }}
monitoring:
  namespace: {{ $monitoringNamespace }}
  grafama:
    namespace: {{ $grafanaNamespace }}
  tracing:
    {{- if index .Configuration "grafana-tempo" }}
    tempoNamespace: {{ $tempoNamespace }}
    {{- end }}

kiali-server:
  {{/* {{ if .OIDC }}
  auth:
    strategy: openid
    openid:
      client_id: {{ .OIDC.ClientId }}
      disable_rbac: true
      authentication_timeout: 300
      username_claim: "email"
      client_secret: {{ .OIDC.ClientSecret }}
      issuer_uri: {{ .OIDC.Configuration.Issuer }}
      scopes:
      - "openid"
      - "profile"
  {{ end }} */}}
  deployment:
    override_ingress_yaml:
      metadata:
        annotations:
          kubernetes.io/tls-acme: "true"
          kubernetes.io/ingress.class: "nginx"
          cert-manager.io/cluster-issuer: letsencrypt-prod
          nginx.ingress.kubernetes.io/force-ssl-redirect: 'true'
          nginx.ingress.kubernetes.io/use-regex: "true"
      spec:
        tls:
        - hosts:
          - {{ .Values.kialiHostname }}
          secretName: kiali-tls
        rules:
        - host: {{ .Values.kialiHostname }}
          http:
            paths:
            - path: /.*
              pathType: Prefix
              backend:
                service:
                  name: kiali
                  port:
                    name: http
  namespace: {{ namespace "istio" }}
  istio_namespace: {{ namespace "istio" }}
  external_services:
    prometheus:
      url: http://monitoring-prometheus.{{ $monitoringNamespace }}:9090
    {{ if .Configuration.grafana }}
    {{ $grafanaValues := .Applications.HelmValues "grafana" }}
    grafana:
      auth:
        username: {{ $grafanaValues.grafana.grafana.admin.user }}
        password: {{ $grafanaValues.grafana.grafana.admin.password }}
      url: https://{{ .Configuration.grafana.hostname }}
      in_cluster_url: http://grafana.{{ $grafanaNamespace }}:80
    {{  end }}
    {{- if index .Configuration "grafana-tempo" }}
    tracing:
      in_cluster_url: http://grafana-tempo-tempo-distributed-query-frontend.{{ $tempoNamespace }}:16686
    {{- end }}

{{ if .Configuration.kubeflow }}
{{ $kubeflowNamespace := namespace "kubeflow" }}
kubeflow:
  enabled: true
  namespace: {{ $kubeflowNamespace }}
{{ end }}
