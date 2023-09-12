global:
  application:
    links:
    - description: temporal web ui
      url: {{ .Values.hostname }}

{{ if .OIDC }}
oidc:
  clientSecret: {{ .OIDC.ClientSecret }}
  clientId: {{ .OIDC.ClientId }}
temporal:
  web:
    additionalEnv:
    - name: TEMPORAL_AUTH_ENABLED
      value: 'true'
    - name: TEMPORAL_AUTH_LABEL
      value: "login with Plural"
    - name: TEMPORAL_AUTH_PROVIDER_URL
      value: {{ .OIDC.Configuration.Issuer }}
    - name: TEMPORAL_AUTH_CALLBACK_URL
      value: https://{{ .Values.hostname }}/auth/sso/callback
    - name: TEMPORAL_AUTH_SCOPES
      value: openid
    - name: TEMPORAL_AUTH_CLIENT_SECRET
      valueFrom:
        secretKeyRef:
          name: oidc-secret
          key: clientSecret
    - name: TEMPORAL_AUTH_CLIENT_ID
      valueFrom:
        secretKeyRef:
          name: oidc-secret
          key: clientId
    ingress:
      enabled: true
      hosts:
      - {{ .Values.hostname }}
      tls:
      - secretName: temporal-tls
        hosts:
        - {{ .Values.hostname }}
{{ end }}
    