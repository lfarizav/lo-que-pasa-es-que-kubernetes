#!/usr/bin/env bash
# lab-part-01 step 1 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
KC="$D/kcna-lab-1.kubeconfig"
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"

$K get nodes -o wide

CP=$($K get nodes -l node-role.kubernetes.io/control-plane -o jsonpath='{.items[0].metadata.name}')
echo "nodo de control: $CP"

$K -n kube-system get pods -o wide

docker exec "$CP" ls -1 /etc/kubernetes/manifests
docker exec "$CP" sh -c 'ls -1 /etc/kubernetes/manifests | wc -l'

for COMPONENTE in etcd kube-apiserver kube-controller-manager kube-scheduler; do
  printf '%s -> dueno=%s\n' "$COMPONENTE" \
    "$($K -n kube-system get pod "${COMPONENTE}-${CP}" -o jsonpath='{.metadata.ownerReferences[0].kind}')"
done

$K -n kube-system get daemonsets
POD_PROXY=$($K -n kube-system get pods -l k8s-app=kube-proxy -o jsonpath='{.items[0].metadata.name}')
$K -n kube-system get pod "$POD_PROXY" -o jsonpath='{.metadata.ownerReferences[0].kind}{"\n"}'

NUM_NODOS=$($K get nodes --no-headers | wc -l)

cat > "$D/01-respuesta.txt" <<EOF
NODOS_TOTALES=$NUM_NODOS
MANIFIESTOS_ESTATICOS=$(docker exec "$CP" sh -c 'ls -1 /etc/kubernetes/manifests | wc -l' | tr -d '[:space:]')
DUENO_DEL_APISERVER=$($K -n kube-system get pod "kube-apiserver-${CP}" -o jsonpath='{.metadata.ownerReferences[0].kind}')
DUENO_DEL_KUBE_PROXY=$($K -n kube-system get pod "$POD_PROXY" -o jsonpath='{.metadata.ownerReferences[0].kind}')
EOF
cat "$D/01-respuesta.txt"
