#!/usr/bin/env bash
# lab-part-02 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/04-answer.txt" || exit 1
REASON_WRITTEN=$(grep -oP '(?<=^REASON_FAILURE=).*' "$D/04-answer.txt")
echo "$REASON_WRITTEN" | grep -qE '^(ErrImagePull|ImagePullBackOff)$' || exit 1
$K -n the-block get deployment the-broken-cart >/dev/null 2>&1 || exit 1
REPLICAS_AVAILABLE=$($K -n the-block get deployment the-broken-cart -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
test "$REPLICAS_AVAILABLE" -ge 1 2>/dev/null || exit 1
IMAGE_REAL=$($K -n the-block get deployment the-broken-cart -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
echo "$IMAGE_REAL" | grep -q '@sha256:' || exit 1
grep -qxF "IMAGE_FIXED=$IMAGE_REAL" "$D/04-answer.txt" || exit 1
POD_FINAL=$($K -n the-block get pods -l app=the-broken-cart --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$POD_FINAL" || exit 1
STATUS=$($K -n the-block get pod "$POD_FINAL" -o jsonpath='{.status.phase}' 2>/dev/null)
test "$STATUS" = "Running" || exit 1
grep -qxF "POD_FINAL_STATUS=$STATUS" "$D/04-answer.txt" || exit 1
echo ok
