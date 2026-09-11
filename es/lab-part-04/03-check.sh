#!/usr/bin/env bash
# lab-part-04 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/03-respuesta.txt" || exit 1
REINICIOS_ESCRITOS=$(grep -oP '(?<=^REINICIOS_ANTES_DEL_FIX=).*' "$D/03-respuesta.txt" || true)
test -n "$REINICIOS_ESCRITOS" || exit 1
test "$REINICIOS_ESCRITOS" -ge 1 2>/dev/null || exit 1
grep -qxF "POD_LISTO_DESPUES_DEL_FIX=true" "$D/03-respuesta.txt" || exit 1
$K -n la-cuadra get deployment el-carrito-probado >/dev/null 2>&1 || exit 1
RUTA_REAL=$($K -n la-cuadra get deployment el-carrito-probado -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null || true)
test -n "$RUTA_REAL" || exit 1
grep -qxF "RUTA_DEL_PROBE_CORREGIDA=$RUTA_REAL" "$D/03-respuesta.txt" || exit 1
POD=$($K -n la-cuadra get pods -l app=el-carrito-probado -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$POD" || exit 1
LISTO_REAL=$($K -n la-cuadra get pod "$POD" -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null)
test "$LISTO_REAL" = "true" || exit 1
PUERTO=$($K -n la-cuadra get deployment el-carrito-probado -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null || true)
test -n "$PUERTO" || exit 1
echo ok
