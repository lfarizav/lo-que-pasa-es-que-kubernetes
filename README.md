# Lo que pasa es que Kubernetes

**Los laboratorios del libro.** · **The book's labs.**

Si usted llegó aquí desde el libro, está en el lugar correcto. Aquí están los cuatro
laboratorios completos, uno por cada parte del libro, listos para clonar y ejecutar.

If you got here from the book, you are in the right place. These are the four labs,
one per part of the book, ready to clone and run.

---

## Español

### El libro

**Lo que pasa es que Kubernetes.** *Guía completa de Kubernetes en lenguaje sencillo.*
Trece capítulos en cuatro partes, catorce diagramas, cuatro laboratorios, glosario,
chuleta de examen y preguntas frecuentes. Cubre los dominios de las certificaciones
**KCNA** y **KCSA**.

Es un libro que explica Kubernetes al revés de como suele enseñarse. En vez de empezar
por la jerga y las siglas, empieza por la pregunta que la jerga esconde: qué problema
resuelve esto, y por qué el sistema se comporta como se comporta. Cada capítulo abre con
una analogía cotidiana, un conjunto residencial para la red, el cuaderno de la abuela
para GitOps, el buen mecánico que pregunta antes de destapar el motor, y desde ahí baja
al detalle técnico citando la documentación oficial textualmente donde el examen
pregunta con precisión. La apuesta es explícita: si usted entiende el mecanismo, no
tiene que memorizar la respuesta.

**Parte 1, Fundamentos (capítulos 1 a 5).** Qué es de verdad un contenedor por dentro,
qué promete Kubernetes y qué no hace nunca, los cuatro objetos que se tocan a diario,
a quién le habla usted cuando escribe `kubectl`, y el scheduler: filtrado, puntuación,
binding, y por qué un Pod en Pending no es un error sino una decisión.

**Parte 2, Orquestación (capítulos 6 a 9).** Las cuatro reglas del modelo de red y quién
las implementa con CNI, con el dato que casi ningún curso ha actualizado: la API de
Ingress está congelada y el proyecto recomienda Gateway. Almacenamiento que sobrevive al
Pod. Seguridad en dos planos, RBAC frente a la API y qué puede hacer el contenedor una
vez corriendo. Y las cinco fases de un Pod, con la razón por la que CrashLoopBackOff no
es ninguna de ellas.

**Parte 3, Entrega (capítulos 10 y 11).** Los cuatro principios formales de GitOps según
OpenGitOps, donde el agente hala desde adentro y nadie empuja desde afuera; Helm; la
diferencia real entre entrega y despliegue continuo; y la escalera de depuración para
cuando el Pod sí arrancó y aun así no sirve.

**Parte 4, Arquitectura (capítulos 12 y 13).** Qué dice de verdad la definición oficial
de cloud native, las dos formas de escalar, los niveles de madurez de la CNCF, y
observabilidad: las tres señales y por qué Kubernetes pierde sus registros si usted no
hace nada.

Dedicado al zambullidor colombiano (*Podiceps andinus*), que vivió en los humedales de
la sabana de Bogotá y en el lago de Tota, y se extinguió en 1977 sin que nadie estuviera
viendo.

Material de estudio independiente. No está afiliado a la Cloud Native Computing
Foundation ni a la Linux Foundation, ni cuenta con su respaldo.

### Cuándo hacer cada laboratorio

Hay un laboratorio por cada parte del libro, y cada uno usa **todo** lo de esa parte, no
solo el último capítulo. Así que el momento de hacerlo es cuando usted termina la parte
completa, no antes: si lo intenta a mitad de camino le van a faltar piezas.

| Termine de leer | Y entonces corra | Tiempo | Puntos |
|---|---|---|---|
| Capítulo 5, *El scheduler: cómo Kubernetes decide dónde va cada Pod* (cierra la Parte 1) | `es/lab-part-01` | 50 min | 40 |
| Capítulo 9, *Troubleshooting: cuando el Pod no arranca* (cierra la Parte 2) | `es/lab-part-02` | 55 min | 40 |
| Capítulo 11, *Depuración de aplicaciones dentro del clúster* (cierra la Parte 3) | `es/lab-part-03` | 45 min | 40 |
| Capítulo 13, *Observabilidad y la comunidad cloud native* (cierra la Parte 4) | `es/lab-part-04` | 40 min | 40 |

Si ya leyó el libro entero, puede hacerlos en orden de corrido. Lo que no conviene es
saltárselos: cada laboratorio le deja ver funcionando lo que el capítulo le contó.

### Antes de empezar

Necesita tres herramientas instaladas y funcionando:

| Herramienta | Para qué | Versión con la que se probó |
|---|---|---|
| `docker` | correr los nodos del clúster | 29.8.0 |
| `kind` | crear el clúster de práctica | v0.32.0 |
| `kubectl` | hablarle al clúster | v1.36.1 |

