#!/usr/bin/env bash
# lab-part-03 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n la-cuadra set image deployment/el-carrito nginx="$V2"
$K -n la-cuadra annotate deployment el-carrito kubernetes.io/change-cause="actualizar a v2" --overwrite
$K -n la-cuadra rollout status deployment/el-carrito --timeout=90s

sleep 3
$K -n la-cuadra get pods -l app=el-carrito -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.containers[0].image}{"\n"}{end}'
$K -n la-cuadra rollout history deployment/el-carrito

REVISION=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
REPLICAS_EN_V2=$($K -n la-cuadra get pods -l app=el-carrito -o jsonpath="{range .items[*]}{.spec.containers[0].image}{'\n'}{end}" | grep -c "$V2")

cat > "$D/01-respuesta.txt" <<EOF
IMAGEN_FINAL=$V2
REPLICAS_ACTUALIZADAS=$REPLICAS_EN_V2
REVISION_ACTUAL=$REVISION
EOF
cat "$D/01-respuesta.txt"
