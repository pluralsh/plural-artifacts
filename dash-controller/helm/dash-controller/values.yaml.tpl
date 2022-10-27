dash:
  image: {{ .Values.dashImage }}
  containerPort: {{ .Values.dashContainerPort }}
  host: {{ .Values.dashDomain }}