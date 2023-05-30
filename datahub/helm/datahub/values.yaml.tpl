global:
  application:
    links:
    - description: datahub web ui
      url: {{ .Values.hostname }}

adminPassword: {{ dedupe . "datahub.adminPassword" (randAlphaNum 14) }}

{{ $prevEncryptionKey := dedupe . "datahub.datahub.global.datahub.encryptionKey.provisionSecret.secretValues.encryptionKey" (randAlphaNum 20) }}
{{ $prevSecret := dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.secret" (randAlphaNum 32) }}
{{ $prevSigningKey := dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.signingKey" (randAlphaNum 32) }}
{{ $prevSalt := dedupe . "datahub.datahub.global.datahub.metadata_service_authentication.provisionSecrets.secretValues.salt" (randAlphaNum 32) }}

secrets:
  encryption:
    encryptionKey: {{ dedupe . "datahub.secrets.encryption.encryptionKey" $prevEncryptionKey }}
  metadata_service_authentication:
    secret: {{ dedupe . "datahub.secrets.metadata_service_authentication.secret" $prevSecret }}
    signingKey: {{ dedupe . "datahub.secrets.metadata_service_authentication.signingKey" $prevSigningKey }}
    salt:  {{ dedupe . "datahub.secrets.metadata_service_authentication.salt" $prevSalt }}

datahub:
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
oidcClientSecret: {{ .OIDC.ClientSecret }}
  {{- end }}
