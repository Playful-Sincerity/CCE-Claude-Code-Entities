---
timestamp: "2026-04-16"
category: architectural-principle
related_project: Claude Code Entities (ecosystem-relevant — applies to any entity/agent with flow states)
status: articulated; needs implementation
source_speech: ../knowledge/sources/wisdom-speech/2026-04-16-focus-aware-nudges-and-value-relationships.md
triggered_by: conversation-audit finding that nudges get skipped during intense work sessions
---

# Focus-Aware Deferred Nudges

## The Principle

When a nudge fires and the entity is in a flow state, **spawn a subagent to handle the nudge's concern in parallel**. Main entity stays in flow. Subagent's result surfaces at a natural breakpoint.

A new rung on the enforcement spectrum, sitting between "advisory nudge that gets skipped in flow" and "hard block that always fires."

## Why It's Load-Bearing

Conversation-audit finding: certain nudges are skipped during intense work sessions. The current enforcement stack offers only two responses:

1. **Break flow** — entity handles the nudge, losing context and momentum
2. **Skip nudge** — flow preserved, but drift risk

Both are bad trade-offs. Focus-aware deferral creates a third option: **handle it elsewhere, preserve flow, ensure the check happens.**

This is how mature humans handle interruptions — delegate with enough context, or defer-with-commitment. It's also the right shape for long-running autonomous entities that will have both flow states AND background concerns needing attention.

## Scope — Non-Blocking Nudges Only

**Defer-via-subagent is appropriate for:**
- Retrieval-budget reminders ("you haven't retrieved in N turns")
- SOUL re-injection prompts
- Drift-flag reviews (snapshot audit finding)
- Chronicle-nudge ("you haven't logged in a while")
- Evolution-audit alerts (Goodhart-via-drafts flags)

**NEVER deferred:**
- PreToolUse retrieval gate for persistent outputs (hard block; can't defer "this is about to persist without a source")
- Any safety-critical pre-action check
- Anything that blocks an irreversible operation

The rule: if the nudge is about something happening NEXT, defer. If it's about something happening NOW, block.

## Mechanism Sketch

1. **Stop hook detects nudge fire + entity state.** A heuristic determines "flow state" — high tool-call density for N consecutive turns, no natural breakpoint signals, consecutive edits to the same file, chain-of-thought patterns.

2. **If NOT in flow:** nudge fires normally (inject into next turn's context).

3. **If in flow:** nudge is written to `.state/pending-nudges/<id>.md` with metadata (fired_at, context_snapshot, handler_subagent_spawned).

4. **Subagent spawned** with the nudge directive + scoped context package. Fresh session (doesn't inherit main entity's potentially-drifted state). Runs in background. Writes findings to `.state/pending-nudges/<id>-result.md`.

5. **Main entity checks pending-nudges at natural breakpoints:**
   - End of a task
   - Before starting a new task
   - When flow ends (Stop hook detects low tool-call density)
   - Sleep pass reviews any stale pending-nudges

6. **Sleep loop escalation:** pending-nudges older than threshold escalate to Wisdom via `proposals/URGENT-stale-nudge-<id>.md`.

## Caveats

1. **Deep-work detection heuristic.** Misclassifying non-flow as flow defers nudges that should fire. Start conservative — require multiple flow signals before deferring.

2. **Token cost.** Every deferred nudge spawns a subagent. Batch if possible (defer 3 nudges, spawn one subagent to handle all). Throttle if spawn-rate exceeds budget.

3. **Lost-in-pending-queue risk.** Nudges deferred but never addressed are worse than never firing — the entity thinks it was handled when it wasn't. Sleep loop MUST review pending-nudges and escalate stale ones.

4. **Context sharing.** Subagent needs enough context to act (what was the entity working on, what's the current task state). Too much and it inherits drifted state; too little and it can't do the check. Package: SOUL.md + recent chronicle entries + scoped task description.

5. **Subagent drift.** A subagent handling a nudge can itself drift. Cross-model review (Opus subagent handling a Haiku entity's nudge) helps; same-model is primary for cost.

## Connection to Existing Architecture

- **Extends B5** (retrieval-first hooks) — adds a sixth mechanism: pending-nudges queue + deferred handling logic.
- **Uses B6** (sleep loop) — sleep pass reviews pending-nudges and escalates stale ones.
- **Maps to earned conviction** — an entity that delegates well rather than dropping flow is closer to a mature mind.

## Implementation Status

Not yet in any session brief. Should be added to B5 as an enhancement, or treated as a B5.5 follow-up.

## Open Questions

- What's the right flow-detection heuristic? (Need empirical tuning)
- Should deferred nudges have a max-defer time (e.g., must fire within 30 minutes regardless of flow)?
- Batch multiple nudges into one subagent or spawn one per nudge?
- How does the entity know what pending-nudges are outstanding? (File-scan at natural breakpoints, or a Stop-hook counter?)
