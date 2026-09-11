#!/usr/bin/env bash
# lab-part-01 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/03-respuesta.txt" || exit 1
$K -n el-carrito get pod test-imperativo >/dev/null 2>&1 || exit 1
$K -n el-carrito get pod test-declarativo >/dev/null 2>&1 || exit 1
ANOT_IMP=$($K -n el-carrito get pod test-imperativo -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null)
ANOT_DEC=$($K -n el-carrito get pod test-declarativo -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null)
test -z "$ANOT_IMP" || exit 1
test -n "$ANOT_DEC" || exit 1
grep -qxF "ANOTACION_IMPERATIVO_VACIA=si" "$D/03-respuesta.txt" || exit 1
grep -qxF "ANOTACION_DECLARATIVO_VACIA=no" "$D/03-respuesta.txt" || exit 1
RECURSO_REAL=$($K api-resources 2>/dev/null | awk '$1=="deployments"{print $2}')
test "$RECURSO_REAL" = "deploy" || exit 1
grep -qxF "RECURSO_ABREVIADO=$RECURSO_REAL" "$D/03-respuesta.txt" || exit 1
echo ok
