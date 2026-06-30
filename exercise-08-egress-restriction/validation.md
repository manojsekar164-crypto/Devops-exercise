# Validation Steps for Exercise 08: Egress Restriction Incident

Verify that application egress connectivity to AWS DynamoDB is functional.

## 1. Apply Network Policy

Apply the corrected NetworkPolicy:
```bash
kubectl apply -f networkpolicy-fixed.yaml
```

Verify that the network policy is registered in the namespace:
```bash
kubectl get networkpolicy payment-service-egress-policy -o yaml
```

## 2. Deploy DynamoDB VPC Endpoint (Terraform)

Deploy the gateway endpoint to bypass NAT Gateway routing:
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Verify the endpoint status in AWS:
```bash
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=vpc-12345678" "Name=service-name,Values=com.amazonaws.ap-south-1.dynamodb" \
  --query "VpcEndpoints[0].State" --output text
```
Expected output: `available`.

## 3. Test Connection from Container

Start a troubleshooting container and check HTTPS egress to the DynamoDB endpoint:
```bash
kubectl run troubleshoot-dns-egress --rm -i --tty --image=curlimages/curl -- \
  curl -I https://dynamodb.ap-south-1.amazonaws.com
```

Expected output:
```
HTTP/1.1 400 Bad Request
...
```
*Note: A 400 Bad Request is the expected response from AWS DynamoDB since we are sending an empty GET request without headers/authentication. It confirms TCP handshake and SSL negotiation succeeded.*

Check CoreDNS resolution to verify local DNS query egress works:
```bash
kubectl run troubleshoot-dns-query --rm -i --tty --image=busybox -- nslookup dynamodb.ap-south-1.amazonaws.com
```
Ensure it returns the corresponding IP address lookup.
