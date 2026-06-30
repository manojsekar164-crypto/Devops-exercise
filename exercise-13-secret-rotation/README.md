# Exercise 13: Secret Rotation Outage

Troubleshooting rotated Secrets Manager credentials not propagating to Pod environment variables.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Sync interval is too long or the application lacks a reload mechanism (such as Stakater Reloader) to refresh static env variables.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
