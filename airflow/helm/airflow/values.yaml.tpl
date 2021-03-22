secrets:
  redis_password: {{ dedupe . "airflow.secrets.redis_password" (randAlphaNum 14) }}

airflow:
  postgresql:
    postgresqlPassword: {{ dedupe . "watchman.postgresql.postgresqlPassword" (randAlphaNum 20) }}
  web:
    baseUrl: {{ .Values.hostname }}
  ingress:
    web:
      host: {{ .Values.hostname }}