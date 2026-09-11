#!/usr/bin/env bash
# lab-part-01 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n the-cart create deployment frying --image="$IMG" --replicas=3
$K -n the-cart wait --for=condition=Available deployment/frying --timeout=90s

$K -n the-cart expose deployment frying --name=charging --port=80 --target-port=80

sleep 3
$K -n the-cart get pods -o wide
$K -n the-cart get deploy frying -o jsonpath='{.spec.selector.matchLabels}{"\n"}'
$K -n the-cart get svc charging -o jsonpath='{.spec.selector}{"\n"}'
$K -n the-cart get endpointslices -l kubernetes.io/service-name=charging

REPLICAS=$($K -n the-cart get deploy frying -o jsonpath='{.status.readyReplicas}')
ENDPOINTS=$($K -n the-cart get endpointslices -l kubernetes.io/service-name=charging -o jsonpath='{.items[0].endpoints[*].addresses[0]}' | wc -w)
TYPE=$($K -n the-cart get svc charging -o jsonpath='{.spec.type}')

cat > "$D/02-answer.txt" <<EOF
REPLICAS_READY=$REPLICAS
ENDPOINTS_SERVICE=$ENDPOINTS
TYPE_SERVICE=$TYPE
EOF
cat "$D/02-answer.txt"
