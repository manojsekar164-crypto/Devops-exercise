# Validation Steps for Exercise 05: Helm Upgrade Failure

Verify how to recover from a blocked Helm upgrade due to immutable selector fields.

## 1. Verify Deployment Conflict

Run the Helm upgrade command and inspect the error:
```bash
helm upgrade payment-service ./charts/payment-service
```
Verify the error: `spec.selector: Invalid value: field is immutable`.

## 2. Recovery - Option A: Delete and Reapply (With Downtime)

If the selector change is mandatory (e.g., migrating metadata standards), delete the deployment:
```bash
kubectl delete deployment payment-service
```
Re-apply/upgrade the chart:
```bash
helm upgrade --install payment-service ./charts/payment-service
```

## 3. Recovery - Option B: Fix Selector and Apply (Zero Downtime)

If zero downtime is required, change the chart template `spec.selector.matchLabels` back to its original value (`app: payment`) and only update image/labels under the `template.metadata.labels` section.

Check the diff to confirm no selector changes exist:
```bash
helm diff upgrade payment-service ./charts/payment-service
```

Upgrade the application:
```bash
helm upgrade payment-service ./charts/payment-service
```

Ensure the deployment upgrade triggers a rolling update and executes successfully:
```bash
kubectl rollout status deployment/payment-service
```
Verify the pods labels and images:
```bash
kubectl get pods -l app=payment -o wide
```
