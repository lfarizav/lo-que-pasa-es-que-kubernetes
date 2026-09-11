#!/usr/bin/env bash
# lab-part-03 step 4 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
test -f "$D/04-respuesta.txt" || exit 1
POD_ESCRITO=$(grep -oP '(?<=^POD_DEPURADO=).*' "$D/04-respuesta.txt")
CONTENEDOR_ESCRITO=$(grep -oP '(?<=^CONTENEDOR_EFIMERO=).*' "$D/04-respuesta.txt" || true)
test -n "$POD_ESCRITO" || exit 1
test -n "$CONTENEDOR_ESCRITO" || exit 1
$K -n la-cuadra get pod "$POD_ESCRITO" >/dev/null 2>&1 || exit 1
NOMBRES_REALES=$($K -n la-cuadra get pod "$POD_ESCRITO" -o jsonpath='{.spec.ephemeralContainers[*].name}' 2>/dev/null)
echo "$NOMBRES_REALES" | grep -qw "$CONTENEDOR_ESCRITO" || exit 1
OBJETIVO=$($K -n la-cuadra get pod "$POD_ESCRITO" -o jsonpath="{.spec.ephemeralContainers[?(@.name=='$CONTENEDOR_ESCRITO')].targetContainerName}" 2>/dev/null)
test "$OBJETIVO" = "nginx" || exit 1
LOG_REAL=$($K -n la-cuadra logs "$POD_ESCRITO" -c "$CONTENEDOR_ESCRITO" 2>/dev/null)
PROCESOS_REALES=$(echo "$LOG_REAL" | grep -c "nginx: ")
test "$PROCESOS_REALES" -ge 2 2>/dev/null || exit 1
grep -qxF "PROCESOS_NGINX_VISTOS=$PROCESOS_REALES" "$D/04-respuesta.txt" || exit 1
RESTARTS_REAL=$($K -n la-cuadra get pod "$POD_ESCRITO" -o jsonpath='{.status.containerStatuses[?(@.name=="nginx")].restartCount}' 2>/dev/null)
test "$RESTARTS_REAL" = "0" || exit 1
grep -qxF "REINICIOS_DEL_NGINX_ORIGINAL=$RESTARTS_REAL" "$D/04-respuesta.txt" || exit 1
echo ok
