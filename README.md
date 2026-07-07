# Fable Mode

**El playbook de razonamiento que Claude Fable 5 escribió sobre sí mismo, instalable en cualquier Claude Code.**

En julio de 2026, antes de que Fable 5 pasara a pago por uso, le pedimos una cosa: que documentara su propia forma de trabajar — el orden de operaciones detrás de sus respuestas, sus criterios para dar algo por terminado y los errores que se prohíbe a sí mismo. Este repo empaqueta ese autorretrato como un skill instalable, para que cualquier modelo (Opus 4.8 incluido) ejecute la misma disciplina.

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

## Qué esperar (y qué no)

Este skill codifica **disciplina, no inteligencia extra**. En problemas de frontera, un modelo más capaz sin hábitos le sigue ganando a uno menos capaz con ellos. Lo que la disciplina compra es otra cosa: elimina las fallas evitables — la afirmación sin verificar, el "terminado" que no se probó, el alcance que se infla solo — y esas fallas son la mayoría de los errores del trabajo diario. Además, a diferencia de una suscripción, los hábitos viajan con vos al próximo modelo.

## Origen

El `SKILL.md` fue generado por Claude Fable 5 en julio de 2026, documentando en primera persona su propio proceso de razonamiento — sus fases de trabajo, sus criterios de terminado y sus anti-patrones — como instrucciones directas para el modelo que lo lea. El historial de este repo es la evidencia.

---

## English

**The reasoning playbook Claude Fable 5 wrote about itself, installable in any Claude Code.** In July 2026, before Fable 5 moved to usage-based pricing, we asked it to document its own way of working: the order of operations behind its answers, its done criteria, and the errors it forbids itself. This repo packages that self-portrait as an installable skill (6-phase protocol, per-task checklists, anti-patterns) plus always-on rules for `~/.claude/CLAUDE.md`.

**Install (one-liner):**

```bash
curl -fsSL https://raw.githubusercontent.com/fabdelgado/fable-mode/main/install.sh | bash
```

**Or as a native plugin:** `/plugin marketplace add fabdelgado/fable-mode` → `/plugin install fable-mode@fable-mode`, then paste [`templates/CLAUDE-rules.md`](templates/CLAUDE-rules.md) into your `~/.claude/CLAUDE.md`.

Trigger with `/fable-mode` or by saying "fable mode". What to expect: this encodes discipline, not extra intelligence — it eliminates the avoidable failures (unverified claims, false completions, scope drift) that make up most everyday errors, and the habits transfer to whatever model you run next.

## Licencia

MIT
