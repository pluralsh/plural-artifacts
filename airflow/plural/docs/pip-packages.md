## Installing pip packages

Frequently an airflow project needs more than our default pip setup installed to work fully.  Airflow's codebase is brittle, and we recommend you handle pip installs by baking a new docker image against ours and then wiring it into your installation.  It's not actually too hard, and we can walk you through it.

### Custom Dockerfile

The dockerfile for our image is found at https://github.com/pluralsh/containers/tree/main/airflow.  You'll also want to keep the `requirements.txt` file adjacent to it.  Simply move these two wherever you manage docker, add whatever pip packages to `requirements.txt` and push it to your container registry.

### wire airflow to point to new dockerfile

You'll then want to edit `airflow/helm/airflow/values.yaml` in your installation repo with something like:

```yaml
airflow:
  airflow:
    airflow:
      image:
        repository: your.docker.repository
        tag: your-tag
```

Alternatively, you should be able to do this in the configuration section for airflow in your plural console as well.

### redeploy

from there you can simply run `plural build --only airflow && plural deploy --commit "using custom docker image"` to set this up