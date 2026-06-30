# Validation Steps for Exercise 22: Horizontal and Cluster Autoscaling

Follow these steps to verify both Horizontal Pod Autoscaler (HPA) and Cluster Autoscaler (CA) behavior.

## 1. Apply Manifests

Deploy resources in the cluster:
```bash
kubectl apply -f deployment.yaml
kubectl apply -f hpa.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml
```

## 2. Verify HPA Status

Check the status of the HPA:
```bash
kubectl get hpa payment-service-hpa
```
Expected output should show target details and targets of CPU/Memory:
```
NAME                  REFERENCE                    TARGETS          MINPODS   MAXPODS   REPLICAS   AGE
payment-service-hpa   Deployment/payment-service   0%/80%, 1%/85%   2         20        2          5m
```

## 3. Verify Cluster Autoscaler Logs

Verify Cluster Autoscaler is running:
```bash
kubectl get deployment -n kube-system cluster-autoscaler
```

Inspect its logs:
```bash
kubectl logs -n kube-system -l app=cluster-autoscaler --tail=50
```

## 4. Run Load Test

Run the load testing script to generate traffic:
```bash
chmod +x load-test.sh
./load-test.sh
```

## 5. Observe Scaling Events

In separate terminal sessions, watch the scaling progress:

### A. Watch Pod replica count scaling (HPA)
```bash
kubectl get hpa payment-service-hpa -w
```
As CPU load increases beyond 80%, HPA will scale up the replicas:
```
NAME                  REFERENCE                    TARGETS            MINPODS   MAXPODS   REPLICAS   AGE
payment-service-hpa   Deployment/payment-service   125%/80%, 3%/85%   2         20        8          10m
```

Watch pods transitions:
```bash
kubectl get pods -w
```

### B. Watch Node count scaling (Cluster Autoscaler)
Once pods exceed capacity and transition to `Pending`, verify if the Cluster Autoscaler requests new nodes:
```bash
kubectl get nodes -w
```
Inspect events for unschedulable pods:
```bash
kubectl describe pod <pending-pod-name>
```
Output should contain events like:
```
Events:
  Type     Reason            Age   From                Message
  ----     ------            ----  ----                -------
  Normal   TriggeredScaleUp  45s   cluster-autoscaler  pod triggered scale-up: [{eks-managed-node-group-1 3->6}]
```
Verify the nodes scaled up from 3 to 6:
```bash
kubectl get nodes
```
