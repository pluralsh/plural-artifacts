You can access your installation at https://{{ .Values.hostname }}
You can access the console at https://{{ .Values.consoleHostname }}

Your initial admin credentials for logging into the console are:

username: {{ .Values.secret.rootUser }}
password: {{ .Values.secret.rootPassword }}
