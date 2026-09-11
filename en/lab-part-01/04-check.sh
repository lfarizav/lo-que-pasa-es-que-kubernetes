#!/usr/bin/env bash
# lab-part-01 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/04-answer.txt" || exit 1
NODE_WORKER=$($K -n the-cart get pod pod-to-worker -o jsonpath='{.spec.nodeName}' 2>/dev/null)
NODE_TOLERANT=$($K -n the-cart get pod pod-tolerant -o jsonpath='{.spec.nodeName}' 2>/dev/null || true)
test -n "$NODE_WORKER" || exit 1
test -n "$NODE_TOLERANT" || exit 1
echo "$NODE_WORKER" | grep -q "worker" || exit 1
echo "$NODE_TOLERANT" | grep -q "control-plane" || exit 1
grep -qxF "NODE_POD_SELECTED=$NODE_WORKER" "$D/04-answer.txt" || exit 1
grep -qxF "NODE_POD_TOLERANT=$NODE_TOLERANT" "$D/04-answer.txt" || exit 1
TAINT=$($K get node "$NODE_TOLERANT" -o jsonpath='{.spec.taints[0].effect}' 2>/dev/null)
test "$TAINT" = "NoSchedule" || exit 1
grep -qxF "TAINT_CONTROL_PLANE=$TAINT" "$D/04-answer.txt" || exit 1
HAS_TOLERATION=$($K -n the-cart get pod pod-tolerant -o json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); t=d['spec'].get('tolerations',[]); print('yes' if any(x.get('key')=='node-role.kubernetes.io/control-plane' for x in t) else 'no')")
test "$HAS_TOLERATION" = "yes" || exit 1
PHASE1=$($K -n the-cart get pod pod-to-worker -o jsonpath='{.status.phase}' 2>/dev/null)
PHASE2=$($K -n the-cart get pod pod-tolerant -o jsonpath='{.status.phase}' 2>/dev/null)
test "$PHASE1" = "Running" || exit 1
test "$PHASE2" = "Running" || exit 1
echo ok
