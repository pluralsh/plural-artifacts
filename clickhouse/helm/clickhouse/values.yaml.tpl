altinity-clickhouse-operator:
  secret:
    password: {{ dedupe . "clickhouse.altinity-clickhouse-operator.secret.password" (randAlphaNum 32) }}
