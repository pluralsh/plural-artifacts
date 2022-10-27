global:
  application:
    links:
    - description: dash web ui
      url: {{ .Values.hostname }}

dash:
  image: {{ .Values.dashImage }}
  containerPort: {{ .Values.dashContainerPort }}
  host: {{ .Values.dashDomain }}
