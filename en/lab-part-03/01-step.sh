#!/usr/bin/env bash
# lab-part-03 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n the-block set image deployment/the-cart nginx="$V2"
$K -n the-block annotate deployment the-cart kubernetes.io/change-cause="update to v2" --overwrite
$K -n the-block rollout status deployment/the-cart --timeout=90s

sleep 3
$K -n the-block get pods -l app=the-cart -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'
$K -n the-block rollout history deployment/the-cart

REVISION=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
REPLICAS_IN_V2=$($K -n the-block get pods -l app=the-cart -o jsonpath="{range .items[*]}{.spec.containers[0].image}{'\n'}{end}" | grep -c "$V2")

cat > "$D/01-answer.txt" <<EOF
IMAGE_FINAL=$V2
REPLICAS_UPDATED=$REPLICAS_IN_V2
REVISION_CURRENT=$REVISION
EOF
cat "$D/01-answer.txt"
