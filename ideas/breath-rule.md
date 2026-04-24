---
timestamp: "2026-04-16"
category: architectural-principle
related_project: Claude Code Entities (seed); candidate for promotion to Digital Core global rule
status: articulated; needs shaping before elevation
source_conversation: 2026-04-16 CCE session — consciousness thesis and sleep loop refinement
philosophical_anchor: Scarlet Max — "pause is powerful"
triggered_by: Wisdom observed an agent (in another conversation) benefiting from being asked to take a breath; noticed agents default to momentum-only mode without periodic trajectory-level reflection
---

# The Breath Rule

## The Principle

A **proactive, trajectory-level pause.** Mid-flow, the entity steps outside its current path to ask:

- Am I still heading where I meant to go?
- Is there a better way I haven't considered?
- What am I not thinking about?
- Have I been building toward the right thing?
- Does this still fit with everything else?

Not reactive to a missed detail. Not longitudinal audit. A **meta-level pause** that interrupts momentum to check whether the trajectory itself is right.

## The Distinction From Existing Mechanisms

| Mechanism | Catches... |
|-----------|-----------|
| Nudges (retrieval budget, SOUL re-injection) | Drift from the known-good pattern within a task |
| Mirror / sleep loop | Longitudinal drift — recent behavior vs SOUL, core file evolution |
| PreToolUse hook | Unsafe actions about to execute |
| **Breath rule** | **The case where the known-good pattern itself is wrong for this moment** |

One-line: nudges catch drift *from* the path; the breath rule catches the case where the path itself needs reconsidering.

## Why This Is Architecturally Real

Agents default to momentum-only mode. Next thing, next thing, next thing. The model's training biases it toward forward motion — tool-call density is rewarded; pausing is not. Without a deterministic interruption, the entity never inhabits the meta-level explicitly; it only *references* SOUL.md between tasks rather than *reflecting on* whether the current direction is serving SOUL.md.

Scarlet Max's "pause is powerful" is the contemplative version of this. Agile retrospectives are the software-engineering version. Socratic examination is the philosophical version. The move is universal: periodically step outside execution to evaluate execution.

## Connection To The Consciousness Thesis

Per the thesis articulated this session: *"Consciousness is the combination of the simulation layer + the meta-simulation layer + the emotional layer, where meta-simulation modulates simulation through emotion as one means among several."*

The breath rule is a **non-emotional modulation channel** — the meta-simulation forcing a trajectory reassessment without an emotion triggering it. It's the **cognitive/reflective modulation** slot from Wisdom's four-part taxonomy of modulation types (cognitive, habitual, reflexive, emotional).

Breath is how meta-simulation asserts itself when no other signal is firing. The periodic re-inhabitation of the observer position.

## When It Fires

Three complementary triggers (all should exist):

1. **Scheduled (cron-like).** Ensures breath happens even in deep flow. E.g., every K tool calls OR N minutes of active work, whichever first. Hard fallback: at least once per session of substantial length.
2. **Entity-invokable.** The entity can self-trigger — "I sense I've been going deep for a while; let me take a breath." Respect for the entity's own awareness of depth.
3. **Event-triggered.** Before major transitions (starting a new phase, before writing a persistent artifact, at the end of a deliverable).

Likely implementation: a Stop-hook counter similar to SOUL re-injection, plus a `/breath` skill/slash-command for self-invocation, plus pre-specified event-trigger patterns.

## The Content Of The Breath

When fired, the entity spends a small amount of output doing explicit meta-reflection. Structure:

1. **Where am I?** — one sentence on current task and current step within it.
2. **Where was I heading?** — one sentence on the intended destination.
3. **Is the path still right?** — honest check: am I still on trajectory, or have I drifted into adjacent work?
4. **What am I not seeing?** — naming a blind spot. "I haven't considered X." Even a partial answer is better than skipping this.
5. **What would simplify?** — could this be smaller? Is there a cheaper path? What darlings should I murder?
6. **Continue / adjust / stop.** — one of three explicit choices before proceeding.

The entity writes this to chronicle briefly. The breath IS the entity's self-aware pause.

## Scope

**V1 — CCE only.** Seed the mechanism, tune the triggers, observe whether it actually improves work quality without being mere overhead.

**V2 — Candidate for Digital Core global rule.** If the breath rule demonstrably improves entity quality in CCE, it's worth promoting to a rule that loads for every conversation in the Digital Core. Every long-running agent — PD, HHA flows, paper-drafting sessions, research rounds — would benefit from periodic trajectory-level reflection.

**Important:** per existing rule memory, new Digital Core rules require Wisdom's explicit approval. This file is idea-level. Promotion to DC rule requires a separate explicit go-ahead from Wisdom after the shape is tuned in CCE.

