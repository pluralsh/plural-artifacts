
{{ $dbPwd := dedupe . "ghost.db.password" (randAlphaNum 26) }}
ghost:
  ghost:
    ingress:
      hostname: {{ .Values.ghostDomain }}
    ghostHost: {{ .Values.ghostDomain }}
    ghostUsername: {{ .Values.ghostUser }}
    ghostEmail: {{ .Values.ghostUserEmail }}
    ghostPassword: {{ dedupe . "ghost.ghost.ghostPassword" (randAlphaNum 26) }}
    externalDatabase:
      host: ghost
      user: ghost
      password: {{ $dbPwd }}
      database: ghost
  db:
    password: {{ $dbPwd }}
    rootPassword: {{ dedupe . "ghost.db.rootPassword" (randAlphaNum 26) }}
    