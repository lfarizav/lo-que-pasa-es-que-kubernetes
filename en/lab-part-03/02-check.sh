#!/usr/bin/env bash
# lab-part-03 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"
test -f "$D/02-answer.txt" || exit 1
grep -qxF "REVISION_BEFORE_ROLLBACK=3" "$D/02-answer.txt" || exit 1
REVISION_REAL=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
test "$REVISION_REAL" -ge 4 2>/dev/null || exit 1
grep -qxF "REVISION_AFTER_ROLLBACK=$REVISION_REAL" "$D/02-answer.txt" || exit 1
IMAGE_REAL=$($K -n the-block get deployment the-cart -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
test "$IMAGE_REAL" = "$V2" || exit 1
grep -qxF "IMAGE_AFTER_ROLLBACK=$V2" "$D/02-answer.txt" || exit 1
REPLICAS_READY=$($K -n the-block get deployment the-cart -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
test "$REPLICAS_READY" = "3" || exit 1
HIST=$($K -n the-block rollout history deployment/the-cart 2>/dev/null)
echo "$HIST" | grep -q "3.*broken version" || exit 1
echo ok
