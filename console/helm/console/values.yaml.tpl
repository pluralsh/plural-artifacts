ingress:
  console_dns: {{ .Values.console_dns }}

provider: {{ .Provider }}

{{ if eq .Provider "azure" }}
podLabels:
  aadpodidbinding: console

consoleIdentityId: {{ importValue "Terraform" "console_msi_id" }}
consoleIdentityClientId: {{ importValue "Terraform" "console_msi_client_id" }}

extraEnv:
- name: ARM_USE_MSI
  value: 'true'
- name: ARM_SUBSCRIPTION_ID
  value: {{ .Context.SubscriptionId }}
- name: ARM_TENANT_ID
  value: {{ .Context.TenantId }}
{{ end }}

serviceAccount:
{{ if eq .Provider "google" }}
  create: false
{{ end }}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-console

{{ $norsa := eq (dig "console" "secrets" "id_rsa" "default" .) "default" }}
{{ $notoken := eq (dig "console" "secrets" "git_access_token" "default" .) "default" }}
{{ $conf := dict }}
{{ if all $norsa $notoken .Values.console_dns }}
  {{ $url := repoUrl }}
  {{ if hasPrefix "https" $url }}
    {{ $token := readLine "Enter your git access token" }}
    {{ $_ := set $conf "git_access_token" $token }}
  {{ else }}
    {{ $id_rsa := readLineDefault "Enter the path to your deploy keys" (homeDir ".ssh" "id_rsa") }}
    {{ $pass := readLine "Enter ssh passphrase (just press enter if none)" }}
    {{ $_ := set $conf "id_rsa" (readFile $id_rsa) }}
    {{ $_ := set $conf "id_rsa_pub" (readFile (printf "%s.pub" $id_rsa)) }}
    {{ $_ := set $conf "ssh_passphrase" $pass }}
  {{ end }}
{{ end }}

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
{{ $identity := pathJoin repoRoot ".plural-crypt" "identity" }}
{{ if fileExists $identity }}
  identity: {{ readFile $identity | quote }}
{{ else if ne (dig "console" "secrets" "identity" "default" .) "default" }}
  identity: {{ .console.secrets.identity | quote }}
{{ else }}
  key: {{ readFile (homeDir ".plural" "key") | quote }}
{{ end }}
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
{{ if not $norsa }}
  id_rsa: {{ .console.secrets.id_rsa | quote }}
  id_rsa_pub: {{ .console.secrets.id_rsa_pub | quote }}
  {{ if .console.secrets.ssh_passphrase }}
  ssh_passphrase: {{ .console.secrets.ssh_passphrase | quote }}
  {{ end }}
{{ else if not $notoken }}
  git_access_token: {{ .console.secrets.git_access_token | quote }}
{{ else if .Values.console_dns }}
{{ range $key, $value := $conf }}
  {{ $key }}: {{ $value | quote }}
{{ end }}
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
{{ if .OIDC }}
  plural_client_id: {{ .OIDC.ClientId }}
  plural_client_secret: {{ .OIDC.ClientSecret }}
{{ end }}

license: {{ .License | quote }}