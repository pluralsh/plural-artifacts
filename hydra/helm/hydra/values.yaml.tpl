{{ $hydraHost := .Values.hostname }}
{{ $adminHost := .Values.adminHostname }}
{{ $hydraPassword := dedupe . "hydra.postgres.password" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: hydra api
      url: {{ $hydraHost }}
    {{ if $adminHost }}
    - description: hydra admin api
      url: {{ $adminHost }}
    {{ end }}

postgres:
  password: {{ $hydraPassword }}

hydra:
  hydra:
    config:
      dsn: "postgres://hydra:{{ $hydraPassword }}@plural-postgres-hydra:5432/hydra"
      secrets:
        system: [{{ dedupe . "hydra.hydra.secrets.system" (randAlphaNum 20) }}]
        cookie: {{ dedupe . "hydra.hydra.secrets.cookie" (randAlphaNum 20) }}
      urls:
        self:
          issuer: https://{{ $hydraHost }}/
        login: {{ .Values.loginUrl }}
        consent: {{ .Values.consentUrl }}
  ingress:
    public:
      hosts:
      - host: {{ $hydraHost }}
        paths: 
        - path: "/.*"
          pathType: ImplementationSpecific
      tls:
      - hosts:
        - {{ $hydraHost }}
        secretName: hydra-tls
    {{ if $adminHost }}
    admin:
      enabled: true
      hosts:
      - host: {{ $adminHost }}
        paths: 
        - path: "/.*"
          pathType: ImplementationSpecific
      tls:
      - hosts:
        - {{ $adminHost }}
        secretName: hydra-admin-tls
    {{ end }}