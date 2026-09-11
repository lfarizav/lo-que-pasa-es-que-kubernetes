#!/usr/bin/env bash
# lab-part-04 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"

$K -n the-block label deployment the-cart \
  app.kubernetes.io/name=the-cart \
  app.kubernetes.io/part-of=the-block-app \
  app.kubernetes.io/managed-by=kubectl

$K -n the-block patch deployment the-cart --type=merge -p '{
  "spec": {
    "template": {
      "metadata": {
        "labels": {
          "app.kubernetes.io/name": "the-cart",
          "app.kubernetes.io/part-of": "the-block-app",
          "app.kubernetes.io/managed-by": "kubectl"
        }
      }
    }
  }
}'
$K -n the-block rollout status deployment/the-cart --timeout=90s

$K -n the-block get deployment the-cart --show-labels
$K -n the-block get pods -l app.kubernetes.io/name=the-cart

NAME=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.labels.app\.kubernetes\.io/name}')
MANAGED_BY=$($K -n the-block get deployment the-cart -o jsonpath='{.metadata.labels.app\.kubernetes\.io/managed-by}')
PODS_WITH_LABEL=$($K -n the-block get pods -l app.kubernetes.io/name=the-cart --no-headers | wc -l)

cat > "$D/04-answer.txt" <<EOF
LABEL_NAME=$NAME
LABEL_MANAGED_BY=$MANAGED_BY
PODS_WITH_LABEL_RECOMMENDED=$PODS_WITH_LABEL
EOF
cat "$D/04-answer.txt"
