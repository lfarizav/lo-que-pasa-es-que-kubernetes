# Parte I - Laboratorio: abra la finca por dentro, arme el carrito con su Pod, su Deployment y su Service, y descubra quién manda al carrito a qué esquina

- Tiempo: 50 min
- Puntos: 40

## Objetivo

Este es un laboratorio Tutorial: cada paso le entrega el comando exacto en su propio campo cmd, porque este es su primer contacto con las manos puestas sobre un clúster real, y ahorita lo que importa es que el modelo mental le quede clarísimo, no que usted memorice sintaxis bajo presión. El Paso 1 le hace abrir el clúster por dentro y separar, con datos de su propio clúster y no de un cuadro, los cuatro Pods estáticos que arranca el kubelet leyendo una carpeta del disco de los que sí reparte un controlador (Capítulos 1 y 2). El Paso 2 le hace armar el carrito completo: un Namespace, un Deployment de tres réplicas, y un Service que les da una sola dirección estable, y después le exige comprobar con sus propios ojos que el Service de verdad apunta a esos tres Pods y a ningún otro (Capítulo 3). El Paso 3 le hace ver la diferencia entre crear algo de un solo comando (imperativo) y aplicar un archivo YAML (declarativo), mirando una anotación que kubectl deja o no deja según el camino que usted tomó (Capítulo 4). El Paso 4 cierra con el scheduler: usted manda un Pod al nodo trabajador con nodeSelector, y después manda otro al nodo de control-plane a propósito, lo cual normalmente está prohibido por un taint, y solo funciona si usted le agrega la tolerancia exacta (Capítulo 5). Ninguna comprobación le cree su palabra: las cuatro vuelven a consultar el clúster vivo en el momento de calificar.

## Prerrequisitos

- Una máquina Linux con kind, kubectl y docker en el PATH, con al menos 3 GB de RAM libres. El laboratorio crea su propio clúster kind de dos nodos llamado kcna-comico-p01 y lo elimina en el teardown.
- AISLAMIENTO, y esto no es un detalle de estilo. El clúster de este laboratorio NUNCA toca su kubeconfig de siempre: se crea con --kubeconfig /tmp/kcna-lab-1.kubeconfig desde el primer comando, y absolutamente todos los kubectl del laboratorio pasan --kubeconfig y --context explícitamente. Compruébelo usted mismo: un kubectl config get-contexts sin --kubeconfig no debe mostrar ni rastro de kcna-comico-p01.
- Acceso a internet en el momento de montar el laboratorio: kind descarga la imagen del nodo si no la tiene en caché, y el clúster descarga la imagen de nginx fijada por digest. La calificación en sí no necesita internet, solo el clúster vivo y el demonio de Docker.
- VERSIONES FIJADAS, verificadas el 2026-08-26 en esta misma máquina. kind v0.32.0. Imagen del nodo kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5, que es la imagen por defecto de esa versión de kind y aquí se pasa explícita con --image porque un tag es mutable y un digest no. Imagen del carrito nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Confirme lo que de verdad le quedó instalado con kind version y kubectl version, nunca de memoria.
- Haber leído los Capítulos 1 a 5. Este laboratorio no vuelve a explicar qué es un contenedor, ni qué componente hace qué, ni la diferencia entre Role y ClusterRole; le hace operar los objetos fundamentales contra un clúster real y le califica el estado final.

## Pasos

### 1. Cap. 1 y 2: quién le dio permiso al kube-apiserver para existir (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Cap. 3: el carrito completo, y una sola dirección para las dos personas que lo atienden (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Cap. 4: la anotación que delata si usted mandó un comando o aplicó un archivo (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Cap. 5: el trabajador recibe el Pod porque usted se lo pidió, la casa de control lo rechaza a menos que usted traiga la llave (10 pts)



```bash
./04-step.sh
./04-check.sh
```

## Cómo correrlo

```bash
./00-setup.sh
./01-step.sh && ./01-check.sh
./02-step.sh && ./02-check.sh
./03-step.sh && ./03-check.sh
./04-step.sh && ./04-check.sh
./99-teardown.sh
```
