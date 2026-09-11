#!/usr/bin/env bash
# lab-part-02 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K create namespace la-cocina-segura
$K label namespace la-cocina-segura pod-security.kubernetes.io/enforce=restricted

cat > "$D/pod-privilegiado.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-privilegiado
  namespace: la-cocina-segura
spec:
  containers:
  - name: nginx
    image: $IMG
    securityContext:
      privileged: true
EOF
SALIDA=$($K apply -f "$D/pod-privilegiado.yaml" 2>&1) || true
echo "$SALIDA"

cat > "$D/pod-restringido.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-restringido
  namespace: la-cocina-segura
spec:
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: $IMG
    securityContext:
      runAsUser: 101
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF
$K apply -f "$D/pod-restringido.yaml"
$K -n la-cocina-segura wait --for=condition=Ready pod/pod-restringido --timeout=60s

RECHAZO=$(printf '%s' "$SALIDA" | grep -o "violates PodSecurity \"restricted[^\"]*\"" | head -1)
ESTADO_RESTRINGIDO=$($K -n la-cocina-segura get pod pod-restringido -o jsonpath='{.status.phase}')
PRIVILEGIADO_EXISTE=$($K -n la-cocina-segura get pod pod-privilegiado --ignore-not-found -o jsonpath='{.metadata.name}')

cat > "$D/03-respuesta.txt" <<EOF
RECHAZO_PRIVILEGIADO=$([ -n "$RECHAZO" ] && echo "si" || echo "no")
PRIVILEGIADO_EXISTE=$([ -z "$PRIVILEGIADO_EXISTE" ] && echo "no" || echo "si")
POD_RESTRINGIDO_ESTADO=$ESTADO_RESTRINGIDO
EOF
cat "$D/03-respuesta.txt"
