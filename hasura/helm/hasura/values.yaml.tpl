{{ $jwtKey := dedupe . "hasura.hasura.jwt.key" (randAlphaNum 40) }}
{{ $dbName := dedupe . "hasura.hasura.pgClient.external.database" "hasura" }}
{{ $dbUsername := dedupe . "hasura.hasura.pgClient.external.username" "hasura" }}
{{ $dbHost := dedupe . "hasura.hasura.pgClient.external.host" "plural-hasura" }}
{{ $dbPort := dedupe . "hasura.hasura.pgClient.external.port | quote" "5432" }}

global:
  application:
    links:
    - url: {{ .Values.hostname }}
      description: hasura dns name

ingress:
  host: {{ .Values.hostname }}

postgres:
  enabled: true

hasura:
  database:
    name: hasura
    username: hasura
    hostname: plural-hasura
    port: 5432
  adminSecret: {{ dedupe . "hasura.hasura.adminSecret" (randAlphaNum 40) }}
  jwtSecret:
    key: {{ $jwtKey }}
    type: "HS256"
  jwt:
    key: {{ $jwtKey }}
  {{ if .Values.postgresqlDisabled }}
  database:
    name: {{ $dbName }}
    username: {{ $dbUsername }}
    hostname: {{ $dbHost }}
    port: {{ $dbPort }}
postgres:
  enabled: false
  {{ end }}
