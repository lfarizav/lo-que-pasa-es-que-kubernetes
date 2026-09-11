#!/usr/bin/env bash
# lab-part-02 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG_BUENA="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n la-cuadra create deployment el-carrito-roto --image=nginx:esta-etiqueta-no-existe-nunca

for i in $(seq 1 40); do
  RAZON=$($K -n la-cuadra get pods -l app=el-carrito-roto -o jsonpath='{.items[0].status.containerStatuses[0].state.waiting.reason}' 2>/dev/null || true)
  case "$RAZON" in
    ErrImagePull|ImagePullBackOff) break ;;
  esac
  sleep 2
done

POD=$($K -n la-cuadra get pods -l app=el-carrito-roto -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD RAZON=$RAZON"
$K -n la-cuadra describe pod "$POD" | grep -A6 '^Events:'

$K -n la-cuadra set image deployment/el-carrito-roto nginx="$IMG_BUENA"
$K -n la-cuadra wait --for=condition=Available deployment/el-carrito-roto --timeout=90s

POD_FINAL=$($K -n la-cuadra get pods -l app=el-carrito-roto --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')
IMAGEN_FINAL=$($K -n la-cuadra get pod "$POD_FINAL" -o jsonpath='{.spec.containers[0].image}')
ESTADO_FINAL=$($K -n la-cuadra get pod "$POD_FINAL" -o jsonpath='{.status.phase}')

cat > "$D/04-respuesta.txt" <<EOF
RAZON_DEL_FALLO=$RAZON
IMAGEN_CORREGIDA=$IMAGEN_FINAL
POD_FINAL_STATUS=$ESTADO_FINAL
EOF
cat "$D/04-respuesta.txt"
