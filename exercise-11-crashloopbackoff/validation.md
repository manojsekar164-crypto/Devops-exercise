# Validation Steps for Exercise 11: CrashLoopBackOff Investigation

Verify that the initContainer handles database startup delay and resolves CrashLoopBackOff.

## 1. Apply Fixed Manifest

Apply the updated deployment:
```bash
kubectl apply -f deployment-fixed.yaml
```

## 2. Monitor Pod Status (During DB Startup Delay)

While the database is still offline or starting up:
```bash
kubectl get pods -w
```
Expected output showing the pod in `Init:0/1` state instead of crashing:
```
NAME                               READY   STATUS     RESTARTS   AGE
payment-service-5c5fbc5f67-abcde   0/1     Init:0/1   0          10s
```

Check the initContainer logs to verify it is polling the database:
```bash
kubectl logs deploy/payment-service -c wait-for-database
```
Output should repeat:
```
Waiting for database at 10.20.0.15:5432...
Waiting for database at 10.20.0.15:5432...
```

## 3. Start Database (Simulate Recovery)

Bring up the database service or fix connection routing. Once the port `5432` opens on `10.20.0.15`:
1. The initContainer will successfully complete (`exit 0`).
2. The main `payment-service` container will start.
3. The pod status should transition to `Running` and eventually `Ready`.

```bash
kubectl get pods
```
Expected output:
```
NAME                               READY   STATUS    RESTARTS   AGE
payment-service-5c5fbc5f67-abcde   1/1     Running   0          2m
```
Ensure the restarts counter remains `0`.
