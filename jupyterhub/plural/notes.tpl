Your jupyterhub installation is available at https://{{ .Values.hostname }}

You can login with
  username: admin
  password: {{ .jupyterhub.jupyterhub.hub.password }}
