Use `plural watch oncall` to track the status of your application

Connect Grafana OnCall Plugin to Grafana OnCall backend:

     Issue the one-time token to connect Grafana OnCall backend and Grafana OnCall plugin by running these commands:

        export POD_NAME=$(kubectl get pods --namespace oncall -l "app.kubernetes.io/name=oncall,app.kubernetes.io/instance=oncall,app.kubernetes.io/component=engine" -o jsonpath="{.items[0].metadata.name}")
        kubectl exec -it $POD_NAME --namespace oncall -- bash -c "python manage.py issue_invite_for_the_frontend --override"

     Fill the Grafana OnCall Backend URL:

        https://{{ .Values.hostname }}

     Fill the Grafana URL:

       https://{{ .Configuration.grafana.hostname }}
