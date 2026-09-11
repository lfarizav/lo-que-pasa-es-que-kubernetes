#!/usr/bin/env bash
# lab-part-01 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-1
cd /tmp/kcna-lab-1

for herramienta in kind kubectl docker; do
  command -v "$herramienta" >/dev/null 2>&1 || echo "FALTA: $herramienta - instalelo antes de continuar."
done

cat > /tmp/kcna-lab-1/kind-config.yaml <<'EOF'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
EOF

kind create cluster --name kcna-comico-p01 \
  --config /tmp/kcna-lab-1/kind-config.yaml \
  --kubeconfig /tmp/kcna-lab-1.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-1.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p01 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p01 create namespace el-carrito

kubectl config get-contexts

echo "espacio de trabajo listo en /tmp/kcna-lab-1"
echo "si la linea de arriba menciona kcna-comico-p01, el aislamiento fallo: revise el --kubeconfig"
