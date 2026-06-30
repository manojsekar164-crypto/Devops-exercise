# Exercise 12: Node NotReady Production Incident

Resolving node disk pressure (DiskPressure=True) due to EKS container log accumulation.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Kubelet limits and container runtime log rotation were not configured. Rotate logs using logrotate and set containerLogMaxSize.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
