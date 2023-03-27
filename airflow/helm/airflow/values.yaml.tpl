global:
  application:
    links:
    - description: airbyte web ui
      url: {{ .Values.hostname }}

{{ if not .Values.redisDisabled }}
secrets:
  redis_password: {{ dedupe . "airflow.secrets.redis_password" (randAlphaNum 14) }}
{{ end }}

{{ if eq .Provider "azure" }}
s3access:
  access_key_id: {{ importValue "Terraform" "access_key_id" }}
  secret_access_key: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}

{{ if .Configuration.datadog }}
exporter:
  statsd:
    relayAddress: "datadog.datadog:8125"
{{ end }}

{{ $sshCredentials := (or (and .Values.private_key (ne .Values.private_key "")) .airflow.sshConfig.id_rsa) }}

{{ if not .Values.gitSyncDisabled }}
{{- if $sshCredentials }}
sshConfig:
  enabled: true
  id_rsa: {{ ternary .Values.private_key (dedupe . "airflow.sshConfig.id_rsa" "") (hasKey .Values "private_key") | quote }}
{{- end }}
{{- if and .Values.gitAccessToken (ne .Values.gitAccessToken "") }}
httpConfig:
  enabled: true
  username: {{ .Values.gitUser }}
  password: {{ .Values.gitAccessToken }}
{{- end }}
{{ end }}

{{ if .Values.postgresqlDisabled }}
postgres:
  enabled: false
{{ else }}
postgresqlPassword: {{ dedupe . "airflow.postgresqlPassword" (randAlphaNum 20) }}
{{ end }}

{{ $hostname := default "example.com" .Values.hostname }}
{{ $minioNamespace := namespace "minio" }}
airflow:
  web:
    baseUrl: {{ $hostname }}
    {{ if .OIDC }}
    webserverConfig:
      stringOverride: |-
        import jwt
        from airflow import configuration as conf
        from airflow.www.security import AirflowSecurityManager
        from flask_appbuilder.security.manager import AUTH_OAUTH

        class PluralSecurityManager(AirflowSecurityManager):
          def _get_oauth_user_info(self, provider, response):
              if provider == "plural":
                  me = self._azure_jwt_token_parse(response["id_token"])
                  split_name = me["name"].split()
                  return {
                      "username": me["name"],
                      "name": me["name"],
                      "first_name": split_name[0],
                      "last_name": " ".join(split_name[1:]),
                      "email": me["email"],
                      "role_keys": [],
                  }
              else:
                  return {}
          oauth_user_info = _get_oauth_user_info
        
        SECURITY_MANAGER_CLASS = PluralSecurityManager

        SQLALCHEMY_DATABASE_URI = conf.get('core', 'SQL_ALCHEMY_CONN')
        
        AUTH_TYPE = AUTH_OAUTH
        
        # registration configs
        AUTH_USER_REGISTRATION = True  # allow users who are not already in the FAB DB
        AUTH_USER_REGISTRATION_ROLE = "Admin"  # this role will be given in addition to any AUTH_ROLES_MAPPING

        # the list of providers which the user can choose from
        OAUTH_PROVIDERS = [
            {
                'name': 'plural',
                'icon': 'fa-square-o',
                'token_key': 'access_token',
                'remote_app': {
                    'client_id': '{{ .OIDC.ClientId }}',
                    'client_secret': '{{ .OIDC.ClientSecret }}',
                    'api_base_url': '{{ .OIDC.Configuration.Issuer }}oauth2/',
                    'client_kwargs': {
                        'scope': 'openid'
                    },
                    'redirect_uri': 'https://{{ $hostname }}/oauth-authorized/plural',
                    'access_token_url': '{{ .OIDC.Configuration.TokenEndpoint }}',
                    'authorize_url': '{{ .OIDC.Configuration.AuthorizationEndpoint }}',
                    'token_endpoint_auth_method': 'client_secret_post',
                }
            }
        ]
        
        # force users to re-auth after 30min of inactivity (to keep roles in sync)
        PERMANENT_SESSION_LIFETIME = 1800
  {{ end }}
  ingress:
    web:
      host: {{ $hostname }}
      {{- if eq .Provider "kind" }}
      annotations:
        external-dns.alpha.kubernetes.io/target: "127.0.0.1"
      {{- end }}

  fernetKey: {{ dedupe . "airflow.airflow.fernetKey" (randAlphaNum 20)}}

  airflow:
    config:
      AIRFLOW__WEBSERVER__BASE_URL: https://{{ $hostname }}/
    {{ if eq .Provider "google" }}
      AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER: "gs://{{ .Values.airflowBucket }}/airflow/logs"
    {{ end }}
    {{ if or (eq .Provider "aws") (eq .Provider "azure") (eq .Provider "kind") }}
      AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER: "s3://{{ .Values.airflowBucket }}/airflow/logs"
    {{ end }}
    {{ if or (eq .Provider "azure") (eq .Provider "kind") }}
      AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID: minio
    {{ end }}
  
    {{ if eq .Provider "google" }}
    connections:
    ## see docs: https://airflow.apache.org/docs/apache-airflow-providers-google/stable/connections/gcp.html
    - id: plural
      type: google_cloud_platform
      description: my GCP connection
      extra: |-
        { "extra__google_cloud_platform__num_retries": "5" }
    {{ end }}
    {{ if eq .Provider "aws" }}
    connections:
    - id: plural
      type: aws
      description: connection to aws s3 logs (via workflow identity)
    {{ end }}
    {{ if eq .Provider "azure" }}
    connections:
    - id: minio
      type: aws
      description: connection to local minio gateway
      extra: |-
        {
          "aws_access_key_id": {{ importValue "Terraform" "access_key_id" }},
          "aws_secret_access_key": {{ importValue "Terraform" "secret_access_key" }},
          "host": "https://{{ .Configuration.minio.hostname }}"
        }
    {{ end }}
    {{ if eq .Provider "kind" }}
    connections:
    - id: minio
      type: aws
      description: connection to local minio gateway
      extra: |-
        {
          "aws_access_key_id": {{ importValue "Terraform" "access_key_id" }},
          "aws_secret_access_key": {{ importValue "Terraform" "secret_access_key" }},
          "host": "http://minio.{{ $minioNamespace }}:9000"
        }
    {{ end }}

  serviceAccount:
  {{ if eq .Provider "google" }}
    create: false
  {{ end }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-airflow"

  dags:
    gitSync:
      {{ if not .Values.gitSyncDisabled }}
      enabled: true
      repo: {{ .Values.dagRepo }}
      branch: {{ .Values.branchName }}
      revision: HEAD
      syncWait: 60
      {{- if $sshCredentials }}
      sshSecret: airflow-ssh-config
      sshSecretKey: id_rsa
      sshKnownHosts: ""
      {{- else if and .Values.gitAccessToken (ne .Values.gitAccessToken "") }}
      httpSecret: airflow-git-http-config
      httpSecretUsernameKey: username
      httpSecretPasswordKey: password
      {{- end }}
      {{ else }}
      enabled: false
      {{ end }}
