Use `plural watch minecraft` to track the status of your application

You'll still need to set up a tcp ingress for this, which is currently a manual process, but can be done easily with:

```yaml
ingress-nginx:
  tcp:
    25565: minecraft/minecraft-server:25565 # add :PROXY to the end of the string for AWS, which requires proxy-protocol to be enabled
```