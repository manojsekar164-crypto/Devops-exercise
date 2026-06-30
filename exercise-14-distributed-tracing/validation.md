# Validation Steps for Exercise 14: Distributed Tracing Investigation

Verify trace spans and identify bottleneck sources using Grafana Tempo.

## 1. Import Trace details in Grafana Tempo

1. Open the Grafana UI.
2. Navigate to **Explore** and select the **Tempo** datasource.
3. Select **TraceID** query type.
4. Input the sample Trace ID: `4c9472f10b27b3eb9687e145b23d941e`.
5. Run the query and analyze the timeline graph.

## 2. Identify the Bottleneck

- Observe the parent span `process-payment` (duration: 4.25s).
- Verify the child span `HTTP POST /v1/charge` (duration: 4.12s) which targets the external payment gateway.
- Confirm this external call is the primary bottleneck causing the checkout latency.

## 3. Verify Timeout and Resilience Settings

Verify if the application deployment configuration enforces external timeouts.
Ensure the deployment's config includes parameters like:
```bash
kubectl describe deploy/payment-service
```
Look for environment variables:
`EXTERNAL_GATEWAY_TIMEOUT=2000` (e.g. 2 seconds instead of no timeout).
