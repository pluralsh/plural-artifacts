prefect-worker:
  worker:
    config:
      workPool: {{ .Values.workPool | quote }}
    cloudApiConfig:
      accountId: {{ .Values.accountId | quote }}
      workspaceId: {{ .Values.workspaceId | quote }}
apiKey: {{ .Values.apiKey | quote }}