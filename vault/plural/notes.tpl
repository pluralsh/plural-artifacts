{{- $namespace := namespace "vault" }}
{{- $recoveryKeys := secret $namespace "vault-recovery-keys" }}
Use `plural watch vault` to track the status of your application

Please securely save the following vault keys,
then delete the secret "vault-recovery-keys" in the "{{ $namespace }}" namespace.

{{ $recoveryKeys.vault_recovery_keys }}
