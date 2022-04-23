global:
  application:
    links:
    - description: jitsu web ui
      url: {{ .Values.hostname }}

ingress:
  tls:
  - secretName: jitsu-tls
    hosts:
    - {{ .Values.hostname }}
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: /.*
      pathType: ImplementationSpecific

secrets:
  redis_host: redis-master.{{ namespace "redis" }}
  redis_password: {{ importValue "Terraform" "redis_password" }}
  admin_token: {{ dedupe . "jitsu.jitsu.secrets.admin_token" (randAlphaNum 32) }}

config:
  server:
    name: {{ .Values.hostname }}