{{- define "lakefs.env" -}}
env:
  {{- if .Values.secrets }}
  - name: LAKEFS_DATABASE_CONNECTION_STRING
    valueFrom:
      secretKeyRef:
        name: {{ include "lakefs.fullname" . }}
        key: database_connection_string
  - name: LAKEFS_AUTH_ENCRYPT_SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "lakefs.fullname" . }}
        key: auth_encrypt_secret_key
  {{- else if or (not .Values.lakefsConfig) .Values.localPostgres }}
  - name: LAKEFS_DATABASE_CONNECTION_STRING
    value: postgres://postgres:password@localhost:5432/postgres?sslmode=disable
  - name: LAKEFS_AUTH_ENCRYPT_SECRET_KEY
    value: asdjfhjaskdhuioaweyuiorasdsjbaskcbkj
  {{- end }}
  {{- if not .Values.lakefsConfig }}
  - name: LAKEFS_BLOCKSTORE_TYPE
    value: local
  - name: LAKEFS_BLOCKSTORE_LOCAL_PATH
    value: /lakefs/data
  {{- end }}
  {{- if .Values.s3Fallback.enabled }}
  - name: LAKEFS_GATEWAYS_S3_FALLBACK_URL
    value: http://localhost:7001
  {{- end }}
  {{- if .Values.committedLocalCacheVolume }}
  - name: LAKEFS_COMMITTED_LOCAL_CACHE_DIR
    value: /lakefs/cache
  {{- end }}
  {{- if .Values.extraEnvVars }}
  {{- toYaml .Values.extraEnvVars | nindent 2 }}
  {{- end }}
{{- if .Values.extraEnvVarsSecret }}
envFrom:
  - secretRef:
      name: {{ .Values.extraEnvVarsSecret }}
{{- end }}
{{- end }}

{{- define "lakefs.volumes" -}}
{{- if .Values.extraVolumes }}
{{ toYaml .Values.extraVolumes }}
{{- end }}
{{- if .Values.committedLocalCacheVolume }}
- name: committed-local-cache
{{- toYaml .Values.committedLocalCacheVolume | nindent 2 }}
{{- end }}
{{- if or (not .Values.lakefsConfig) .Values.localPostgres }}
- name: {{ .Chart.Name }}-postgredb
{{- end }}
{{- if not .Values.lakefsConfig }}
- name: {{ .Chart.Name }}-local-data
{{- end}}
{{- if .Values.lakefsConfig }}
- name: config-volume
  configMap:
    name: {{ include "lakefs.fullname" . }}
    items:
      - key: config.yaml
        path: config.yaml
{{- end }}
{{- end }}