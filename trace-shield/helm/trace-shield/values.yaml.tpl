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

kratos:
  kratos:
    config:
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

hydraSecrets:
  dsn: postgres://hydra:{{ $hydraPostgresPass }}@plural-postgres-hydra:5432/hydra
  system: {{dedupe . "trace-shield.hydraSecrets.system" (randAlphaNum 32) }}
  cookie: {{dedupe . "trace-shield.hydraSecrets.cookie" (randAlphaNum 32) }}

hydra:
  hydra:
    config:
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
      dsn: postgres://keto:{{ $ketoPostgresPass }}@plural-postgres-keto:5432/keto
