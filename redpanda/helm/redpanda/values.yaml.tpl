{{ $hostname := default "example.com" .Values.hostname }}
{{ $consoleHostname := default "example.com" .Values.consoleHostname }}

global:
  application:
    links:
    - description: redpanda instance
      url: {{ $hostname }}
    - description: redpanda console
      url: {{ $consoleHostname }}

secret:
  rootUser: {{ dedupe . "redpanda.secret.rootUser" (randAlphaNum 20) }}
  rootPassword: {{ dedupe . "redpanda.secret.rootPassword" (randAlphaNum 30) }}

redpanda:
  external:
    domain: {{ $hostname }}
