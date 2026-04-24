---
timestamp: "2026-04-16"
category: architectural-principle
related_project: Claude Code Entities (but ecosystem-level — applies to Claude Code, Companion, PS Bot, any agent)
status: articulated; needs /think-deep
source_speech: ../knowledge/sources/wisdom-speech/2026-04-16-retrieval-over-weights.md
---

# Retrieval-Over-Weights as Architectural Default

## The Principle

An agent's default posture should be: **don't answer from weights; find real data.**

Weights-reasoning remains available as an explicit operation. But the architecture biases toward retrieval-from-grounded-sources (memories, documents, web, research, code) over generate-from-LLM-knowledge. Not "always retrieve" — "prefer retrieval, know when you're generating, make it structurally hard to default to generation."

This is the **Associative Memory principle applied at the behavioral architecture level**, before the graph is built.

## Two Drift Types (consolidating the research round)

| Drift Type | Timescale | Mechanism | Structural Answer |
|---|---|---|---|
| **Value-drift** | Long-horizon (sessions/weeks) | Self-modification of rules/values drifts away from intent | Layered self-modification ordering (memory → skills → rules → hooks), proposals with review |
| **Output-drift (hallucination)** | Per-response | Weights-generation produces ungrounded claims | Retrieval-first posture as structural default |

The Stream 1 research addressed value-drift. This principle addresses output-drift. Both are required. Neither covers the other.

## Nuances to Hold

1. **Not every question needs retrieval.** "What's 2 + 2" doesn't. The principle is "prefer retrieval when accuracy matters," not "always retrieve." Implies: *calibration of when weights are enough* is itself a load-bearing capability.

2. **Retrieval isn't automatically ground truth.** MINJA poisons memory (95% success against production agents per Stream B). Stale sources mislead. "Grounded in retrieval" is weaker than "grounded in provenance." Every retrieved fact needs source + trust weighting. Otherwise hallucination just moves one layer down.

3. **Weights-reasoning is genuinely useful.** The goal is *not-default-to-it*, not *never-use-it*. The entity's judgment about WHEN weights-only is sufficient has to be built — as a calibration skill.

## Why It's Load-Bearing

The biggest failures of agentic systems share a root cause — the agent operating from weights instead of from grounded, retrieved, provenanced data:
- Hallucination (output-drift from ground truth, every response)
- Context overflow (over-reasoning instead of over-retrieving)
- Generic/unanchored answers (retrieval skipped)
- Silent value drift (compound effect of small ungrounded choices)

A structural bias toward retrieval addresses all four at once, upstream.

## Wisdom's Constraint

Must be structural, not markdown.

> "a powerful behaviorism that's not just in markdown files — it's actually architectural and structural and deterministic"

Rule files in context have 25–80% compliance (Stream B: SNCS 0.245–0.545 to 0.80). That's not enough for something this load-bearing. The mechanism needs hook-level or scheduled-context-injection-level reliability.

## Candidate Structural Mechanisms (for /think-deep)

1. **Epistemic status annotation** — every claim in a response is tagged at source: `[memory]`, `[retrieved]`, `[reasoned]`, `[weights-only]`. Makes weights-reasoning visible instead of invisible. Nudge or hook enforces tagging.

2. **Living world-model file** — entity maintains `world-model.md` per project. Substantive responses link back to specific sections. Updating the file is a deliberate act, not an automatic one. **The project world-model connects UP to the Digital Core's own world-model** — the DC is the meta-world-model that each project's world-model is a specialized extension of. Learning and best practices flow both directions.

3. **Retrieval budget nudge** — N turns without a Read / Grep / WebFetch triggers a Stop-hook nudge. Simple, cheap. Doesn't block, just reminds.

4. **Entity-level retrieval check (heartbeat)** — a reviewing entity subagent on heartbeat cadence reviews recent responses and flags "weights-only" ones for backfill with retrieval or explicit marking. (Note on naming: "entity," not "companion" — Companion is a specific project; the generic pattern is an entity reviewing another entity.)

5. **Pre-output gate** — for high-stakes outputs (certain file paths, certain tool calls, publications), a PreToolUse hook requires at least one retrieval since the last such output.

6. **Scheduled world-model re-injection** — cron-fed context injection re-loads the current world-model summary periodically, keeping it salient rather than relying on once-at-session-start presence.

7. **Confidence-gated output** — outputs self-declare confidence. Low confidence triggers mandatory retrieval before commit.

8. **Retrieval-first prompt structure** — system prompt explicitly says "before generating substantive content, check what you already know from memory/docs/web." This is weak on its own (markdown problem) but useful in combination with the above.

None of these is a full answer. Combinations probably win. The /think-deep should work out which combinations give the best reliability-to-friction ratio.

## The Nudge-as-Value-Association Insight (Wisdom, 2026-04-16)

Nudges fired on cadence function as **value-association mechanisms.** The nudge checks the entity against stated values; the entity modulates its behavior based on its own assessment of that check, plus other signals. This is the Mirror pattern from the Convergence Paper working as a drift-check mechanism on BOTH drift types simultaneously:

- Against **output-drift**: the nudge asks "have you been generating from weights instead of retrieval?"
- Against **value-drift**: the nudge asks "have recent decisions aligned with stated values?"

Same mechanism, two surfaces. A Mirror-style subagent + scheduled nudge is the unified structural answer to both drift types — which is exactly what makes this principle so load-bearing: the architecture that solves output-drift ALSO solves value-drift, if designed right.

## Connections

- **Associative Memory** — this is the same philosophy, operationalized at the behavior layer before the graph is built
- **Earned Conviction** (Convergence Paper `ideas/03-earned-conviction.md`) — convictions are built from retrieved experience, not installed; this principle is the runtime analogue
- **Stream 1 Research** — the layered ordering (memory → skills → rules → hooks) assumed values existed; this principle is about how outputs get made in the first place
- **MINJA / memory poisoning** (Stream B §3.1) — why retrieval needs provenance, not just retrieval
- **"Do LLMs Follow Their Own Rules?"** (2026, SNCS 0.245–0.80) — why markdown isn't enough

## Status

- **Articulated:** 2026-04-16 (Wisdom, speech preserved)
- **/think-deep:** pending
- **Implementation scope:** starts in CCE; generalizes to Digital Core if validated
