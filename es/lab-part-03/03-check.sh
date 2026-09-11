#!/usr/bin/env bash
# lab-part-03 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"
test -f "$D/03-respuesta.txt" || exit 1
test -f "$D/version-copiada.txt" || exit 1
POD_ESCRITO=$(grep -oP '(?<=^POD_INSPECCIONADO=).*' "$D/03-respuesta.txt" || true)
test -n "$POD_ESCRITO" || exit 1
$K -n la-cuadra get pod "$POD_ESCRITO" >/dev/null 2>&1 || exit 1
PS_REAL=$($K -n la-cuadra exec "$POD_ESCRITO" -- ps aux 2>/dev/null)
echo "$PS_REAL" | grep -q "nginx: master process" || exit 1
echo "$PS_REAL" | awk '$1==1 && $2=="root"{found=1} END{exit !found}' || exit 1
CONTENIDO_REAL=$($K -n la-cuadra exec "$POD_ESCRITO" -- cat /tmp/version.txt 2>/dev/null)
CONTENIDO_COPIADO=$(cat "$D/version-copiada.txt")
test "$CONTENIDO_REAL" = "$CONTENIDO_COPIADO" || exit 1
grep -qxF "ARCHIVO_COPIADO_CONTENIDO=$CONTENIDO_COPIADO" "$D/03-respuesta.txt" || exit 1
RESTARTS=$($K -n la-cuadra get pod "$POD_ESCRITO" -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)
test "$RESTARTS" = "0" || exit 1
echo ok
