.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: upload-airflow upload-bootstrap upload-plural

upload-airflow: # uploads airflow artifacts 
	forge apply -f airflow/Forgefile

upload-bootstrap: # uploads k8s bootstrapping artifacts
	forge apply -f bootstrap/Forgefile

upload-plural: # uploads plural platform artifacts
	forge apply -f plural/Forgefile

import-operator:
	cp ../plural-operator/config/crd/bases/* bootstrap/forge/crds