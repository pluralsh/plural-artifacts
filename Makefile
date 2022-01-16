APPS := $(shell ls -l | egrep '^d' | awk '{ print $$9 }')
JOBS := $(addprefix upload-,${APPS})

PG_APPS := airbyte airflow gitlab nocodb sentry superset hasura
PG_JOBS := $(addprefix sync-pg-,${PG_APPS})

.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ${JOBS} ; echo "finished updating all apps"

sync-pgs: ${PG_JOBS} ; echo "synced pg resources"

sync-pg-%:
	cp .plural/runbooks/db-scaling.xml $*/helm/$*/runbooks/db-scaling.xml
	cp .plural/resources/postgres-secret-sync.yaml $*/helm/$*/templates/pgsync.yaml

import-operator:
	kustomize build ../plural-operator/config/crd/ -o bootstrap/helm/bootstrap/crds

import-tigera:
	cp -R ../calico/calico/_includes/charts/tigera-operator/crds/. bootstrap/helm/bootstrap/crds 
	cp -R ../calico/calico/_includes/charts/calico/crds/kdd/. bootstrap/helm/bootstrap/crds
	rm bootstrap/helm/bootstrap/crds/calico

create-template:
	@read -p "Enter Application Name:" application; \
	mkdir -p ./$$application/helm; \
	helm create ./$$application/helm/$$application; \
	echo "apiVersion: plural.sh/v1alpha1\nkind: Dependencies\nmetadata:\n  application: true\n  description: Deploys $$application crafted for the target cloud\nspec:\n  dependencies:\n  - type: helm\n    name: bootstrap\n    repo: bootstrap\n    version: '>= 0.5.1'\n  - type: terraform\n    name: aws\n    repo: $$application\n    version: '>= 0.1.0'\n    optional: true\n  - type: terraform\n    name: azure\n    repo: $$application\n    version: '>= 0.1.0'\n    optional: true\n  - type: terraform\n    name: gcp\n    repo: $$application\n    version: '>= 0.1.0'\n    optional: true" > ./$$application/helm/$$application/deps.yaml; \
	echo "# $$application\n\nInstalls $$application using Plural." > ./$$application/helm/$$application/README.md; \
	echo "global:\n  application:\n    links:\n    - description: $$application web ui\n      url: {{ .Values.hostname }}" > ./$$application/helm/$$application/values.yaml.tpl; \
	mkdir -p ./$$application/plural/icons; \
	mkdir -p ./$$application/plural/recipes; \
	mkdir -p ./$$application/plural/tags/helm; \
	mkdir -p ./$$application/plural/tags/terraform; \
	echo "" > ./$$application/plural/notes.tpl; \
	echo "name: $$application-aws\ndescription: Installs $$application on an aws eks cluster\nprovider: AWS\ndependencies:\n- repo: bootstrap\n  name: aws-k8s\nsections:\n- name: $$application\n  configuration: []\n  items:\n  - type: TERRAFORM\n    name: aws\n  - type: HELM\n    name: $$application" > ./$$application/plural/recipes/$$application-aws.yaml; \
	echo "name: $$application-azure\ndescription: Installs $$application on an azure aks cluster\nprovider: AZURE\ndependencies:\n- repo: bootstrap\n  name: azure-k8s\nsections:\n- name: $$application\n  configuration: []\n  items:\n  - type: TERRAFORM\n    name: azure\n  - type: HELM\n    name: $$application" > ./$$application/plural/recipes/$$application-azure.yaml; \
	echo "name: $$application-gcp\ndescription: Installs $$application on a gcp gke cluster\nprovider: GCP\ndependencies:\n- repo: bootstrap\n  name: gcp-kubernetes\nsections:\n- name: $$application\n  configuration: []\n  items:\n  - type: TERRAFORM\n    name: gcp\n  - type: HELM\n    name: $$application" > ./$$application/plural/recipes/$$application-gcp.yaml; \
	echo "spec:\n  chart: $$application\n  version: 0.1.0\ntags:\n- stable\n- warm" > ./$$application/plural/tags/helm/$$application.yaml; \
	echo "spec:\n  terraform: aws\n  version: 0.1.0\ntags:\n- stable\n- warm" > ./$$application/plural/tags/terraform/aws.yaml; \
	echo "spec:\n  terraform: azure\n  version: 0.1.0\ntags:\n- stable\n- warm" > ./$$application/plural/tags/terraform/azure.yaml; \
	echo "spec:\n  terraform: gcp\n  version: 0.1.0\ntags:\n- stable\n- warm" > ./$$application/plural/tags/terraform/gcp.yaml; \
	mkdir -p ./$$application/terraform/aws; \
	mkdir -p ./$$application/terraform/azure; \
	mkdir -p ./$$application/terraform/gcp; \
	echo "apiVersion: plural.sh/v1alpha1\nkind: Dependencies\nmetadata:\n  description: $$application aws setup\n  version: 0.1.0\nspec:\n  dependencies:\n  - name: aws-bootstrap\n    repo: bootstrap\n    type: terraform\n    version: '>= 0.1.1'\n  providers:\n  - aws" > ./$$application/terraform/aws/deps.yaml; \
	echo "apiVersion: plural.sh/v1alpha1\nkind: Dependencies\nmetadata:\n  description: $$application azure setup\n  version: 0.1.0\nspec:\n  dependencies:\n  - name: azure-bootstrap\n    repo: bootstrap\n    type: terraform\n    version: '>= 0.1.1'\n  providers:\n  - azure" > ./$$application/terraform/azure/deps.yaml; \
	echo "apiVersion: plural.sh/v1alpha1\nkind: Dependencies\nmetadata:\n  description: $$application gcp setup\n  version: 0.1.0\nspec:\n  dependencies:\n  - name: gcp-bootstrap\n    repo: bootstrap\n    type: terraform\n    version: '>= 0.1.1'\n  providers:\n  - gcp" > ./$$application/terraform/gcp/deps.yaml; \
	echo "resource \"kubernetes_namespace\" \"$$application\" {\n  metadata {\n    name = var.namespace\n    labels = {\n      \"app.kubernetes.io/managed-by\" = \"plural\"\n      \"app.plural.sh/name\" = \"$$application\"\n    }\n  }\n}" > ./$$application/terraform/aws/main.tf; \
	echo "resource \"kubernetes_namespace\" \"$$application\" {\n  metadata {\n    name = var.namespace\n    labels = {\n      \"app.kubernetes.io/managed-by\" = \"plural\"\n      \"app.plural.sh/name\" = \"$$application\"\n    }\n  }\n}" > ./$$application/terraform/azure/main.tf; \
	echo "resource \"kubernetes_namespace\" \"$$application\" {\n  metadata {\n    name = var.namespace\n    labels = {\n      \"app.kubernetes.io/managed-by\" = \"plural\"\n      \"app.plural.sh/name\" = \"$$application\"\n    }\n  }\n}" > ./$$application/terraform/gcp/main.tf; \
	echo "namespace = {{ .Namespace | quote }}" > ./$$application/terraform/aws/terraform.tfvars; \
	echo "namespace = {{ .Namespace | quote }}" > ./$$application/terraform/azure/terraform.tfvars; \
	echo "namespace = {{ .Namespace | quote }}" > ./$$application/terraform/gcp/terraform.tfvars; \
	echo "variable \"namespace\" {\n  type = string\n  default = \"$$application\"\n}" > ./$$application/terraform/aws/variables.tf; \
	echo "variable \"namespace\" {\n  type = string\n  default = \"$$application\"\n}" > ./$$application/terraform/azure/variables.tf; \
	echo "variable \"namespace\" {\n  type = string\n  default = \"$$application\"\n}" > ./$$application/terraform/gcp/variables.tf; \
	echo "name: $$application\ndescription: PLACEHOLDER\ncategory: PLACEHOLDER\nicon: plural/icons/PLACEHOLDER\ndarkIcon: plural/icons/PLACEHOLDER\nnotes: plural/notes.tpl\noauthSettings:\n  uriFormat: PLACEHOLDER\n  authMethod: PLACEHOLDER\ntags:\n- tag: PLACEHOLDER" > ./$$application/repository.yaml; \
	echo "REPO $$application\nATTRIBUTES Plural repository.yaml\n\nTF terraform/*\nHELM helm/*\nRECIPE plural/recipes/*\nTAG plural/tags/**/*" > ./$$application/Pluralfile; \

upload-%: # uploads artifacts
	plural apply -f $*/Pluralfile