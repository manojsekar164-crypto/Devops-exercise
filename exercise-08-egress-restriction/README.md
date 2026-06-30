# Exercise 08: Egress Restriction Incident

Resolving database connection timeouts due to egress blocking NetworkPolicies or missing VPC Gateway Endpoints.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: A default-deny egress NetworkPolicy is blocking pods from connecting to external APIs, or routing lacks a DynamoDB Gateway Endpoint.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
