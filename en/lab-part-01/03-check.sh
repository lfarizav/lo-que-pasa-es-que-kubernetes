#!/usr/bin/env bash
# lab-part-01 step 3 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-1
K="kubectl --kubeconfig /tmp/kcna-lab-1.kubeconfig --context kind-kcna-comico-p01"
test -f "$D/03-answer.txt" || exit 1
$K -n the-cart get pod test-imperative >/dev/null 2>&1 || exit 1
$K -n the-cart get pod test-declarative >/dev/null 2>&1 || exit 1
ANNOT_IMP=$($K -n the-cart get pod test-imperative -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null)
ANNOT_DEC=$($K -n the-cart get pod test-declarative -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null)
test -z "$ANNOT_IMP" || exit 1
test -n "$ANNOT_DEC" || exit 1
grep -qxF "ANNOTATION_IMPERATIVE_EMPTY=yes" "$D/03-answer.txt" || exit 1
grep -qxF "ANNOTATION_DECLARATIVE_EMPTY=no" "$D/03-answer.txt" || exit 1
RESOURCE_REAL=$($K api-resources 2>/dev/null | awk '$1=="deployments"{print $2}')
test "$RESOURCE_REAL" = "deploy" || exit 1
grep -qxF "RESOURCE_SHORT=$RESOURCE_REAL" "$D/03-answer.txt" || exit 1
echo ok
