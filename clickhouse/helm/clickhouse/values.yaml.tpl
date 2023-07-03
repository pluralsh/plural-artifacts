altinity-clickhouse-operator:
  secret:
    create: true
    user: {{ dedupe . "clickhouse.altinity-clickhouse-operator.secret.user" (randAlphaNum 32) }}
    password: {{ dedupe . "clickhouse.altinity-clickhouse-operator.secret.password" (randAlphaNum 32) }}