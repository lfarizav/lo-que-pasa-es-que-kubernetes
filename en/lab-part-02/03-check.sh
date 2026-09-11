#!/usr/bin/env bash
# lab-part-02 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/03-answer.txt" || exit 1
LEVEL=$($K get namespace the-safe-kitchen -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)
test "$LEVEL" = "restricted" || exit 1
$K -n the-safe-kitchen get pod pod-privileged >/dev/null 2>&1 && exit 1
grep -qxF "PRIVILEGED_EXISTS=no" "$D/03-answer.txt" || exit 1
grep -qxF "REJECTION_PRIVILEGED=yes" "$D/03-answer.txt" || exit 1
STATUS=$($K -n the-safe-kitchen get pod pod-restricted -o jsonpath='{.status.phase}' 2>/dev/null)
test "$STATUS" = "Running" || exit 1
grep -qxF "POD_RESTRICTED_STATUS=$STATUS" "$D/03-answer.txt" || exit 1
DROP=$($K -n the-safe-kitchen get pod pod-restricted -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop[0]}' 2>/dev/null)
test "$DROP" = "ALL" || exit 1
NONROOT=$($K -n the-safe-kitchen get pod pod-restricted -o jsonpath='{.spec.securityContext.runAsNonRoot}' 2>/dev/null)
test "$NONROOT" = "true" || exit 1
echo ok
