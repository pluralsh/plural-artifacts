config:
  databases:
    connection:
      password: {{ dedupe . "pipelines.config.databases.connection.password" (randAlphaNum 20) }}
  objectStore:
    bucketName: {{ .Values.pipelines_bucket }}
    bucketRegion: {{ .Region }}