Your tier installation is available at https://{{ .Values.hostname }}

You can inspect the runtime configuration by running:

  curl -u "{{ .Values.tier.basicAuth }}:" https://{{ .Values.hostname }}/v1/whoami
