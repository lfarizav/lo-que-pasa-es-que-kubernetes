#!/usr/bin/env bash
# lab-part-02 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-2
cd /tmp/kcna-lab-2

for herramienta in kind kubectl docker; do
  command -v "$herramienta" >/dev/null 2>&1 || echo "FALTA: $herramienta - instalelo antes de continuar."
done

kind create cluster --name kcna-comico-p02 \
  --kubeconfig /tmp/kcna-lab-2.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-2.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 create namespace la-cuadra

IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  -n la-cuadra create deployment el-carrito --image="$IMG" --replicas=2
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  -n la-cuadra wait --for=condition=Available deployment/el-carrito --timeout=90s

kubectl config get-contexts

echo "espacio de trabajo listo en /tmp/kcna-lab-2"
echo "si la linea de arriba menciona kcna-comico-p02, el aislamiento fallo: revise el --kubeconfig"
