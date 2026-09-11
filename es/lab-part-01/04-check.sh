#!/usr/bin/env bash
# lab-part-01 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/04-respuesta.txt" || exit 1
NODO_TRABAJADOR=$($K -n el-carrito get pod pod-al-trabajador -o jsonpath='{.spec.nodeName}' 2>/dev/null)
NODO_TOLERANTE=$($K -n el-carrito get pod pod-tolerante -o jsonpath='{.spec.nodeName}' 2>/dev/null || true)
test -n "$NODO_TRABAJADOR" || exit 1
test -n "$NODO_TOLERANTE" || exit 1
echo "$NODO_TRABAJADOR" | grep -q "worker" || exit 1
echo "$NODO_TOLERANTE" | grep -q "control-plane" || exit 1
grep -qxF "NODO_DEL_POD_SELECCIONADO=$NODO_TRABAJADOR" "$D/04-respuesta.txt" || exit 1
grep -qxF "NODO_DEL_POD_TOLERANTE=$NODO_TOLERANTE" "$D/04-respuesta.txt" || exit 1
TAINT=$($K get node "$NODO_TOLERANTE" -o jsonpath='{.spec.taints[0].effect}' 2>/dev/null)
test "$TAINT" = "NoSchedule" || exit 1
grep -qxF "TAINT_DEL_CONTROL_PLANE=$TAINT" "$D/04-respuesta.txt" || exit 1
TIENE_TOLERANCIA=$($K -n el-carrito get pod pod-tolerante -o json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); t=d['spec'].get('tolerations',[]); print('si' if any(x.get('key')=='node-role.kubernetes.io/control-plane' for x in t) else 'no')")
test "$TIENE_TOLERANCIA" = "si" || exit 1
FASE1=$($K -n el-carrito get pod pod-al-trabajador -o jsonpath='{.status.phase}' 2>/dev/null)
FASE2=$($K -n el-carrito get pod pod-tolerante -o jsonpath='{.status.phase}' 2>/dev/null)
test "$FASE1" = "Running" || exit 1
test "$FASE2" = "Running" || exit 1
echo ok
