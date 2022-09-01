<!--- Hello Plural contributor! It's great to have you with us! -->

## Summary
<!-- Describe your changes here, include the motivation/context, test coverage, -->
<!-- the type of change i.e. breaking change, new feature, or bug fix -->
<!-- and related GitHub issue or screenshots (if applicable). -->


## Test Plan
<!--- Please describe the tests you have added and your testing environment (if applicable). -->


## Checklist
<!--- Go over all the following points, and put an `x` in all the boxes that apply. -->
<!--- If you're unsure about any of these, don't hesitate to ask in our Discord. -->

- [ ]  No images hosted from dockerhub
- [ ]  Are dashboards present to understand the health of the application.  There **must** be at least 1 of these
    - [ ]  all databases should have dashboards
    - [ ]  ideally also have at least cpu/mem utilization dashboards for webserver tier of the app
    - [ ]  you can use `plural from-grafana` to convert a grafana dashboard found via google to our CRD
- [ ]  Are scaling runbooks present
    - [ ]  all databases **must** have scaling runbooks
    - [ ]  you can use the charts in `pluralsh/module-library` to accelerate this
- [ ]  do you need to add config overlays?
    - [ ]  inputing secrets
    - [ ]  configuring autoscaling
- [ ]  If there’s a web-facing component to the app, we need to support OIDC authentication and setting up private networks if no authentication option is viable
- [ ]  All major clouds must be supported
    - [ ]  Azure
    - [ ]  AWS
    - [ ]  GCP