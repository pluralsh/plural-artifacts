metrics:
  password: {{ dedupe . "mongodb-community.metrics.password" (randAlphaNum 14) }}

secrets:
  password: {{ dedupe . "mongodb-community.secrets.password" (randAlphaNum 14) }}