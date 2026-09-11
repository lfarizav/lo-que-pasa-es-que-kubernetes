#!/usr/bin/env bash
# lab-part-02 step 1 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/01-respuesta.txt" || exit 1
$K -n la-cuadra get svc menu-fijo >/dev/null 2>&1 || exit 1
$K -n la-cuadra get svc menu-para-llevar >/dev/null 2>&1 || exit 1
CLUSTERIP=$($K -n la-cuadra get svc menu-fijo -o jsonpath='{.spec.clusterIP}' 2>/dev/null || true)
test -n "$CLUSTERIP" || exit 1
grep -qxF "DNS_RESUELTO=$CLUSTERIP" "$D/01-respuesta.txt" || exit 1
$K -n la-cuadra get pod cliente >/dev/null 2>&1 || exit 1
CODIGO_CLUSTERIP=$($K -n la-cuadra exec cliente -- sh -c "wget -q -O /dev/null -S --timeout=5 http://${CLUSTERIP}/ 2>&1 | grep -o 'HTTP/1.1 [0-9]*' | head -1 | awk '{print \$2}'" 2>/dev/null)
test "$CODIGO_CLUSTERIP" = "200" || exit 1
grep -qxF "RESPUESTA_CLUSTERIP=$CODIGO_CLUSTERIP" "$D/01-respuesta.txt" || exit 1
NODEPORT=$($K -n la-cuadra get svc menu-para-llevar -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || true)
test -n "$NODEPORT" || exit 1
TIPO=$($K -n la-cuadra get svc menu-para-llevar -o jsonpath='{.spec.type}' 2>/dev/null)
test "$TIPO" = "NodePort" || exit 1
NODO=$($K get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
CODIGO_NODEPORT=$(docker exec "$NODO" curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:${NODEPORT}/" 2>/dev/null)
test "$CODIGO_NODEPORT" = "200" || exit 1
grep -qxF "RESPUESTA_NODEPORT=$CODIGO_NODEPORT" "$D/01-respuesta.txt" || exit 1
echo ok
