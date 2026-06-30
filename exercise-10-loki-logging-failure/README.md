# Exercise 10: Loki Logging Failure

Troubleshooting Alloy agent unable to ship logs with HTTP 403 authorization failures.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Loki multi-tenancy auth is enabled but the Alloy shipper configuration is missing the X-Scope-OrgID header.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
