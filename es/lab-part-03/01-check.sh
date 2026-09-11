#!/usr/bin/env bash
# lab-part-03 step 1 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
V2="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"
test -f "$D/01-respuesta.txt" || exit 1
grep -qxF "IMAGEN_FINAL=$V2" "$D/01-respuesta.txt" || exit 1
IMAGEN_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
test "$IMAGEN_REAL" = "$V2" || exit 1
REPLICAS_REALES=$($K -n la-cuadra get pods -l app=el-carrito -o jsonpath="{range .items[*]}{.spec.containers[0].image}{'\n'}{end}" 2>/dev/null | grep -c "$V2")
test "$REPLICAS_REALES" = "3" || exit 1
grep -qxF "REPLICAS_ACTUALIZADAS=$REPLICAS_REALES" "$D/01-respuesta.txt" || exit 1
REVISION_REAL=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
test "$REVISION_REAL" = "2" || exit 1
grep -qxF "REVISION_ACTUAL=$REVISION_REAL" "$D/01-respuesta.txt" || exit 1
HIST=$($K -n la-cuadra rollout history deployment/el-carrito 2>/dev/null)
echo "$HIST" | grep -q "1.*version inicial v1" || exit 1
echo "$HIST" | grep -q "2.*actualizar a v2" || exit 1
echo ok
