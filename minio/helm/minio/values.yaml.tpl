secret:
  accessKey: {{ dedupe . "minio.secret.accessKey" (randAlphaNum 20) }}
  secretKey: {{ dedupe . "minio.secret.secretKey" (randAlphaNum 30) }}
