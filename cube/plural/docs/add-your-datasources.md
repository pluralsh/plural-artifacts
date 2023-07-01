# Add Your Cube Datasources

Cube allows you to connect to multiple datasources. To configure them with Plural, you'll need to update the `cube/helm/cube/values.yaml` file.
All supported datasources could be found [here](https://cube.dev/docs/config/databases).


Example of a postgres datasource
```yaml
cube:
  cube:
    datasources:
      default: # one default datasource is required
        type: postgres
        host: <PG_DB_HOST>
        port: 5432
        name: postgres
        user: postgres
        pass: <PG_DB_PASSWORD>
      postgres_2: # you can define the name you want
        type: postgres
        host: <PG_DB_HOST2>
        port: 5432
        name: postgres
        user: postgres
        pass: <PG_DB_PASSWORD2>
```

Looking at a specific datasource? Check next parts.

### Datasources configuration

| Name          | Description                                                              | Value          |
| ------------- | ------------------------------------------------------------------------ | -------------- |
| `datasources` | map of named datasources. The first datasource has to be named "default" | { default: {}} |

### Common datasource parameters

| Name                                                       | Description                                                                                   | Value   |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------- |
| `datasources.<name>.type`                                  | A database type supported by Cube.js                                                          |         |
| `datasources.<name>.url`                                   | The URL for a database                                                                        |         |
| `datasources.<name>.host`                                  | The host URL for a database                                                                   |         |
| `datasources.<name>.port`                                  | The port for the database connection                                                          |         |
| `datasources.<name>.schema`                                | The schema within the database to connect to                                                  |         |
| `datasources.<name>.name`                                  | The name of the database to connect to                                                        |         |
| `datasources.<name>.user`                                  | The username used to connect to the database                                                  |         |
| `datasources.<name>.pass`                                  | The password used to connect to the database                                                  |         |
| `datasources.<name>.passFromSecret.name`                   | The password used to connect to the database (using secret)                                   |         |
| `datasources.<name>.passFromSecret.key`                    | The password used to connect to the database (using secret)                                   |         |
| `datasources.<name>.domain`                                | A domain name within the database to connect to                                               |         |
| `datasources.<name>.socketPath`                            | The path to a Unix socket for a MySQL database                                                |         |
| `datasources.<name>.catalog`                               | The catalog within the database to connect to                                                 |         |
| `datasources.<name>.maxPool`                               | The maximum number of connections to keep active in the database connection pool              |         |
| `datasources.<name>.queryTimeout`                          | The timeout value for any queries made to the database by Cube                                |         |
| `datasources.<name>.export.name`                           | The name of a bucket in cloud storage                                                         |         |
| `datasources.<name>.export.type`                           | The cloud provider where the bucket is hosted (gcs, s3)                                       |         |
| `datasources.<name>.export.gcs.credentials`                | Base64 encoded JSON key file for connecting to Google Cloud                                   |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.name` | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                    |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.key`  | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                    |         |
| `datasources.<name>.export.aws.key`                        | The AWS Access Key ID to use for the export bucket                                            |         |
| `datasources.<name>.export.aws.secret`                     | The AWS Secret Access Key to use for the export bucket                                        |         |
| `datasources.<name>.export.aws.secretFromSecret.name`      | The AWS Secret Access Key to use for the export bucket (using secret)                         |         |
| `datasources.<name>.export.aws.secretFromSecret.key`       | The AWS Secret Access Key to use for the export bucket (using secret)                         |         |
| `datasources.<name>.export.aws.region`                     | The AWS region of the export bucket                                                           |         |
| `datasources.<name>.export.redshift.arn`                   | An ARN of an AWS IAM role with permission to write to the configured bucket (see export.name) |         |
| `datasources.<name>.ssl.enabled`                           | If true, enables SSL encryption for database connections from Cube.js                         | `false` |
| `datasources.<name>.ssl.rejectUnAuthorized`                | If true, verifies the CA chain with the system's built-in CA chain                            |         |
| `datasources.<name>.ssl.ca`                                | The contents of a CA bundle in PEM format, or a path to one                                   |         |
| `datasources.<name>.ssl.cert`                              | The contents of an SSL certificate in PEM format, or a path to one                            |         |
| `datasources.<name>.ssl.key`                               | The contents of a private key in PEM format, or a path to one                                 |         |
| `datasources.<name>.ssl.ciphers`                           | The ciphers used by the SSL certificate                                                       |         |
| `datasources.<name>.ssl.serverName`                        | The server name for the SNI TLS extension                                                     |         |
| `datasources.<name>.ssl.passPhrase`                        | he passphrase used to encrypt the SSL private key                                             |         |

### Athena datasource parameters

| Name                                              | Description                                                              | Value |
| ------------------------------------------------- | ------------------------------------------------------------------------ | ----- |
| `datasources.<name>.athena.key`                   | The AWS Access Key ID to use for database connections                    |       |
| `datasources.<name>.athena.keyFromSecret.name`    | The AWS Access Key ID to use for database connections (using secret)     |       |
| `datasources.<name>.athena.keyFromSecret.key`     | The AWS Access Key ID to use for database connections (using secret)     |       |
| `datasources.<name>.athena.region`                | The AWS region of the Cube.js deployment                                 |       |
| `datasources.<name>.athena.s3OutputLocation`      | The S3 path to store query results made by the Cube.js deployment        |       |
| `datasources.<name>.athena.secret`                | The AWS Secret Access Key to use for database connections                |       |
| `datasources.<name>.athena.secretFromSecret.name` | The AWS Secret Access Key to use for database connections (using secret) |       |
| `datasources.<name>.athena.secretFromSecret.key`  | The AWS Secret Access Key to use for database connections (using secret) |       |
| `datasources.<name>.athena.workgroup`             | The name of the workgroup in which the query is being started            |       |
| `datasources.<name>.athena.catalog`               | The name of the catalog to use by default                                |       |

### Bigquery datasource parameters

| Name                                                     | Description                                                                     | Value |
| -------------------------------------------------------- | ------------------------------------------------------------------------------- | ----- |
| `datasources.<name>.bigquery.projectId`                  | The Google BigQuery project ID to connect to                                    |       |
| `datasources.<name>.bigquery.location`                   | The Google BigQuery dataset location to connect to                              |       |
| `datasources.<name>.bigquery.credentials`                | A Base64 encoded JSON key file for connecting to Google BigQuery                |       |
| `datasources.<name>.bigquery.credentialsFromSecret.name` | A Base64 encoded JSON key file for connecting to Google BigQuery (using secret) |       |
| `datasources.<name>.bigquery.credentialsFromSecret.key`  | A Base64 encoded JSON key file for connecting to Google BigQuery (using secret) |       |
| `datasources.<name>.bigquery.keyFile`                    | The path to a JSON key file for connecting to Google BigQuery                   |       |

### Databricks datasource parameters

| Name                                         | Description                                                               | Value |
| -------------------------------------------- | ------------------------------------------------------------------------- | ----- |
| `datasources.<name>.databricks.url`          | The URL for a JDBC connection                                             |       |
| `datasources.<name>.databricks.acceptPolicy` | Whether or not to accept the license terms for the Databricks JDBC driver |       |
| `datasources.<name>.databricks.token`        | The personal access token used to authenticate the Databricks connection  |       |
| `datasources.<name>.databricks.catalog`      | Databricks catalog name                                                   |       |

### Clickhouse datasource parameters

| Name                                     | Description                                             | Value |
| ---------------------------------------- | ------------------------------------------------------- | ----- |
| `datasources.<name>.clickhouse.readonly` | Whether the ClickHouse user has read-only access or not |       |

### Firebolt datasource parameters

| Name                                      | Description                                    | Value |
| ----------------------------------------- | ---------------------------------------------- | ----- |
| `datasources.<name>.firebolt.account`     | Account name                                   |       |
| `datasources.<name>.firebolt.engineName`  | Engine name to connect to                      |       |
| `datasources.<name>.firebolt.apiEndpoint` | Firebolt API endpoint. Used for authentication |       |

### Hive datasource parameters

| Name                                    | Description                                     | Value |
| --------------------------------------- | ----------------------------------------------- | ----- |
| `datasources.<name>.hive.cdhVersion`    | The version of the CDH instance for Apache Hive |       |
| `datasources.<name>.hive.thriftVersion` | The version of Thrift Server for Apache Hive    |       |
| `datasources.<name>.hive.type`          | The type of Apache Hive server                  |       |
| `datasources.<name>.hive.version`       | The version of Apache Hive                      |       |

### Presto datasource parameters

| Name                                | Description                             | Value |
| ----------------------------------- | --------------------------------------- | ----- |
| `datasources.<name>.presto.catalog` | The catalog within Presto to connect to |       |

### Snowflake datasource parameters

| Name                                                  | Description                                                            | Value |
| ----------------------------------------------------- | ---------------------------------------------------------------------- | ----- |
| `datasources.<name>.snowFlake.account`                | The Snowflake account ID to use when connecting to the database        |       |
| `datasources.<name>.snowFlake.region`                 | The Snowflake region to use when connecting to the database            |       |
| `datasources.<name>.snowFlake.role`                   | The Snowflake role to use when connecting to the database              |       |
| `datasources.<name>.snowFlake.warehouse`              | The Snowflake warehouse to use when connecting to the database         |       |
| `datasources.<name>.snowFlake.clientSessionKeepAlive` | If true, keep the Snowflake connection alive indefinitely              |       |
| `datasources.<name>.snowFlake.authenticator`          | The type of authenticator to use with Snowflake. Defaults to SNOWFLAKE |       |
| `datasources.<name>.snowFlake.privateKeyPath`         | The path to the private RSA key folder                                 |       |
| `datasources.<name>.snowFlake.privateKeyPass`         | The password for the private RSA key. Only required for encrypted keys |       |

### Trino datasource parameters

| Name                               | Description                            | Value |
| ---------------------------------- | -------------------------------------- | ----- |
| `datasources.<name>.trino.catalog` | The catalog within Trino to connect to |       |