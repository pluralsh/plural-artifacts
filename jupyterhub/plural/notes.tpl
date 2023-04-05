Your jupyterhub installation is available at https://{{ .Values.hostname }}

You can login with
  username: {{ .Values.jupyterhub.hub.adminUser }}
  password: {{ .Values.jupyterhub.hub.password }}
