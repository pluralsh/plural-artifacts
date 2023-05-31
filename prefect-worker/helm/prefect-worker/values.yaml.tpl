prefect-worker:
  worker:
    config:
      workPool: {{ .values.workPool | quote }}
    cloudApiConfig:
      accountId: {{ .Values.accountId | quote }}
      workspaceId: {{ .Values.workspaceId | quote }}
apiKey: {{ .Values.apiKey | quote }}