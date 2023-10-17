## Using the Airflow API

To use the [Airflow Stable REST API](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html) 
follow the steps below

### edit values.yaml

You'll need edit `airflow/helm/airflow/values.yaml` in your installation repo to enable basic auth to the REST API:

```yaml
airflow:
  airflow:
    airflow:
      config:
        AIRFLOW__API__AUTH_BACKENDS: airflow.api.auth.backend.basic_auth
```

Alternatively, you should be able to do this in the configuration section for airflow in your plural console as well.

### create an Airflow User

Create an Airflow user that will be used to make the API calls. To do this, you'll need to identify your Airflow 
Scheduler pod by running:

```shell
kubectl get pods -n airflow
```

After which you can run the following to get a shell to the scheduler container (be sure to replace `nnn-nnn` with the 
actual output from the previous command above):

```shell
kubectl exec -ti airflow-scheduler-nnn-nnn --namespace airflow -- /bin/bash
```

Now that you have a shell to the scheduler container, you can run an Airflow command to create a user (see Airflow Docs 
[here](https://airflow.apache.org/docs/apache-airflow/stable/security/webserver.html#web-authentication)):

```shell
airflow@airflow-scheduler-nnn-nnn:/opt/airflow$ airflow users create -e spiderman@superhero.org -f Peter -l Parker -p my_super_secret_password -r Admin -u pparker
```

### customize role (optional)

If you want to customize the Role for your API user and which permissions it has, you can do so in the Airflow UI. See 
more details [here](https://airflow.apache.org/docs/apache-airflow/stable/security/access-control.html)

## Making API Calls

Once you've completed the steps above to configure basic auth, you should be able to make api requests to your Airflow 
instance accordingly:

```python
    # trigger a DAG in Python 

    import json
    import requests
    from requests.auth import HTTPBasicAuth
    
    # Define your base URL and dag ID as variables
    base_url = "<replace with your base_url>" # Your base URL (can be found in your project's context.yaml - spec.configuration.airflow.hostname)
    dag_id = "<replace with dag_id you want to trigger>"
    
    # Define your username and password
    username="pparker"
    password="my_super_secret_password"
    
    # Construct and execute http request - (this one triggers a dag)
    response = requests.post(
        url=f"https://{base_url}/api/v1/dags/{dag_id}/dagRuns",
        headers={"accept": "application/json", "content-type": "application/json"},
        data=json.dumps({}),
        auth=HTTPBasicAuth(username=username, password=password)
    )
    print(response.json())
```

```bash
    # Define your base URL and dag ID as variables
    base_url="<replace with your base_url>" # Your base URL (can be found in your project's context.yaml - spec.configuration.airflow.hostname)
    dag_id="<replace with dag_id you want to trigger>"
    
    # Define your username and password
    username="pparker"
    password="my_super_secret_password"
    
    # Construct and execute the curl command - (this one triggers a dag)
    curl -X POST "$base_url/api/v1/dags/$dag_id/dagRuns" \
    -H "accept: application/json" \
    -H "content-type: application/json" \
    -d "{}" \
    -u "$username:$password"
```

For complete documentation on the API Stable REST API, be sure to visit the OSS docs [here](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html).