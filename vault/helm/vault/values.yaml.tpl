vault:
  server:
    extraEnvironmentVars:
      {{- if eq .Provider "aws" }}
      VAULT_SEAL_TYPE: awskms
      VAULT_AWSKMS_SEAL_KEY_ID: {{ importValue "Terraform" "aws_kms_key_id" }}
      {{- end }}
    ingress:
      enabled: true
      annotations:
        kubernetes.io/tls-acme: "true"
        cert-manager.io/cluster-issuer: letsencrypt-prod
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
        nginx.ingress.kubernetes.io/use-regex: "true"  # TODO: do we need that?
      ingressClassName: nginx
      hosts:
      - host: {{ .Values.hostname }}
        paths: []
      tls:
      - hosts:
        - {{ .Values.hostname }}
        secretName: vault-tls

    {{ if eq .Provider "aws" }}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-vault"
    {{ end }}

    {{ if .OIDC }}
    oidc_enabled: true
    oidc_discovery_url: "{{ .OIDC.Configuration.AuthorizationEndpoint }}"
    oidc_client_id: "{{ .OIDC.ClientId }}"
    oidc_client_secret: "{{ .OIDC.ClientSecret }}"
    {{ else }}
    oidc_enabled: false
    {{ end }}

