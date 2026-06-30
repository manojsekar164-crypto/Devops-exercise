# Validation Steps for Exercise 03: ArgoCD OutOfSync Production Incident

Verify that ArgoCD sync status remains `Synced` and does not conflict with autoscaling.

## 1. Apply Manifests

Apply the updated ArgoCD Application configuration:
```bash
kubectl apply -f argocd-application.yaml
```

## 2. Simulate Drift

Simulate HPA or manual scaling on EKS by scaling the live deployment to `5` replicas:
```bash
kubectl scale deployment/payment-service --replicas=5
```

## 3. Verify ArgoCD Synchronization Status

Check the status of the ArgoCD application via CLI:
```bash
argocd app get payment-service-app
```
Expected output:
```
Name:               argocd/payment-service-app
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://argocd.example.com/applications/payment-service-app
Repo:               https://github.com/tharaneshtharanesh431-design/DevOps_26_Exercises.git
Target:             HEAD
Path:               exercise-20-external-secrets
SyncWindow:         Sync Allowed
Sync Policy:        Automated (Prune, SelfHeal)
Sync Status:        Synced to HEAD (e7f3a8b)  <-- MUST BE SYNCED EVEN WITH 5 REPLICAS
Health Status:      Healthy
```

Verify that ArgoCD does not trigger a roll-down to `3` pods, confirming the `ignoreDifferences` config works as intended.
```bash
kubectl get deployment payment-service
```
Active replicas should remain `5`.
