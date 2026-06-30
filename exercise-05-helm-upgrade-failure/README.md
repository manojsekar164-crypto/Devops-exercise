# Exercise 05: Helm Upgrade Failure Troubleshooting

Handling deployment failure due to immutable field updates (spec.selector.matchLabels).

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Kubernetes deployment selectors are immutable. A change in matchLabels from payment to payment-v2 blocks upgrades. Must delete deployment or rollback.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
