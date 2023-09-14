{{ $hostname := .Values.hostname }}
global:
  application:
    links:
    - description: kubeflow dashboard ui
      url: {{ $hostname }}
  domain: {{ $hostname }}
