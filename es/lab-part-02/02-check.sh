#!/usr/bin/env bash
# lab-part-02 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/02-respuesta.txt" || exit 1
$K -n la-cuadra get pvc cuaderno-del-carrito >/dev/null 2>&1 || exit 1
ESTADO=$($K -n la-cuadra get pvc cuaderno-del-carrito -o jsonpath='{.status.phase}' 2>/dev/null)
test "$ESTADO" = "Bound" || exit 1
grep -qxF "ESTADO_PVC=$ESTADO" "$D/02-respuesta.txt" || exit 1
CLASE=$($K -n la-cuadra get pvc cuaderno-del-carrito -o jsonpath='{.spec.storageClassName}' 2>/dev/null)
test "$CLASE" = "standard" || exit 1
grep -qxF "CLASE_DE_ALMACENAMIENTO=$CLASE" "$D/02-respuesta.txt" || exit 1
$K -n la-cuadra get pod pod-con-disco >/dev/null 2>&1 || exit 1
CONTENIDO=$($K -n la-cuadra exec pod-con-disco -- cat /datos/receta.txt 2>/dev/null || true)
test -n "$CONTENIDO" || exit 1
grep -qxF "CONTENIDO_PERSISTIDO=$CONTENIDO" "$D/02-respuesta.txt" || exit 1
PV=$($K -n la-cuadra get pvc cuaderno-del-carrito -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)
test -n "$PV" || exit 1
$K get pv "$PV" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null | grep -q . || exit 1
echo ok
