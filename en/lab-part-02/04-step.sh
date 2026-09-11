#!/usr/bin/env bash
# lab-part-02 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG_GOOD="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n the-block create deployment the-broken-cart --image=nginx:esta-etiqueta-no-existe-nunca

for i in $(seq 1 40); do
  REASON=$($K -n the-block get pods -l app=the-broken-cart -o jsonpath='{.items[0].status.containerStatuses[0].state.waiting.reason}' 2>/dev/null || true)
  case "$REASON" in
    ErrImagePull|ImagePullBackOff) break ;;
  esac
  sleep 2
done

POD=$($K -n the-block get pods -l app=the-broken-cart -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD REASON=$REASON"
$K -n the-block describe pod "$POD" | grep -A6 '^Events:'

$K -n the-block set image deployment/the-broken-cart nginx="$IMG_GOOD"
$K -n the-block wait --for=condition=Available deployment/the-broken-cart --timeout=90s

POD_FINAL=$($K -n the-block get pods -l app=the-broken-cart --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')
IMAGE_FINAL=$($K -n the-block get pod "$POD_FINAL" -o jsonpath='{.spec.containers[0].image}')
STATUS_FINAL=$($K -n the-block get pod "$POD_FINAL" -o jsonpath='{.status.phase}')

cat > "$D/04-answer.txt" <<EOF
REASON_FAILURE=$REASON
IMAGE_FIXED=$IMAGE_FINAL
POD_FINAL_STATUS=$STATUS_FINAL
EOF
cat "$D/04-answer.txt"
