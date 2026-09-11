#!/usr/bin/env bash
# lab-part-03 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"
test -f "$D/02-respuesta.txt" || exit 1
grep -qxF "REVISION_ANTES_DEL_ROLLBACK=3" "$D/02-respuesta.txt" || exit 1
REVISION_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
test "$REVISION_REAL" -ge 4 2>/dev/null || exit 1
grep -qxF "REVISION_DESPUES_DEL_ROLLBACK=$REVISION_REAL" "$D/02-respuesta.txt" || exit 1
IMAGEN_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
test "$IMAGEN_REAL" = "$V2" || exit 1
grep -qxF "IMAGEN_DESPUES_DEL_ROLLBACK=$V2" "$D/02-respuesta.txt" || exit 1
REPLICAS_LISTAS=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
test "$REPLICAS_LISTAS" = "3" || exit 1
HIST=$($K -n la-cuadra rollout history deployment/el-carrito 2>/dev/null)
echo "$HIST" | grep -q "3.*version rota" || exit 1
echo ok
