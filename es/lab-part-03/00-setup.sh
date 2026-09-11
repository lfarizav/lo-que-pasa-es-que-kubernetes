#!/usr/bin/env bash
# lab-part-03 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-3
cd /tmp/kcna-lab-3

for herramienta in kind kubectl docker; do
  command -v "$herramienta" >/dev/null 2>&1 || echo "FALTA: $herramienta - instalelo antes de continuar."
done

kind create cluster --name kcna-comico-p03 \
  --kubeconfig /tmp/kcna-lab-3.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-3.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 create namespace la-cuadra

V1="nginx@sha256:a8b39bd9cf0f83869a2162827a0caf6137ddf759d50a171451b335cecc87d236"
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n la-cuadra create deployment el-carrito --image="$V1" --replicas=3
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n la-cuadra wait --for=condition=Available deployment/el-carrito --timeout=90s
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n la-cuadra annotate deployment el-carrito kubernetes.io/change-cause="version inicial v1"

kubectl config get-contexts

echo "espacio de trabajo listo en /tmp/kcna-lab-3"
echo "si la linea de arriba menciona kcna-comico-p03, el aislamiento fallo: revise el --kubeconfig"
