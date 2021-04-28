postgresql:
  postgresqlPassword: {{ dedupe . "console.postgresql.postgresqlPassword" (randAlphaNum 20) }}

ingress:
  console_dns: {{ .Values.console_dns }}

provider: {{ .Provider }}

serviceAccount:
{{ if eq .Provider "google" }}
  create: false
{{ end }}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-console

secrets:
  jwt: {{ dedupe . "console.secrets.jwt" (randAlphaNum 20) }}
  admin_name: {{ .Values.admin_name }}
  admin_email: {{ .Values.admin_email }}
  admin_password: {{ dedupe . "console.secrets.admin_password" (randAlphaNum 20) }}
{{ if .Values.console_dns }}
  git_url: {{ repoUrl }}
  repo_root: {{ repoName }}
  branch_name: {{ branchName }}
  config: {{ readFile (homeDir ".plural" "config.yml") | quote }}
  key: {{ readFile (homeDir ".plural" "key") | quote }}
  known_hosts: {{ knownHosts | quote }}
{{ else }}
  git_url: ''
  repo_root: ''
  branch_name: ''
  config: ''
  key: ''
  known_hosts: ''
{{ end }}
  cluster_name: {{ .Cluster }}
  erlang: {{ dedupe . "console.secrets.erlang" (randAlphaNum 14) }}
{{ if and (hasKey . "console") (hasKey .console "secrets") }}
  webhook_secret: {{ .console.secrets.webhook_secret }}
  id_rsa: {{ .console.secrets.id_rsa | quote }}
  id_rsa_pub: {{ .console.secrets.id_rsa_pub | quote }}
{{ else if .Values.console_dns }}
  {{ $id_rsa := readLineDefault "Enter the path to your deploy keys" (homeDir ".ssh" "id_rsa") }}
  id_rsa: {{ readFile $id_rsa | quote }}
  id_rsa_pub: {{ readFile (printf "%s.pub" $id_rsa) | quote }}
{{ end }}
{{ if hasKey .Values "git_user" }}
  git_user: {{ .Values.git_user }}
{{ else }}
  git_user: console
{{ end }}
{{ if hasKey .Values "git_email" }}
  git_email: {{ .Values.git_email }}
{{ else }}
  git_email: console@plural.sh
{{ end }}

license: {{ .License | quote }}