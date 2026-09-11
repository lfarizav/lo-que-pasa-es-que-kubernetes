#!/usr/bin/env bash
# lab-part-02 step 1 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-2
K="kubectl --kubeconfig /tmp/kcna-lab-2.kubeconfig --context kind-kcna-comico-p02"
test -f "$D/01-answer.txt" || exit 1
$K -n the-block get svc fixed-menu >/dev/null 2>&1 || exit 1
$K -n the-block get svc takeaway-menu >/dev/null 2>&1 || exit 1
CLUSTERIP=$($K -n the-block get svc fixed-menu -o jsonpath='{.spec.clusterIP}' 2>/dev/null || true)
test -n "$CLUSTERIP" || exit 1
grep -qxF "DNS_RESOLVED=$CLUSTERIP" "$D/01-answer.txt" || exit 1
$K -n the-block get pod client >/dev/null 2>&1 || exit 1
CODE_CLUSTERIP=$($K -n the-block exec client -- sh -c "wget -q -O /dev/null -S --timeout=5 http://${CLUSTERIP}/ 2>&1 | grep -o 'HTTP/1.1 [0-9]*' | head -1 | awk '{print \$2}'" 2>/dev/null)
test "$CODE_CLUSTERIP" = "200" || exit 1
grep -qxF "ANSWER_CLUSTERIP=$CODE_CLUSTERIP" "$D/01-answer.txt" || exit 1
NODEPORT=$($K -n the-block get svc takeaway-menu -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || true)
test -n "$NODEPORT" || exit 1
TYPE=$($K -n the-block get svc takeaway-menu -o jsonpath='{.spec.type}' 2>/dev/null)
test "$TYPE" = "NodePort" || exit 1
NODE=$($K get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
CODE_NODEPORT=$(docker exec "$NODE" curl -s -o /dev/null -w '%{http_code}' --max-time 5 "http://localhost:${NODEPORT}/" 2>/dev/null)
test "$CODE_NODEPORT" = "200" || exit 1
grep -qxF "ANSWER_NODEPORT=$CODE_NODEPORT" "$D/01-answer.txt" || exit 1
echo ok
