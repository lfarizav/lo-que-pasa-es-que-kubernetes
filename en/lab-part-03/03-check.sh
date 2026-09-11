#!/usr/bin/env bash
# lab-part-03 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
test -f "$D/03-answer.txt" || exit 1
test -f "$D/version-copiada.txt" || exit 1
POD_WRITTEN=$(grep -oP '(?<=^POD_INSPECTED=).*' "$D/03-answer.txt" || true)
test -n "$POD_WRITTEN" || exit 1
$K -n the-block get pod "$POD_WRITTEN" >/dev/null 2>&1 || exit 1
PS_REAL=$($K -n the-block exec "$POD_WRITTEN" -- ps aux 2>/dev/null)
echo "$PS_REAL" | grep -q "nginx: master process" || exit 1
echo "$PS_REAL" | awk '$1==1 && $2=="root"{found=1} END{exit !found}' || exit 1
CONTENT_REAL=$($K -n the-block exec "$POD_WRITTEN" -- cat /tmp/version.txt 2>/dev/null)
CONTENT_COPIED=$(cat "$D/version-copiada.txt")
test "$CONTENT_REAL" = "$CONTENT_COPIED" || exit 1
grep -qxF "FILE_COPIED_CONTENT=$CONTENT_COPIED" "$D/03-answer.txt" || exit 1
RESTARTS=$($K -n the-block get pod "$POD_WRITTEN" -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)
test "$RESTARTS" = "0" || exit 1
echo ok
