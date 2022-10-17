global:
  application:
    links:
    - description: datahub web ui
      url: {{ .Values.hostname }}

adminPassword: {{ dedupe . "datahub.adminPassword" (randAlphaNum 14) }}

datahub:
  global:
    datahub:
      encryptionKey:
        provisionSecret:
          autoGenerate: false
          secretValues:
            encryptionKey: {{ dedupe . "datahub.datahub.global.datahub.encryptionKey.provisionSecret.secretValues.encryptionKey" (randAlphaNum 20) }}
      metadata_service_authentication:
        provisionSecrets:
          autoGenerate: false
          secretValues:
            secret: {{ dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.secret" (randAlphaNum 32) }}
            signingKey: {{ dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.signingKey" (randAlphaNum 32) }}
            salt: {{ dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.salt" (randAlphaNum 32) }}
  datahub-frontend:
    ingress:
      hosts:
        - host: {{ .Values.hostname }}
          paths:
          - /
      tls:
      - secretName: datahub-frontend-tls
        hosts:
        - {{ .Values.hostname }}
  {{- if .OIDC }}
    extraEnvs:
    - name: AUTH_OIDC_ENABLED
      value: "true"
    - name: AUTH_OIDC_CLIENT_ID
      value: {{ .OIDC.ClientId }}
    - name: AUTH_OIDC_CLIENT_SECRET
      valueFrom:
        secretKeyRef:
          name: datahub-oidc-client-secret
          key: clientSecret
    - name: AUTH_OIDC_BASE_URL
      value: https://{{ .Values.hostname }}
    - name: AUTH_OIDC_DISCOVERY_URI
      value: {{ .OIDC.Configuration.Issuer }}.well-known/openid-configuration
    - name: AUTH_OIDC_SCOPE
      value: "openid profile offline_access"
    - name: AUTH_OIDC_JIT_PROVISIONING_ENABLED
      value: "true"
    - name: AUTH_OIDC_PRE_PROVISIONING_REQUIRED
      value: "false"
    - name: AUTH_OIDC_EXTRACT_GROUPS_ENABLED
      value: "true"
    - name: AUTH_OIDC_GROUPS_CLAIM
      value: "groups"
    - name: AUTH_OIDC_USER_NAME_CLAIM
      value: email
    - name: AUTH_OIDC_CLIENT_AUTHENTICATION_METHOD
      value: client_secret_post
    - name: PAC4J_SESSIONSTORE_PROVIDER
      value: PlayCacheSessionStore
oidcClientSecret: {{ .OIDC.ClientSecret }}
  {{- end }}
