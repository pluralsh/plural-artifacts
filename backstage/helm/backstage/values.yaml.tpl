{{ $backstagePgPwd := dedupe . "backstage.postgres.password" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: backstage web ui
      url: {{ .Values.hostname }}

postgres:
  password: {{ $backstagePgPwd }}

backstage:
  ingress:
    host: {{ .Values.hostname }}

  backstage:
    appConfig:
      backend:
        database:
          client: pg
          connection:
            user: backstage
            host: plural-postgres-backstage
            port: "5432"
            database: backstage
            password: {{ $backstagePgPwd }}
            ssl: "true"
    extraEnvVars:
      - name: APP_CONFIG_app_baseUrl
        value: https://{{ .Values.hostname }}
      - name: APP_CONFIG_backend_baseUrl
        value: https://{{ .Values.hostname }}
      - name: NODE_TLS_REJECT_UNAUTHORIZED
        value: "0"