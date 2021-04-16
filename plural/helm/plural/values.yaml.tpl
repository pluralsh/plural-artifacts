postgresql:
  postgresqlPassword: {{ dedupe . "plural.postgresql.postgresqlPassword" (randAlphaNum 14) }}
  postgresqlPostgresPassword: {{ dedupe . "plural.postgresql.postgresqlPostgresPassword" (randAlphaNum 14) }}

rabbitmq:
  auth:
    password: {{ dedupe . "plural.rabbitmq.auth.password" (randAlphaNum 26) }}
    erlangCookie: {{ dedupe . "plural.rabbitmq.auth.erlangCookie" (randAlphaNum 26) }}

influxdb:
  setDefaultUser:
    user:
      password: {{ dedupe . "plural.influxdb.setDefaultUser.user.password" (randAlphaNum 26) }}

provider: {{ .Provider }}
region: {{ .Region }}

serviceAccountAnnotations:
  eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/plural"

registry:
  rbac:
    serviceAccountAnnotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/plural"
  configData:
    storage:
      {{ if eq .Provider "google" }}
      gcs:
        bucket: {{ .Values.images_bucket }}
      {{ end }}
      {{ if eq .Provider "aws" }}
      s3:
        region: {{ .Region }}
        bucket: {{ .Values.images_bucket }}
      {{ end }}
    auth:
      token:
        realm: https://{{ .Values.plural_dns }}/auth/token
        service: {{ .Values.plural_dkr_dns }}
        issuer: {{ .Values.plural_dns }}

{{ $certificate := genCA "plural" 1886 }}

secrets:
  jwt: {{ dedupe . "plural.secrets.jwt" (randAlphaNum 14) }}
  erlang: {{ dedupe . "plural.secrets.erlang" (randAlphaNum 14) }}
  jwt_pk: {{ dedupe . "plural.secrets.jwt_pk" $certificate.Key | quote }}
  jwt_cert: {{ dedupe . "plural.secrets.jwt_cert" $certificate.Cert | quote }}
  jwt_aud: {{ .Values.plural_dkr_dns }}
  jwt_iss: {{ .Values.plural_dns }}
  aes_key: {{ dedupe . "plural.secrets.aes_key" genAESKey }}

admin:
  enabled: true
  name: {{ .Values.admin_name }}
  email: {{ .Values.admin_email }}
  password: {{ dedupe . "plural.admin.password" (randAlphaNum 14) }}
  publisher: {{ .Values.publisher }}
  publisher_description: {{ .Values.publisher_description }}

ingress:
  dns: {{ .Values.plural_dns }}
  dkr_dns: {{ .Values.plural_dkr_dns }}

api:
  bucket: {{ .Values.assets_bucket }}

chartmuseum:
  bucket: {{ .Values.chartmuseum_bucket }}
  rbac:
    serviceAccountAnnotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/plural"

license: {{ .License | quote }}