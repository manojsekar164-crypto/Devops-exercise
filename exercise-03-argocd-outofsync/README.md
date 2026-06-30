# Exercise 03: ArgoCD OutOfSync Production Incident

Resolving state drift where Git desired replicas (3) differ from live cluster replicas (5) scaled by HPA.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: ArgoCD detects drift because the static replicas config conflicts with Horizontal Pod Autoscaler. Exclude replicas from comparison using ignoreDifferences.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
