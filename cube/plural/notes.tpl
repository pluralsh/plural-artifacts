Use `plural watch cube` to track the status of your application

Your api endpoint is: https://{{ .Values.hostname }}
Your api secret (used to sign jwt) is: {{ .cube.cube.config.apiSecret }}
More info on authentication and authorization -> https://cube.dev/docs/security

Note that you'll need to define properly your datasources.
Check out the docs on the plural console for that.
