# Part II - Lab: the whole block talks to the cart, the recipe notebook survives closing time, the kitchen shuts the door on danger, and you diagnose the cart that will not start

- Time: 55 min
- Points: 40

## Objective

This is a Tutorial Lab: every step hands you the exact command in its own cmd field. Step 1 has you expose the same Deployment with a ClusterIP Service and a NodePort one, and test both: the cluster's internal DNS resolution and access from outside the Pod (Chapter 6). Step 2 has you request storage with a PersistentVolumeClaim, write a file, delete the Pod, recreate it, and verify with your own eyes that the file is still there because the disk did not die with the Pod (Chapter 7). Step 3 has you harden a namespace with Pod Security Admission's restricted profile, try to sneak in a privileged Pod and watch it get flatly rejected, and then build the Pod that does satisfy the profile's five conditions (Chapter 8). Step 4 has you break a Deployment on purpose with an image tag that does not exist, read the exact failure reason off the Events, and fix it by swapping the image for one pinned by digest (Chapter 9). No check takes your word for it: all four re-query the live cluster at grading time.

## Prerequisites

- A Linux machine with kind, kubectl and docker on PATH, with at least 2 GB of free RAM. The lab creates its own single-node kind cluster named kcna-comico-p02 and deletes it in the teardown.
- ISOLATION. This lab's cluster NEVER touches your everyday kubeconfig: it is created with --kubeconfig /tmp/kcna-lab-2.kubeconfig from the very first command, and absolutely every kubectl in the lab passes --kubeconfig and --context explicitly.
- Internet access when you set the lab up, so kind pulls the node image if it is not already cached and the cluster pulls the digest-pinned nginx image. Grading itself needs no internet.
- PINNED VERSIONS, verified on 2026-08-26 on this same machine. kind v0.32.0. Node image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. Cart image nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. The cluster ships out of the box with the standard StorageClass, backed by rancher.io/local-path, which Step 2 uses as-is, with nothing extra installed. Always confirm what you actually got with kind version and kubectl version, never from memory.
- Having read Chapters 6 through 9. This lab does not re-explain what a Service is, what a PersistentVolumeClaim is, or Pod Security Admission's categories; it makes you operate all four against a real cluster and grades the end state.

## Steps

### 1. Ch. 6: an address that resolves by name, and a door that opens from outside (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Ch. 7: the recipe notebook survives even when the Pod does not (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Ch. 8: the restricted kitchen does not negotiate with the Pod that shows up without the five conditions (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Ch. 9: the cart will not start, and you read the exact reason before touching anything (10 pts)



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
