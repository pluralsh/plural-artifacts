{{ $hostname := default "example.com" .Values.hostname }}
{{ $consoleHostname := default "example.com" .Values.consoleHostname }}
{{ $rootUser := dedupe . "secret.rootUser" (randAlphaNum 20) }}
{{ $rootPassword := dedupe . "secret.rootPassword" (randAlphaNum 30) }}

global:
  application:
    links:
    - description: redpanda instance
      url: {{ $hostname }}
    - description: redpanda console
      url: {{ $consoleHostname }}

secret:
  rootUser: {{ $rootUser }}
  rootPassword: {{ $rootPassword }}

redpanda:
  external:
    domain: {{ $hostname }}
  auth:
    sasl:
      enabled: true
    users:
      - name: {{ $rootUser }}
        password: {{ $rootPassword }}
