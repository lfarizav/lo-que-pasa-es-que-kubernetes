#!/usr/bin/env bash
# lab-part-04 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n la-cuadra create deployment el-carrito --image="$IMG" --replicas=2
$K -n la-cuadra wait --for=condition=Available deployment/el-carrito --timeout=90s

for i in $(seq 1 40); do
  CPU_NODO=$($K top nodes --no-headers 2>/dev/null | awk '{print $2}' | tr -d 'm' || true)
  [ -n "$CPU_NODO" ] && [ "$CPU_NODO" -gt 0 ] 2>/dev/null && break
  sleep 3
done

$K top nodes
for i in $(seq 1 40); do
  MEM_POD=$($K -n la-cuadra top pods --no-headers 2>/dev/null | head -1 | awk '{print $3}' | tr -d 'Mi' || true)
  [ -n "$MEM_POD" ] && [ "$MEM_POD" -gt 0 ] 2>/dev/null && break
  sleep 3
done
$K -n la-cuadra top pods

cat > "$D/02-respuesta.txt" <<EOF
CPU_DEL_NODO_MAYOR_QUE_CERO=$([ "$CPU_NODO" -gt 0 ] 2>/dev/null && echo "si" || echo "no")
MEMORIA_DEL_POD_MAYOR_QUE_CERO=$([ "$MEM_POD" -gt 0 ] 2>/dev/null && echo "si" || echo "no")
EOF
cat "$D/02-respuesta.txt"
