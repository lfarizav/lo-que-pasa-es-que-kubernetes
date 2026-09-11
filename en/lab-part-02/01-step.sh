#!/usr/bin/env bash
# lab-part-02 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K -n the-block expose deployment the-cart --name=fixed-menu --port=80 --target-port=80
$K -n the-block expose deployment the-cart --name=takeaway-menu --port=80 --target-port=80 --type=NodePort
$K -n the-block get svc

$K -n the-block run client --image="$IMG" --command -- sleep 3600
$K -n the-block wait --for=condition=Ready pod/client --timeout=60s

$K -n the-block exec client -- getent hosts fixed-menu.the-block.svc.cluster.local

CLUSTERIP=$($K -n the-block get svc fixed-menu -o jsonpath='{.spec.clusterIP}')
CODE_CLUSTERIP=$($K -n the-block exec client -- sh -c "wget -q -O /dev/null -S --timeout=5 http://${CLUSTERIP}/ 2>&1 | grep -o 'HTTP/1.1 [0-9]*' | head -1 | awk '{print \$2}'")

NODE=$($K get nodes -o jsonpath='{.items[0].metadata.name}')
NODEPORT=$($K -n the-block get svc takeaway-menu -o jsonpath='{.spec.ports[0].nodePort}')
CODE_NODEPORT=$(docker exec "$NODE" curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:${NODEPORT}/")

cat > "$D/01-answer.txt" <<EOF
DNS_RESOLVED=$CLUSTERIP
ANSWER_CLUSTERIP=$CODE_CLUSTERIP
ANSWER_NODEPORT=$CODE_NODEPORT
EOF
cat "$D/01-answer.txt"
