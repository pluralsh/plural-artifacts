{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $isAws := eq .Provider "aws" }}
{{ $notAws := ne .Provider "aws" }}
{{ $hostname := .Values.hostname }}
yatai:
  ingress:
    hosts:
      - host: {{ $hostname }}
        paths:
        - /
    tls:
    - secretName: yatai-ingress-tls
      hosts:
        - {{ $hostname }}
  s3:
    region: {{ .Region }}
    {{- if $isGcp }}
    endpoint: "storage.googleapis.com"
    region: {{ .Values.bucket_location }}
    {{- else if $notAws }}
    endpoint: {{ .Configuration.minio.hostname }}
    region: us-east-1
    {{- end }}
    {{- if $notAws }}
    accessKey: {{ importValue "Terraform" "access_key_id" }}
    secretKey: {{ importValue "Terraform" "secret_access_key" }}
    {{- end }}
    bucketName: {{ .Values.bucket }}
  serviceAccount:
    annotations:
      {{- if $isAws }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- else if $isGcp }}
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
      {{- end }}

yatai-deployment:
  layers:
    network:
      domainSuffix: {{ $hostname }}
  serviceAccount:
    annotations:
      {{- if $isAws }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- else if $isGcp }}
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
      {{- end }}

yatai-image-builder:
  yatai:
    endpoint: http://yatai.yatai.svc.cluster.local
  serviceAccount:
    annotations:
      {{- if $isAws }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- else if $isGcp }}
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
      {{- end }}
  dockerRegistry:
    {{- if and $isAws .Values.use_ecr }}
    server: {{ index (split "/" (importValue "Terraform" "ecr_registry_url")) 0 }}
    {{- else }}
    server: {{ .Values.image_registry }} 
    {{- end }}
    bentoRepositoryName: {{ .Values.image_repository_name }}
    {{- if not .Values.use_ecr }}
    username: {{ .Values.image_registry_username }}
    password: {{ .Values.image_registry_password }}
    {{- end }}
    {{- if ( and $isAws .Values.use_ecr ) }}
    useAWSECRWithIAMRole: {{ .Values.use_ecr | quote }}
    awsECRRegion: {{ .Region }}
    {{- end }}
  {{- if $notAws }}
  aws:
    accessKeyID: {{ importValue "Terraform" "access_key_id" }}
    secretAccessKey: {{ importValue "Terraform" "secret_access_key" }}
  {{- end }}

initialization:
  email: {{ .Values.initial_email }}
  username: {{ .Values.initial_username }}
  password: {{ dedupe . "yatai.initialization.password" (randAlphaNum 32) }}
  