{{ $apiSecret := dedupe . "cube.cube.config.apiSecret" (randAlphaNum 40) }}

global:
  application:
    links:
    - description: cube api
      url: {{ .Values.hostname }}

cube:
  ingress:
    hostname: {{ .Values.hostname }}
  config:
    apiSecret: {{ $apiSecret }}
  datasources:
    default:
      type: {{ .Values.databaseType }}