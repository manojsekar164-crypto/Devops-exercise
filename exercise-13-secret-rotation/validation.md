# Validation: Exercise 13

## 1. Apply Manifests
```bash
kubectl apply -f externalsecret-rotated.yaml
kubectl apply -f reloader-annotations.yaml
```

## 2. Simulate AWS Rotation
```bash
aws secretsmanager rotate-secret --secret-id prod/payment/secrets --region us-east-1
```

## 3. Verify Sync & Restart
1. Check ESO logs for successful sync:
`kubectl describe externalsecret payment-db-externalsecret`
2. Verify Stakater Reloader triggered a rolling restart:
`kubectl get pods -w`
3. Check env variables:
`kubectl exec -it deploy/payment-service -- env | grep DB_PASSWORD`
