You can view your harbor instance at https://{{ .Values.hostname }}

Your initial admin credentials are:

username: admin
password: {{ .harbor.harbor.harborAdminPassword }}