#!/usr/bin/env bash
# lab-part-01 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/02-respuesta.txt" || exit 1
$K -n el-carrito get deployment friendo >/dev/null 2>&1 || exit 1
$K -n el-carrito get svc cobrando >/dev/null 2>&1 || exit 1
REPLICAS=$($K -n el-carrito get deploy friendo -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
test "$REPLICAS" = "3" || exit 1
grep -qxF "REPLICAS_LISTAS=$REPLICAS" "$D/02-respuesta.txt" || exit 1
TIPO=$($K -n el-carrito get svc cobrando -o jsonpath='{.spec.type}' 2>/dev/null)
test "$TIPO" = "ClusterIP" || exit 1
grep -qxF "TIPO_DE_SERVICE=$TIPO" "$D/02-respuesta.txt" || exit 1
ENDPOINTS=$($K -n el-carrito get endpointslices -l kubernetes.io/service-name=cobrando -o jsonpath='{.items[0].endpoints[*].addresses[0]}' 2>/dev/null | wc -w | tr -d '[:space:]')
test "$ENDPOINTS" = "3" || exit 1
grep -qxF "ENDPOINTS_DEL_SERVICE=$ENDPOINTS" "$D/02-respuesta.txt" || exit 1
SEL_DEPLOY=$($K -n el-carrito get deploy friendo -o jsonpath='{.spec.selector.matchLabels}' 2>/dev/null)
SEL_SVC=$($K -n el-carrito get svc cobrando -o jsonpath='{.spec.selector}' 2>/dev/null)
test "$SEL_DEPLOY" = "$SEL_SVC" || exit 1
PODS_APP=$($K -n el-carrito get pods -l app=friendo --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')
test "$PODS_APP" = "3" || exit 1
echo ok
