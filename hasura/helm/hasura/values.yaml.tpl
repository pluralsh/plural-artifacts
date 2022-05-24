{{ $postgresPwd := dedupe . "hasura.hasura.pgClient.external.password" (randAlphaNum 40) }}

global:
  application:
    links:
    - url: {{ .Values.hostname }}
      description: hasura dns name

postgres:
  password: {{ $postgresPwd }}

ingress:
  host: {{ .Values.hostname }}

hasura:
  adminSecret: {{ dedupe . "hasura.hasura.adminSecret" (randAlphaNum 40) }}
  jwt:
    key: {{ dedupe . "hasura.hasura.jwt.key" (randAlphaNum 40) }}
  {{ if not .Values.postgresqlDisabled }}
  pgClient:
    external: 
      enabled: true
      host: plural-hasura
      port: 5432
      username: hasura
      database: hasura
      password: {{ $postgresPwd }}
  {{ else }}
  pgClient:
    external: 
      enabled: true
  {{ end }}