oauth2-proxy:
  config:
    clientID: 3ccA3af1jp59Ld
    # OAuth client secret
    clientSecret: S2pr99BZdG5GI2SBLwBpnhaRLqd8Acj9
    # Create a new secret with the following command
    # openssl rand -base64 32 | head -c 32 | base64
    # Use an existing secret for OAuth2 credentials (see secret.yaml for required fields)
    # Example:
    # existingSecret: secret
    cookieSecret: 8U6zzbwBC3qt4v1OAOG0bQ==
  extraArgs:
    cookie-domain: .{{ .Values.auth_cookie_domain }}
    whitelist-domain: .{{ .Values.auth_whitelist_domain }}
    oidc-issuer-url: {{ .Values.oidc_issuer_url }}
    scope: {{ .Values.oidc_scope }}
    user-id-claim: {{ .Values.user_id_claim }}
