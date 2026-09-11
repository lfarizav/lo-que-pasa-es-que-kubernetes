#!/usr/bin/env bash
# lab-part-01 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.taints}{"\n"}{end}'

cat > "$D/pod-al-trabajador.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-al-trabajador
  namespace: el-carrito
spec:
  nodeSelector:
    kubernetes.io/hostname: kcna-comico-p01-worker
  containers:
  - name: nginx
    image: $IMG
EOF
$K apply -f "$D/pod-al-trabajador.yaml"
$K -n el-carrito wait --for=condition=Ready pod/pod-al-trabajador --timeout=60s

cat > "$D/pod-tolerante.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-tolerante
  namespace: el-carrito
spec:
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  tolerations:
  - key: node-role.kubernetes.io/control-plane
    effect: NoSchedule
    operator: Exists
  containers:
  - name: nginx
    image: $IMG
EOF
$K apply -f "$D/pod-tolerante.yaml"
$K -n el-carrito wait --for=condition=Ready pod/pod-tolerante --timeout=60s

NODO_TRABAJADOR=$($K -n el-carrito get pod pod-al-trabajador -o jsonpath='{.spec.nodeName}')
NODO_TOLERANTE=$($K -n el-carrito get pod pod-tolerante -o jsonpath='{.spec.nodeName}')
TAINT=$($K get node kcna-comico-p01-control-plane -o jsonpath='{.spec.taints[0].effect}')

cat > "$D/04-respuesta.txt" <<EOF
NODO_DEL_POD_SELECCIONADO=$NODO_TRABAJADOR
NODO_DEL_POD_TOLERANTE=$NODO_TOLERANTE
TAINT_DEL_CONTROL_PLANE=$TAINT
EOF
cat "$D/04-respuesta.txt"
