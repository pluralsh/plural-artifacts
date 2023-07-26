## Enable Bucket Versioning

In case you want to enable s3 object versioning, this is supported via a small terraform configuration.  Go to `mlflow/terraform/main.tf` and within the manual section of the `aws` module, add:

```tf
module "aws" {
  ## BEGIN MANUAL SECTION <- be sure to put it w/in these
  enable_versioning = true
  ## END MANUAL SECTION
}
```

Then run a quick `plural deploy --commit "enable mlflow s3 versioning"` and you'll be set.