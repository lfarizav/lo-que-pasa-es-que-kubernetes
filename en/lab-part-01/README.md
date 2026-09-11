# Part I - Lab: open the homestead up from the inside, build the cart's Pod, Deployment and Service, and find out who sends the cart to which corner

- Time: 50 min
- Points: 40

## Objective

This is a Tutorial Lab: every step hands you the exact command in its own cmd field, because this is your first hands-on contact with a real cluster, and right now what matters is that the mental model lands crystal clear, not that you memorize syntax under pressure. Step 1 has you open the cluster up from the inside and separate, with data from your own cluster and not a table, the four static Pods the kubelet starts by reading a folder on disk from the ones a controller really does hand out (Chapters 1 and 2). Step 2 has you build the whole cart: a Namespace, a three-replica Deployment, and a Service that gives them a single stable address, and then demands you verify with your own eyes that the Service really does point at those three Pods and no others (Chapter 3). Step 3 has you see the difference between creating something with a single command (imperative) and applying a YAML file (declarative), by looking at an annotation kubectl does or does not leave depending on which path you took (Chapter 4). Step 4 closes with the scheduler: you send a Pod to the worker node with nodeSelector, and then send another to the control-plane node on purpose, which is normally forbidden by a taint, and only works if you add the exact matching toleration (Chapter 5). No check takes your word for it: all four re-query the live cluster at grading time.

## Prerequisites

- A Linux machine with kind, kubectl and docker on PATH, with at least 3 GB of free RAM. The lab creates its own two-node kind cluster named kcna-comico-p01 and deletes it in the teardown.
- ISOLATION, and this is not a matter of style. This lab's cluster NEVER touches your everyday kubeconfig: it is created with --kubeconfig /tmp/kcna-lab-1.kubeconfig from the very first command, and absolutely every kubectl in the lab passes --kubeconfig and --context explicitly. Check it yourself: a kubectl config get-contexts with no --kubeconfig must show no trace of kcna-comico-p01.
- Internet access when you set the lab up: kind pulls the node image if it is not already cached, and the cluster pulls the digest-pinned nginx image. Grading itself needs no internet, only the live cluster and the Docker daemon.
- PINNED VERSIONS, verified on 2026-08-26 on this same machine. kind v0.32.0. Node image kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5, which is that kind release's default image and is passed explicitly here with --image because a tag is mutable and a digest is not. Cart image nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Confirm what you actually got with kind version and kubectl version, never from memory.
- Having read Chapters 1 through 5. This lab does not re-explain what a container is, what each component does, or the difference between Role and ClusterRole; it makes you operate the fundamental objects against a real cluster and grades the end state.

## Steps

### 1. Ch. 1 and 2: who gave the kube-apiserver permission to exist (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Ch. 3: the whole cart, and one address for the two people running it (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Ch. 4: the annotation that gives away whether you ran a command or applied a file (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Ch. 5: the worker gets the Pod because you asked, the control house rejects it unless you bring the key (10 pts)



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
