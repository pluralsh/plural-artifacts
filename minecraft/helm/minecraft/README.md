This chart will set up your minecraft server.  You'll still need to configure tcp ingress for the nodeport service, which can be done with:


```yaml
ingress-nginx:
  tcp:
    25565: minecraft/minecraft-server:25565 # add :PROXY to the end of the string for AWS, which requires proxy-protocol to be enabled
```