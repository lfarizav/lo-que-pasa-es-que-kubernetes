#!/usr/bin/env bash
# lab-part-03 - teardown
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

kind delete cluster --name kcna-comico-p03 \
  --kubeconfig /tmp/kcna-lab-3.kubeconfig

rm -rf /tmp/kcna-lab-3 /tmp/kcna-lab-3.kubeconfig

echo "cluster kcna-comico-p03 eliminado y workspace borrado"
echo "sus otros clusteres de kind siguen intactos:"
kind get clusters
