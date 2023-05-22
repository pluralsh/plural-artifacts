{{ $hostname := .Values.hostname }}

You can view your installation at https://{{ $hostname}}

NOTES:
When installing Yatai for the first time, run the following command to get an initialization link for creating your admin account:

  export YATAI_INITIALIZATION_TOKEN=$(kubectl get secret yatai-env --namespace {{ namespace "yatai" }} -o jsonpath="{.data.YATAI_INITIALIZATION_TOKEN}" | base64 --decode)

  echo "Create admin account at: https://{{ $hostname }}/setup?token=$YATAI_INITIALIZATION_TOKEN"
