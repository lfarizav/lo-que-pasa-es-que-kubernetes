#!/usr/bin/env bash
# lab-part-02 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-2
cd /tmp/kcna-lab-2

for tool in kind kubectl docker; do
  command -v "$tool" >/dev/null 2>&1 || echo "MISSING: $tool - install it before continuing."
done

kind create cluster --name kcna-comico-p02 \
  --kubeconfig /tmp/kcna-lab-2.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-2.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 create namespace the-block

IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  -n the-block create deployment the-cart --image="$IMG" --replicas=2
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p02 \
  -n the-block wait --for=condition=Available deployment/the-cart --timeout=90s

kubectl config get-contexts

echo "workspace ready at /tmp/kcna-lab-2"
echo "if the line above mentions kcna-comico-p02, isolation failed: check --kubeconfig"
