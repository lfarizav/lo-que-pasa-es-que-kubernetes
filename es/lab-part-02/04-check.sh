#!/usr/bin/env bash
# lab-part-02 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/04-respuesta.txt" || exit 1
RAZON_ESCRITA=$(grep -oP '(?<=^RAZON_DEL_FALLO=).*' "$D/04-respuesta.txt")
echo "$RAZON_ESCRITA" | grep -qE '^(ErrImagePull|ImagePullBackOff)$' || exit 1
$K -n la-cuadra get deployment el-carrito-roto >/dev/null 2>&1 || exit 1
REPLICAS_DISPONIBLES=$($K -n la-cuadra get deployment el-carrito-roto -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
test "$REPLICAS_DISPONIBLES" -ge 1 2>/dev/null || exit 1
IMAGEN_REAL=$($K -n la-cuadra get deployment el-carrito-roto -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
echo "$IMAGEN_REAL" | grep -q '@sha256:' || exit 1
grep -qxF "IMAGEN_CORREGIDA=$IMAGEN_REAL" "$D/04-respuesta.txt" || exit 1
POD_FINAL=$($K -n la-cuadra get pods -l app=el-carrito-roto --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$POD_FINAL" || exit 1
ESTADO=$($K -n la-cuadra get pod "$POD_FINAL" -o jsonpath='{.status.phase}' 2>/dev/null)
test "$ESTADO" = "Running" || exit 1
grep -qxF "POD_FINAL_STATUS=$ESTADO" "$D/04-respuesta.txt" || exit 1
echo ok
