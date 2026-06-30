# Exercise 15: Complete Production Outage

Post-Mortem RCA for Redis authentication failure post rotation.

## Overview
This folder contains the complete, production-ready configurations for this exercise.

- **Objective**: Establish reliable EKS operations and configurations.
- **RCA/Context**: Secret rotated at 08:55. New deployment rolled out at 09:00 with static secrets containing old values, resulting in complete outage.

## Setup Instructions
1. Run ./scripts/deploy.sh to apply resources.
2. Verify implementation using ./scripts/validate.sh.
