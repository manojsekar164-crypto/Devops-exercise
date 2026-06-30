# Validation Steps for Exercise 07: ALB Ingress Failure

Verify subnet tagging and resolve AWS Load Balancer Controller subnet discovery errors.

## 1. Apply Tags to Subnets

Ensure public subnets (where the internet-facing load balancer resides) are tagged with `kubernetes.io/role/elb=1`:
```bash
aws ec2 create-tags \
  --resources subnet-011122223333aaa11 subnet-022233334444bbb22 \
  --tags Key=kubernetes.io/role/elb,Value=1 Key=kubernetes.io/cluster/my-eks-cluster,Value=shared
```

Ensure private subnets (where the pods reside and routing occurs) are tagged with `kubernetes.io/role/internal-elb=1`:
```bash
aws ec2 create-tags \
  --resources subnet-033344445555ccc33 subnet-044455556666ddd44 \
  --tags Key=kubernetes.io/role/internal-elb,Value=1 Key=kubernetes.io/cluster/my-eks-cluster,Value=shared
```

## 2. Restart AWS Load Balancer Controller

Re-trigger a controller reconciliation loop:
```bash
kubectl rollout restart deployment/aws-load-balancer-controller -n kube-system
kubectl rollout status deployment/aws-load-balancer-controller -n kube-system
```

## 3. Monitor Controller logs

Verify that subnet discovery runs successfully without throwing warnings:
```bash
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller --tail=50
```
Expected logs:
```
I0510 13:15:20.123456       1 ingress_controller.go:120] successfully discovered subnets for ALB
I0510 13:15:20.654321       1 targetgroup_binding.go:230] successfully bound target group targets
```

## 4. Verify Target Health

Check the target group binding status in the cluster:
```bash
kubectl get targetgroupbindings
```

Query AWS Target Group status via AWS CLI to verify pod IPs are registered and status is `healthy`:
```bash
TG_ARN=$(aws elbv2 describe-target-groups --query "TargetGroups[?contains(TargetGroupName,'payment')].TargetGroupArn" --output text)
aws elbv2 describe-target-health --target-group-arn $TG_ARN
```
Expected output should list pod IPs as `healthy`.
