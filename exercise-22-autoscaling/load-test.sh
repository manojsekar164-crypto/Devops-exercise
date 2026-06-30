#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

TARGET_URL="https://payment.example.com/api/test-load"

echo "=========================================================="
echo " Starting Load Test Commands for HPA Scaling Verification"
echo "=========================================================="
echo "Target URL: ${TARGET_URL}"

# Option 1: ApacheBench (ab)
# -n: total number of requests
# -c: concurrency (number of multiple requests to perform at a time)
run_ab() {
  echo -e "\n---> Running ApacheBench (ab) load test..."
  ab -n 10000 -c 100 "${TARGET_URL}"
}

# Option 2: hey (HTTP load generator)
# -z: duration of application load test
# -c: concurrency
run_hey() {
  echo -e "\n---> Running hey load test..."
  hey -z 5m -c 50 "${TARGET_URL}"
}

# Option 3: k6 (Modern performance testing tool)
run_k6() {
  echo -e "\n---> Running k6 load test..."
  cat <<EOF > k6-script.js
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 50 }, // ramp up to 50 users
    { duration: '3m', target: 50 }, // stay at 50 users
    { duration: '1m', target: 0 },  // scale down to 0
  ],
};

export default function () {
  http.get('${TARGET_URL}');
  sleep(0.1);
}
EOF
  k6 run k6-script.js
  rm k6-script.js
}

# Print options
echo "Choose a load test option to run manually:"
echo "1. ApacheBench (ab)"
echo "2. hey"
echo "3. k6"
echo "Example run command: ./load-test.sh (uncomment target option below)"

# run_ab
# run_hey
# run_k6
