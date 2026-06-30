# Exercise 09: Prometheus Monitoring Failure

Troubleshooting metrics targets DOWN status due to port name mismatch between Service and ServiceMonitor.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: ServiceMonitor endpoint is configured to scrape port 'metrics' but the Service targets port named 'prometheus'.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
