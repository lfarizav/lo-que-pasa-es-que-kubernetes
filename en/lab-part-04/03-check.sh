#!/usr/bin/env bash
# lab-part-04 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/03-answer.txt" || exit 1
RESTARTS_WRITTEN=$(grep -oP '(?<=^RESTARTS_BEFORE_FIX=).*' "$D/03-answer.txt" || true)
test -n "$RESTARTS_WRITTEN" || exit 1
test "$RESTARTS_WRITTEN" -ge 1 2>/dev/null || exit 1
grep -qxF "POD_READY_AFTER_FIX=true" "$D/03-answer.txt" || exit 1
$K -n the-block get deployment the-tested-cart >/dev/null 2>&1 || exit 1
PATH_REAL=$($K -n the-block get deployment the-tested-cart -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null || true)
test -n "$PATH_REAL" || exit 1
grep -qxF "PATH_PROBE_FIXED=$PATH_REAL" "$D/03-answer.txt" || exit 1
POD=$($K -n the-block get pods -l app=the-tested-cart -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$POD" || exit 1
READY_REAL=$($K -n the-block get pod "$POD" -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null)
test "$READY_REAL" = "true" || exit 1
PORT=$($K -n the-block get deployment the-tested-cart -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null || true)
test -n "$PORT" || exit 1
echo ok
