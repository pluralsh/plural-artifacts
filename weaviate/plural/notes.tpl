Your Weaviate installation is available at https://{{ .Values.hostname }}

Authentication by API-KEY is enabled.
API-KEY for admin {{ .Values.adminEmail }} is {{ .weaviate.weaviate.admin.key }}
Make sure to include this header while requesting your API -> Authorization: Bearer {{ .weaviate.weaviate.admin.key }}