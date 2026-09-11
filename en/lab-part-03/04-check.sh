#!/usr/bin/env bash
# lab-part-03 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
test -f "$D/04-answer.txt" || exit 1
POD_WRITTEN=$(grep -oP '(?<=^POD_DEBUGGED=).*' "$D/04-answer.txt")
CONTAINER_WRITTEN=$(grep -oP '(?<=^CONTAINER_EPHEMERAL=).*' "$D/04-answer.txt" || true)
test -n "$POD_WRITTEN" || exit 1
test -n "$CONTAINER_WRITTEN" || exit 1
$K -n the-block get pod "$POD_WRITTEN" >/dev/null 2>&1 || exit 1
NAMES_REAL=$($K -n the-block get pod "$POD_WRITTEN" -o jsonpath='{.spec.ephemeralContainers[*].name}' 2>/dev/null)
echo "$NAMES_REAL" | grep -qw "$CONTAINER_WRITTEN" || exit 1
TARGET=$($K -n the-block get pod "$POD_WRITTEN" -o jsonpath="{.spec.ephemeralContainers[?(@.name=='$CONTAINER_WRITTEN')].targetContainerName}" 2>/dev/null)
test "$TARGET" = "nginx" || exit 1
LOG_REAL=$($K -n the-block logs "$POD_WRITTEN" -c "$CONTAINER_WRITTEN" 2>/dev/null)
PROCESSES_REAL=$(echo "$LOG_REAL" | grep -c "nginx: ")
test "$PROCESSES_REAL" -ge 2 2>/dev/null || exit 1
grep -qxF "PROCESSES_NGINX_SEEN=$PROCESSES_REAL" "$D/04-answer.txt" || exit 1
RESTARTS_REAL=$($K -n the-block get pod "$POD_WRITTEN" -o jsonpath='{.status.containerStatuses[?(@.name=="nginx")].restartCount}' 2>/dev/null)
test "$RESTARTS_REAL" = "0" || exit 1
grep -qxF "RESTARTS_NGINX_ORIGINAL=$RESTARTS_REAL" "$D/04-answer.txt" || exit 1
echo ok
