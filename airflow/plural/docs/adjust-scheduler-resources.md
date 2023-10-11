## Adjusting Scheduler Resources

In Airflow, the [scheduler](https://airflow.apache.org/docs/apache-airflow/stable/administration-and-deployment/scheduler.html) 
monitors all tasks and DAGs, then triggers the task instances once their dependencies are complete.

You may find that you need to increase the number of schedulers that you are running as well as increase the resources 
available to each scheduler.

### edit values.yaml

In order to update scheduler resources, you'll then want to edit `airflow/helm/airflow/values.yaml` in your installation 
repo. If you wanted 2 schedulers each with at least 0.5 cpu & 1.75Gi of resources, you'd make the following change:

```yaml
airflow:
  airflow:
    airflow:
    scheduler:
      replicas: 2
      resources:
        limits:
          cpu: 1.5
          memory: 2.5Gi
        requests:
          cpu: 0.5
          memory: 1.75Gi
```

> It is highly recommended to set limits on your scheduler(s) to ensure fair resource sharing across your cluster.

Alternatively, you should be able to do this in the configuration section for airflow in your plural console as well.

### redeploy

From there, you should be able to run `plural build --only airflow && plural deploy --commit "update scheduler 
resources"` to adjust your Airflow scheduler configuration
