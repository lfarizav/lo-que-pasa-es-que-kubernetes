#!/usr/bin/env bash
# lab-part-04 step 1 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/01-respuesta.txt" || exit 1
DISPONIBLE_REAL=$($K get apiservice v1beta1.metrics.k8s.io -o jsonpath='{.status.conditions[0].status}' 2>/dev/null)
test "$DISPONIBLE_REAL" = "True" || exit 1
grep -qxF "APISERVICE_DISPONIBLE=$DISPONIBLE_REAL" "$D/01-respuesta.txt" || exit 1
LISTAS=$($K -n kube-system get deployment metrics-server -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
DESEADAS=$($K -n kube-system get deployment metrics-server -o jsonpath='{.spec.replicas}' 2>/dev/null)
test "$LISTAS" = "1" || exit 1
test "$DESEADAS" = "1" || exit 1
grep -qxF "REPLICAS_METRICS_SERVER=${LISTAS}/${DESEADAS}" "$D/01-respuesta.txt" || exit 1
ARGS=$($K -n kube-system get deployment metrics-server -o jsonpath='{.spec.template.spec.containers[0].args}' 2>/dev/null)
echo "$ARGS" | grep -q "kubelet-insecure-tls" || exit 1
echo ok
