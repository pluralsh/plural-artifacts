postgresqlPassword: {{ dedupe . "vaultwarden.postgresqlPassword" (randAlphaNum 30) }}

{{ $postgresqlPassword := dedupe . "vaultwarden.postgresqlPassword" (randAlphaNum 30) }}

vaultwarden:
  env:
    ADMIN_TOKEN: {{ dedupe . "vaultwarden.vaultwarden.env.ADMIN_TOKEN" (randAlphaNum 30) }}
    DATABASE_URL: postgresql://vaultwarden:{{ $postgresqlPassword }}@plural-vaultwarden[:5432]/vaultwarden
