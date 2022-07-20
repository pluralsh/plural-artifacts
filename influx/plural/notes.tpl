You can view your chronograf instance at https://{{ .Values.chronografHostname }}

{{ if .OIDC }}
You've enabled Plural OIDC for your chronograf instance.  

Be sure to add more teammates in the plural UI.  The admin user will also
need to enable that user after their initial authentication - or you can enable
the all users as superuser setting to do so.
{{ end }}

Your initial admin credentials are:

username: admin
password: {{ .influx.influxdb.setDefaultUser.user.password }}

To help you set up the chronograf wizard, you can use these hostnames (and the standard ports) for the various influxdata components:

influxdb: http://influxdb
kapacitor: http:/influx-kapacitor
telegraf: http://influx-telegraf