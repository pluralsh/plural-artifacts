# Using a Custom Launch Template in Plural AWS Provider

For Plural AWS clusters, it's sometimes useful to define your own node launch template.  Some common usecases are:

* toggling the setup of security settings like whether to require Instance Metadata Service v2
* using an in-house "golden" AMI
* enabling enhanced monitoring

To do this, you'll need to make a modest terraform change, in `bootstrap/terraform/main.tf` under `aws-bootstrap` add:

```
generate_launch_template = true
```

to the manual section.  Additionally you can check the submodule's launch template variables for some other toggles you might find useful.