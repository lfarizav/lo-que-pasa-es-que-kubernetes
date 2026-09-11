#!/usr/bin/env bash
# lab-part-03 step 4 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"

POD=$($K -n la-cuadra get pods -l app=el-carrito -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD"

$K -n la-cuadra debug "$POD" --image=busybox:1.36 --target=nginx -- ps aux

NOMBRE_EFIMERO=$($K -n la-cuadra get pod "$POD" -o jsonpath='{.spec.ephemeralContainers[-1:].name}')
echo "NOMBRE_EFIMERO=$NOMBRE_EFIMERO"

for i in $(seq 1 15); do
  LOG_EFIMERO=$($K -n la-cuadra logs "$POD" -c "$NOMBRE_EFIMERO" 2>/dev/null || true)
  if echo "$LOG_EFIMERO" | grep -q "nginx: "; then
    break
  fi
  sleep 2
done
echo "$LOG_EFIMERO"

PROCESOS_NGINX=$(echo "$LOG_EFIMERO" | grep -c "nginx: ")
RESTARTS_ORIGINAL=$($K -n la-cuadra get pod "$POD" -o jsonpath='{.status.containerStatuses[?(@.name=="nginx")].restartCount}')

cat > "$D/04-respuesta.txt" <<EOF
POD_DEPURADO=$POD
CONTENEDOR_EFIMERO=$NOMBRE_EFIMERO
PROCESOS_NGINX_VISTOS=$PROCESOS_NGINX
REINICIOS_DEL_NGINX_ORIGINAL=$RESTARTS_ORIGINAL
EOF
cat "$D/04-respuesta.txt"
