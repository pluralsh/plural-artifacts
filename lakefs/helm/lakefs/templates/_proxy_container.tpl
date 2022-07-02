{{- define "lakefs.s3proxyContainer" }}
{{- if .Values.lakefsConfig }}
{{ $config := .Values.lakefsConfig | fromYaml  }}
{{- end }}
{{- if .Values.s3Fallback.enabled }}
- name: s3proxy
  image: andrewgaul/s3proxy
  ports:
  - containerPort: 7001
  env:
  - name: S3PROXY_AUTHORIZATION
    value: none
{{- if .Values.s3Fallback.aws_access_key }}
  - name: JCLOUDS_IDENTITY
    value: {{ .Values.s3Fallback.aws_access_key }}
  - name: JCLOUDS_CREDENTIAL
    value: {{ .Values.s3Fallback.aws_secret_key }}
{{- end }}
  - name: JCLOUDS_PROVIDER
    value: s3
  - name: JCLOUDS_ENDPOINT
    value: https://s3.amazonaws.com
  - name: S3PROXY_ENDPOINT
    value: "http://0.0.0.0:7001"
  - name: S3PROXY_VIRTUALHOST
    value: localhost
  - name: LOG_LEVEL
    value: {{ .Values.s3Fallback.log_level | default "info" }}
{{- end }}
{{- end }}