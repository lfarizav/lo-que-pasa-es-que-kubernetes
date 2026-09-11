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
  name: cart-notebook
  namespace: the-block
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: standard
  resources:
    requests:
      storage: 100Mi
EOF
$K apply -f "$D/pvc.yaml"

cat > "$D/pod-with-disk.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-disk
  namespace: the-block
spec:
  containers:
  - name: nginx
    image: $IMG
    volumeMounts:
    - name: disco
      mountPath: /data
  volumes:
  - name: disco
    persistentVolumeClaim:
      claimName: cart-notebook
EOF
$K apply -f "$D/pod-with-disk.yaml"
$K -n the-block wait --for=condition=Ready pod/pod-with-disk --timeout=90s

$K -n the-block get pvc cart-notebook

$K -n the-block exec pod-with-disk -- sh -c 'echo "the-cart-secret-recipe" > /data/recipe.txt'
$K -n the-block exec pod-with-disk -- cat /data/recipe.txt

$K -n the-block delete pod pod-with-disk --wait=true
$K apply -f "$D/pod-with-disk.yaml"
$K -n the-block wait --for=condition=Ready pod/pod-with-disk --timeout=90s

CONTENT=$($K -n the-block exec pod-with-disk -- cat /data/recipe.txt)
STATUS=$($K -n the-block get pvc cart-notebook -o jsonpath='{.status.phase}')
CLASS=$($K -n the-block get pvc cart-notebook -o jsonpath='{.spec.storageClassName}')

cat > "$D/02-answer.txt" <<EOF
STATUS_PVC=$STATUS
CLASS_STORAGE=$CLASS
CONTENT_PERSISTED=$CONTENT
EOF
cat "$D/02-answer.txt"
