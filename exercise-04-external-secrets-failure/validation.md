# Validation Steps for Exercise 04: External Secrets Failure

Verify that ExternalSecret resolves authorization issues and successfully syncs.

## 1. Apply AWS IAM Configuration

1. Update the IAM Role trust policy using `iam-trust-policy.json`.
2. Apply the IAM policy `iam-policy.json` to the IAM Role `eks-external-secrets-role` via AWS Console or CLI:
```bash
aws iam put-role-policy \
  --role-name eks-external-secrets-role \
  --policy-name SecretsManagerAccessPolicy \
  --policy-document file://iam-policy.json
```

## 2. Apply Fixed Manifest

Apply the corrected ExternalSecret:
```bash
kubectl apply -f externalsecret-fixed.yaml
```

## 3. Trigger Manual Sync

If sync does not occur immediately, force a trigger sync:
```bash
kubectl annotate externalsecret database-credentials force-sync="$(date +%s)" --overwrite
```

## 4. Verify Secret Synced Status

Check if status transitions to `SecretSynced` and `READY=True`:
```bash
kubectl get externalsecret database-credentials
```
Expected output:
```
NAME                   STORE                REFRESH INTERVAL   STATUS         READY
database-credentials   aws-secretsmanager   1h                 SecretSynced   True
```

Inspect details if it still fails:
```bash
kubectl describe externalsecret database-credentials
```

## 5. Verify Injected Kubernetes Secret

Verify that the secret was successfully created in Kubernetes:
```bash
kubectl get secret payment-db-secret -o yaml
```
Ensure the `DB_PASSWORD` key is present.
