# Part III - Lab: change the cart's menu without ever closing, roll it back when the new recipe goes wrong, and get into the kitchen without turning off the stove

- Time: 45 min
- Points: 40

## Objective

This is a Tutorial Lab: every step hands you the exact command in its own cmd field. Step 1 has you update a Deployment from one nginx version to another with a rolling update, and verify all three replicas end up on the new image without the cart ever stopping selling (Chapter 10). Step 2 has you break it on purpose with an image that does not exist, watch the rollout get stuck, and bring it back with kubectl rollout undo, verifying the revision history really did record the failed attempt and the recovery (Chapter 10). Step 3 has you get into a running Pod with kubectl exec to read its processes with your own eyes, and pull a file out of it with kubectl cp, without bringing anything down or restarting anything (Chapter 11). Step 4 closes with kubectl debug: you add an ephemeral container to a Pod that is already running, targeted at the nginx container, and from there you see nginx's processes without touching the original Pod for a single second (Chapter 11). No check takes your word for it: all four re-query the live cluster at grading time.

## Prerequisites

- A Linux machine with kind, kubectl and docker on PATH, with at least 2 GB of free RAM. The lab creates its own single-node kind cluster named kcna-comico-p03 and deletes it in the teardown.
- ISOLATION. This lab's cluster NEVER touches your everyday kubeconfig: it is created with --kubeconfig /tmp/kcna-lab-3.kubeconfig from the very first command, and absolutely every kubectl in the lab passes --kubeconfig and --context explicitly.
- Internet access when you set the lab up, to pull the node image if it is not cached and the digest/tag-pinned nginx and busybox images. Grading itself needs no internet.
- PINNED VERSIONS, verified on 2026-08-26 on this same machine. kind v0.32.0. Node image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. Starting version nginx:1.28-alpine@sha256:a8b39bd9cf0f83869a2162827a0caf6137ddf759d50a171451b335cecc87d236. New version nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Debug image busybox:1.36. Always confirm what you actually got with kind version and kubectl version, never from memory.
- Having read Chapters 10 and 11. This lab does not re-explain what a rolling update is, or what ephemeral containers are; it makes you operate them against a real cluster and grades the end state.

## Steps

### 1. Ch. 10: change the cart's recipe without closing the shop for a minute (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Ch. 10: the new recipe goes wrong, and you bring it back without guessing (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Ch. 11: get into the Pod to look inside without touching it from outside (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Ch. 11: get into the kitchen without turning off the stove, with an ephemeral container (10 pts)



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

---

_Hecho con ❤️ por Luis Felipe Ariza Vesga._
