extraArgs:
  cookie-domain: .{{ .Values.auth_cookie_domain }}
  whitelist-domain: .{{ .Values.auth_whitelist_domain }}
  oidc-issuer-url: {{ .Values.oidc_issuer_url }}
  scope: {{ .Values.oidc_scope }}
  user-id-claim: {{ .Values.user_id_claim }}
