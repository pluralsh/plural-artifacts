prefect-agent:
  agent:
    cloudApiConfig:
      accountId: {{ .Values.accountId | quote }}
      workspaceId: {{ .Values.workspaceId | quote }}