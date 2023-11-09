## Configuring Basic Auth

Airbyte's api and web interface is not authenticated by default.  We provide an oauth proxy by default to grant some security to your airbyte install, but in order to integrate with tools like airflow, you'll likely want a means to authenticate with static creds.  That's where basic auth can be very useful.  The process is very simple.

### modify context.yaml

in the `context.yaml` file at the root of your repo, simply add:

```yaml
configuration:
  airbyte:
    users:
      <name>: <password>
      <name2>: <password2>
```
you can use `plural crypto random` to generate a high-entropy password if that is helpful as well.

### redeploy

Simply run `plural build --only airbyte && plural deploy --commit "enabling basic auth"` to wire in the credentials to our oauth proxy.  Occasionally you need to restart the web pods to get it to take, you can find them with:

```sh
kubectl get pods -n airbyte | grep airbyte-web
```

then delete them (allowing k8s to restart) with:

```sh
kubectl delete pod <name> -n airbyte
```

## Making API Calls

Once you've completed the steps above to configure basic auth, you should be able to make api requests to your Airbyte 
instance accordingly:

```python
    # python

    import base64
    import requests

    user = "<insert-your-username>" # configured in previous step
    password = "<insert-your-password>" # configured in previous step
    base_url = "<insert-your-base-url>" # can be found in your project's context.yaml (spec.configuration.airbyte.hostname)
    credentials = f"{user}:{password}"
    credentials_base64 = base64.b64encode(credentials.encode("utf-8")).decode("utf-8")
    response = requests.post(
        url=f"https://{base_url}/api/v1/workspaces/list",
        headers={
            "accept": "application/json",
            "authorization": f"Basic {credentials_base64}"
        }
    )
    print(response.json())
```

```bash
    user="<insert-your-username>"  # configured in previous step
    password="<insert-your-password>"  # configured in previous step
    
    # Your base URL (can be found in your project's context.yaml - spec.configuration.airbyte.hostname)
    base_url="<insert-your-base-url>"
    
    # Combine the username and password with a colon (required for Basic Authentication)
    credentials="${user}:${password}"
    
    # Encode the credentials in base64
    credentials_base64=$(echo -n "$credentials" | base64)
    
    # Make an HTTP POST request using curl
    curl -X POST "https://${base_url}/api/v1/workspaces/list" \
        -H "accept: application/json" \
        -H "authorization: Basic $credentials_base64"
```

It's also worth noting that the [Airbyte Public API Docs](https://airbyte-public-api-docs.s3.us-east-2.amazonaws.com/) 
will serve as a more accurate reference than the [Airbyte Reference API Docs](https://reference.airbyte.com/reference/start) 
when building your application.