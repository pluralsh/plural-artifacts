{{ $istioNamespace := namespace "istio" }}

dex:
  config:
    issuer: https://{{ .Values.fqdn }}
    staticPasswords:
    - email: {{ .Values.email }}
      hash: $2y$12$1c5U2ToHRv.PaFI6Va/4a..OQZW8hmomITwNiDxwQu8x7g.doVAce
      username: {{ .Values.username }}
      userID: '15841185641784'
    staticClients:
    - id: {{ dedupe . "dex.dex.config.staticClients[0].id" (randAlphaNum 14) }}
      redirectURIs:
      - {{ .Values.redirectURI }}
      name: Dex Login Application
      secret: {{ dedupe . "dex.dex.config.staticClients[0].secret" (randAlphaNum 32) }}
  
  ingress:
    hosts:
    - host: {{ .Values.fqdn }}
      paths:
      - path: /.*
        pathType: Prefix
    tls:
    - hosts:
      - {{ .Values.fqdn }}
      secretName: dex-cert

istio:
  enabled: {{ .Values.istioEnabled }}
  host: {{ .Values.fqdn }}
  namespace: {{ $istioNamespace }}
