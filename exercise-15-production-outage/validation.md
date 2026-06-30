# Validation Steps for Exercise 15: Complete Production Outage

Verify the resolution of the Redis authentication failure and ensure services are back online.

## 1. Force Secret Re-sync

Fetch the latest rotated Redis secret from AWS Secrets Manager immediately:
```bash
kubectl annotate externalsecret redis-externalsecret force-sync="$(date +%s)" --overwrite
```

Verify that the secret synced state is `Ready=True`:
```bash
kubectl get externalsecret redis-externalsecret
```

## 2. Restart Application Pods

Restart the pods to inject the updated secret into container environment variables:
```bash
kubectl rollout restart deployment/payment-service
kubectl rollout status deployment/payment-service
```

## 3. Verify Redis Connection

1. Inspect the application logs to ensure successful connection to Redis:
```bash
kubectl logs deploy/payment-service --tail=50 | grep -i "redis"
```
Look for:
`Successfully connected to Redis at redis-master.default.svc.cluster.local:6379`.

2. Inspect Redis logs to verify client authentication is successful:
```bash
kubectl logs statefulset/redis-master --tail=50 | grep -i "auth"
```
Ensure no further `Authentication failed` logs occur.

## 4. Test API Health Endpoint

Run an HTTP request test against the service ingress domain:
```bash
curl -I https://payment.example.com/healthz
```
Expected output:
```
HTTP/1.1 200 OK
Content-Type: application/json
...
```
Ensure the HTTP 503 response is fully resolved.
