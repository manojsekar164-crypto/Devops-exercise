# Exercise 06: EKS Node Scale Failure Troubleshooting

Troubleshooting Cluster Autoscaler unable to scale up nodes for pending pods due to missing ASG tags or IAM permissions.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: ASGs must be tagged with k8s.io/cluster-autoscaler/enabled for autodiscovery, and the IAM role must have permissions to scale ASGs.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