Versiones cercanas también sirven. El clúster se crea con la imagen
`kindest/node:v1.36.1`, fijada por digest, así que el laboratorio se comporta igual hoy
que dentro de un año.

### Empiece aquí

```bash
git clone https://github.com/lfarizav/lo-que-pasa-es-que-kubernetes.git
cd lo-que-pasa-es-que-kubernetes/es/lab-part-01
cat README.md
```

Cada laboratorio se corre siempre igual: primero el montaje, después cada paso con su
verificador, y al final el desmontaje.

```bash
./00-setup.sh                  # crea el clúster y deja todo listo
./01-step.sh && ./01-check.sh  # haga el paso, compruebe que quedó bien
./02-step.sh && ./02-check.sh
./03-step.sh && ./03-check.sh
./04-step.sh && ./04-check.sh
./99-teardown.sh               # borra el clúster y el espacio de trabajo
```

El verificador imprime `ok` cuando el paso quedó bien, y no imprime nada cuando no.
No se conforma con que usted diga que lo hizo: vuelve a consultarle al clúster en vivo.

Los `0N-step.sh` están para que usted no se quede atascado, pero el laboratorio se
aprovecha leyendo el `README.md` del laboratorio y escribiendo usted los comandos.
Corra el script cuando quiera comparar, o cuando algo no salga.

### Su clúster de todos los días no se toca

Cada laboratorio crea su propio clúster, con su propio archivo de kubeconfig en
`/tmp/kcna-lab-N.kubeconfig`, y **todos** los `kubectl` del laboratorio pasan
`--kubeconfig` y `--context` de forma explícita. Su kubeconfig de siempre no se lee ni
se modifica, y el `99-teardown.sh` borra únicamente el clúster de ese laboratorio, por
nombre. Sus otros clústeres de kind siguen donde estaban.

### Qué hace cada laboratorio

| | Capítulos | Laboratorio |
|---|---|---|
| 1 | 1 a 5 | Abra la finca por dentro, arme el carrito con su Pod, su Deployment y su Service, y descubra quién manda al carrito a qué esquina |
| 2 | 6 a 9 | La cuadra entera se comunica con el carrito, el cuaderno de recetas sobrevive el cierre del día, la cocina se cierra a lo peligroso, y usted diagnostica el carrito que no prende |
| 3 | 10 y 11 | Cambie el menú del carrito sin cerrar nunca, devuélvalo cuando la receta nueva sale mal, y entre a la cocina sin apagar la estufa |
| 4 | 12 y 13 | Instale el pesa-recetas que el ecosistema entero usa por debajo, mírelo funcionar, y póngale al carrito el mismo apellido que usa toda la comunidad |

### Si algo no funciona

Revise primero este repositorio: cuando la documentación oficial cambia, la corrección
llega aquí antes que a la siguiente edición impresa. Si el problema sigue, abra un issue
contando qué comando falló, con la versión de Kubernetes y el sistema operativo. Los
reportes de error son bienvenidos y son la forma más rápida de mejorar el material.

Y una advertencia que también está en el libro: nunca corra en un clúster de producción
un comando de un libro, de un blog o de un video sin entender qué hace. Este libro
incluido.

---

## English

### The book

**Here's What's Actually Going On with Kubernetes.** *The complete Kubernetes guide in
plain language.* Thirteen chapters in four parts, fourteen diagrams, four labs, a
glossary, an exam cheat sheet and an FAQ. It covers the domains of the **KCNA** and
**KCSA** certifications.

This book explains Kubernetes the opposite way round from how it is usually taught.
Instead of opening with the jargon and the acronyms, it opens with the question the
jargon hides: what problem does this actually solve, and why does the system behave the
way it does? Every chapter starts from an everyday analogy, a gated residential complex
for the network, your grandmother's notebook for GitOps, the honest mechanic who asks
questions before opening the hood, and from there it goes down into the technical
detail, quoting the official documentation word for word wherever the exam asks with
precision. The bet is explicit: once you understand the mechanism, there is no answer
left to memorize.

**Part 1, Fundamentals (chapters 1 to 5).** What a container really is underneath, what
Kubernetes promises and what it never does, the four objects you touch every day, who
you are really talking to when you type `kubectl`, and the scheduler: filtering,
scoring, binding, and why a Pod stuck in Pending is a decision rather than an error.

**Part 2, Orchestration (chapters 6 to 9).** The four rules of the network model and who
implements them with CNI, including the detail almost no course has updated: the Ingress
API is frozen and the project now points to Gateway. Storage that outlives the Pod.
Security on two planes, RBAC against the API and what the container can do once it is
running. And the five phases of a Pod, with the reason CrashLoopBackOff is none of them.

