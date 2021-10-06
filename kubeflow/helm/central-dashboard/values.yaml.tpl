{{ $istioNamespace := namespace "istio" }}
{{ $hostname := .Values.hostname }}
global:
  istioNamespace: {{ $istioNamespace }}
  domain: {{ $hostname }}
