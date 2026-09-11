#!/usr/bin/env bash
# lab-part-02 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/03-respuesta.txt" || exit 1
NIVEL=$($K get namespace la-cocina-segura -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)
test "$NIVEL" = "restricted" || exit 1
$K -n la-cocina-segura get pod pod-privilegiado >/dev/null 2>&1 && exit 1
grep -qxF "PRIVILEGIADO_EXISTE=no" "$D/03-respuesta.txt" || exit 1
grep -qxF "RECHAZO_PRIVILEGIADO=si" "$D/03-respuesta.txt" || exit 1
ESTADO=$($K -n la-cocina-segura get pod pod-restringido -o jsonpath='{.status.phase}' 2>/dev/null)
test "$ESTADO" = "Running" || exit 1
grep -qxF "POD_RESTRINGIDO_ESTADO=$ESTADO" "$D/03-respuesta.txt" || exit 1
DROP=$($K -n la-cocina-segura get pod pod-restringido -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop[0]}' 2>/dev/null)
test "$DROP" = "ALL" || exit 1
NONROOT=$($K -n la-cocina-segura get pod pod-restringido -o jsonpath='{.spec.securityContext.runAsNonRoot}' 2>/dev/null)
test "$NONROOT" = "true" || exit 1
echo ok
