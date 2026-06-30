# Exercise 07: ALB Ingress Failure Troubleshooting

Troubleshooting ALB Controller target registration failure due to 'Unable to discover subnets'.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: AWS ALB Ingress Controller scans VPC subnets and requires elb (public) and internal-elb (private) discover tags to provision load balancers.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
