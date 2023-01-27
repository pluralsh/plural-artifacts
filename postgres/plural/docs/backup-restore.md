## Postgres Backup and Restore

Zalando's postgres operator has a number of useful backup/restore features that can be useful if you want to leverage them.
The two main one's we've used is:

* clone from object storage - backs up snapshots and WAL logs to S3 or an equivalent object store where you can then pull it back down
* clone from another instance - nice for creating hot backups

### Finding your postgres database

The process will involve usage of kubectl so it's useful to get familiar with how to manage postgres with zalando's custom resource and kubectl:

```sh
kubectl get postgresql -n $namespace # get postgres isntances in a namespace
kubectl get postgresql $name -n $namespace -o yaml > db.yaml # dump the yaml for a postgres instance to a file
kubectl delete postgresql $name -n $namespace # deletes an instance
```

These are some basic commands you'll likely want to use

### Clone from object storage

The procedure from this is relatively simple:

* run `kubectl get postgresql <name> -n <namespace> -o yaml > db.yaml` to get the current yaml
* copy the `uid` in the metadata section of the yam, you'll need it later. This can be found in a block like:

```yaml
apiVersion: acid.zalan.do/v1
kind: postgresql
metadata:
  annotations:
    meta.helm.sh/release-name: airbyte
    meta.helm.sh/release-namespace: airbyte
  creationTimestamp: "2022-10-31T23:53:27Z"
  generation: 6
  labels:
    app.kubernetes.io/instance: airbyte
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: postgres
    app.kubernetes.io/version: 1.16.0
    helm.sh/chart: postgres-0.1.16
  name: plural-airbyte
  namespace: airbyte
  resourceVersion: "966219670"
  uid: 40c1d314-f667-421e-a059-f4521e8eb811
spec:
  databases:
    airbyte: airbyte
  numberOfInstances: 2
  postgresql:
    parameters:
      max_connections: "101"
    version: "13"
  resources:
    limits:
      cpu: "2"
      memory: 1Gi
    requests:
      cpu: 50m
      memory: 100Mi
  teamId: plural
  users:
    airbyte:
    - superuser
    - createdb
  volume:
    size: 27Gi
```
* delete your existing cluster (you can also create a hot standby if you want using the subsequent station just in case)
    * `kubectl delete postgresql <name> -n <namespace>` is the command here
* add a `clone` block within the spec field of your postgres db, that will look something like.  You'll also want to strip out extraneous fields from the metadata, `creationTimestamp`, `generation`, `resourceVersion`, `uid`.  K8s will probably understand this but still good practice.

```yaml
apiVersion: acid.zalan.do/v1
kind: postgresql
metadata:
  annotations:
    meta.helm.sh/release-name: airbyte
    meta.helm.sh/release-namespace: airbyte
  creationTimestamp: "2022-10-31T23:53:27Z"
  generation: 6
  labels:
    app.kubernetes.io/instance: airbyte
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: postgres
    app.kubernetes.io/version: 1.16.0
    helm.sh/chart: postgres-0.1.16
  name: plural-airbyte
  namespace: airbyte
  resourceVersion: "966219670"
  uid: 40c1d314-f667-421e-a059-f4521e8eb811
spec:
  clone:
    cluster: plural-airbyte # notice this is the same as `metadata.name`
    s3_access_key_id: AWS_ACCESS_KEY_ID
    s3_secret_access_key: AWS_SECRET_ACCESS_KEY
    timestamp: "2022-10-31T19:00:00+04:00"
    uid: SOME-UUID
  databases:
    airbyte: airbyte
  numberOfInstances: 2
  postgresql:
    parameters:
      max_connections: "101"
    version: "13"
  resources:
    limits:
      cpu: "2"
      memory: 1Gi
    requests:
      cpu: 50m
      memory: 100Mi
  teamId: plural
  users:
    airbyte:
    - superuser
    - createdb
  volume:
    size: 27Gi
```
* `kubectl apply -f db.yaml` - reapply the database to k8s using the file you were working on

Postgres will perform the backup w/in the postgres pod itself, so if you want to track its status, you can look at the pods with:

```sh
kubectl logs DB-NAME-0 -n NAMESPACE # inject whatever the name of the postgres db you created and the namespace it was applied to
```

### Clone from another cluster

This is really useful for creating hot standbys or recreating a cluster entirely if you say want to change the underlying storage class of the db.  The preparation is similar to above:

* dump the db to a file with `kubectl get postgresql <name> -n <namespace> -o yaml > db.yaml`
* edit the file and add a clone block like:

```yaml
apiVersion: acid.zalan.do/v1
kind: postgresql
metadata:
  annotations:
    meta.helm.sh/release-name: airbyte
    meta.helm.sh/release-namespace: airbyte
  creationTimestamp: "2022-10-31T23:53:27Z"
  generation: 6
  labels:
    app.kubernetes.io/instance: airbyte
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: postgres
    app.kubernetes.io/version: 1.16.0
    helm.sh/chart: postgres-0.1.16
  name: plural-airbyte
  namespace: airbyte
  resourceVersion: "966219670"
  uid: 40c1d314-f667-421e-a059-f4521e8eb811
spec:
  clone:
    cluster: plural-airbyte-old # notice no timestamp or uid triggers a pg_basebackup from a running cluster
  databases:
    airbyte: airbyte
  numberOfInstances: 2
  postgresql:
    parameters:
      max_connections: "101"
    version: "13"
  resources:
    limits:
      cpu: "2"
      memory: 1Gi
    requests:
      cpu: 50m
      memory: 100Mi
  teamId: plural
  users:
    airbyte:
    - superuser
    - createdb
  volume:
    size: 27Gi
```
* `kubectl apply -f db.yaml`
* same as above, you can track the clone via `kubectl logs ...`

