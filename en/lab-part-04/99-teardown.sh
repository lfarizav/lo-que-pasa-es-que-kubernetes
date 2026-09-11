#!/usr/bin/env bash
# lab-part-04 - teardown
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

kind delete cluster --name kcna-comico-p04 \
  --kubeconfig /tmp/kcna-lab-4.kubeconfig

rm -rf /tmp/kcna-lab-4 /tmp/kcna-lab-4.kubeconfig

echo "cluster kcna-comico-p04 deleted and workspace removed"
echo "your other kind clusters are untouched:"
kind get clusters
