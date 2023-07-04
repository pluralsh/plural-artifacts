{{ $grafanaAgent := and .Configuration (index .Configuration "grafana-agent") }}
{{ $tempo := and .Configuration .Configuration.tempo }}
{{- if and $grafanaAgent $tempo }}
{{ $grafanaAgentNamespace := namespace "grafana-agent" }}
{{- end }}

{{ $hydraPostgresPass := dedupe . "trace-shield.postgresHydra.password" (randAlphaNum 32) }}
postgresHydra:
  password: {{ $hydraPostgresPass}}

{{ $ketoPostgresPass := dedupe . "trace-shield.postgresKeto.password" (randAlphaNum 32) }}
postgresKeto:
  password: {{ $ketoPostgresPass}}

{{ $kratosPostgresPass := dedupe . "trace-shield.postgresKratos.password" (randAlphaNum 32) }}
postgresKratos:
  password: {{ $kratosPostgresPass}}

config:
  hostname: {{ .Values.frontendHostname }}
  tenant:
    create: true
    name: {{ .Cluster }}
  {{- if and .Configuration.mimir .Configuration.mimir.hostname }}
  mimir:
    enabled: true
    publicURL: {{ .Configuration.mimir.hostname }}
  {{- end }}
  {{- if and .Configuration.loki .Configuration.loki.hostname }}
  loki:
    enabled: true
    publicURL: {{ .Configuration.loki.hostname }}
  {{- end }}
  {{- if and .Configuration.tempo .Configuration.tempo.hostname }}
  tempo:
    enabled: true
    publicURL: {{ .Configuration.tempo.hostname }}
  {{- end }}

{{- if and $grafanaAgent $tempo }}
backend:
  extraEnv:
  - name: OTEL_EXPORTER_OTLP_ENDPOINT
    value: http://grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:4318
  - name: OTEL_EXPORTER_OTLP_TRACES_INSECURE
    value: "true"
  - name: OTEL_SERVICE_NAME
    value: trace-shield-backend
{{- end }}

ingress:
  hosts:
    - host: {{ .Values.frontendHostname }}
      backendPaths:
        - path: /graphql
          pathType: Prefix
        - path: /graphiql
          pathType: Prefix
        - path: /check
          pathType: Prefix
        - path: /user-webhook
          pathType: Prefix
        - path: /oauth2/consent
          pathType: Prefix
      frontendPaths:
        - path: /.*
          pathType: Prefix
  tls:
   - secretName: trace-shield-tls
     hosts:
       - {{ .Values.frontendHostname }}

kratos:
  kratos:
    config:
      {{- if and $grafanaAgent $tempo }}
      tracing:
        service_name: Ory Kratos
        provider: otel
        providers:
          otlp:
            insecure: true
            sampling:
              sampling_ratio: 1.0
            server_url: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:4318
      {{- end }}
      cookies:
        {{- if .Values.frontendHostname }}
        domain: {{ regexReplaceAll "^.+?\\." .Values.frontendHostname "" }}
        {{- end }}
      serve:
        public:
          base_url: https://{{ .Values.frontendHostname }}/.ory/kratos/public/
      dsn: postgres://kratos:{{ $kratosPostgresPass }}@plural-postgres-kratos:5432/kratos
      selfservice:
        default_browser_return_url: https://{{ .Values.frontendHostname }}/
        flows:
          error:
            ui_url: https://{{ .Values.frontendHostname }}/error
          settings:
            ui_url: https://{{ .Values.frontendHostname }}/settings
          recovery:
            ui_url: https://{{ .Values.frontendHostname }}/recovery
          verification:
            ui_url: https://{{ .Values.frontendHostname }}/verification
            after:
              default_browser_return_url: https://{{ .Values.frontendHostname }}/
          logout:
            after:
              default_browser_return_url: https://{{ .Values.frontendHostname }}/login
          login:
            ui_url: https://{{ .Values.frontendHostname }}/login
          registration:
            ui_url: https://{{ .Values.frontendHostname }}/registration
        methods:
          webauthn:
            config:
              rp:
                id: {{ .Values.frontendHostname }}
                origin: https://{{ .Values.frontendHostname }}/login
  ingress:
    public:
      enabled: true
      hosts:
        - host: {{ .Values.frontendHostname }}
          paths: 
            - path: /.ory/kratos/public/(.*)
              pathType: Prefix
      tls:
      - secretName: trace-shield-tls
        hosts:
          - {{ .Values.frontendHostname }}

kratosSecrets:
  default: {{dedupe . "trace-shield.kratosSecrets.default" (randAlphaNum 32) }}
  cipher: {{dedupe . "trace-shield.kratosSecrets.cipher" (randAlphaNum 32) }}
  cookie: {{dedupe . "trace-shield.kratosSecrets.cookie" (randAlphaNum 32) }}

hydraSecrets:
  dsn: postgres://hydra:{{ $hydraPostgresPass }}@plural-postgres-hydra:5432/hydra
  system: {{dedupe . "trace-shield.hydraSecrets.system" (randAlphaNum 32) }}
  cookie: {{dedupe . "trace-shield.hydraSecrets.cookie" (randAlphaNum 32) }}

hydra:
  hydra:
    config:
      {{- if and $grafanaAgent $tempo }}
      tracing:
        service_name: Ory Hydra
        provider: otel
        providers:
          otlp:
            insecure: true
            sampling:
              sampling_ratio: 1.0
            server_url: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:4318
      {{- end }}
      urls:
        self:
          issuer: https://{{ .Values.hydraHostname }}
        login: https://{{ .Values.frontendHostname }}/login
        consent: https://{{ .Values.frontendHostname }}/consent
  ingress:
    public:
      hosts:
      - host: {{ .Values.hydraHostname }}
        paths:
        - path: /.*
          pathType: ImplementationSpecific
      tls:
      - hosts:
        - {{ .Values.hydraHostname }}
        secretName: hydra-tls

keto:
  keto:
    config:
      {{- if and $grafanaAgent $tempo }}
      tracing:
        service_name: Ory Keto
        provider: otel
        providers:
          otlp:
            insecure: true
            sampling:
              sampling_ratio: 1.0
            server_url: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:4318
      {{- end }}
      dsn: postgres://keto:{{ $ketoPostgresPass }}@plural-postgres-keto:5432/keto

oathkeeper:
  oathkeeper:
    config:
      {{- if and $grafanaAgent $tempo }}
      tracing:
        service_name: Ory Oathkeeper
        provider: otel
        providers:
          otlp:
            insecure: true
            sampling:
              sampling_ratio: 1.0
            server_url: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:4318
      {{- end }}
      errors:
        handlers:
          redirect:
            enabled: true
            config:
              to: https://{{ .Values.frontendHostname }}/login
