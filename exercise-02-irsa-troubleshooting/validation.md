# Validation Steps for Exercise 02: IAM / IRSA Failure

Verify the fix for IAM Role for Service Accounts (IRSA) mapping.

## 1. Apply Manifests

Apply the fixed ServiceAccount and Pod configs:
```bash
kubectl apply -f serviceaccount-fixed.yaml
kubectl apply -f pod-fixed.yaml
```

## 2. Check ServiceAccount Annotation

Ensure the service account is correctly configured:
```bash
kubectl describe sa dynamo-reader-sa
```
Look for the annotation:
`eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/eks-dynamodb-reader-role`

## 3. Verify Pod Mutating Webhook Injections

EKS injects specific environment variables and volumes automatically when a pod is scheduled with a service account linked to an AWS role. Verify that they are present:
```bash
kubectl get pod dynamo-client-pod -o yaml
```
Ensure the following are present in the output spec:
1. **Environment Variables**:
   - `AWS_ROLE_ARN=arn:aws:iam::123456789012:role/eks-dynamodb-reader-role`
   - `AWS_WEB_IDENTITY_TOKEN_FILE=/var/run/secrets/eks.amazonaws.com/serviceaccount/token`
2. **Volume Mounts**:
   - A volume named `aws-token` mounted at `/var/run/secrets/eks.amazonaws.com/serviceaccount`.

## 4. Test DynamoDB Connection

Access the running container and attempt a read operation or check application logs:
```bash
kubectl logs dynamo-client-pod
```
Verify that no `AccessDeniedException` is logged and the pod successfully communicates with DynamoDB.
