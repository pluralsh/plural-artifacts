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

helm-dependencies-%: # syncs helm dependencies for a chart
	dir=pwd
	for D in ./$*/helm/* ; do \
		cd $$dir$$D && helm dependency update && cd - ; \
	done

upload-%: # uploads artifacts
	plural apply -f $*/Pluralfile