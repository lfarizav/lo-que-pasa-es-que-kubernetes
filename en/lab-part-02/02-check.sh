#!/usr/bin/env bash
# lab-part-02 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/02-answer.txt" || exit 1
$K -n the-block get pvc cart-notebook >/dev/null 2>&1 || exit 1
STATUS=$($K -n the-block get pvc cart-notebook -o jsonpath='{.status.phase}' 2>/dev/null)
test "$STATUS" = "Bound" || exit 1
grep -qxF "STATUS_PVC=$STATUS" "$D/02-answer.txt" || exit 1
CLASS=$($K -n the-block get pvc cart-notebook -o jsonpath='{.spec.storageClassName}' 2>/dev/null)
test "$CLASS" = "standard" || exit 1
grep -qxF "CLASS_STORAGE=$CLASS" "$D/02-answer.txt" || exit 1
$K -n the-block get pod pod-with-disk >/dev/null 2>&1 || exit 1
CONTENT=$($K -n the-block exec pod-with-disk -- cat /data/recipe.txt 2>/dev/null || true)
test -n "$CONTENT" || exit 1
grep -qxF "CONTENT_PERSISTED=$CONTENT" "$D/02-answer.txt" || exit 1
PV=$($K -n the-block get pvc cart-notebook -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)
test -n "$PV" || exit 1
$K get pv "$PV" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null | grep -q . || exit 1
echo ok