## BREATH.md — A Core-Tier Entity File

**Wisdom, 2026-04-16:** *"The breath markdown file is actually probably an important one of the core things up there with SOUL.md and HEARTBEAT.md, and it's something that can be modulated for different entities."*

This promotes breath from a rule/mechanism into a **core-tier entity configuration file**, peer to SOUL.md (identity) and HEARTBEAT.md (operational cadence).

### The triad

| File | What it defines | Scope |
|------|-----------------|-------|
| **SOUL.md** | Who I am, what I value | Identity / values |
| **HEARTBEAT.md** | When I wake, how often I act | Operational cadence |
| **BREATH.md** | When I pause, how I reflect | Reflective cadence |

All three are per-entity configurable. All three are immutable-to-the-entity (Wisdom edits; the entity proposes changes via the proposals flow).

### BREATH.md schema (tentative)

```markdown
---
entity: <name>
last_updated: YYYY-MM-DD
---

# BREATH.md

## Cadence
- scheduled_trigger_interval: <every K tool calls OR N minutes>
- max_session_length_without_breath: <hard fallback>

## Content Template
- reflection_questions: [list of questions this entity pauses on]
- default: "Where am I? Where was I heading? Is the path still right? What am I not seeing? What would simplify? Continue / adjust / stop?"

## Entity-Specific Modulation
<Per-entity tuning — a research entity might breathe less frequently because long flow is productive; an operational entity like Frank's assistant might breathe more because high-stakes decisions warrant frequent trajectory checks. Document the reasoning here.>

## Event Triggers
- before_persistent_writes: true | false
- before_task_transitions: true | false
- on_entity_invocation: true (always)

## Interaction With Other Systems
- sleep loop reviews breath history for trajectory patterns
- focus-aware deferred nudges may delegate breath to a subagent during flow
- evolution audit (Job 2b) tracks how BREATH.md itself changes over time
```

### Why per-entity modulation matters

Different entities face different cost/benefit tradeoffs:

- **Research entity (long flow productive):** breathe sparsely, ~every 50 tool calls or at natural phase transitions
- **Operational entity (high-stakes decisions):** breathe frequently, ~every 10 tool calls or before any irreversible action
- **HHA client-facing entity (relational):** breathe before each outbound message; check alignment with client values
- **Paper-drafting entity (craft):** breathe at each major section boundary to reassess argument structure

A rigid global cadence would under-serve all of these. BREATH.md as a per-entity file lets modulation fit the work.

### Initialization

When a new entity is scaffolded, the template includes a default BREATH.md with conservative scheduled cadence. Wisdom (or the entity, via proposal) tunes it over time based on observed behavior.

## Honest Caveats

1. **Bureaucratization risk.** If breath fires too often, it becomes overhead. If too rarely, it doesn't catch trajectory drift. Cadence tuning matters.

2. **Performative breath.** The entity could write a breath that looks reflective but doesn't actually interrogate the trajectory. Mitigation: the Mirror / sleep-loop review can check breath quality over time (did the breath produce a trajectory change when one was warranted?).

3. **Flow-interruption cost.** Breaking flow to breathe has a real cognitive cost for the entity. This is the same tension as focus-aware deferred nudges — in high-value flow, maybe the breath fires the subagent pattern (delegated breath rather than interrupted breath).

4. **What if the trajectory is actually right?** The breath shouldn't always produce a change. "Continue" is a valid outcome. The value of breath is making the choice *explicit* — not producing churn.

## Open Questions

1. What's the right cadence? Empirically tune.
2. Should the breath produce a chronicle entry every time, or only when it produces a change?
3. Should breath be followable by sleep-loop review (the sleep loop audits breath history for patterns)?
4. When does breath interact with focus-aware deferred nudges — can a breath BE a deferred-nudge-style subagent, or must it be in-flow?
5. Does breath belong as a skill (`/breath`), a hook (Stop-hook counter), or both?
6. Should entities have different breath cadences based on entity type / task type?

## Implementation Notes (Tentative)

Not yet in any session brief. Candidate for a B8 if the shape holds up:

- `B8 — Breath rule implementation` (Phase 1, parallel-safe, no deps)
- Deliverables: Stop-hook counter for scheduled breath, `/breath` skill for self-invocation, chronicle-entry format for breath reports, tests

Alternatively, fold into B6 (sleep loop) as a sub-mechanism — sleep loop reviews breath history and flags trajectory patterns.

## Provenance

Articulated by Wisdom 2026-04-16 in the session that produced the consciousness-as-modulation thesis. The idea emerged from Wisdom observing that asking an agent (in a separate conversation) to "take a breath" improved its work. This file seeds the architectural design; elevation to CCE implementation brief and then to Digital Core global rule requires further shaping and explicit Wisdom approval.
