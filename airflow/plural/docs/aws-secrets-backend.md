## Connecting to AWS Secrets Backend

Airflow allows you the opportunity to connect to various services as a Secrets Backend as an alternative to using the 
Airflow UI to manage connections. One of these services is [AWS Secrets Manager](https://airflow.apache.org/docs/apache-airflow-providers-amazon/stable/secrets-backends/aws-secrets-manager.html).
Once you add below configurations, Airflow will be able to retrieve Secrets from AWS Secrets Manager (provided that they 
have the same prefixes specified in the `KWARGS` config).

In this scenario, the prefixes are `airflow/connections` & `airflow/variables`, so any values stored under the 
`airflow/connections` prefix would be treated the same as an object stored in the `Admin >> Connections` menu of the 
Airflow UI. Any values stored under the `airflow/variables` prefix would be treated the same as an object stored in the 
`Admin >> Variables` menu of the Airflow UI.

### edit values.yaml

You'll then want to edit `airflow/helm/airflow/values.yaml` in your installation repo with something like:

```yaml
airflow:
  airflow:
    airflow:
      config:
        AIRFLOW__SECRETS__BACKEND: airflow.providers.amazon.aws.secrets.secrets_manager.SecretsManagerBackend
        AIRFLOW__SECRETS__BACKEND_KWARGS: '{"connections_prefix": "airflow/connections","variables_prefix":
          "airflow/variables"}'
```

Alternatively, you should be able to do this in the configuration section for airflow in your plural console as well.

### add policy to AWS role

When installing the Airflow Application, Plural added a default role for Airflow. The role will be called 
`<your-cluster-name>-airflow`. You will need to add a policy to that role to allow it to access AWS Secrets Manager. You
can use this policy as a starting point:

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"secretsmanager:GetRandomPassword",
				"secretsmanager:ListSecrets"
			],
			"Resource": "*"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "secretsmanager:*",
			"Resource": "arn:aws:secretsmanager:<insert-aws-region>:<insert-aws-account-number>:secret:airflow/*"
		}
	]
}
```

### redeploy

From there, you should be able to run `plural build --only airflow && plural deploy --commit "use aws secrets manager 
backend"` to use the secrets backend