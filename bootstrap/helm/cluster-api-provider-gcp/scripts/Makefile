GCP_VERSION=v1.3.4

gcp:
# Clean current CRDs
	rm -rf ../templates/*-crd.yaml
	mkdir tmp
	wget https://github.com/pluralsh/cluster-api-provider-gcp/releases/download/${GCP_VERSION}/infrastructure-components.yaml
# This rewrites the data to stringData in the secret
	yq 'select(.kind == "Secret") | .data."credentials.json" = ""' infrastructure-components.yaml > tmp.yaml
# This removes the Secret from the yaml
	yq 'del( select(.kind == "Secret"))' infrastructure-components.yaml > tmp2.yaml

# This combines the yaml files back together
	yq eval-all tmp.yaml tmp2.yaml > infrastructure-components.yaml

	cat infrastructure-components.yaml | helmify -generate-defaults -image-pull-secrets tmp/cluster-api-provider-gcp
	rm infrastructure-components.yaml tmp.yaml tmp2.yaml
	yq -i ".appVersion=\"${GCP_VERSION}\"" ../Chart.yaml

	mv tmp/cluster-api-provider-gcp/templates/*-crd.yaml ../templates/
	rm -rf tmp/
