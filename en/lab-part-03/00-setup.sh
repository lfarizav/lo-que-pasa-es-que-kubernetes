#!/usr/bin/env bash
# lab-part-03 - setup
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

mkdir -p /tmp/kcna-lab-3
cd /tmp/kcna-lab-3

for tool in kind kubectl docker; do
  command -v "$tool" >/dev/null 2>&1 || echo "MISSING: $tool - install it before continuing."
done

kind create cluster --name kcna-comico-p03 \
  --kubeconfig /tmp/kcna-lab-3.kubeconfig \
  --image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5

KC=/tmp/kcna-lab-3.kubeconfig
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  wait --for=condition=Ready nodes --all --timeout=180s

kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 create namespace the-block

V1="nginx@sha256:a8b39bd9cf0f83869a2162827a0caf6137ddf759d50a171451b335cecc87d236"
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n the-block create deployment the-cart --image="$V1" --replicas=3
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n the-block wait --for=condition=Available deployment/the-cart --timeout=90s
kubectl --kubeconfig "$KC" --context kind-kcna-comico-p03 \
  -n the-block annotate deployment the-cart kubernetes.io/change-cause="initial version v1"

kubectl config get-contexts

echo "workspace ready at /tmp/kcna-lab-3"
echo "if the line above mentions kcna-comico-p03, isolation failed: check --kubeconfig"
