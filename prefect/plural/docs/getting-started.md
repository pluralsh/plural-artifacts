---
description: Modern orchestration tool and Airflow alternative.
---

## Setting up Prefect with Plural

This guide goes over the basics to getting started with running Prefect flows on Plural.

### Step 1: Configure Access to Plural

The Prefect CLI needs API access to Prefect on the Plural cluster. A simple solution is to create a basic auth user in Plural.

1) In the Plural repo open context.yaml
2) Add a users object to the prefect bundle:

prefect:
users: { <username>: <password> }

Plural has a utility to create a password. `plural crypto random will create a random string that can be used as a password.

### Step 2: Install Prefect CLI

To install the Prefect CLI locally, you will need to have Python and pip installed on your machine.

Open a terminal window and run the following command to install the Prefect CLI:

```shell
pip install prefect
```

Once the installation is complete, you can verify that the CLI is installed by running the following command:

```shell
prefect --version
``

### Step 3: Create a profile to connect to Plural

Prefect allows you to have multiple profiles to connect to different Prefect Server instances. I.e local, cloud or self-hosted. Plural is a self-hosted solution.

1) Create a new profile prefect profile create <profile-name> set the profile name to plural
2) On the new profile, set the PREFECT_API_URL with prefect config set PREFECT_API_URL="https://<user>:<password>@<yourprefecturl>.onplural.sh/api"
3) <user> and <password> are from the Plural config above. <yourprefecturl> is the URL you use to connect to Prefect Server ending with .onplural.sh/api

### Step 4: Test running a local file on the Plural Prefect instances

1) Create a file called test_flow.py
2) Add the following:

```python
from prefect import flow

@flow
def test_flow():
    print("What is your favorite number?")
    print(42)

if name == "__main__":
    test_flow()


3) Run the file locally python test_flow.py
```

If everything is functioning, you should see a flow run on the Plural hosted Prefect Server UI.

*Guide contributed by @reeves from the Plural Discord.*