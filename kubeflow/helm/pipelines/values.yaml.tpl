config:
  databases:
    connection:
      password: {{ dedupe . "pipelines.config.databases.connection.password" (randAlphaNum 20) }}
  objectStore:
    {{- if eq .Provider "google" }}
    bucketHost: storage.googleapis.com
    {{- end }}
    bucketName: {{ .Values.pipelines_bucket }}
    bucketRegion: {{ .Region }}
