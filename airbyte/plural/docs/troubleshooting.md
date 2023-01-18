# Troubleshooting Guide

This is a running doc of things that could potentially surface in your airbyte instance that can be easily addressed.  You'll find most of these errors in the logs for airbyte but they can surface elsewhere as well

### Failure executing: POST at: https://172.20.0.1/api/v1/namespaces/airbyte/pods. Message: Unauthorized! Configured service account doesn't have access. Service account may have been revoked. Unauthorized.

It's unclear exactly what causes this, but it's likely a bug in airbyte's kubernetes client implementation.  There's a spot-fix for this, simply delete the airbyte-worker pods in your instance and allow k8s to respawn them.  That will regenerate the service account token and allow airbyte to continue as normal.