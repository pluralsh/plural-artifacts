global:
  application:
    links:
    - description: renovate public endpoint
      url: {{ .Values.hostname }}

mend-renovate-ce:
  ingress:
    hosts:
      - {{ .Values.hostname }}
    tls:
    - secretName: whitesource-renovate-tls
      hosts:
      -  {{ .Values.hostname }}
  renovate:
    {{- if .Values.acceptTos }}
    mendRnvAcceptTos: "y"
    {{- end }}
    mendRnvLicenseKey: {{ .Values.licenseKey }}
    mendRnvServerApiSecret: {{ dedupe . "renovate-on-prem.mend-renovate-ce.renovate.mendRnvServerApiSecret" (randAlphaNum 32) }}
    mendRnvPlatform: {{ .Values.platform }}
    {{- if .Values.renovateEndpoint }}
    mendRnvEndpoint: {{ .Values.renovateEndpoint }}
    {{- else if eq .Values.platform "github" }}
    mendRnvEndpoint: https://api.github.com/
    {{- else if eq .Values.platform "gitlab" }}
    mendRnvEndpoint: https://gitlab.com/api/v4/
    {{- end }}
    {{- if .Values.githubAppId }}
    mendRnvGithubAppId: {{ .Values.githubAppId | quote }}
    {{- end }}
    {{- if .Values.githubAppKey }}
    mendRnvGithubAppKey: {{ .Values.githubAppKey | quote }}
    {{- end }}
    {{- if .Values.webhookSecret }}
    mendRnvWebhookSecret: {{ .Values.webhookSecret }}
    {{- end }}
    {{- if .Values.renovateToken }}
    mendRnvGitlabPat: {{ .Values.renovateToken }}
    {{- end }}
    {{- if .Values.githubComToken }}
    githubComToken: {{ .Values.githubComToken }}
    {{- end }}
    {{- if or .Configuration.redis .Values.extraEnvVars }}
    extraEnvVars:
    {{- if .Values.extraEnvVars }}
    {{- toYaml .Values.extraEnvVars | nindent 4 }}
    {{- end }}
    {{- if .Configuration.redis }}
    {{ $redisNamespace := namespace "redis" }}
    - name: REDIS_PASSWORD
      valueFrom:
        secretKeyRef:
          name: renovate-on-prem-secret
          key: redis-password
    - name: RENOVATE_REDIS_URL
      value: redis://:$(REDIS_PASSWORD)@redis-master.{{ $redisNamespace }}:6379
    {{- end }}
    {{- end }}

{{- if or .Configuration.redis .Values.extraSecrets }}
secrets:
  {{- if .Values.extraSecrets }}
  {{- toYaml .Values.extraSecrets | nindent 2 }}
  {{- end }}
  {{- if .Configuration.redis }}
  {{ $redisValues := .Applications.HelmValues "redis" }}
  redis-password: {{ $redisValues.redis.password }}
  {{- end }}
{{- end }}
