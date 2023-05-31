{{- $tfOutput := pathJoin repoRoot "bootstrap" "output.yaml" }}
gcp_project_id = {{ .Project | quote }}
gcp_region = {{ .Region | quote }}
cluster_name = {{ .Cluster | quote }}
