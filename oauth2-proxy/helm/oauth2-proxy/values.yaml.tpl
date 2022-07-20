oauth2-proxy:
  config:
    clientID: {{ .OIDC.ClientId }}
    # OAuth client secret
    clientSecret: {{ .OIDC.ClientSecret }}
    # Create a new secret with the following command
    # openssl rand -base64 32 | head -c 32 | base64
    # Use an existing secret for OAuth2 credentials (see secret.yaml for required fields)
    # Example:
    # existingSecret: secret
    cookieSecret: {{ dedupe . "oauth2-proxy.oauth2-proxy.config.cookieSecret" (randAlphaNum 32) }}
  extraArgs:
    cookie-domain: ".{{ .Values.auth_cookie_domain }}"
    whitelist-domain: ".{{ .Values.auth_whitelist_domain }}"
    oidc-issuer-url: {{ .OIDC.Configuration.Issuer }}
    user-id-claim: {{ .Values.user_id_claim }}
