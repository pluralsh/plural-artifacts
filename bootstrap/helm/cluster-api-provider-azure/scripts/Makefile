AZURE_VERSION=v1.9.10

azure:
# Clean current CRDs
	rm -rf ../templates/*-crd.yaml
	mkdir tmp
	wget https://github.com/pluralsh/cluster-api-provider-azure/releases/download/${AZURE_VERSION}/infrastructure-components.yaml
# This rewrites the data to stringData in the secret
	yq 'select(.kind == "Secret") | .stringData += .data | del(.data)' infrastructure-components.yaml > tmp.yaml
# This removes the Secret from the yaml
	yq 'del( select(.kind == "Secret"))' infrastructure-components.yaml > tmp2.yaml

# This combines the yaml files back together
	yq eval-all tmp.yaml tmp2.yaml > infrastructure-components.yaml

	cat infrastructure-components.yaml | helmify -generate-defaults -image-pull-secrets tmp/cluster-api-provider-azure
	rm infrastructure-components.yaml tmp.yaml tmp2.yaml
	yq -i ".appVersion=\"${AZURE_VERSION}\"" ../Chart.yaml

# This removes the Azure credentials from the values.yaml since it is being set by managerBootstrapCredentials.credentials instead
	yq -i "del(.configVariables.azureClientIdB64) | del(.configVariables.azureClientSecretB64) | del(.configVariables.azureSubscriptionIdB64) | del(.configVariables.azureTenantIdB64)" tmp/cluster-api-provider-azure/values.yaml

	mv tmp/cluster-api-provider-azure/templates/*-crd.yaml ../templates/
	rm -rf tmp/
