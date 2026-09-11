#!/usr/bin/env bash
# lab-part-01 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n el-carrito create deployment friendo --image="$IMG" --replicas=3
$K -n el-carrito wait --for=condition=Available deployment/friendo --timeout=90s

$K -n el-carrito expose deployment friendo --name=cobrando --port=80 --target-port=80

sleep 3
$K -n el-carrito get pods -o wide
$K -n el-carrito get deploy friendo -o jsonpath='{.spec.selector.matchLabels}{"\n"}'
$K -n el-carrito get svc cobrando -o jsonpath='{.spec.selector}{"\n"}'
$K -n el-carrito get endpointslices -l kubernetes.io/service-name=cobrando

REPLICAS=$($K -n el-carrito get deploy friendo -o jsonpath='{.status.readyReplicas}')
ENDPOINTS=$($K -n el-carrito get endpointslices -l kubernetes.io/service-name=cobrando -o jsonpath='{.items[0].endpoints[*].addresses[0]}' | wc -w)
TIPO=$($K -n el-carrito get svc cobrando -o jsonpath='{.spec.type}')

cat > "$D/02-respuesta.txt" <<EOF
REPLICAS_LISTAS=$REPLICAS
ENDPOINTS_DEL_SERVICE=$ENDPOINTS
TIPO_DE_SERVICE=$TIPO
EOF
cat "$D/02-respuesta.txt"
