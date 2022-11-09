global:
  application:
    links:
    - description: renovate public endpoint
      url: {{ .Values.hostname }}

whitesource-renovate:
  ingress:
    hosts:
      - {{ .Values.hostname }}
    tls:
    - secretName: whitesource-renovate-tls
      hosts:
      -  {{ .Values.hostname }}
  renovate:
    {{- if .Values.acceptTos }}
    acceptWhiteSourceTos: "y"
    {{- end }}
    licenseKey: {{ .Values.licenseKey }}
    renovatePlatform: {{ .Values.platform }}
    {{- if .Values.renovateEndpoint }}
    renovateEndpoint: {{ .Values.renovateEndpoint }}
    {{- else if eq .Values.platform "github" }}
    renovateEndpoint: https://api.github.com/
    {{- else if eq .Values.platform "gitlab" }}
    renovateEndpoint: https://gitlab.com/api/v4/
    {{- end }}
    {{- if .Values.githubAppId }}
    githubAppId: {{ .Values.githubAppId }}
    {{- end }}
    {{- if .Values.githubAppKey }}
    githubAppKey: {{ .Values.githubAppKey }}
    {{- end }}
    {{- if .Values.webhookSecret }}
    webhookSecret: {{ .Values.webhookSecret }}
    {{- end }}
    {{- if .Values.renovateToken }}
    renovateToken: {{ .Values.renovateToken }}
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
