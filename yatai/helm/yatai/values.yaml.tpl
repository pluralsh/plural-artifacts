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
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- end }}
  dockerRegistry:
    server: {{ .Values.image_registry }} 
    username: {{ .Values.image_registry_username }}
    password: {{ .Values.image_registry_password }}