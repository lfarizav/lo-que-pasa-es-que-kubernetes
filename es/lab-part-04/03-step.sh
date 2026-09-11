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
  name: el-carrito-probado
  namespace: la-cuadra
spec:
  replicas: 1
  selector:
    matchLabels:
      app: el-carrito-probado
  template:
    metadata:
      labels:
        app: el-carrito-probado
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
  REINICIOS=$($K -n la-cuadra get pods -l app=el-carrito-probado -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}' 2>/dev/null || true)
  [ -n "$REINICIOS" ] && [ "$REINICIOS" -ge 1 ] 2>/dev/null && break
done
echo "reinicios antes del fix: $REINICIOS"
$K -n la-cuadra get events --field-selector reason=Unhealthy -o jsonpath='{range .items[*]}{.reason}{" "}{.message}{"\n"}{end}' | head -3

$K -n la-cuadra patch deployment el-carrito-probado --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/httpGet/path","value":"/"}]'
$K -n la-cuadra rollout status deployment/el-carrito-probado --timeout=60s

sleep 10
POD=$($K -n la-cuadra get pods -l app=el-carrito-probado -o jsonpath='{.items[0].metadata.name}')
LISTO=$($K -n la-cuadra get pod "$POD" -o jsonpath='{.status.containerStatuses[0].ready}')
RUTA_ACTUAL=$($K -n la-cuadra get deployment el-carrito-probado -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}')

cat > "$D/03-respuesta.txt" <<EOF
REINICIOS_ANTES_DEL_FIX=$REINICIOS
POD_LISTO_DESPUES_DEL_FIX=$LISTO
RUTA_DEL_PROBE_CORREGIDA=$RUTA_ACTUAL
EOF
cat "$D/03-respuesta.txt"
