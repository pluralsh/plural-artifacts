# Gitlab

Deploys an off the shelf hosted version of gitlab EE.  This chart is based on gitlab's own chart, details are available here: https://gitlab.com/gitlab-org/charts/gitlab

In addition, we'll deploy plural specific features like dashboards, proxies, etc.  We'll also configure backend storage using the cloud specific object store and ensure you're using the best available database solution we have on the platform.

## Configuration

For configuration of the gitlab chart itself, see https://docs.gitlab.com/charts/charts