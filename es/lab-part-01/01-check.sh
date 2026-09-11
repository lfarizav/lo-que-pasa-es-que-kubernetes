#!/usr/bin/env bash
# lab-part-01 step 1 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/01-respuesta.txt" || exit 1
CP=$($K get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$CP" || exit 1
docker inspect "$CP" >/dev/null 2>&1 || exit 1
NUM_NODOS=$($K get nodes --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')
grep -qxF "NODOS_TOTALES=$NUM_NODOS" "$D/01-respuesta.txt" || exit 1
MANIF=$(docker exec "$CP" sh -c 'ls -1 /etc/kubernetes/manifests 2>/dev/null | wc -l' | tr -d '[:space:]')
test "$MANIF" -ge 4 || exit 1
grep -qxF "MANIFIESTOS_ESTATICOS=$MANIF" "$D/01-respuesta.txt" || exit 1
for ARCHIVO in $(docker exec "$CP" sh -c 'ls -1 /etc/kubernetes/manifests' | tr -d '\r'); do
  COMPONENTE="${ARCHIVO%.yaml}"
  DUENO=$($K -n kube-system get pod "${COMPONENTE}-${CP}" -o jsonpath='{.metadata.ownerReferences[0].kind}' 2>/dev/null)
  test "$DUENO" = "Node" || exit 1
done
DUENO_API=$($K -n kube-system get pod "kube-apiserver-${CP}" -o jsonpath='{.metadata.ownerReferences[0].kind}' 2>/dev/null)
test "$DUENO_API" = "Node" || exit 1
grep -qxF "DUENO_DEL_APISERVER=$DUENO_API" "$D/01-respuesta.txt" || exit 1
POD_PROXY=$($K -n kube-system get pods -l k8s-app=kube-proxy -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
test -n "$POD_PROXY" || exit 1
DUENO_PROXY=$($K -n kube-system get pod "$POD_PROXY" -o jsonpath='{.metadata.ownerReferences[0].kind}' 2>/dev/null)
test "$DUENO_PROXY" = "DaemonSet" || exit 1
grep -qxF "DUENO_DEL_KUBE_PROXY=$DUENO_PROXY" "$D/01-respuesta.txt" || exit 1
$K -n kube-system get daemonset kube-proxy >/dev/null 2>&1 || exit 1
echo ok
