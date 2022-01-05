
{{ $dbPwd := dedupe . "ghost.db.password" (randAlphaNum 26) }}

global:
  application:
    links:
    - description: ghost web address
      url: {{ .Values.ghostDomain }}

ghost:
  domain: {{ .Values.ghostDomain }}
  env:
    url: https://{{ .Values.ghostDomain }}/
    database__connection__password: {{ $dbPwd }}
    mail__from: {{ .Values.ghostEmail }}
db:
  password: {{ $dbPwd }}
  rootPassword: {{ dedupe . "ghost.db.rootPassword" (randAlphaNum 26) }}
