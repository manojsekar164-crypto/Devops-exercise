# Exercise 11: CrashLoopBackOff Investigation

Investigating app CrashLoopBackOff caused by instant startup panic on database connection refused.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Application crashes immediately instead of retrying when database is offline. Add retry loops or wait-for-db initContainers.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
