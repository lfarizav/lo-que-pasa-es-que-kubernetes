#!/usr/bin/env bash
# lab-part-04 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/04-answer.txt" || exit 1
NAME_REAL=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.labels.app\.kubernetes\.io/name}' 2>/dev/null)
MANAGED_REAL=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.labels.app\.kubernetes\.io/managed-by}' 2>/dev/null)
PARTOF_REAL=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.labels.app\.kubernetes\.io/part-of}' 2>/dev/null || true)
test -n "$NAME_REAL" || exit 1
test -n "$MANAGED_REAL" || exit 1
test -n "$PARTOF_REAL" || exit 1
grep -qxF "LABEL_NAME=$NAME_REAL" "$D/04-answer.txt" || exit 1
grep -qxF "LABEL_MANAGED_BY=$MANAGED_REAL" "$D/04-answer.txt" || exit 1
PODS_REAL=$($K -n the-block get pods -l "app.kubernetes.io/name=${NAME_REAL}" --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')
test "$PODS_REAL" -ge 1 2>/dev/null || exit 1
grep -qxF "PODS_WITH_LABEL_RECOMMENDED=$PODS_REAL" "$D/04-answer.txt" || exit 1
echo ok
