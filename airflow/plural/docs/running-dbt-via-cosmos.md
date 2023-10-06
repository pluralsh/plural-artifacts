## Running dbt core in Airflow via Cosmos

[Cosmos](https://github.com/astronomer/astronomer-cosmos) is an open source project that allows you to run dbt core 
projects in Airflow natively. To date, it is probably one of the best ways to run dbt core in Airflow.

### custom dockerfile

In order to run dbt core effectively, we recommend you bake a new docker image against ours and then wiring it into your 
installation. Please follow the [pip-packages](./pip-packages.md) guide for instructions on baking your own image.

Airflow and dbt both share common dependencies (i.e. Jinja). This can cause dependency clashes between Airflow and your 
dbt adapter when you upgrade them. To solve for this, we can put our dbt adapter in its own python virtual environment. 
This is possible by adding the following step to your custom `Dockerfile`:

```dockerfile
FROM docker.io/apache/airflow:2.6.3-python3.10

USER root
RUN apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements.txt requirements.txt
RUN pip freeze | grep -i apache-airflow > protected-packages.txt \
 && pip install --constraint ./protected-packages.txt --no-cache-dir -r ./requirements.txt \
 && rm -rf ./protected-packages.txt ./requirements.txt

## create virtual environments for dbt
RUN export PIP_USER=false && python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-redshift==1.6.1 && deactivate && export PIP_USER=true

```

In this example, we've installed the `dbt-redshift` adapter into the python virtual environment. However, you can swap 
the adapter for the one that suites your needs (i.e. `dbt-bigquery`, `dbt-snowflake`, etc.) 

### add dbt project to your dags directory

In your dags directory, add a folder called `dbt`. Within that folder, copy your dbt project. For example, if you were 
going to add Fishtown Analytic's classic [Jaffle Shop project](https://github.com/dbt-labs/jaffle_shop), your project 
directory would look something like this:

```yaml
plural-airflow-repo
└── dags
    └── dbt
        └── jaffle_shop
            ├── LICENSE
            ├── README.md
            ├── dbt_project.yml
            ├── etc
            │   ├── dbdiagram_definition.txt
            │   └── jaffle_shop_erd.png
            ├── models
            │   ├── customers.sql
            │   ├── docs.md
            │   ├── orders.sql
            │   ├── overview.md
            │   ├── schema.yml
            │   └── staging
            │       ├── schema.yml
            │       ├── stg_customers.sql
            │       ├── stg_orders.sql
            │       └── stg_payments.sql
            └── seeds
                ├── raw_customers.csv
                ├── raw_orders.csv
                └── raw_payments.csv
```

### point Cosmos class to the nested dbt project directory

In your dags directory, add a `jaffle_shop.py` file to create a DAG, and add the following contents to it:

```python
"""
## Jaffle Shop

Example of using cosmos to run the jaffle shop dbt project
"""
import os
from datetime import datetime

from airflow import DAG
from cosmos import DbtTaskGroup, ExecutionConfig, ProfileConfig, ProjectConfig
from cosmos.profiles.redshift.user_pass import RedshiftUserPasswordProfileMapping

'''these next lines help to resolve the path to your dbt project in the plural airflow instance vs. local development'''

# Dynamically retrieves the Airflow Home directory 
airflow_home = os.getenv("AIRFLOW_HOME", "/usr/local/airflow")

# I've set a local env variable ENVIRONMENT=DEV to determine if dag is running in plural airflow or local airflow
if os.getenv("ENVIRONMENT", "PROD") == "DEV":
    # the project path when running Airflow locally
    dbt_project_path = f"{airflow_home}/dags/dbt/jaffle_shop"  
else:
    # the project path in plural cluster
    dbt_project_path = f"{airflow_home}/dags/repo/dags/dbt/jaffle_shop"  

# the path to the dbt executable that's within the venv created in Dockerfile
dbt_executable_path = f"{airflow_home}/dbt_venv/bin/dbt"

# Profile mapping to connect dbt to a target
profile_mapping = RedshiftUserPasswordProfileMapping(
    # airflow connection id to use for the dbt target
    conn_id="redshift_default",  
    profile_args={
        # my redshift database name
        "dbname": "dev", 
        # default schema to write to if one isn't specified in .yml or .sql dbt files
        "schema": "a_default_schema_name"  
    }
)

with DAG(
        dag_id="jaffle_shop",
        start_date=datetime(2023, 10, 6),
        schedule=None,
        doc_md=__doc__,
        tags=["dbt", "redshift"],
):
    DbtTaskGroup(
        project_config=ProjectConfig(
            dbt_project_path=dbt_project_path
        ),
        execution_config=ExecutionConfig(
            dbt_executable_path=dbt_executable_path
        ),
        profile_config=ProfileConfig(
            profile_name="jaffle_shop",  # the default profile - recommended to be your dbt project name
            target_name="cosmos_target",  # the default target - recommended to just leave as cosmos_target
            profile_mapping=profile_mapping,
        )
    )
```

This example uses a Redshift Data Warehouse as a target, but you can also configure profiles for other targets (i.e. 
Snowflake, BigQuery, etc.). For more information, please review Cosmos Docs [here](https://astronomer.github.io/astronomer-cosmos/profiles/index.html). 
After making these changes, you should see the DAG parse like so:

![jaffle_shop_dag.png](static%2Fjaffle_shop_dag.png)
