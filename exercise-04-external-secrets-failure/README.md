# Exercise 04: External Secrets Failure Troubleshooting

Troubleshooting SecretSyncedError due to secretsmanager:GetSecretValue access denials.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: The EKS IAM role associated with the ExternalSecret lacks read permissions on Secrets Manager, or the OIDC provider trust relationship is misconfigured.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
