## Welcome to plural-artifacts

This is a central repository for packaging all the applications we're managing within Plural.  In general, there's a common structure to the layout of all these apps:

```
<app-name>/
- helm // helm charts for the app
- terraform // terraform modules for the app
- plural // plural metadata
repository.yaml // repository specification
```

There's also a Makefile with some useful utilities for managing these files.


### Plural Contributor Program

We are focused on properly compensating any contributions to the Plural platform, which includes a meaningful bounty for either adding an application to this repo or upgrading an existing one.  Currently the rewards are:

* $75 for a tested, successful application upgrade
* $300 for a new application onboarded that is on our roadmap (https://github.com/orgs/pluralsh/projects/2).

To be eligible for the upgrade bounty you'll want to follow the steps for upgrading an application below and we simply need to confirm it was correct and properly tested.  

To be eligible for an application onboarding bounty, the process is a bit more involved, but requires you to follow the add new application flow and then once we've deemed the application to have a `releaseStatus` of `BETA` or higher, the reward is eligible.  The application must have an existing issue in this repo allowing us to vet the eligibility of the application as well. If you would like to onboard something not currently in the queue, simply create an issue and we'll determine if it's something we'd like to be on the platform from there.

To claim the reward, you should get in touch with us on our discord at https://discord.gg/pluralsh and we'll simply need to confirm that you did the work (easy way to do that is linking your discord handle on the relevant PRs) and will give you the bounty you've earned.

(Disclaimer: These bounties are subject to change
 
Contributor hereby grants to Plural and its affiliates a non-exclusive, perpetual, irrevocable, worldwide, royalty-free, transferable, sublicensable (through multiple tiers) license to freely use, make available and otherwise exploit any materials or contributions submitted by Contributor for any purpose (“Contributions”). Contributor represents, warrants and covenants that: (a) all contributions and Plural’s use thereof will comply with all applicable laws, rules and regulations as well as all applicable third party and open source licenses; (b) Contributor’s submission of Contributions is not and will not be inconsistent with any obligation Contributor may have to others; (c) neither Contributor’s submission of Contributions, nor Plural’s development, use, production, distribution or other exploitation thereof will infringe, misappropriate or violate any intellectual property or other right of any person or entity (including, without limitation, Contributor); and (d) Contributor has the full right to provide Plural with the Contributions and foregoing license. Plural reserves the right to review all Contributions and may or may not, within Plural’s sole discretion, use or incorporate Contributions into Plural’s offerings. Contributor is providing Contributions as an independent contractor and is not a partner, joint venture or agent of Plural and shall not bind nor attempt to bind Plural to any contract. Contributor is not a Plural employee or consultant, and Contributor shall not be eligible to participate in any of Plural’s employee benefit plans, fringe benefit programs, group insurance arrangements or similar programs. )

### Adding a new application

To add a new application, you'll want to run `plural create` and answer the brief questionnaire. This will generate the above directory structure with stub implementations for most of the basic resources. Generally we try to extend the existing upstream Helm packaging, so you'll ideally want to find an already working Helm chart, research its configuration and modify it appropriately.  General rules of thumb are:

* Replace all built-in stateful services
    - Many charts will bake in a Bitnami Postgres Helm chart. You'll want to replace this with our Zalando Postgres operator setup which will have backup/restore and high availability set up already
    - Some apps use Elasticsearch, Kafka, MongoDB, etc.  We have operator setups in the catalog for these applications that you can use here
    - Frequently, Redis can be left as-is if it's purely used for memory caching. We leave this to the judgement of the user
* Try to build out as many config overlays and runbooks as possible. You can look to [Airflow](https://github.com/pluralsh/plural-artifacts/tree/f9fda1a23782739c80200ebb6da11076eeb8de9c/airflow/helm/airflow/templates) and [Airbyte](https://github.com/pluralsh/plural-artifacts/tree/main/airbyte/helm/airbyte/templates) for inspiration for how to do this.
* If the app supports OIDC, ensure this is configurable.


You can learn more about all the custom resources that can be used when building out the packaging for an application [here](https://docs.plural.sh/adding-new-application/guide) as well. 

### Upgrading an application

The upgrade process usually involves two main steps:

* figure out how to update the app's Helm chart
* test it using `plural link`

To test, you'll need to already have the app installed in some cluster.  The `plural link command works similarly to yarn or npm link if you're familiar with either. Basically, within the installation repo for that app, run:

```sh
plural link {helm|terraform} <app-name> --path ../plural-artifacts/<app-name>/{helm|terraform}/<package-name> --name <package-name>
```

Then you can run:

```sh
plural build --only <app-name> --force
plural deploy
```

This deploys the app with the local link you established. The `--force` flag will prevent any deduping w/in the Plural CLI from triggering.


### External Contributor Flow

For adding a new application the flow should be as follow:

* create an initial pr from the setup given by `plural create` above.  You'll want to make sure the `repository.yaml` file is marked `private: true` and add your plural email to the list of contributors, eg:

```
name: airbyte
description: airbyte deployed on plural
category: DATA
releaseStatus: ALPHA
private: true # keeps the repo from being publicly available to users until its ready
contributors:
- my@plural.email
...
```

You'll want to create a pr with that initial setup which will create the initial repository and mark yourself as a contributor.

* deploy a gcp or aws cluster to properly build and test the application, which can be done with the upgrade steps above
* publish a new pr with the final version, and if it's good to go, we can drop the privacy flag.
* if we're confident its ready for general use, we can move the `releaseStatus` to `GA` or `BETA` as appropriate.


### Helpful utilities

If you're frequently updating Helm dependencies, it can be complicated to sync them locally. To make this easier, you can just run:

```sh
make helm-dependencies-<app>
```

If you have publish access to this repo, you can publish your changes directly with the following command:

```sh
make upload-<app>
```

**Only do this for apps that have not yet been publicly released**
