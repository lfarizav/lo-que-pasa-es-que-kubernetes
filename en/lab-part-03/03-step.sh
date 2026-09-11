#!/usr/bin/env bash
# lab-part-03 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-3
K="kubectl --kubeconfig /tmp/kcna-lab-3.kubeconfig --context kind-kcna-comico-p03"

POD=$($K -n the-block get pods -l app=the-cart -o jsonpath='{.items[0].metadata.name}')
echo "POD=$POD"

$K -n the-block exec "$POD" -- ps aux

$K -n the-block exec "$POD" -- sh -c 'echo "nginx-version-in-the-pod" > /tmp/version.txt'

$K -n the-block cp "the-block/${POD}:/tmp/version.txt" "$D/version-copiada.txt"
cat "$D/version-copiada.txt"

CONTENT=$(cat "$D/version-copiada.txt")

cat > "$D/03-answer.txt" <<EOF
POD_INSPECTED=$POD
FILE_COPIED_CONTENT=$CONTENT
EOF
cat "$D/03-answer.txt"
