#!/usr/bin/env bash
# lab-part-02 - teardown
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

kind delete cluster --name kcna-comico-p02 \
  --kubeconfig /tmp/kcna-lab-2.kubeconfig

rm -rf /tmp/kcna-lab-2 /tmp/kcna-lab-2.kubeconfig

echo "cluster kcna-comico-p02 eliminado y workspace borrado"
echo "sus otros clusteres de kind siguen intactos:"
kind get clusters
