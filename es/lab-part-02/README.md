# Parte II - Laboratorio: la cuadra entera se comunica con el carrito, el cuaderno de recetas sobrevive el cierre del día, la cocina se cierra a lo peligroso, y usted diagnostica el carrito que no prende

- Tiempo: 55 min
- Puntos: 40

## Objetivo

Este es un laboratorio Tutorial: cada paso le entrega el comando exacto en su propio campo cmd. El Paso 1 le hace exponer el mismo Deployment con un Service ClusterIP y con uno NodePort, y probar los dos: la resolución de DNS interna del clúster y el acceso desde afuera del Pod (Capítulo 6). El Paso 2 le hace pedir almacenamiento con una PersistentVolumeClaim, escribir un archivo, borrar el Pod, recrearlo, y comprobar con sus propios ojos que el archivo sigue ahí porque el disco no murió con el Pod (Capítulo 7). El Paso 3 le hace endurecer un namespace con el perfil restricted de Pod Security Admission, intentar colar un Pod privilegiado y verlo rechazado en seco, y después construir el Pod que sí cumple las cinco condiciones del perfil (Capítulo 8). El Paso 4 le hace romper un Deployment a propósito con una etiqueta de imagen que no existe, leer la razón exacta del fallo en los Events, y arreglarlo cambiando la imagen por una fijada por digest (Capítulo 9). Ninguna comprobación le cree su palabra: las cuatro vuelven a consultar el clúster vivo en el momento de calificar.

## Prerrequisitos

- Una máquina Linux con kind, kubectl y docker en el PATH, con al menos 2 GB de RAM libres. El laboratorio crea su propio clúster kind de un solo nodo llamado kcna-comico-p02 y lo elimina en el teardown.
- AISLAMIENTO. El clúster de este laboratorio NUNCA toca su kubeconfig de siempre: se crea con --kubeconfig /tmp/kcna-lab-2.kubeconfig desde el primer comando, y absolutamente todos los kubectl del laboratorio pasan --kubeconfig y --context explícitamente.
- Acceso a internet en el momento de montar el laboratorio, para que kind descargue la imagen del nodo si no la tiene en caché y el clúster descargue la imagen de nginx fijada por digest. La calificación en sí no necesita internet.
- VERSIONES FIJADAS, verificadas el 2026-08-26 en esta misma máquina. kind v0.32.0. Imagen del nodo kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. Imagen del carrito nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. El clúster trae de fábrica la StorageClass standard, respaldada por rancher.io/local-path, que el Paso 2 usa tal cual viene, sin instalar nada adicional. Confirme siempre lo que de verdad le quedó instalado con kind version y kubectl version, nunca de memoria.
- Haber leído los Capítulos 6 a 9. Este laboratorio no vuelve a explicar qué es un Service, ni qué es una PersistentVolumeClaim, ni las categorías de Pod Security Admission; le hace operar los cuatro contra un clúster real y le califica el estado final.

## Pasos

### 1. Cap. 6: una dirección que se resuelve por nombre, y una puerta que se abre desde afuera (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Cap. 7: el cuaderno de recetas sobrevive aunque el Pod se acabe (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Cap. 8: la cocina restringida no negocia con el Pod que llega sin las cinco condiciones (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Cap. 9: el carrito no prende, y usted lee la razón exacta antes de tocar nada (10 pts)



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

---

_Hecho con ❤️ por Luis Felipe Ariza Vesga._
