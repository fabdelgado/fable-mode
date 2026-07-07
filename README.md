# Fable Mode

**El playbook de razonamiento que Claude Fable 5 escribió sobre sí mismo, instalable en cualquier Claude Code.**

En julio de 2026, antes de que Fable 5 pasara a pago por uso, le pedimos una cosa: que documentara su propia forma de trabajar — el orden de operaciones detrás de sus respuestas, sus criterios para dar algo por terminado y los errores que se prohíbe a sí mismo. Este repo empaqueta ese autorretrato como un skill instalable, para que cualquier modelo (Opus 4.8 incluido) ejecute la misma disciplina.

📖 **La historia completa del experimento** — cómo se extrajo el playbook, las rondas de iteración A/B y los resultados de la evaluación ciega — está contada en el blog: [Cloné los hábitos de Fable 5 en un skill open source](https://ketoro.com.uy/blog/clonar-fable-5-habitos-skill/).

**Qué instala:**

- **Skill `fable-mode`** — el playbook completo: protocolo de 6 fases (encuadre → plan → ejecución → auto-refutación → loop de verificación → entrega), checklists por tipo de tarea, criterios de "terminado" y anti-patrones. Se activa con `/fable-mode`, diciendo "modo fable", o solo, cuando la tarea lo amerita.
- **Reglas siempre activas en `~/.claude/CLAUDE.md`** — las 6 reglas núcleo condensadas, que aplican en cada sesión sin invocar nada.

## Instalación

### Opción 1 — Una línea (recomendada: instala skill + reglas)

```bash
curl -fsSL https://raw.githubusercontent.com/fabdelgado/fable-mode/main/install.sh | bash
```

### Opción 2 — Plugin nativo de Claude Code (instala el skill)

Dentro de Claude Code:

```
/plugin marketplace add fabdelgado/fable-mode
/plugin install fable-mode@fable-mode
```

Para las reglas siempre activas, pegá el contenido de [`templates/CLAUDE-rules.md`](templates/CLAUDE-rules.md) en tu `~/.claude/CLAUDE.md`.

### Opción 3 — Manual

1. Copiá [`skills/fable-mode/SKILL.md`](skills/fable-mode/SKILL.md) a `~/.claude/skills/fable-mode/SKILL.md`
2. Pegá [`templates/CLAUDE-rules.md`](templates/CLAUDE-rules.md) al final de tu `~/.claude/CLAUDE.md`

En todos los casos: abrí una sesión **nueva** de Claude Code para que cargue.

## Cómo se usa

La configuración es en capas, y cada capa tiene un costo distinto en tokens:

- **Base (costo cero):** las reglas del `CLAUDE.md` corren solas en cada sesión. Para trabajo rutinario, alcanzan.
- **Protocolo completo:** invocá `/fable-mode` (o dejá que se active solo) en features, debugging, escritura larga o decisiones. Suma el loop de verificación y los checklists.
- **Razonamiento profundo:** en problemas caros (arquitectura, bugs esquivos), sumá `ultrathink` indicando *en qué* profundizar — casos límite, seguridad, rendimiento. En trabajo crítico y largo, `ultracode` habilita verificación multiagente.

El presupuesto de razonamiento es un recurso: gastalo según lo que cuesta equivocarse en esa tarea, no por costumbre.

## Validación A/B contra Fable real

Este skill no es teórico: se iteró contra salidas reales de Fable 5 hasta converger. Metodología: cada tarea de prueba la corrieron dos agentes en contextos independientes — Opus 4.8 con el skill como instrucciones obligatorias vs. Fable 5 nativo sin instrucciones — y se compararon las salidas con una rúbrica de 8 criterios de comportamiento (apertura con el resultado, verificación con evidencia, disciplina de alcance, recomendación única, calibración de forma, supuestos marcados, prosa sin narración de protocolo).

Tras 3 rondas de iteración (4 brechas detectadas y corregidas), dos corridas de validación independientes — 20 tareas en total, cubriendo debugging en Python/JavaScript/SQL/bash, decisiones técnicas, seguridad, premisas falsas, estimación bajo presión, escritura ejecutiva y trampas de alcance — dieron **20 de 20 pares convergidos**. Detalle completo, historial de iteración y limitaciones honestas de la evaluación (no es un benchmark ciego; la varianza residual es simétrica entre ambos lados) en [`eval/README.md`](eval/README.md).

## Qué esperar (y qué no)

Este skill codifica **disciplina, no inteligencia extra**. En problemas de frontera, un modelo más capaz sin hábitos le sigue ganando a uno menos capaz con ellos. Lo que la disciplina compra es otra cosa: elimina las fallas evitables — la afirmación sin verificar, el "terminado" que no se probó, el alcance que se infla solo — y esas fallas son la mayoría de los errores del trabajo diario. Además, a diferencia de una suscripción, los hábitos viajan con vos al próximo modelo.

### Estimá tu propio porcentaje

"¿Qué % de Fable me da el clon?" no tiene una sola respuesta: depende de tu mezcla de tareas. Los dos regímenes se comportan distinto:

| Régimen | Qué incluye | Cuánto cierra el clon | Base |
|---|---|---|---|
| Trabajo diario | bugs autocontenidos, decisiones técnicas, reviews, escritura, estimaciones | ~95-100% | Medido: 20/20 pares convergidos + evaluación ciega (ver [`eval/`](eval/README.md)) |
| Cola difícil | cadenas agénticas largas, bugs sutiles multi-archivo, diseño novedoso | ~70-80% | Estimado, no medido — el techo de capacidad no se copia |

Cuenta rápida: **tu % ≈ (proporción de trabajo diario × 0.95) + (proporción de cola difícil × 0.75)**. Un dev de producto típico (90/10) queda en ~93%. Un perfil pesado en agentes largos (50/50) queda en ~85%, y ahí la brecha se siente.

### Cuándo pagar créditos por el original

Regla de escalada, en orden:

1. **Por defecto, el clon.** Todo el trabajo diario, que es la gran mayoría del volumen.
2. **Escalá al original cuando el clon falló dos veces en el mismo problema** con el loop de verificación activado. Ese es el señalador empírico de que estás contra el techo del modelo, no contra un hábito faltante — más iteraciones del clon no lo van a resolver.
3. **Arrancá directo con el original** solo cuando el costo de un error supera con claridad el costo de los créditos: agente crítico en producción, deadline caro, decisión difícil de revertir. Pagás el pico, no la suscripción mental de "todo con el mejor modelo".

La trampa a evitar es la inversa: usar el original para trabajo rutinario "por las dudas". A ~2x el precio y consumiendo límites al doble de velocidad, eso es pagar techo para tareas de piso.

## Origen

El `SKILL.md` fue generado por Claude Fable 5 en julio de 2026, documentando en primera persona su propio proceso de razonamiento — sus fases de trabajo, sus criterios de terminado y sus anti-patrones — como instrucciones directas para el modelo que lo lea. El historial de este repo es la evidencia.

---

## English

**The reasoning playbook Claude Fable 5 wrote about itself, installable in any Claude Code.** In July 2026, before Fable 5 moved to usage-based pricing, we asked it to document its own way of working: the order of operations behind its answers, its done criteria, and the errors it forbids itself. This repo packages that self-portrait as an installable skill (6-phase protocol, per-task checklists, anti-patterns) plus always-on rules for `~/.claude/CLAUDE.md`.

📖 The full story of the experiment — playbook extraction, A/B iteration rounds, and the blind-judge results — is on the blog (Spanish): [Cloné los hábitos de Fable 5 en un skill open source](https://ketoro.com.uy/blog/clonar-fable-5-habitos-skill/).

**Install (one-liner):**

```bash
curl -fsSL https://raw.githubusercontent.com/fabdelgado/fable-mode/main/install.sh | bash
```

**Or as a native plugin:** `/plugin marketplace add fabdelgado/fable-mode` → `/plugin install fable-mode@fable-mode`, then paste [`templates/CLAUDE-rules.md`](templates/CLAUDE-rules.md) into your `~/.claude/CLAUDE.md`.

Trigger with `/fable-mode` or by saying "fable mode". What to expect: this encodes discipline, not extra intelligence — it eliminates the avoidable failures (unverified claims, false completions, scope drift) that make up most everyday errors, and the habits transfer to whatever model you run next.

**Estimate your own percentage:** the clone closes ~95-100% of the gap on daily work (measured) and an estimated ~70-80% on frontier work (long agentic chains, novel design — capability ceilings don't copy). Your number ≈ daily share × 0.95 + frontier share × 0.75. **When to pay for the original:** default to the clone; escalate to Fable credits when the clone fails twice on the same problem with the verification loop on, or start with the original when an error clearly costs more than the credits.

**A/B validated:** the skill was iterated against native Fable 5 outputs until convergence — Opus 4.8 + skill vs. Fable 5, same prompts, independent contexts, 8-criterion behavioral rubric. Two validation runs on 20 distinct tasks (Python/JS/SQL/bash debugging, technical decisions, security review, false premises, estimation, executive writing, scope traps): **20/20 task pairs converged**. Method, iteration history, and honest limitations in [`eval/README.md`](eval/README.md).

## Licencia

MIT
