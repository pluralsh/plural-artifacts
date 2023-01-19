{{/* vim: set filetype=mustache: */}}
{{/*
Return the env variables for upgrade jobs
*/}}
{{- define "datahub.upgrade.env" -}}
- name: ENTITY_REGISTRY_CONFIG_PATH
  value: /datahub/datahub-gms/resources/entity-registry.yml
- name: DATAHUB_GMS_HOST
  value: {{ printf "%s-%s" .Release.Name "datahub-gms" }}
- name: DATAHUB_GMS_PORT
  value: "{{ .Values.datahub.global.datahub.gms.port }}"
- name: DATAHUB_MAE_CONSUMER_HOST
  value: {{ printf "%s-%s" .Release.Name "datahub-mae-consumer" }}
- name: DATAHUB_MAE_CONSUMER_PORT
  value: "{{ .Values.datahub.global.datahub.mae_consumer.port }}"
- name: EBEAN_DATASOURCE_USERNAME
  value: "{{ .Values.datahub.global.sql.datasource.username }}"
- name: EBEAN_DATASOURCE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.datahub.global.sql.datasource.password.secretRef }}"
      key: "{{ .Values.datahub.global.sql.datasource.password.secretKey }}"
- name: EBEAN_DATASOURCE_HOST
  value: "{{ .Values.datahub.global.sql.datasource.host }}"
- name: EBEAN_DATASOURCE_URL
  value: "{{ .Values.datahub.global.sql.datasource.url }}"
- name: EBEAN_DATASOURCE_DRIVER
  value: "{{ .Values.datahub.global.sql.datasource.driver }}"
- name: KAFKA_BOOTSTRAP_SERVER
  value: "{{ .Values.datahub.global.kafka.bootstrap.server }}"
- name: KAFKA_SCHEMAREGISTRY_URL
  value: "{{ .Values.datahub.global.kafka.schemaregistry.url }}"
- name: ELASTICSEARCH_HOST
  value: {{ .Values.datahub.global.elasticsearch.host | quote }}
- name: ELASTICSEARCH_PORT
  value: {{ .Values.datahub.global.elasticsearch.port | quote }}
- name: SKIP_ELASTICSEARCH_CHECK
  value: {{ .Values.datahub.global.elasticsearch.skipcheck | quote }}
- name: ELASTICSEARCH_INSECURE
  value: {{ .Values.datahub.global.elasticsearch.insecure | quote }}
{{- with .Values.datahub.global.elasticsearch.useSSL }}
- name: ELASTICSEARCH_USE_SSL
  value: {{ . | quote }}
{{- end }}
{{- with .Values.datahub.global.elasticsearch.auth }}
- name: ELASTICSEARCH_USERNAME
  value: {{ .username }}
- name: ELASTICSEARCH_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .password.secretRef }}"
      key: "{{ .password.secretKey }}"
{{- end }}
{{- with .Values.datahub.global.elasticsearch.indexPrefix }}
- name: INDEX_PREFIX
  value: {{ . }}
{{- end }}
- name: GRAPH_SERVICE_IMPL
  value: {{ .Values.datahub.global.graph_service_impl }}
{{- if eq .Values.datahub.global.graph_service_impl "neo4j" }}
- name: NEO4J_HOST
  value: "{{ .Values.datahub.global.neo4j.host }}"
- name: NEO4J_URI
  value: "{{ .Values.datahub.global.neo4j.uri }}"
- name: NEO4J_USERNAME
  value: "{{ .Values.datahub.global.neo4j.username }}"
- name: NEO4J_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.datahub.global.neo4j.password.secretRef }}"
      key: "{{ .Values.datahub.global.neo4j.password.secretKey }}"
{{- end }}
{{- if .Values.datahub.global.springKafkaConfigurationOverrides }}
{{- range $configName, $configValue := .Values.datahub.global.springKafkaConfigurationOverrides }}
- name: SPRING_KAFKA_PROPERTIES_{{ $configName | replace "." "_" | upper }}
  value: {{ $configValue | quote }}
{{- end }}
{{- end }}
{{- if .Values.datahub.global.credentialsAndCertsSecrets }}
{{- range $envVarName, $envVarValue := .Values.datahub.global.credentialsAndCertsSecrets.secureEnv }}
- name: SPRING_KAFKA_PROPERTIES_{{ $envVarName | replace "." "_" | upper }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Values.datahub.global.credentialsAndCertsSecrets.name }}
      key: {{ $envVarValue }}
{{- end }}
{{- end }}
{{- end -}}