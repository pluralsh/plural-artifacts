Use `plural watch imgproxy` to track the status of your application.
When it's fully provisioned, you can use it using https://{{ .Values.hostname }}

Sign your url using:
Key: {{ .imgproxy.imgproxy.features.urlSignature.key }}
Salt: {{ .imgproxy.imgproxy.features.urlSignature.salt }}
