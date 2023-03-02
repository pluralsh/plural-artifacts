## Welcome to plural-artifacts

This is a central repository for all the packaging for apps we're managing within Plural.  In general, there's a common structure to the layout of all these apps:

```
<app-name>/
- helm # helm charts for the app
- terraform # terraform modules for the app
- plural # plural metadata
repository.yaml # repository specification
```

There's also a Makefile with some useful utilities for managing these 

### Adding a new application

To add a new application, you'll want to run `plural create` and answer the brief questionairre.  That will generate the above directory structure with stub implementations for most of the basic resources.  Generally we try to extend the existing upstream helm packaging, so you'll want to find any prior art, research its configuration and modify it appropriately.  General rules of thumb are:

* replace all built-in stateful services
    - many charts will bake in a bitnami postgres helm chart, replace w/ our zalando pg operator setup which will have backup/restore and HA set up already
    - some apps use elasticsearch, kafka, mongo, etc.  We have operator setups w/in the catalog as well you can use here
    - frequently redis can be left as-is if it's purely used for memory caching, that's left to the judgement of the user
* try to build out as many config overlays and runbooks as possible.  You can look to airflow and airbyte for inspiration for how to do this
* if the app supports OIDC, ensure this is configurable


You can learn more about all the custom resources that can be used when building out the packaging for an application [here](https://docs.plural.sh/adding-new-application/guide) as well 

### Upgrading an application

The upgrade process usually involves two main steps:

* figure out how to update the app's helm chart
* test it using `plural link`

To test, you'll need to already have the app installed in some cluster.  The plural link command works similarly to yarn or npm link if you're familiar with either.  Basically, within the installation repo for that app, run:

```sh
plural link {helm|terraform} <app-name> --path ../plural-artifacts/<app-name>/{helm|terraform}/<package-name> --name <package-name>
```

then you can run

```sh
plural build --only <app-name> --force
plural deploy
```

to deploy the app with the local link you established. The `--force` flag will prevent any deduping w/in the plural cli from triggering

### Helpful utilities

Frequently if you're updating helm dependencies, it can be complicated to sync them locally appropriately, you can just run:

```sh
make helm-dependencies-<app>
```

to simplify that

If you have publish access to this repo, you can publish your changes directly with

```sh
make upload-<app>
```

as well. **Only do this for apps that have not yet been publicly released**