{{ $hostname := .Values.hostname }}

You can view your installation at https://{{ $hostname}}

Your initial admin credentials are:

Email: {{ .Values.initial_email }}
Username: {{ .Values.initial_username }}
Password: {{ .yatai.initialization.initial_password }}
