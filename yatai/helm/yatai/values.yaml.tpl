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
    bucketName: {{ .Values.bucket }}
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- end }}

yatai-deployment:
  layers:
    network:
      domainSuffix: {{ $hostname }}
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- end }}

yatai-image-builder:
  yatai:
    endpoint: http://yatai.{{ namespace "yatai" }}.svc.cluster.local
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- end }}
  dockerRegistry:
    {{- if eq .Provider "aws" }}
    server: {{ importValue "Terraform" "ecr_registry_url" }}
    {{- else }}
    server: {{ .Values.image_registry }} 
    {{- end }}
    bentoRepositoryName: {{ .Values.image_repository_name }}
    {{- if not .Values.use_ecr }}
    username: {{ .Values.image_registry_username }}
    password: {{ .Values.image_registry_password }}
    {{- end }}
    {{- if ( and (eq .Provider "aws") .Values.use_ecr ) }}
    useAWSECRWithIAMRole: {{ .Values.use_ecr | quote }}
    awsECRRegion: {{ .Region }}
    {{- end }}