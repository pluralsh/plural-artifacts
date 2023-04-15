{{ $sonarqubePgPwd := dedupe . "sonarqube.postgres.password" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: sonarqube web ui
      url: {{ .Values.hostname }}

postgres:
  password: {{ $sonarqubePgPwd }}

sonarqube:
  ingress:
    enabled: true
    ingressClassName: "nginx"
    annotations:
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
    - name: {{ .Values.hostname }}
      paths:
        - path: '/'
          pathType: ImplementationSpecific
    tls:
    - secretName: sonarqube-tls
      hosts:
        - {{ .Values.hostname }}
