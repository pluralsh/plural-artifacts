datadog:
  datadog:
    apiKey: {{ .Values.apiKey | quote }}
    {{ if eq .Provider "azure" }}
    datadog:
      env:
      - name: DD_KUBELET_TLS_VERIFY
        value: "false"
    clusterAgent:
      env:
      - name: "DD_ADMISSION_CONTROLLER_ADD_AKS_SELECTORS"
        value: "true"
    {{ end }}