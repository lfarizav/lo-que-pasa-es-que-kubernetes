#!/usr/bin/env bash
# lab-part-04 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/04-respuesta.txt" || exit 1
NOMBRE_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.labels.app\.kubernetes\.io/name}' 2>/dev/null)
GESTIONADO_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.labels.app\.kubernetes\.io/managed-by}' 2>/dev/null)
PARTOF_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.labels.app\.kubernetes\.io/part-of}' 2>/dev/null || true)
test -n "$NOMBRE_REAL" || exit 1
test -n "$GESTIONADO_REAL" || exit 1
test -n "$PARTOF_REAL" || exit 1
grep -qxF "ETIQUETA_NOMBRE=$NOMBRE_REAL" "$D/04-respuesta.txt" || exit 1
grep -qxF "ETIQUETA_GESTIONADO_POR=$GESTIONADO_REAL" "$D/04-respuesta.txt" || exit 1
PODS_REALES=$($K -n la-cuadra get pods -l "app.kubernetes.io/name=${NOMBRE_REAL}" --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')
test "$PODS_REALES" -ge 1 2>/dev/null || exit 1
grep -qxF "PODS_CON_ETIQUETA_RECOMENDADA=$PODS_REALES" "$D/04-respuesta.txt" || exit 1
echo ok
