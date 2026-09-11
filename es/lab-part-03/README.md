# Parte III - Laboratorio: cambie el menú del carrito sin cerrar nunca, devuélvalo cuando la receta nueva sale mal, y entre a la cocina sin apagar la estufa

- Tiempo: 45 min
- Puntos: 40

## Objetivo

Este es un laboratorio Tutorial: cada paso le entrega el comando exacto en su propio campo cmd. El Paso 1 le hace actualizar un Deployment de una versión de nginx a otra con una actualización progresiva, y comprobar que las tres réplicas terminan en la imagen nueva sin que el carrito dejara de vender en ningún momento (Capítulo 10). El Paso 2 le hace romperlo a propósito con una imagen que no existe, ver el rollout atascado, y devolverlo con kubectl rollout undo, comprobando que el historial de revisiones sí registró el intento fallido y la recuperación (Capítulo 10). El Paso 3 le hace entrar a un Pod corriendo con kubectl exec para leer sus procesos con sus propios ojos, y sacar un archivo de adentro con kubectl cp, sin bajar ni reiniciar nada (Capítulo 11). El Paso 4 cierra con kubectl debug: usted agrega un contenedor efímero a un Pod que ya está corriendo, apuntado al contenedor de nginx, y desde ahí ve los procesos de nginx sin haber tocado el Pod original ni un segundo (Capítulo 11). Ninguna comprobación le cree su palabra: las cuatro vuelven a consultar el clúster vivo en el momento de calificar.

## Prerrequisitos

- Una máquina Linux con kind, kubectl y docker en el PATH, con al menos 2 GB de RAM libres. El laboratorio crea su propio clúster kind de un solo nodo llamado kcna-comico-p03 y lo elimina en el teardown.
- AISLAMIENTO. El clúster de este laboratorio NUNCA toca su kubeconfig de siempre: se crea con --kubeconfig /tmp/kcna-lab-3.kubeconfig desde el primer comando, y absolutamente todos los kubectl del laboratorio pasan --kubeconfig y --context explícitamente.
- Acceso a internet en el momento de montar el laboratorio, para descargar la imagen del nodo si no está en caché y las imágenes de nginx y busybox fijadas por digest/tag. La calificación en sí no necesita internet.
- VERSIONES FIJADAS, verificadas el 2026-08-26 en esta misma máquina. kind v0.32.0. Imagen del nodo kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. Versión inicial nginx:1.28-alpine@sha256:a8b39bd9cf0f83869a2162827a0caf6137ddf759d50a171451b335cecc87d236. Versión nueva nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Imagen de depuración busybox:1.36. Confirme siempre lo que de verdad le quedó instalado con kind version y kubectl version, nunca de memoria.
- Haber leído los Capítulos 10 y 11. Este laboratorio no vuelve a explicar qué es una actualización progresiva, ni qué son los contenedores efímeros; le hace operarlos contra un clúster real y le califica el estado final.

## Pasos

### 1. Cap. 10: cambie la receta del carrito sin cerrar el negocio ni un minuto (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Cap. 10: la receta nueva sale mal, y usted la devuelve sin adivinar nada (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Cap. 11: entre a mirar el Pod por dentro sin tocarlo desde afuera (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Cap. 11: métase a la cocina sin apagar la estufa, con un contenedor efímero (10 pts)



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
