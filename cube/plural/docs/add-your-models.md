# Add Your Cube Models

To overwrite default schema, create a new folder `schemas` inside `cube/helm/cube` folder.

Then you can add your `yaml` or `js` files.

Example of a yaml model file looks like (More info [here](https://cube.dev/docs/schema/getting-started))
```yaml
cubes:
  - name: my_table
    sql_table: my_table
    data_source: default
    dimensions:
      - name: id
        sql: id
        type: string
        primary_key: true
      - name: product_id
        sql: product_id
        type: string
    measures:
      - name: count
        type: count
```

You can add as many model as you want inside `schemas` folder.

Then, you'll to create a `configmap.yaml` inside `cube/helm/cube/templates` with the following value:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cube-model
data:
{{ (.Files.Glob "schemas/**.yaml").AsConfig | indent 2 }} # Note the **.yaml, adjust it if you want to use js models
```

Finally, you need to edit `cube/helm/cube/values.yaml`
```yaml
cube:
  cube:
    config:
      volumes:
      - name: cube-model
        configMap:
          name: cube-model
      volumeMounts:
      - name: cube-model
        readOnly: true
        mountPath: /cube/conf/schema/example.yaml
        subPath: example.yaml
      <...>
```

Once that reconfiguration has been made, simply run: `plural build --only cube && plural deploy --commit "feat(cube): add cube models"` to apply the changes on your cluster.