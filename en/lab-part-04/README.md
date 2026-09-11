# Part IV - Lab: install the recipe scale the whole ecosystem relies on underneath, watch it work, and give the cart the same surname the whole community uses

- Time: 40 min
- Points: 40

## Objective

This is a Tutorial Lab: every step hands you the exact command in its own cmd field. Step 1 has you install metrics-server, the project that gives Kubernetes the API aggregation layer that dozens of CNCF ecosystem projects later build on, with the specific tweak it needs on kind (Chapter 12). Step 2 has you use that installation to read real CPU and memory numbers with kubectl top, the simplest entry point into observability (Chapter 13). Step 3 has you break a Deployment on purpose with a liveness probe pointing at a path that does not exist, watch the restarts climb on their own, and fix it without removing the control (Chapter 13). Step 4 has you add the app.kubernetes.io recommended labels the whole Kubernetes community uses to the Deployment, so third-party tools can identify your resources without guessing (Chapter 13). No check takes your word for it: all four re-query the live cluster at grading time.

## Prerequisites

- A Linux machine with kind, kubectl and docker on PATH, with at least 2 GB of free RAM. The lab creates its own single-node kind cluster named kcna-comico-p04 and deletes it in the teardown.
- ISOLATION. This lab's cluster NEVER touches your everyday kubeconfig: it is created with --kubeconfig /tmp/kcna-lab-4.kubeconfig from the very first command, and absolutely every kubectl in the lab passes --kubeconfig and --context explicitly.
- Internet access when you set the lab up: kind pulls the node image if it is not cached, the cluster pulls the digest-pinned nginx image, and Step 1 downloads the official metrics-server manifest from GitHub. Grading itself needs no internet.
- PINNED VERSIONS, verified on 2026-08-26 on this same machine. kind v0.32.0. Node image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. metrics-server v0.9.0, the latest official release published by kubernetes-sigs at the time this lab was written, installed from its official components.yaml. Cart image nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Always confirm what you actually got with kind version and kubectl version, never from memory.
- Having read Chapters 12 and 13. This lab does not re-explain what the API aggregation layer is, what liveness probes are, or the recommended labels; it makes you operate them against a real cluster and grades the end state.

## Steps

### 1. Ch. 12: install the recipe scale the whole CNCF ecosystem relies on underneath (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Ch. 13: weigh the cart with real numbers, not guesses (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Ch. 13: the cart shuts itself off when the health recipe is written wrong, and you fix it without removing the watchman (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Ch. 13: give the cart the same surname the whole community uses (10 pts)



```bash
./04-step.sh
./04-check.sh
```

## How to run

```bash
./00-setup.sh
./01-step.sh && ./01-check.sh
./02-step.sh && ./02-check.sh
./03-step.sh && ./03-check.sh
./04-step.sh && ./04-check.sh
./99-teardown.sh
```
