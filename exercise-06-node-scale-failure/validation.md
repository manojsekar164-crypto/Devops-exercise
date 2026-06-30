# Validation Steps for Exercise 06: EKS Node Scale Failure

Verify that the Cluster Autoscaler is functional and registers ASG changes.

## 1. Apply AWS ASG Tags

Using the AWS CLI, tag the EKS node group Auto Scaling Group:
```bash
# Obtain ASG Name
ASG_NAME=$(aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[?contains(Tags[?Key=='eks:cluster-name'].Value, 'my-eks-cluster')].AutoScalingGroupName" --output text)

# Apply Tags
aws autoscaling create-or-update-tags --tags \
  "ResourceId=${ASG_NAME},ResourceType=auto-scaling-group,Key=k8s.io/cluster-autoscaler/enabled,Value=true,PropagateAtLaunch=true" \
  "ResourceId=${ASG_NAME},ResourceType=auto-scaling-group,Key=k8s.io/cluster-autoscaler/my-eks-cluster,Value=owned,PropagateAtLaunch=true"
```

## 2. Verify IAM Roles and Permissions

Ensure the IAM policy is attached to the Cluster Autoscaler IAM Role:
```bash
aws iam put-role-policy \
  --role-name eks-cluster-autoscaler-role \
  --policy-name ClusterAutoscalerASGPolicy \
  --policy-document file://cluster-autoscaler-iam-policy.json
```

## 3. Restart Cluster Autoscaler

Restart the autoscaler deployment to refresh its configuration cache:
```bash
kubectl rollout restart deployment/cluster-autoscaler -n kube-system
kubectl rollout status deployment/cluster-autoscaler -n kube-system
```

## 4. Validate Cluster Autoscaler Status

1. Check logs:
```bash
kubectl logs -n kube-system -l app=cluster-autoscaler --tail=100
```
Verify logs no longer output `No node group config found` or `Failed to autodiscover ASG`.
Instead, logs should show successful polling:
```
I0510 12:15:30.123456       1 static_autoscaler.go:210] Starting main loop
I0510 12:15:30.123890       1 static_autoscaler.go:340] Filtered out 0 empty node groups
```

2. Inspect the Cluster Autoscaler configmap:
```bash
kubectl get configmap cluster-autoscaler-status -n kube-system -o yaml
```
Ensure the target ASGs are recognized as active and healthy.

## 5. Verify Pending Pods Resolution

Check if EKS scales up the node group capacity to satisfy pending pods resource requests:
```bash
kubectl get nodes
kubectl get pods
```
All pending pods should transition to `Running` as the autoscaler provisions new nodes.
