#!/usr/bin/env bash
# lab-part-01 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K api-resources | grep -w deployments

$K -n el-carrito run test-imperativo --image="$IMG"
$K -n el-carrito wait --for=condition=Ready pod/test-imperativo --timeout=60s

cat > "$D/test-declarativo.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: test-declarativo
  namespace: el-carrito
spec:
  containers:
  - name: nginx
    image: $IMG
EOF
$K apply -f "$D/test-declarativo.yaml"
$K -n el-carrito wait --for=condition=Ready pod/test-declarativo --timeout=60s

ANOT_IMPERATIVO=$($K -n el-carrito get pod test-imperativo -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}')
ANOT_DECLARATIVO=$($K -n el-carrito get pod test-declarativo -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}')
RECURSO=$($K api-resources | awk '$1=="deployments"{print $2}')

cat > "$D/03-respuesta.txt" <<EOF
ANOTACION_IMPERATIVO_VACIA=$([ -z "$ANOT_IMPERATIVO" ] && echo "si" || echo "no")
ANOTACION_DECLARATIVO_VACIA=$([ -z "$ANOT_DECLARATIVO" ] && echo "si" || echo "no")
RECURSO_ABREVIADO=$RECURSO
EOF
cat "$D/03-respuesta.txt"
