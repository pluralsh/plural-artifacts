## Configuring 

Prefect agents allow for a single agent to poll multiple work queues for a lightweight and efficient deployment structure.  By default a work queue named `default` is associated with the Prefect Agent.  However, this can be overwritten with your own custom workspaces easily by modifying the `values.yaml` in your Plural config.

### Plural Build

After the bundle install of the prefect-agent, run the `plural build` command to pull down the prefect-agent helm chart to your local repository.

You will find that an empty `values.yaml` file is generated under `helm/prefect-agent`

### Modify the Values File

Open up a code editor and update the empty values.yaml file to include the workspaces you want to queue with the Prefect Agent

```yaml
prefect-agent:
  prefect-agent:
    agent:
      config:
        workQueues:
        - custom-work-queue1
        - custom-work-queue2
        - "***"
```
### Deploy the Agent

Simply run `plural deploy --commit "Deploy with custom work queues"`

### Verify Agent is running

You can now verify that the Prefect Agent is up and running by checking its status under `Work Queues` in your [Prefect Cloud web console](https://app.prefect.cloud) or through the Prefect Agent logs in the Plural Console if that has been deployed