#!/usr/bin/env bash
# lab-part-02 step 3 (10 pts)
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
IMG="nginx@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b"

$K create namespace the-safe-kitchen
$K label namespace the-safe-kitchen pod-security.kubernetes.io/enforce=restricted

cat > "$D/pod-privileged.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-privileged
  namespace: the-safe-kitchen
spec:
  containers:
  - name: nginx
    image: $IMG
    securityContext:
      privileged: true
EOF
OUTPUT=$($K apply -f "$D/pod-privileged.yaml" 2>&1) || true
echo "$OUTPUT"

cat > "$D/pod-restricted.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-restricted
  namespace: the-safe-kitchen
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
$K apply -f "$D/pod-restricted.yaml"
$K -n the-safe-kitchen wait --for=condition=Ready pod/pod-restricted --timeout=60s

REJECTION=$(printf '%s' "$OUTPUT" | grep -o "violates PodSecurity \"restricted[^\"]*\"" | head -1)
STATUS_RESTRICTED=$($K -n the-safe-kitchen get pod pod-restricted -o jsonpath='{.status.phase}')
PRIVILEGED_EXISTS=$($K -n the-safe-kitchen get pod pod-privileged --ignore-not-found -o jsonpath='{.metadata.name}')

cat > "$D/03-answer.txt" <<EOF
REJECTION_PRIVILEGED=$([ -n "$REJECTION" ] && echo "yes" || echo "no")
PRIVILEGED_EXISTS=$([ -z "$PRIVILEGED_EXISTS" ] && echo "no" || echo "yes")
POD_RESTRICTED_STATUS=$STATUS_RESTRICTED
EOF
cat "$D/03-answer.txt"
