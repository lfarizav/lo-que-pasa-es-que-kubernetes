#!/usr/bin/env bash
# lab-part-04 step 2 - grader
# Generated from the book's lab source. Do not edit here.
set -euo pipefail

D=/tmp/kcna-lab-4
K="kubectl --kubeconfig /tmp/kcna-lab-4.kubeconfig --context kind-kcna-comico-p04"
test -f "$D/02-answer.txt" || exit 1
grep -qxF "CPU_NODE_GREATER_ZERO=yes" "$D/02-answer.txt" || exit 1
grep -qxF "MEMORY_POD_GREATER_ZERO=yes" "$D/02-answer.txt" || exit 1
CPU_REAL=$($K top nodes --no-headers 2>/dev/null | awk '{print $2}' | tr -d 'm' || true)
test -n "$CPU_REAL" || exit 1
test "$CPU_REAL" -gt 0 2>/dev/null || exit 1
MEM_REAL=$($K -n the-block top pods --no-headers 2>/dev/null | head -1 | awk '{print $3}' | tr -d 'Mi' || true)
test -n "$MEM_REAL" || exit 1
test "$MEM_REAL" -gt 0 2>/dev/null || exit 1
$K -n the-block get deployment the-cart >/dev/null 2>&1 || exit 1
echo ok
