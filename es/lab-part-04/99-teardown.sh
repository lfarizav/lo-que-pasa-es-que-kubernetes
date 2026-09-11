#!/usr/bin/env bash
# lab-part-04 - teardown
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

kind delete cluster --name kcna-comico-p04 \
  --kubeconfig /tmp/kcna-lab-4.kubeconfig

rm -rf /tmp/kcna-lab-4 /tmp/kcna-lab-4.kubeconfig

echo "cluster kcna-comico-p04 eliminado y workspace borrado"
echo "sus otros clusteres de kind siguen intactos:"
kind get clusters