**Part 3, Delivery (chapters 10 and 11).** The four formal principles of GitOps as
defined by OpenGitOps, where the agent pulls from the inside and nobody pushes from the
outside; Helm; the real difference between continuous delivery and continuous
deployment; and the debugging ladder for when the Pod did start and still does not work.

**Part 4, Architecture (chapters 12 and 13).** What the official cloud native definition
really says, the two ways to scale, the CNCF maturity levels, and observability: the
three signals and why Kubernetes loses your logs if you do nothing about it.

Dedicated to the Colombian grebe (*Podiceps andinus*), which lived in the wetlands of
the Bogota savanna and Lake Tota, and became extinct in 1977 with nobody seeing.

Independent study material. Not affiliated with, endorsed by, or sponsored by the Cloud
Native Computing Foundation or the Linux Foundation.

### When to do each lab

There is one lab per part of the book, and each one uses **everything** in that part,
not just the last chapter. So the moment to do it is when you finish the whole part, not
before: attempt it halfway through and you will be missing pieces.

| Finish reading | Then run | Time | Points |
|---|---|---|---|
| Chapter 5, *The Scheduler: How Kubernetes Decides Where Each Pod Goes* (closes Part 1) | `en/lab-part-01` | 50 min | 40 |
| Chapter 9, *Troubleshooting: When the Pod Will Not Start* (closes Part 2) | `en/lab-part-02` | 55 min | 40 |
| Chapter 11, *Debugging Applications Inside the Cluster* (closes Part 3) | `en/lab-part-03` | 45 min | 40 |
| Chapter 13, *Observability and the Cloud Native Community* (closes Part 4) | `en/lab-part-04` | 40 min | 40 |

If you have already read the whole book, you can run them back to back. What you should
not do is skip them: each lab is where you watch the chapter's explanation actually run.

### Before you start

You need three tools installed and working:

| Tool | What for | Version this was tested on |
|---|---|---|
| `docker` | running the cluster's nodes | 29.8.0 |
| `kind` | creating the practice cluster | v0.32.0 |
| `kubectl` | talking to the cluster | v1.36.1 |

Nearby versions are fine too. The cluster is created from `kindest/node:v1.36.1`,
pinned by digest, so the lab behaves the same today as it will a year from now.

### Start here

```bash
git clone https://github.com/lfarizav/lo-que-pasa-es-que-kubernetes.git
cd lo-que-pasa-es-que-kubernetes/en/lab-part-01
cat README.md
```

Every lab runs the same way: setup first, then each step with its grader, then teardown.

```bash
./00-setup.sh                  # creates the cluster and gets everything ready
./01-step.sh && ./01-check.sh  # do the step, then check that it landed
./02-step.sh && ./02-check.sh
./03-step.sh && ./03-check.sh
./04-step.sh && ./04-check.sh
./99-teardown.sh               # deletes the cluster and the workspace
```

The grader prints `ok` when the step is right and prints nothing when it is not. It does
not take your word for it: it goes back and asks the live cluster.

The `0N-step.sh` scripts are there so you never get stuck, but you get the most out of a
lab by reading its `README.md` and typing the commands yourself. Run the script when you
want to compare, or when something goes wrong.

### Your everyday cluster is never touched

Each lab creates its own cluster with its own kubeconfig file at
`/tmp/kcna-lab-N.kubeconfig`, and **every** kubectl in the lab passes `--kubeconfig` and
`--context` explicitly. Your usual kubeconfig is neither read nor modified, and
`99-teardown.sh` deletes only that lab's cluster, by name. Your other kind clusters stay
exactly where they were.

### What each lab does

| | Chapters | Lab |
|---|---|---|
| 1 | 1 to 5 | Open the homestead up from the inside, build the cart's Pod, Deployment and Service, and find out who sends the cart to which corner |
| 2 | 6 to 9 | The whole block talks to the cart, the recipe notebook survives closing time, the kitchen shuts the door on danger, and you diagnose the cart that will not start |
| 3 | 10 and 11 | Change the cart's menu without ever closing, roll it back when the new recipe goes wrong, and get into the kitchen without turning off the stove |
| 4 | 12 and 13 | Install the recipe scale the whole ecosystem relies on underneath, watch it work, and give the cart the same surname the whole community uses |

### If something does not work

Check this repository first: when the official documentation changes, the correction
lands here before it reaches the next printed edition. If the problem persists, open an
issue saying which command failed, with your Kubernetes version and operating system.
Bug reports are welcome and they are the fastest way to improve the material.

And a warning that is also in the book: never run a command from a book, a blog or a
video on a production cluster without understanding what it does. This book included.

---

_Hecho con ❤️ por Luis Felipe Ariza Vesga._
