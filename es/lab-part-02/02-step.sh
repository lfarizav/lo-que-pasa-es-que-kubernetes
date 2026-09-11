#!/usr/bin/env bash
# lab-part-02 step 2 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

cat > "$D/pvc.yaml" <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cuaderno-del-carrito
  namespace: la-cuadra
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: standard
  resources:
    requests:
      storage: 100Mi
EOF
$K apply -f "$D/pvc.yaml"

cat > "$D/pod-con-disco.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-con-disco
  namespace: la-cuadra
spec:
  containers:
  - name: nginx
    image: $IMG
    volumeMounts:
    - name: disco
      mountPath: /datos
  volumes:
  - name: disco
    persistentVolumeClaim:
      claimName: cuaderno-del-carrito
EOF
$K apply -f "$D/pod-con-disco.yaml"
$K -n la-cuadra wait --for=condition=Ready pod/pod-con-disco --timeout=90s

$K -n la-cuadra get pvc cuaderno-del-carrito

$K -n la-cuadra exec pod-con-disco -- sh -c 'echo "receta-secreta-del-carrito" > /datos/receta.txt'
$K -n la-cuadra exec pod-con-disco -- cat /datos/receta.txt

$K -n la-cuadra delete pod pod-con-disco --wait=true
$K apply -f "$D/pod-con-disco.yaml"
$K -n la-cuadra wait --for=condition=Ready pod/pod-con-disco --timeout=90s

CONTENIDO=$($K -n la-cuadra exec pod-con-disco -- cat /datos/receta.txt)
ESTADO=$($K -n la-cuadra get pvc cuaderno-del-carrito -o jsonpath='{.status.phase}')
CLASE=$($K -n la-cuadra get pvc cuaderno-del-carrito -o jsonpath='{.spec.storageClassName}')

cat > "$D/02-respuesta.txt" <<EOF
ESTADO_PVC=$ESTADO
CLASE_DE_ALMACENAMIENTO=$CLASE
CONTENIDO_PERSISTIDO=$CONTENIDO
EOF
cat "$D/02-respuesta.txt"
