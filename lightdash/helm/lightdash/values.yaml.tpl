global:
  application:
    links:
    - description: lightdash web ui
      url: {{ .Values.hostname }}


#lightdash:
#  externalDatabase:
#    host: plural-lightdash
#    user: lightdash
#    password: lightdash
#    existingSecret: "lightdash.plural-lightdash.credentials.postgresql.acid.zalan.do"
#    existingSecretPasswordKey: "password"
#    database: lightdash
#    port: 5432
#  configMap:
#    # Example connection details for Lightdash postgres database - Change me!
#    PGHOST: lightdashdb-postgresql.default.svc.cluster.local
#    PGPORT: 5432
#    PGUSER: lightdash
#    PGDATABASE: lightdash

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