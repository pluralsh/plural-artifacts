global:
  application:
    links:
    - description: lightdash web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: lightdash-tls
     hosts:
       - {{ .Values.hostname }}

lightdash:
  configMap:
    PGSSLMODE: "no-verify"
    # Example connection details for Lightdash postgres database - Change me!
    PGHOST: "plural-postgres-lightdash"
    PGPORT: "5432"
    PGUSER: lightdash
    PGDATABASE: "lightdash"
    SITE_URL: {{ .Values.hostname }}