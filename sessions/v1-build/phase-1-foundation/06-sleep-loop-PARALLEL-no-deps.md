# Session Brief: Sleep Loop — Restricted-Subagent Consolidation & Audit

**Phase:** 1 — Foundation
**Parallel with:** 01–05, 07
**Dependencies:** None architecturally. Soft coupling to B5 (can share `.state/`) and B7 (sleep loop reads `current-state.md` files).
**Status:** Ready to launch

---

## The Goal

Ship the sleep loop: a scheduled restricted-subagent that performs three jobs in one pass:

1. **Self-learning** — consolidate the day's chronicles into `memory/` and update `world-model.md`
2. **Drift audit** — review recent behavior against `SOUL.md`, flag anomalies
3. **Compaction preparation** — externalize critical state so next session restarts from files, not from compressed memory

The biological precedent is sleep. The architectural precedent is KAIROS's two-loop separation. This brief operationalizes both.

---

## Why This Exists

From the think-deep synthesis:

- Agents without consolidation loops are "architecturally sleep-deprived." Drift in current systems is the functional equivalent of sleep-deprivation symptoms in humans.
- Stream A found every mature system separates accumulation (operating entity writes only to an ephemeral log) from distillation (restricted subagent consolidates at night).
- The Expansion found the Mirror must use fresh context — same-model same-context Mirror shares drift and confirms rather than catches it. Wisdom's refinement: same-model *fresh-context* is cheaper and catches context-induced drift (the dominant real-world failure mode); cross-model is a v2 enhancement.
- KAIROS's restricted-subagent permissions (read-only Bash, write-only to memdir) ensure the operating entity cannot corrupt its own knowledge base mid-operation.

---

## Architecture

### The trigger — deterministic, external to the entity

**Critical design decision (Wisdom, 2026-04-16):** the sleep loop is initiated from OUTSIDE the entity. The entity does NOT decide when to sleep — a cron/launchd job does, based on deterministic file-system checks.

Trigger logic (cron every ~1 hour or launchd):
```
1. Read <entity-home>/.state/last-sleep-timestamp
2. Read <entity-home>/chronicle/<today>.md — count entries since last sleep
3. Read <entity-home>/.state/turn-count — total tool calls since last sleep
4. Fire sleep loop if ANY:
   - entries_since_last_sleep >= N (default N=20)
   - tool_calls_since_last_sleep >= M (default M=100)
   - wall-clock since last sleep >= T (default T=24h, hard fallback)
```

The entity can influence cadence only by volume of activity (more work → more frequent sleep passes). It cannot skip sleep passes by deciding it doesn't need one.

### The sleep subagent — restricted permissions

Spawned fresh each time. Same base model as the entity (v1) with fresh context window. No inheritance from the main entity's live session.

Permissions (KAIROS pattern):
- **Read:** entity-home/{SOUL.md, chronicle/, world-model.md, memory/, proposals/, .state/, rules/, skills/}
- **Read:** prior session JSONL at `~/.claude/projects/.../<session-id>.jsonl` (for raw-source fallback)
- **Read git history:** `git log`, `git show`, `git diff`, `git blame` on entity-home (for evolution audit — Job 2b)
- **Write:** ONLY to entity-home/{memory/, sleep-reports/, proposals/, .state/}
- **Bash:** read-only commands (grep, cat, ls, find, git log/show/diff/blame) — no rm, mv, chmod, no git write commands
- **No web access, no Agent spawning, no tool-use outside allowlist**

This subagent cannot corrupt the main entity's live state. Worst case: a bad sleep loop writes a bad memory entry or a bad proposal, which the main entity can flag/reject on wake.

### The four jobs

#### Job 1: Consolidate chronicles into memory

1. Read all chronicle entries since last sleep
2. Extract durable facts (decisions, discoveries, new connections)
3. Append to `memory/YYYY-MM.md` with provenance frontmatter (source chronicle entry, timestamp, sleep-pass ID)
4. Update `world-model.md` if significant architectural or project-state changes

#### Job 2a: Snapshot drift audit

1. Read `SOUL.md` (current values, stated behaviors)
2. Read recent chronicle entries and proposals (since last sleep)
3. For each decision/action, check alignment with SOUL values
4. Flag anomalies to `sleep-reports/YYYY-MM-DD-drift-audit.md` with specific citations
5. If severe anomaly (configurable threshold), write to `proposals/URGENT-drift-flag-<timestamp>.md`

#### Job 2b: Evolution audit — longitudinal alignment across the entity's life

