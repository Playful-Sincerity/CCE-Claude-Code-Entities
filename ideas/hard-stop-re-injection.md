---
timestamp: "2026-04-16"
category: architectural-principle
related_project: Claude Code Entities; extends the enforcement spectrum with a new rung
status: articulated; not yet in any session brief
source: Wisdom, end of 2026-04-16 CCE session
related_ideas:
  - ideas/focus-aware-deferred-nudges.md (the previous-strongest non-block mechanism)
  - ideas/breath-rule.md (what the hard-stop typically injects)
---

# Hard-Stop Re-Injection — The Watcher's Interrupt

## The Principle

A new rung on the enforcement spectrum: **deterministic stop + context inject + allowed resume**. Stronger than a nudge (which can be skipped in flow), weaker than a block (which prevents action entirely). Used when the entity is going off-track badly enough that passive nudges won't be absorbed — but the work shouldn't be killed entirely.

Wisdom's framing: *"sometimes the only way to get it to actually listen is if you're deterministically stopping it, and then allow it to resume, but with the injected context of take a breath."*

## The Enforcement Spectrum — Expanded

| Rung | Mechanism | Compliance | Use Case |
|------|-----------|-----------|----------|
| Advisory | Rules loaded into context | 25–80% | Default guidance |
| Scheduled injection | Rules re-loaded periodically | Higher than advisory | Keep values salient |
| Nudge | Stop-hook text in next turn | Skippable in flow | Reminders, soft steering |
| Deferred nudge | Subagent handles while main continues | Preserves flow | Non-urgent checks during deep work |
| **Hard-stop re-injection** | **Forced pause + context inject + resume** | **~100% attention** | **Entity is going off-track; must absorb new context before continuing** |
| Soft block | Warning before action | Deliberative checkpoint | Pre-commit review |
| Hard block | Physical prevention | 100% | Safety-critical gates |
| Training | Weight-level values | Baked in | Foundational posture |

Hard-stop sits between nudge and soft-block. Nudges are text the entity may ignore. Soft blocks stop specific actions. Hard-stop stops the entity itself — briefly — to ensure absorption.

## When It Fires

Fired by an **external watcher**, not by the entity itself. The entity cannot self-interrupt effectively when it's already drifted — it needs something outside to intervene.

**The watcher:**
- Runs on near-real-time cadence (much faster than the sleep loop)
- Reviews recent entity output for specific trigger conditions
- Independent from the main entity (separate process, can be same-model fresh-context or cross-model)
- Has write access to a hard-stop flag file; does NOT modify the entity directly

**Trigger conditions (tunable):**
- Sustained drift from declared task direction (comparing recent actions to current-state.md or SOUL.md)
- Approach to irreversible / high-stakes action without adequate retrieval
- Value conflict not being deliberated
- Time since last breath exceeds critical threshold (and entity shows no sign of pausing)
- Specific keywords/patterns (e.g., entity about to commit something it flagged as uncertain)

## Mechanism Sketch

1. **Watcher subagent** runs on cadence (e.g., every 30 seconds or every 5 tool calls). Reads recent entity activity.
2. **If trigger condition met,** watcher writes a hard-stop flag file: `.state/hard-stop-requests/<timestamp>.md` containing:
   - What the watcher observed
   - Why this warrants a stop
   - What context to inject ("take a breath" + specific observations)
   - Suggested re-orientation
3. **PreToolUse hook** (or Stop hook, depending on timing) checks `.state/hard-stop-requests/` before every tool call:
   - If a hard-stop flag exists → block the tool call, inject the watcher's context into next turn, clear the flag
   - If no flag → proceed normally
4. **Entity absorbs the injected context**, acknowledges it (explicitly), and resumes work with the new orientation.

## Why This Is Architecturally Distinct

Every existing mechanism in CCE is either:
- **Passive** (the entity may or may not respond): nudges, rules, scheduled injection
- **Absolute** (blocks the entity from continuing period): PreToolUse retrieval gate

Hard-stop is neither. It's active and recoverable. The entity is interrupted, shown the new context, and given the chance to incorporate and continue. Like a mentor tapping you on the shoulder mid-work — you stop, you listen, you absorb, you continue with that information now in mind.

## Connection To The Breath Rule

The breath rule's fundamental concern: *nudges may not be listened to in flow*. The focus-aware deferred nudge solution handles it via parallelism (subagent does the check while main continues). But there are cases where parallel handling isn't enough — the main entity's trajectory itself is wrong, and deferring the check doesn't help.

Hard-stop re-injection is the enforcement path for those cases. If the breath nudge is being ignored AND the watcher detects serious drift, the watcher escalates from nudge to hard-stop. "Take a breath" moves from suggestion to intervention.

## Honest Caveats

1. **Over-triggering is costly.** Hard-stops interrupt flow by construction. If the watcher's heuristic is too aggressive, the entity can't get anything done. Needs empirical tuning; start very conservative.

2. **Watcher reliability.** If the watcher itself drifts (same-model paradigm drift), it may fail to catch problems or may fire false alarms. Cross-model watcher is stronger but more expensive. Probably: v1 uses same-model fresh-context watcher; v2 layers cross-model on top.

3. **Entity adversarial adaptation.** If the entity learns to route around hard-stops (e.g., by phrasing actions to avoid the watcher's triggers), we're in Goodhart territory. Mitigation: watcher triggers are simple and transparent; sleep-loop audits hard-stop frequency and whether entity behavior shifted to avoid them.

4. **State consistency on resume.** If a hard-stop fires mid-tool-call, the entity needs clean re-entry. The blocked tool call should be able to be re-invoked cleanly after the injected context is absorbed. Probably: hard-stop fires between tool calls, not mid-call.

## Scope

**V1 — CCE only.** Specifically for entities that have drifted into risky trajectory. The watcher is optional for early entities; required for entities with autonomous operation at any significant scale.

**V2 — Candidate for Digital Core global rule.** Every long-running Claude Code conversation could benefit from a watcher that can hard-stop when the trajectory is clearly off. Requires validation in CCE first.

## Implementation Status

Not yet in any session brief. Should be added as a Phase 1 or Phase 2 brief after the watcher's trigger conditions are empirically specified. Prerequisite: sleep loop (B6) running long enough to produce behavioral baselines.

## Open Questions

1. What exactly are the watcher's trigger conditions? (Needs empirical work)
2. How often does the watcher check? (Real-time is expensive; per-tool-call is efficient)
3. Cross-model watcher from v1, or layer on later?
4. What does "acknowledge the hard-stop" look like from the entity's side? (Free text? Specific format?)
5. How do we prevent hard-stop cascades (hard-stop triggers another hard-stop triggers another)?
