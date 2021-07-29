config:
  clientID: fsyPNk0U1mk8ah
  # OAuth client secret
  clientSecret: bs29oDPCHqn6s1e4KR31fWRP0ySC7T02
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
