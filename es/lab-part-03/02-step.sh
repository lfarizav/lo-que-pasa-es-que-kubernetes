#!/usr/bin/env bash
# lab-part-03 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n la-cuadra set image deployment/el-carrito nginx=nginx:esta-etiqueta-no-existe-nunca
$K -n la-cuadra annotate deployment el-carrito kubernetes.io/change-cause="version rota" --overwrite

timeout 15 kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03 \
  -n la-cuadra rollout status deployment/el-carrito --timeout=12s || echo "ATASCADO: el rollout no termina, como se esperaba"

REVISION_ROTA=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
echo "revision con el intento roto: $REVISION_ROTA"

$K -n la-cuadra rollout undo deployment/el-carrito
$K -n la-cuadra rollout status deployment/el-carrito --timeout=90s

sleep 3
REVISION_DESPUES=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
IMAGEN_DESPUES=$($K -n la-cuadra get pods -l app=el-carrito -o jsonpath='{.items[0].spec.containers[0].image}')
$K -n la-cuadra get pods -l app=el-carrito -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}'

cat > "$D/02-respuesta.txt" <<EOF
REVISION_ANTES_DEL_ROLLBACK=$REVISION_ROTA
REVISION_DESPUES_DEL_ROLLBACK=$REVISION_DESPUES
IMAGEN_DESPUES_DEL_ROLLBACK=$IMAGEN_DESPUES
EOF
cat "$D/02-respuesta.txt"
