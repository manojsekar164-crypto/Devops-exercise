# Exercise 14: Distributed Tracing Investigation

Investigating checkout latency bottlenecks using Grafana Tempo traces.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Spans in Tempo show that the external payment gateway call in payment-service is taking 4.2 seconds out of 4.8 seconds total.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