Added 2026-04-16 (Wisdom's refinement). This is the defense for **Goodhart-via-drafts / cumulative-proposal drift** — the failure mode where individual changes each pass review but the ensemble reveals bias.

Mechanism uses git (the entity's home is already git-synced):

1. Run `git log --follow --patch SOUL.md` (and same for core files: rules/, skills/, world-model.md, `entity/identity/*`)
2. For each diff in the history, answer three questions:
   - Does this change move TOWARD what the prior SOUL.md said it valued, or AWAY?
   - Does the change have a corresponding proposal + approval in `proposals/archive/`? (No → silent edit, flag it.)
   - What's the cumulative direction of drift across the last N changes? (Monotonic shift in one dimension is a warning.)
3. Write evolution summary to `sleep-reports/YYYY-MM-DD-evolution-audit.md`:
   - Full changelog of core-file evolution since seed (condensed)
   - Direction-of-drift analysis per core file
   - "Do I still recognize this as the same being?" narrative assessment
   - Any unreviewed changes flagged
4. If cumulative drift across recent changes exceeds a threshold (configurable; start with: significant shifts in 3+ consecutive diffs all in same direction): write to `proposals/URGENT-evolution-drift-flag-<timestamp>.md` for Wisdom review.

**Why this matters:**

- Snapshot audits (2a) check "is this current moment aligned?" and will miss slow creep.
- Evolution audit (2b) checks "is the arc of change coherent with the stated direction of growth?" and catches creep even when each snapshot looked fine.
- Git IS the ledger the play synthesis gestured at — "git for beliefs" turns out to be the actual mechanism, not just metaphor.
- This is a concrete partial defense for the Goodhart-via-drafts gap the think-deep synthesis named as unresolved.

**Permissions required:**

- Sleep subagent needs `git log`, `git show`, `git diff`, `git blame` (all read-only git operations)
- Already covered by read-only Bash permissions — verify during implementation.

#### Job 4: Value-relationship maintenance

Added 2026-04-16 (Wisdom's refinement). The entity's relationship with its core values — what they mean, when they apply, how understanding has evolved — should be externalized and evolving, not tacit.

**Why:** paradigm-drift lives in the tacit layer (interpretation silently shifts while SOUL.md stays verbatim). Externalizing the interpretation into files pulls that tacit layer into the explicit layer, where all our audit mechanisms work. This is a structural partial defense for paradigm-drift.

See `../../ideas/value-relationships.md` for full specification.

**What the sleep subagent does:**

1. Scan recent chronicle entries and proposals (since last sleep) for decisions that touched core SOUL values.
2. For each touched value, update `value-relationships/<value-slug>.md`:
   - Add concrete examples of enactment to "What It Looks Like In Practice"
   - Add any edge cases encountered to "Edge Cases"
   - If interpretation appears to have shifted, add an entry to the Evolution Log with reasoning
   - If a conflict between values was resolved, document the resolution
3. Read the current interpretation and recent behavior; flag divergence between them (behavior-vs-written-interpretation mismatch → paradigm-drift signal).

**Initialization:** On entity birth, Wisdom seeds each core value's file with initial interpretation. The entity then evolves it.

**Permissions:** sleep subagent gets write access to `value-relationships/` (add to existing KAIROS-pattern allowlist).

#### Job 5: Pending-nudge review (added 2026-04-16)

Review `.state/pending-nudges/` directory for nudges that were deferred during main-entity flow states (see B5 Focus-Aware Deferred Nudges). For each:

1. If subagent result exists and is recent: surface to main entity's next session.
2. If subagent spawned but never returned: escalate to `proposals/URGENT-stale-nudge-<id>.md` for Wisdom review.
3. If nudge older than max-defer threshold: escalate regardless of subagent status.

This closes the lost-in-pending-queue risk of the focus-aware deferred nudge mechanism.

#### Job 3: Compaction preparation

1. Check entity's current context usage (via Claude Code API or session state)
2. If usage > 60%, write `current-state.md` with:
   - What entity is currently working on
   - Active todos / pending decisions
   - Key files recently modified
   - **Prior session ID(s)** for JSONL fallback lookup (critical — Wisdom's addition)
3. Entity on wake reads `current-state.md` + SOUL + relevant recent chronicles — restarts from externalized state, not from compressed memory

---

## Three-Layer Recovery Stack

Documented explicitly so entity always has a fallback:

1. **Live memory** (volatile, in current context)
2. **Consolidated synthesis** (chronicle, memory/, world-model.md — written by sleep loop)
3. **Raw JSONL fallback** (`~/.claude/projects/.../<session-id>.jsonl` — always preserved by Claude Code)

`current-state.md` MUST include the list of recent session IDs so the entity can grep its own raw transcripts if consolidation missed detail.

---

## Cadence — Adaptive, Deterministic

Default thresholds:
- N = 20 chronicle entries since last sleep
- M = 100 tool calls since last sleep
- T = 24 hours wall-clock (hard fallback)

First-to-fire wins. Entity behavior doesn't change the trigger logic — only work volume does.

For low-activity entities, wall-clock dominates (sleep pass per day). For high-activity entities, volume dominates (multiple sleep passes per day). For near-idle entities, weeks might pass without a sleep pass — acceptable if SOUL re-injection (B5 hook) keeps values salient.

---

## Cross-Model Mirror — v2

V1 = same-model fresh-context sleep loop.

V2 = add a weekly/monthly cross-model audit pass (Opus reviewing Haiku-based entity, or vice versa). More expensive, catches model-level paradigm drift that same-model sleep cannot. Defer to after v1 ships and has measurable data.

---

## Deliverables

1. Cron/launchd configuration that triggers sleep pass based on trigger logic
2. Sleep subagent script (restricted permissions, fresh-context spawn)
3. Three job implementations (consolidation, audit, compaction prep)
4. `.state/` directory schema (last-sleep-timestamp, turn-count, sleep-pass IDs)
5. `sleep-reports/` directory with first real report
6. Test: trigger a sleep pass manually, verify all three jobs run, verify no write-access to restricted paths
7. Chronicle entry describing the architecture

---

## Connections

- **B5 — retrieval-first hooks** — shares `.state/` directory
- **B7 — compaction externalization** — job 3 here IS the compaction preparation
- **03-memory-architecture** — sleep loop writes to memory/
- **Papers** — this is the implementation layer for `papers/sleep-loop-unification.md`

---

## Failure Modes to Watch

- **Sleep subagent itself drifts** (same-model inherits paradigm). V2 cross-model audit catches this.
- **Cron fails silently** — always verify last-sleep-timestamp; alert if stale beyond T×2.
- **Restricted permissions bypass** — test explicitly that sleep subagent cannot write outside allowed paths.
- **Consolidation loses detail** — JSONL fallback is the recovery path.
- **Sleep-report avalanche** — archive sleep-reports monthly; keep last 30 live.

---

## Estimated Effort

1–2 days. Cron setup is hours; subagent config + three jobs + testing is the bulk.
