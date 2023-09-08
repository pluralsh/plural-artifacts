APPS := $(shell ls -l | egrep '^d' | awk '{ print $$9 }')
JOBS := $(addprefix upload-,${APPS})

.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ${JOBS} ; echo "finished updating all apps"


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

download-temporal-chart: # downloads temporal's helm chart since it isn't published by them
	cd temporal/helm/temporal/charts && curl -L https://github.com/temporalio/helm-charts/archive/refs/tags/v1.21.5.tar.gz | tar -xz
	mv temporal/helm/temporal/charts/helm-charts-1.21.5 temporal/helm/temporal/charts/temporal
	rm -rf temporal/helm/temporal/charts/temporal/.github