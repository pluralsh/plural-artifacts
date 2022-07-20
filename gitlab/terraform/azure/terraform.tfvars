cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
resource_group = {{ .Project | quote }}

// buckets
registry_bucket = {{ .Values.registryBucket | quote }}
artifacts_bucket = {{ .Values.artifactsBucket | quote }}
packages_bucket = {{ .Values.packagesBucket | quote }}
backups_bucket = {{ .Values.backupsBucket | quote }}
backups_tmp_bucket = {{ .Values.backupsTmpBucket | quote }}
lfs_bucket = {{ .Values.lfsBucket | quote }}
runner_cache_bucket = {{ .Values.runnerCacheBucket | quote }}
terraform_bucket = {{ .Values.terraformBucket | quote }}

// minio configuration
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}