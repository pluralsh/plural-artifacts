{{ $hostname := default "example.com" .Values.hostname }}
{{ $password := dedupe . "jupyterhub.jupyterhub.hub.password" (randAlphaNum 30) }}

global:
  application:
    links:
    - description: jupyterhub instance
      url: {{ $hostname }}

jupyterhub:
  hub:
    password: {{ $password }}

  proxy:
    ingress:
      hostname: {{ $hostname }}
      extraTls:
        - hosts:
          - {{ $hostname }}
          secretName: jupyterhub-tls
