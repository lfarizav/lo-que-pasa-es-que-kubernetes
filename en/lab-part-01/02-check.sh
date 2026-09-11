#!/usr/bin/env bash
# lab-part-01 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/02-answer.txt" || exit 1
$K -n the-cart get deployment frying >/dev/null 2>&1 || exit 1
$K -n the-cart get svc charging >/dev/null 2>&1 || exit 1
REPLICAS=$($K -n the-cart get deploy frying -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
test "$REPLICAS" = "3" || exit 1
grep -qxF "REPLICAS_READY=$REPLICAS" "$D/02-answer.txt" || exit 1
TYPE=$($K -n the-cart get svc charging -o jsonpath='{.spec.type}' 2>/dev/null)
test "$TYPE" = "ClusterIP" || exit 1
grep -qxF "TYPE_SERVICE=$TYPE" "$D/02-answer.txt" || exit 1
ENDPOINTS=$($K -n the-cart get endpointslices -l kubernetes.io/service-name=charging -o jsonpath='{.items[0].endpoints[*].addresses[0]}' 2>/dev/null | wc -w | tr -d '[:space:]')
test "$ENDPOINTS" = "3" || exit 1
grep -qxF "ENDPOINTS_SERVICE=$ENDPOINTS" "$D/02-answer.txt" || exit 1
SEL_DEPLOY=$($K -n the-cart get deploy frying -o jsonpath='{.spec.selector.matchLabels}' 2>/dev/null)
SEL_SVC=$($K -n the-cart get svc charging -o jsonpath='{.spec.selector}' 2>/dev/null)
test "$SEL_DEPLOY" = "$SEL_SVC" || exit 1
PODS_APP=$($K -n the-cart get pods -l app=frying --no-headers 2>/dev/null | wc -l | tr -d '[:space:]')
test "$PODS_APP" = "3" || exit 1
echo ok
