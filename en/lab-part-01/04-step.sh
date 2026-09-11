#!/usr/bin/env bash
# lab-part-01 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" -> "}{.spec.taints}{"\n"}{end}'

cat > "$D/pod-to-worker.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-to-worker
  namespace: the-cart
spec:
  nodeSelector:
    kubernetes.io/hostname: kcna-comico-p01-worker
  containers:
  - name: nginx
    image: $IMG
EOF
$K apply -f "$D/pod-to-worker.yaml"
$K -n the-cart wait --for=condition=Ready pod/pod-to-worker --timeout=60s

cat > "$D/pod-tolerant.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-tolerant
  namespace: the-cart
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
$K apply -f "$D/pod-tolerant.yaml"
$K -n the-cart wait --for=condition=Ready pod/pod-tolerant --timeout=60s

NODE_WORKER=$($K -n the-cart get pod pod-to-worker -o jsonpath='{.spec.nodeName}')
NODE_TOLERANT=$($K -n the-cart get pod pod-tolerant -o jsonpath='{.spec.nodeName}')
TAINT=$($K get node kcna-comico-p01-control-plane -o jsonpath='{.spec.taints[0].effect}')

cat > "$D/04-answer.txt" <<EOF
NODE_POD_SELECTED=$NODE_WORKER
NODE_POD_TOLERANT=$NODE_TOLERANT
TAINT_CONTROL_PLANE=$TAINT
EOF
cat "$D/04-answer.txt"
