ingress:
  host: {{ .Values.hostname }}

minio:
  password: {{ dedupe . "touca.minio.password" (randAlphaNum 20) }}

mongoNamespace: {{ namespace "mongodb" }}