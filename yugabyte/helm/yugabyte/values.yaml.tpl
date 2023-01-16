yugabyte:
  autoMultiAz:
    cloud: {{ .Provider }}
  authCredentials:
    ysql:
      user: yugabyte
      password: {{ dedupe . "yugabyte.yugabyte.authCredentials.ysql.password" (randAlphaNum 32) }}
    ycql:
      user: cassandra
      password: {{ dedupe . "yugabyte.yugabyte.authCredentials.ycql.password" (randAlphaNum 32) }}
