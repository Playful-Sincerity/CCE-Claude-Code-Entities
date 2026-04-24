# Session Brief: Retrieval-First Hooks — Implementation

**Phase:** 1 — Foundation
**Parallel with:** 01-permission-model, 02-pd-identity-test, 03-memory-architecture, 04-comparative-architecture, 06-sleep-loop, 07-compaction-externalization
**Dependencies:** None — parallel-safe
**Status:** Ready to launch

---

## The Goal

Ship four hooks that implement retrieval-over-weights as the entity's architectural default:

1. **UserPromptSubmit hook** — re-inject SOUL.md at session start
2. **Stop hook (retrieval budget)** — nudge if N turns elapse without Read/Grep/WebFetch
3. **PreToolUse hook (retrieval gate)** — require at least one retrieval before persistent outputs (Write/Edit to chronicle, proposals, communications, world-model)
4. **Stop hook (SOUL re-injection)** — periodic re-injection every K turns

Retrieval-over-weights as stated principle: 25–80% compliance. As hook-enforced: ~100%. This brief moves the principle from advisory to gate.

---

## Why This Exists

From the think-deep synthesis (`research/think-deep/2026-04-16-two-drift-types-unified-answer.md`):

- Production agent landscape is backwards — agentic-RAG treats retrieval-skipping as a feature improvement
- No production system ships retrieval-first-as-declared-default with architectural enforcement
- Claude Code's PreToolUse hook system provides 100% enforcement compliance per three independent production sources
- Output-drift (hallucination per-response) is the drift type this addresses; complements sleep-loop (B6) which addresses value-drift and compaction (B7)

Scoped principle — NOT universal. Creative work, quick answers, reasoning-only responses are exempt. The gate fires only on persistent outputs.

---

## The Four Hooks — Specifications

### 1. UserPromptSubmit hook — SOUL injection

**When:** Fires at the start of every user prompt submission in an entity session.
**What:** Reads `<entity-home>/SOUL.md`; injects via `additionalContext` field.
**Why:** Rules loaded once at session start get drowned by accumulated context. Re-injecting per-prompt keeps values salient.
**Script:** `scripts/hooks/soul-inject.sh`
**Test:** Start entity session, verify SOUL.md contents appear at top of system context each turn.

### 2. Stop hook — retrieval budget

**When:** Fires after each entity response.
**What:** Counts tool calls in last N turns (configurable, default N=5). If count of `{Read, Grep, WebFetch, Bash with grep/cat/find, memory consults}` is zero, emits a nudge into next turn's context: *"You haven't retrieved grounded data in N turns. Recent outputs may be weights-only. Consider consulting a source."*
**Why:** Cheap, loud enough to notice, doesn't block. Addresses the *habit* of retrieval without enforcing it.
**Script:** `scripts/hooks/retrieval-budget.sh`
**Test:** Run entity session with no retrievals for 6 turns; verify nudge appears on turn 7.

### 3. PreToolUse hook — retrieval gate for persistent outputs

**When:** Fires before Write, Edit, or Agent calls whose target path matches persistent-output patterns.
**What:** Inspects the session transcript. If no Read/Grep/WebFetch has occurred since the previous persistent-output event (or ever in this session), blocks the call with a message: *"Persistent outputs require grounded retrieval. Please consult at least one source (Read, Grep, WebFetch) before this output. If this is reasoning-only or creative work, annotate the output explicitly as `[weights-only]` and re-invoke."*
**Why:** This is the gate-layer defense. Hook compliance ≈ 100% vs rules 25–80%.
**Scope — critical:** persistent-output patterns include:
- `chronicle/*.md`
- `proposals/*.md`
- `memory/*.md`
- `world-model.md`
- `entity/communications/*` (outgoing messages)
**Scope — excluded:** transient outputs, creative work, short quick responses, internal reasoning files.
**Script:** `scripts/hooks/retrieval-gate.sh`
**Test:** Attempt to write to chronicle without prior retrieval — should block. Retrieve, then write — should pass. Try with `[weights-only]` annotation — should pass with warning.

### 4.5 Focus-aware deferred nudge handling (added 2026-04-16)

