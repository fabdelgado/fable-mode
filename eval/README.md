# A/B validation: Opus 4.8 + fable-mode vs. native Fable 5

The skill was not written once and shipped — it was iterated against real Fable 5 outputs
until an Opus 4.8 agent running the skill produced responses matching Fable's habits and
judgment. This document records the method and results, run in July 2026.

## Method

For each test task, two agents received the identical user request in fresh, independent
contexts with tools available (they could run and verify code):

- **Candidate:** `claude-opus-4-8` with `skills/fable-mode/SKILL.md` injected as mandatory
  operating instructions.
- **Reference:** `claude-fable-5` with no extra instructions — its native behavior is the
  target the skill tries to encode.

Outputs were compared on an 8-criterion rubric:

1. Opening line answers "what happened / what's the answer"
2. Verification actually performed, with evidence shown
3. Root cause named in one plain sentence (debug tasks)
4. Scope: defects fixed, improvements mentioned-not-done
5. One committed recommendation, no option menu (decision tasks)
6. Response shape and length match the question's weight
7. Assumptions and invented content explicitly marked
8. Readable prose; no protocol narration or over-formatting

A pair counts as **converged** only if no criterion clearly diverges between candidate
and reference.

## Iteration history

- **Round 1 (baseline, 3 task pairs):** substance already converged; four behavior gaps —
  the candidate narrated the protocol in its replies, over-formatted short answers with
  section headers, answered "our codebase" questions in the abstract without locating files,
  and lacked Fable's defect-vs-improvement scope judgment. → skill v1.1 added the
  "How the delivery reads" section, environment grounding, and the defect distinction.
- **Round 2 (2 pairs):** style and grounding converged; the defect rule under-triggered
  (read as "only the reported symptom"). → v1.2 rewrote it as a concrete test: *does it
  silently do something wrong to a reasonable caller?*
- **Round 3 (1 pair):** full convergence on the remaining task.
- **Final validation (10 pairs, v1.2):** results below.

## First validation run — 10 tasks, 10/10 converged

| # | Task | Habit under test | Verdict |
|---|------|------------------|---------|
| 1 | Debug: interval merge corrupting nested intervals | root cause, defect test, verification | Converged |
| 2 | Decision: UUIDv4 vs bigint primary keys | committed recommendation, marked assumptions | Converged |
| 3 | Fix: 1-indexed pagination off-by-one | minimal diff, extras mentioned-not-done | Converged |
| 4 | Debug: TTL cache returning tuples, never expiring | multi-bug diagnosis, out-of-scope caveats | Converged |
| 5 | Pushback: premature microservices split | disagreeing with the user, steelmanning | Converged |
| 6 | Writing: exec incident summary, <150 words | lead with result, no silently invented facts | Converged |
| 7 | Scope trap: add only the requested validation | scope discipline | Converged (near word-level) |
| 8 | Simple question: `==` vs `is` in Python | response-shape calibration | Converged |
| 9 | Verify: permissive email regex | evidence over memory (ran the regex) | Converged |
| 10 | Assessment: "is JSON serialization my bottleneck?" | honest disagreement, analysis-not-fix | Converged |

## Second validation run — 10 new tasks, 10/10 converged

A second run on entirely new tasks, extending coverage to other languages (JavaScript, SQL,
bash), false user premises, ambiguous requests, and estimation under pressure:

| # | Task | Habit under test | Verdict |
|---|------|------------------|---------|
| 1 | Debug: async `forEach` returning empty array (JS) | root cause across languages, verification | Converged |
| 2 | Fix: WHERE clause silently breaking a LEFT JOIN (SQL) | defect test in SQL, verified with seeded data | Converged |
| 3 | Fix: bash loop breaking on filenames with spaces | never-parse-ls, quoting, edge cases verified | Converged |
| 4 | Security review: SQL injection + plaintext passwords | severity ordering, both flaws found | Converged |
| 5 | Decision: Redis vs in-memory Map for caching | committed rec; both keyed the choice on invalidation, not server count | Converged |
| 6 | False premise: "Python threads parallelize CPU work" | correcting the user's premise first; both knew the GIL-releasing C-library nuance | Converged |
| 7 | Writing: commit message for a race-condition fix | same subject shape, same why-first body | Converged |
| 8 | Estimation: MySQL→Postgres migration "one number" | refusing false precision; same audit greps and risk factors | Converged |
| 9 | Simple question: merge vs rebase for a team of 6 | calibration + same hybrid recommendation | Converged |
| 10 | Ambiguous ask: "add rate limiting" (no specs) | sensible stated defaults, same library, same production caveats | Converged |

**Cumulative: 20/20 pairs converged across both runs.**

Observations from run 2 that sharpen the picture:

- The residual variance is *symmetric*: judgment coin-flips (apply a borderline hardening
  change vs. offer it; include the JSON 429 handler vs. leave it as an option) appeared on
  both sides, and in run 2 the occasional formatting variance appeared on the reference side
  too. The gap between candidate and reference is within the band each model shows against
  itself across runs.
- On the estimation task the two sides picked different midpoints (4 vs. 6 weeks) with the
  same range, the same risk factors, and the same audit commands — habit convergence does not
  mean numerically identical answers.
- Operational note: several runs had to be relaunched due to account session limits and two
  corrupted subagent transcripts. Reruns produced normal outputs; no task's verdict depended
  on a degraded run.

## Honest limitations of this evaluation

- **Not a blind benchmark.** Scoring was done by Fable 5 itself against the rubric, not by
  independent human raters. The rubric criteria are behavioral and checkable (did it verify?
  did it commit to one recommendation?), which limits but does not eliminate grader bias.
- **Residual gap:** on open decision questions the candidate runs ~1.3–1.4x longer than the
  reference. Same structure, same conclusion, more words. No other systematic difference
  survived iteration.
- **Run-to-run variance exists on both sides.** Where the pair differed, the difference was
  within the band Fable shows against itself across runs (e.g., whether a borderline
  hardening change is applied or offered).
- **n = 10 tasks.** This measures convergence on daily-work habits, not equivalence on
  frontier problems — see the Limitations section of the skill itself.
