#!/usr/bin/env bash
# lab-part-01 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K api-resources | grep -w deployments

$K -n the-cart run test-imperative --image="$IMG"
$K -n the-cart wait --for=condition=Ready pod/test-imperative --timeout=60s

cat > "$D/test-declarative.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: test-declarative
  namespace: the-cart
spec:
  containers:
  - name: nginx
    image: $IMG
EOF
$K apply -f "$D/test-declarative.yaml"
$K -n the-cart wait --for=condition=Ready pod/test-declarative --timeout=60s

ANNOT_IMPERATIVE=$($K -n the-cart get pod test-imperative -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}')
ANNOT_DECLARATIVE=$($K -n the-cart get pod test-declarative -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}')
RESOURCE=$($K api-resources | awk '$1=="deployments"{print $2}')

cat > "$D/03-answer.txt" <<EOF
ANNOTATION_IMPERATIVE_EMPTY=$([ -z "$ANNOT_IMPERATIVE" ] && echo "yes" || echo "no")
ANNOTATION_DECLARATIVE_EMPTY=$([ -z "$ANNOT_DECLARATIVE" ] && echo "yes" || echo "no")
RESOURCE_SHORT=$RESOURCE
EOF
cat "$D/03-answer.txt"
