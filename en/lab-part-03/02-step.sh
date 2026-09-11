#!/usr/bin/env bash
# lab-part-03 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n the-block set image deployment/the-cart nginx=nginx:esta-etiqueta-no-existe-nunca
$K -n the-block annotate deployment the-cart kubernetes.io/change-cause="broken version" --overwrite

timeout 15 kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03 \
  -n the-block rollout status deployment/the-cart --timeout=12s || echo "STUCK: the rollout does not finish, as expected"

REVISION_BROKEN=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
echo "revision with the broken attempt: $REVISION_BROKEN"

$K -n the-block rollout undo deployment/the-cart
$K -n the-block rollout status deployment/the-cart --timeout=90s

sleep 3
REVISION_AFTER=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
IMAGE_AFTER=$($K -n the-block get pods -l app=the-cart -o jsonpath='{.items[0].spec.containers[0].image}')
$K -n the-block get pods -l app=the-cart -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}'

cat > "$D/02-answer.txt" <<EOF
REVISION_BEFORE_ROLLBACK=$REVISION_BROKEN
REVISION_AFTER_ROLLBACK=$REVISION_AFTER
IMAGE_AFTER_ROLLBACK=$IMAGE_AFTER
EOF
cat "$D/02-answer.txt"
