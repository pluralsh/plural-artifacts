{{ $postgresPwd := dedupe . "hasura.hasura.postgres.password" (randAlphaNum 40) }}
{{ $jwtKey := dedupe . "hasura.hasura.jwtKey" (randAlphaNum 40) }}

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
  dbUrl: postgres://hasura:{{ $postgresPwd }}@plural-hasura:5432/hasura
  jwtKey: {{ $jwtKey }}
  adminSecret: {{ dedupe . "hasura.hasura.adminSecret" (randAlphaNum 40) }}
  jwtSecret: "{\"key\": \"{{ $jwtKey }}\", \"type\": \"HS256\"}"