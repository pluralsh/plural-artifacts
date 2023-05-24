{{ $hostname := .Values.hostname }}
{{ $yataiNamespace := namespace "yatai" }}
{{ $creds := secret $yataiNamespace "yatai-initialization-admin-creds" }}

You can view your installation at https://{{ $hostname}}

Your initial admin credentials are:

Email: {{ $creds.email }}
Username: {{ $creds.username }}
Password: {{ $creds.password }}
