#!/usr/bin/env bash
# lab-part-02 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n la-cuadra expose deployment el-carrito --name=menu-fijo --port=80 --target-port=80
$K -n la-cuadra expose deployment el-carrito --name=menu-para-llevar --port=80 --target-port=80 --type=NodePort
$K -n la-cuadra get svc

$K -n la-cuadra run cliente --image="$IMG" --command -- sleep 3600
$K -n la-cuadra wait --for=condition=Ready pod/cliente --timeout=60s

$K -n la-cuadra exec cliente -- getent hosts menu-fijo.la-cuadra.svc.cluster.local

CLUSTERIP=$($K -n la-cuadra get svc menu-fijo -o jsonpath='{.spec.clusterIP}')
CODIGO_CLUSTERIP=$($K -n la-cuadra exec cliente -- sh -c "wget -q -O /dev/null -S --timeout=5 http://${CLUSTERIP}/ 2>&1 | grep -o 'HTTP/1.1 [0-9]*' | head -1 | awk '{print \$2}'")

NODO=$($K get nodes -o jsonpath='{.items[0].metadata.name}')
NODEPORT=$($K -n la-cuadra get svc menu-para-llevar -o jsonpath='{.spec.ports[0].nodePort}')
CODIGO_NODEPORT=$(docker exec "$NODO" curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:${NODEPORT}/")

cat > "$D/01-respuesta.txt" <<EOF
DNS_RESUELTO=$CLUSTERIP
RESPUESTA_CLUSTERIP=$CODIGO_CLUSTERIP
RESPUESTA_NODEPORT=$CODIGO_NODEPORT
EOF
cat "$D/01-respuesta.txt"
