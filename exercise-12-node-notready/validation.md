# Validation Steps for Exercise 12: Node NotReady Production Incident

Verify that the node has recovered from DiskPressure and that log rotation policies are active.

## 1. Verify Node Recovery Status

After cleaning up logs and restarting kubelet on the affected host, check the node's conditions:
```bash
kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,REASON:.status.conditions[-1].reason
```
Ensure `DiskPressure` evaluates to `False`.

Check node ready status:
```bash
kubectl get node <node-name>
```
Expected output:
```
NAME                                STATUS   ROLES    AGE   VERSION
ip-10-20-1-150.ap-south-1.compute   Ready    <none>   35d   v1.28.2
```

## 2. Verify Kubelet Log Config

To verify if the kubelet configuration applies correctly, describe the EKS node kubelet endpoint config:
```bash
kubectl get --raw "/api/v1/nodes/<node-name>/proxy/configz" | jq .kubeletconfig.containerLogMaxSize
```
Expected output: `"10Mi"`.

## 3. Verify Logrotate Configuration

1. Place `logrotate-containers.conf` inside the node's `/etc/logrotate.d/` directory:
```bash
sudo cp logrotate-containers.conf /etc/logrotate.d/containers
```
2. Trigger a dry-run to test if the rules are syntactically valid:
```bash
sudo logrotate -d /etc/logrotate.d/containers
```
Ensure no compilation errors are printed.

3. Manually trigger logrotate to check output:
```bash
sudo logrotate -f /etc/logrotate.d/containers
```
Check if logs have been compressed and rotated:
```bash
ls -lh /var/log/pods/*/*
```
Ensure files ending in `.log.1` or `.log.2.gz` have been created.
