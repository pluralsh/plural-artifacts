global:
  application:
    links:
    - description: openmetadata web ui
      url: {{ .Values.hostname }}
  elasticsearch:
    host: elasticsearch-es-http.{{ namespace "elasticsearch" }}

elasticNamespace: {{ namespace "elasticsearch" }}