#!/usr/bin/env bash
# lab-part-04 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

cat > "$D/deploy-probado.yaml" <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: the-tested-cart
  namespace: the-block
spec:
  replicas: 1
  selector:
    matchLabels:
      app: the-tested-cart
  template:
    metadata:
      labels:
        app: the-tested-cart
    spec:
      containers:
      - name: nginx
        image: $IMG
        livenessProbe:
          httpGet:
            path: /esta-ruta-no-existe
            port: 80
          initialDelaySeconds: 2
          periodSeconds: 3
          failureThreshold: 1
EOF
$K apply -f "$D/deploy-probado.yaml"

for i in $(seq 1 12); do
  sleep 3
  RESTARTS=$($K -n the-block get pods -l app=the-tested-cart -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}' 2>/dev/null || true)
  [ -n "$RESTARTS" ] && [ "$RESTARTS" -ge 1 ] 2>/dev/null && break
done
echo "restarts before the fix: $RESTARTS"
$K -n the-block get events --field-selector reason=Unhealthy -o jsonpath='{range .items[*]}{.reason}{" "}{.message}{"\n"}{end}' | head -3

$K -n the-block patch deployment the-tested-cart --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/httpGet/path","value":"/"}]'
$K -n the-block rollout status deployment/the-tested-cart --timeout=60s

sleep 10
POD=$($K -n the-block get pods -l app=the-tested-cart -o jsonpath='{.items[0].metadata.name}')
READY=$($K -n the-block get pod "$POD" -o jsonpath='{.status.containerStatuses[0].ready}')
PATH_CURRENT=$($K -n the-block get deployment the-tested-cart -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}')

cat > "$D/03-answer.txt" <<EOF
RESTARTS_BEFORE_FIX=$RESTARTS
POD_READY_AFTER_FIX=$READY
PATH_PROBE_FIXED=$PATH_CURRENT
EOF
cat "$D/03-answer.txt"
