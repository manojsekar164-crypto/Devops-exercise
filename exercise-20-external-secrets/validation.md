# Validation Steps for Exercise 20: External Secrets Integration

Follow these validation steps to verify the sync and setup of the External Secrets Operator with AWS Secrets Manager.

## 1. Setup AWS Secret (Prerequisite)

Verify that the secret exists in AWS Secrets Manager and contains the appropriate JSON keys:
```bash
aws secretsmanager get-secret-value --secret-id prod/payment/secrets --region us-east-1
```
Output should contain:
```json
{
  "SecretString": "{\"DB_USERNAME\":\"dbadmin\",\"DB_PASSWORD\":\"highlysecurepassword123\",\"JWT_SECRET\":\"supersecretjwttokenkey\"}"
}
```

## 2. Check Custom Resource Definitions (CRDs)

Verify that External Secrets CRDs are installed in the cluster:
```bash
kubectl get crd | grep external-secrets
```

## 3. Verify Kubernetes Service Account and SecretStore

Verify the `ServiceAccount` and its IAM Role annotation:
```bash
kubectl describe sa external-secrets-sa
```

Verify that the `SecretStore` is successfully configured:
```bash
kubectl get secretstore aws-secretsmanager
```
Verify its detailed status and verify the connection is `Valid`:
```bash
kubectl describe secretstore aws-secretsmanager
```

## 4. Check ExternalSecret Status

Query the `ExternalSecret` resource status:
```bash
kubectl get externalsecret payment-db-externalsecret
```
Expected output:
```
NAME                         STORE                REFRESH INTERVAL   STATUS         READY
payment-db-externalsecret    aws-secretsmanager   1h                 SecretSynced   True
```

Inspect details if it fails to sync:
```bash
kubectl describe externalsecret payment-db-externalsecret
```

## 5. Verify Synced Kubernetes Secret

Check if the target Kubernetes Secret has been successfully created:
```bash
kubectl get secret payment-db-secret
```

Check the keys present inside the secret (without revealing base64 values):
```bash
kubectl get secret payment-db-secret -o jsonpath='{.data}'
```
Expected output keys: `DB_USERNAME`, `DB_PASSWORD`, `JWT_SECRET`.

Decode and verify values locally:
```bash
kubectl get secret payment-db-secret -o jsonpath='{.data.DB_USERNAME}' | base64 --decode
```

## 6. Verify Deployment Integration

Check the application pods deployment status:
```bash
kubectl rollout status deployment/payment-service
```

Inspect environmental variables inside the container to verify they match the secret:
```bash
kubectl exec -it deploy/payment-service -- env | grep -E "DB_|JWT_"
```
