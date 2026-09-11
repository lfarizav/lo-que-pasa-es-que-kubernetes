#!/usr/bin/env bash
# lab-part-03 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"

POD=$($K -n la-cuadra get pods -l app=el-carrito -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD"

$K -n la-cuadra exec "$POD" -- ps aux

$K -n la-cuadra exec "$POD" -- sh -c 'echo "version-nginx-en-el-pod" > /tmp/version.txt'

$K -n la-cuadra cp "la-cuadra/${POD}:/tmp/version.txt" "$D/version-copiada.txt"
cat "$D/version-copiada.txt"

CONTENIDO=$(cat "$D/version-copiada.txt")

cat > "$D/03-respuesta.txt" <<EOF
POD_INSPECCIONADO=$POD
ARCHIVO_COPIADO_CONTENIDO=$CONTENIDO
EOF
cat "$D/03-respuesta.txt"
