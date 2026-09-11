#!/usr/bin/env bash
# lab-part-04 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"

$K -n la-cuadra label deployment el-carrito \
  app.kubernetes.io/name=el-carrito \
  app.kubernetes.io/part-of=la-cuadra-app \
  app.kubernetes.io/managed-by=kubectl

$K -n la-cuadra patch deployment el-carrito --type=merge -p '{
  "spec": {
    "template": {
      "metadata": {
        "labels": {
          "app.kubernetes.io/name": "el-carrito",
          "app.kubernetes.io/part-of": "la-cuadra-app",
          "app.kubernetes.io/managed-by": "kubectl"
        }
      }
    }
  }
}'
$K -n la-cuadra rollout status deployment/el-carrito --timeout=90s

$K -n la-cuadra get deployment el-carrito --show-labels
$K -n la-cuadra get pods -l app.kubernetes.io/name=el-carrito

NOMBRE=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.labels.app\.kubernetes\.io/name}')
GESTIONADO_POR=$($K -n la-cuadra get deployment el-carrito -o jsonpath='{.metadata.labels.app\.kubernetes\.io/managed-by}')
PODS_CON_ETIQUETA=$($K -n la-cuadra get pods -l app.kubernetes.io/name=el-carrito --no-headers | wc -l)

cat > "$D/04-respuesta.txt" <<EOF
ETIQUETA_NOMBRE=$NOMBRE
ETIQUETA_GESTIONADO_POR=$GESTIONADO_POR
PODS_CON_ETIQUETA_RECOMENDADA=$PODS_CON_ETIQUETA
EOF
cat "$D/04-respuesta.txt"
