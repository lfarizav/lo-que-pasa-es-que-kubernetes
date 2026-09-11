#!/usr/bin/env bash
# lab-part-04 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"

curl -sL https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.9.0/components.yaml \
  -o "$D/metrics-server-v0.9.0.yaml"

$K apply -f "$D/metrics-server-v0.9.0.yaml"

$K -n kube-system patch deployment metrics-server --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

$K -n kube-system rollout status deployment/metrics-server --timeout=90s

for i in $(seq 1 40); do
  AVAILABLE=$($K get apiservice v1beta1.metrics.k8s.io -o jsonpath='{.status.conditions[0].status}' 2>/dev/null || true)
  [ "$AVAILABLE" = "True" ] && break
  sleep 3
done

$K get apiservice v1beta1.metrics.k8s.io
$K -n kube-system get deployment metrics-server

REPLICAS=$($K -n kube-system get deployment metrics-server -o jsonpath='{.status.readyReplicas}/{.spec.replicas}')

cat > "$D/01-answer.txt" <<EOF
APISERVICE_AVAILABLE=$AVAILABLE
REPLICAS_METRICS_SERVER=$REPLICAS
EOF
cat "$D/01-answer.txt"
