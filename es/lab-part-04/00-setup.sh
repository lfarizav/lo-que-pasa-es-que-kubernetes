#!/usr/bin/env bash
# lab-part-04 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-4
cd /tmp/kcna-lab-4

for herramienta in kind kubectl docker curl; do
  command -v "$herramienta" >/dev/null 2>&1 || echo "FALTA: $herramienta - instalelo antes de continuar."
done

kind create cluster --name kcna-comico-p04 \
  --kubeconfig /tmp/kcna-lab-4.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-4.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p04 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p04 create namespace la-cuadra

kubectl config get-contexts

echo "espacio de trabajo listo en /tmp/kcna-lab-4"
echo "si la linea de arriba menciona kcna-comico-p04, el aislamiento fallo: revise el --kubeconfig"
