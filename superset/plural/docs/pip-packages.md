## Adding additional pip packages

Superset doesn't come pre-installed with all drivers you might need for your visualizations.  To add additional db drivers, the most stable solution is to extend our docker image, which is relatively easy to do.

### Build your extended image

First copy the dockerfile here https://github.com/pluralsh/plural-artifacts/blob/main/superset/Dockerfile to wherever you want to manage your image.  You'll also want to copy the requirements.txt in the same subfolder, and add whatever additional packages you want to it.  Build the image then push it to your registry of choice to use it in the next step.

### Wire Superset with this image


You'll then want to edit `superset/helm/superset/values.yaml` in your installation repo with something like:

```yaml
superset:
  superset:
    image:
      repository: your.docker.repository
      tag: your-tag
```

Alternatively, you should be able to do this in the configuration section for superset in your plural console as well.

### redeploy

from there you can simply run `plural build && plural deploy --commit "using custom docker image"` to set this up