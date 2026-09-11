#!/usr/bin/env bash
# lab-part-03 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"

POD=$($K -n the-block get pods -l app=the-cart -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD"

$K -n the-block debug "$POD" --image=busybox:1.36 --target=nginx -- ps aux

NAME_EPHEMERAL=$($K -n the-block get pod "$POD" -o jsonpath='{.spec.ephemeralContainers[-1:].name}')
echo "NAME_EPHEMERAL=$NAME_EPHEMERAL"

for i in $(seq 1 15); do
  LOG_EPHEMERAL=$($K -n the-block logs "$POD" -c "$NAME_EPHEMERAL" 2>/dev/null || true)
  if echo "$LOG_EPHEMERAL" | grep -q "nginx: "; then
    break
  fi
  sleep 2
done
echo "$LOG_EPHEMERAL"

PROCESSES_NGINX=$(echo "$LOG_EPHEMERAL" | grep -c "nginx: ")
RESTARTS_ORIGINAL=$($K -n the-block get pod "$POD" -o jsonpath='{.status.containerStatuses[?(@.name=="nginx")].restartCount}')

cat > "$D/04-answer.txt" <<EOF
POD_DEBUGGED=$POD
CONTAINER_EPHEMERAL=$NAME_EPHEMERAL
PROCESSES_NGINX_SEEN=$PROCESSES_NGINX
RESTARTS_NGINX_ORIGINAL=$RESTARTS_ORIGINAL
EOF
cat "$D/04-answer.txt"