**Problem:** conversation audit showed nudges get skipped during intense work sessions. The current enforcement stack forces a bad trade: break flow to handle nudge, or skip nudge and drift.

**Solution:** add a third path. When a nudge fires AND the entity is in a flow state, defer the nudge to a background subagent. Main entity stays in flow; subagent's result lands at a natural breakpoint.

See `../../ideas/focus-aware-deferred-nudges.md` for full specification.

**Mechanism:**

1. When a Stop hook fires (retrieval budget, SOUL re-injection, etc.), check flow state.
2. Flow heuristic (tune empirically): high tool-call density for N consecutive turns + no natural breakpoint signals. Start conservative.
3. If NOT in flow → nudge fires normally (inject into next turn's context).
4. If in flow → write nudge to `.state/pending-nudges/<id>.md` with metadata (fired_at, context_snapshot, subagent_id).
5. Spawn subagent with nudge directive + scoped context package (SOUL.md + recent chronicle + current task). Background.
6. Subagent writes findings to `.state/pending-nudges/<id>-result.md`.
7. Main entity checks `.state/pending-nudges/` at natural breakpoints (end of task, Stop hook detects low activity).
8. B6 sleep loop Job 5 reviews stale pending-nudges; escalates via `proposals/URGENT-stale-nudge-<id>.md`.

**Scoped to non-blocking nudges only.** PreToolUse retrieval gate (hook #3 above) stays as a hard block — cannot be deferred. Flow-respect applies to nudges about what happens next, not to gates on what's happening now.

**Script:** `scripts/hooks/flow-aware-nudge.sh` (orchestrator that wraps the other Stop hooks).

**Caveats to handle in implementation:**
- Deep-work detection heuristic needs empirical tuning. Start conservative.
- Batch multiple nudges into one subagent to control token cost.
- Max-defer time (e.g., 30 min wall-clock) ensures nudges fire even if flow never breaks.
- Subagent gets fresh session (doesn't inherit main entity's potentially-drifted state).

### 4. Stop hook — SOUL re-injection counter

**When:** Fires after each entity response.
**What:** Increments a turn counter (stored in `<entity-home>/.state/turn-count`). Every K turns (default K=20), re-injects SOUL.md via `additionalContext`. Resets counter.
**Why:** Rules drift out of effective context as conversation accumulates. Periodic re-injection keeps values salient without full reload.
**Script:** `scripts/hooks/soul-reinject.sh`
**Test:** Run 21 turns, verify SOUL.md re-injected at turn 21.

---

## Implementation Constraints

- **Use Claude Code's native hook system.** Don't build a parallel framework.
- **Hook scripts live in entity home** (`<entity-home>/scripts/hooks/`). Each entity has its own — not shared globally.
- **Configuration in `<entity-home>/.claude/settings.json`.** Per-entity config, not user-level.
- **Fail safe on errors.** If a hook script errors, log and let the call proceed — don't brick the entity.
- **No state in hooks that the entity can corrupt.** `.state/` files should be hook-managed, not entity-modifiable.

---

## Deliverables

1. Four hook scripts working end-to-end
2. `settings.json` template for entity homes (pre-wired with all four hooks)
3. Test harness documenting each hook's trigger and validation
4. Brief chronicle entry describing the retrieval-first architecture now live

---

## Connections

- **B6 — sleep loop** — sleep subagent can read hook logs for its audit pass; they share the `.state/` directory
- **B7 — compaction** — current-state.md is a *persistent output* that also requires retrieval per the gate
- **03-memory-architecture** — memory writes require retrieval (via this gate)
- **Papers** — this is the implementation layer for the retrieval-over-weights paper candidate (`papers/retrieval-over-weights.md`)

---

## Measurement (for the paper, when shipped)

Once hooks run live, track:
- Nudge fire rate (how often retrieval-budget fires) — informs N
- Gate block rate (how often PreToolUse blocks) — informs scope
- SOUL re-injection count per session — informs K
- User-perceived quality delta (subjective, document in chronicle)
- Hallucination rate before/after hooks (requires eval set)

---

## Estimated Effort

4–6 hours focused. Each hook is ~30–60 lines of shell or node. Configuration + tests double the time.
