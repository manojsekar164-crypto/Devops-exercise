# Exercise 02: IAM / IRSA Failure Troubleshooting

Resolving AccessDeniedException when EKS pod falls back to node group IAM role.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: EKS Pod is missing 'serviceAccountName' in the template spec or the ServiceAccount lacks OIDC role ARN annotations.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
