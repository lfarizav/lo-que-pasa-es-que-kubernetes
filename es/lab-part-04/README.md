# Parte IV - Laboratorio: instale el pesa-recetas que el ecosistema entero usa por debajo, mírelo funcionar, y póngale al carrito el mismo apellido que usa toda la comunidad

- Tiempo: 40 min
- Puntos: 40

## Objetivo

Este es un laboratorio Tutorial: cada paso le entrega el comando exacto en su propio campo cmd. El Paso 1 le hace instalar metrics-server, el proyecto que le da a Kubernetes la capa de agregación de la API que después usan decenas de proyectos del ecosistema CNCF, con el ajuste puntual que necesita en kind (Capítulo 12). El Paso 2 le hace usar esa instalación para leer números reales de CPU y memoria con kubectl top, la puerta de entrada más simple a la observabilidad (Capítulo 13). El Paso 3 le hace romper un Deployment a propósito con un liveness probé apuntando a una ruta que no existe, ver los reinicios subir solos, y arreglarlo sin quitar el control (Capítulo 13). El Paso 4 le hace ponerle al Deployment las etiquetas recomendadas app.kubernetes.io que toda la comunidad de Kubernetes usa para que las herramientas de terceros puedan identificar sus recursos sin adivinar (Capítulo 13). Ninguna comprobación le cree su palabra: las cuatro vuelven a consultar el clúster vivo en el momento de calificar.

## Prerrequisitos

- Una máquina Linux con kind, kubectl y docker en el PATH, con al menos 2 GB de RAM libres. El laboratorio crea su propio clúster kind de un solo nodo llamado kcna-comico-p04 y lo elimina en el teardown.
- AISLAMIENTO. El clúster de este laboratorio NUNCA toca su kubeconfig de siempre: se crea con --kubeconfig /tmp/kcna-lab-4.kubeconfig desde el primer comando, y absolutamente todos los kubectl del laboratorio pasan --kubeconfig y --context explícitamente.
- Acceso a internet en el momento de montar el laboratorio: kind descarga la imagen del nodo si no está en caché, el clúster descarga la imagen de nginx fijada por digest, y el Paso 1 descarga el manifiesto oficial de metrics-server desde GitHub. La calificación en sí no necesita internet.
- VERSIONES FIJADAS, verificadas el 2026-08-26 en esta misma máquina. kind v0.32.0. Imagen del nodo kindest/node:v1.36.1@sha256:3489c7674813ba5d8b1a9977baea8a6e553784dab7b84759d1014dbd78f7ebd5. metrics-server v0.9.0, el release oficial más reciente publicado por kubernetes-sigs en el momento de escribir este laboratorio, instalado desde su components.yaml oficial. Imagen del carrito nginx:1.29.5-alpine@sha256:1eff5a5f3fcf8431a0abb7eddf5471fec24e5e1905a2581aeacdb07a4479b92b. Confirme siempre lo que de verdad le quedó instalado con kind version y kubectl version, nunca de memoria.
- Haber leído los Capítulos 12 y 13. Este laboratorio no vuelve a explicar qué es la capa de agregación de la API, ni qué son los liveness probes, ni las etiquetas recomendadas; le hace operarlos contra un clúster real y le califica el estado final.

## Pasos

### 1. Cap. 12: instale el pesa-recetas que todo el ecosistema CNCF usa por debajo (10 pts)



```bash
./01-step.sh
./01-check.sh
```

### 2. Cap. 13: pese el carrito con números reales, no con adivinanzas (10 pts)



```bash
./02-step.sh
./02-check.sh
```

### 3. Cap. 13: el carrito se apaga solo cuando la receta de salud está mal escrita, y usted lo arregla sin quitarle el vigilante (10 pts)



```bash
./03-step.sh
./03-check.sh
```

### 4. Cap. 13: póngale al carrito el mismo apellido que usa toda la comunidad (10 pts)



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
