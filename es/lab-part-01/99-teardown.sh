#!/usr/bin/env bash
# lab-part-01 - teardown
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

kind delete cluster --name kcna-comico-p01 \
  --kubeconfig /tmp/kcna-lab-1.kubeconfig

rm -rf /tmp/kcna-lab-1 /tmp/kcna-lab-1.kubeconfig

echo "cluster kcna-comico-p01 eliminado y workspace borrado"
echo "sus otros clusteres de kind siguen intactos:"
kind get clusters
