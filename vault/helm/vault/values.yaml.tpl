vault:
  server:
    extraEnvironmentVars:
      {{- if eq .Provider "aws" }}
      VAULT_SEAL_TYPE: awskms
      {{- end }}
      {{- if eq .Provider "google" }}
      VAULT_SEAL_TYPE: gcpckms
      GOOGLE_PROJECT: {{ .Project }}
      GOOGLE_REGION: {{ importValue "Terraform" "google_kms_key_ring_location" }}
      {{- end }}
      {{- if .OIDC }}
      OIDC_DISCOVERY_URL: "https://oidc.plural.sh/"
      {{- end }}

    extraSecretEnvironmentVars:
    {{- if eq .Provider "aws" }}
    - envName: VAULT_AWSKMS_SEAL_KEY_ID
      secretName: vault-env-secret
      secretKey: VAULT_AWSKMS_SEAL_KEY_ID
    {{- end }}
    {{- if eq .Provider "google" }}
    - envName: VAULT_GCPCKMS_SEAL_CRYPTO_KEY
      secretName: vault-env-secret
      secretKey: VAULT_GCPCKMS_SEAL_CRYPTO_KEY
    - envName: VAULT_GCPCKMS_SEAL_KEY_RING
      secretName: vault-env-secret
      secretKey: VAULT_GCPCKMS_SEAL_KEY_RING
    {{- end }}
    {{- if .OIDC }}
    - envName: OIDC_CLIENT_ID
      secretName: vault-env-secret
      secretKey: OIDC_CLIENT_ID
    - envName: OIDC_CLIENT_SECRET
      secretName: vault-env-secret
      secretKey: OIDC_CLIENT_SECRET
    {{- end }}

    ingress:
      enabled: true
      annotations:
        kubernetes.io/tls-acme: "true"
        cert-manager.io/cluster-issuer: letsencrypt-prod
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
        nginx.ingress.kubernetes.io/use-regex: "true"
      {{- if not .Values.exposePrivate }}
      ingressClassName: nginx
      {{- else }}
      ingressClassName: internal-nginx
      {{- end }}
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
    {{ if eq .Provider "google" }}
    serviceAccount:
      create: false
      name: vault
    {{ end }}

envSecret:
  {{- if eq .Provider "aws" }}
  VAULT_AWSKMS_SEAL_KEY_ID: {{ importValue "Terraform" "aws_kms_key_id" }}
  {{- end }}
  {{- if eq .Provider "google" }}
  VAULT_GCPCKMS_SEAL_KEY_RING: {{ importValue "Terraform" "google_kms_key_ring_name" }}
  VAULT_GCPCKMS_SEAL_CRYPTO_KEY: {{ importValue "Terraform" "google_kms_crypto_key_name" }}
  {{- end }}
  {{- if .OIDC }}
  OIDC_CLIENT_ID: "{{ .OIDC.ClientId }}"
  OIDC_CLIENT_SECRET: "{{ .OIDC.ClientSecret }}"
  {{- end }}

{{- if .OIDC }}
oidc:
  enabled: true
  redirectHostname: {{ .Values.hostname }}
  adminEmail: {{ .Config.Email }}
{{- end }}
