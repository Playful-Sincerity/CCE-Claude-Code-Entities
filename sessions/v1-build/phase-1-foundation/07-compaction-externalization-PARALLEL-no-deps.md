# Session Brief: Compaction Externalization — Three-Layer Recovery Stack

**Phase:** 1 — Foundation
**Parallel with:** 01–06
**Dependencies:** None architecturally. Integrates with B6 (sleep loop job 3) and builds on existing `/carryover` skill.
**Status:** Ready to launch

---

## The Goal

Ship the compaction-handling architecture: entity doesn't survive compaction — it *restarts* with externalized state. This brief defines the three-layer recovery stack and the `current-state.md` format that makes it work.

---

## Why This Exists

From think-deep synthesis:

- Stream B found artifact tracking scored 2.19/5.0 across all tested compaction frameworks. Compaction is inherently lossy.
- 100K tokens compresses to ~500 tokens of signal — 200× ratio.
- Instead of fighting the loss, externalize critical state *before* compaction into files that survive.
- Three-layer recovery: live memory → consolidated files → raw JSONL fallback. Always a path to recover detail.

---

## The Three-Layer Recovery Stack

### Layer 1: Live memory (volatile)

The current conversation context. Fastest, most detailed, but doesn't survive compaction.

### Layer 2: Consolidated synthesis (durable, lossy-by-design)

- `SOUL.md` — identity, values. Reloaded via B5 UserPromptSubmit hook.
- `chronicle/<date>.md` — narrative of what happened.
- `memory/<period>.md` — structured facts with provenance, written by sleep loop.
- `world-model.md` — entity's understanding of the project.
- `current-state.md` — the carryover document (defined below).
- `proposals/` — pending rule changes awaiting Wisdom review.

These are the files the entity reloads from when returning from compaction.

### Layer 3: Raw JSONL fallback (complete, always available)

Claude Code automatically stores every session as JSONL at `~/.claude/projects/<project-hash>/<session-id>.jsonl`. Complete transcript — every message, tool call, and result.

If consolidation missed detail, the entity can grep its own prior-session JSONLs to recover it. This is the "what was I actually thinking there" fallback.

---

## `current-state.md` — The Carryover Document

**Format:**
```markdown
---
written_at: YYYY-MM-DD HH:MM
written_by: <entity | sleep-loop | /carryover>
session_id: <current session ID>
prior_session_ids:
  - <session ID 1>  # most recent first
  - <session ID 2>
  - <session ID 3>
context_usage_at_write: <percentage>
---

# Current State — <entity name>, <date>

## What I'm Working On
<One paragraph — the active task.>

## Active Todos
- [ ] <pending item>
- [ ] <pending item>

## Key Decisions Made (this session)
- <decision + one-line reasoning>

## Key Files Recently Modified
- `<path>` — <what changed, why>

## Open Questions / Blockers
- <question the entity is sitting with>

## Prior-Session JSONL Paths (for fallback detail recovery)
- ~/.claude/projects/<hash>/<session-id-1>.jsonl  # <date + one-line summary>
- ~/.claude/projects/<hash>/<session-id-2>.jsonl
- ~/.claude/projects/<hash>/<session-id-3>.jsonl

## What To Re-Read First On Wake
- <file> — <why it's the most important context to reload>
- <file> — <why>
```

**Critical:** `prior_session_ids` and JSONL paths MUST be included (Wisdom's addition, 2026-04-16). Without them, layer-3 recovery is blocked.

---

## When `current-state.md` Gets Written

Three triggers:

1. **Context-usage gate:** when live context usage crosses 60%, the entity writes/updates `current-state.md`. Fires before auto-compact at 80% so the externalization completes before the lossy pass.
2. **Sleep loop (B6 job 3):** every sleep pass refreshes `current-state.md` with the latest state.
3. **Manual `/carryover` invocation:** Wisdom triggers it explicitly. Existing skill; this brief extends it.

---

## Integration with `/carryover` Skill

The `/carryover` skill already exists (`~/.claude/skills/carryover/`). This brief extends its pattern:

- Skill output goes to `<entity-home>/current-state.md` (new location, entity-aware)
- Skill populates the fields above, specifically including `prior_session_ids`
- Skill runs `session-id` skill internally to capture the current session ID
- Skill suggests files for the "What To Re-Read First On Wake" section based on recent edits

---

## Wake Sequence

When an entity starts a new session (after compaction or fresh start):

1. B5 UserPromptSubmit hook injects SOUL.md
2. Entity's boot prompt (in `<entity-home>/CLAUDE.md`) reads `current-state.md`
3. Entity's boot prompt reads the files listed in "What To Re-Read First On Wake"
4. Entity re-orients: "I was doing X, my last session ended at HH:MM, these files are relevant, these todos are pending"
5. If the entity needs detail that isn't in the consolidated files, it reads prior-session JSONLs via Read tool

---

## JSONL Fallback Lookup — Entity-Accessible

The entity needs to be able to grep its own JSONLs. Provide a helper:

`scripts/tools/grep-past-sessions.sh <query>` — wraps `grep -r <query> ~/.claude/projects/<hash>/*.jsonl` with human-readable output. Entity can invoke this via Bash when it needs to recover detail.

This is layer-3 recovery, entity-initiated. The sleep loop might use this during audit passes ("did this decision have reasoning I should capture into memory?").

---

## Deliverables

1. `current-state.md` template with full frontmatter schema
2. Extended `/carryover` skill that writes to entity-home, populates prior_session_ids
3. Hook or boot-prompt wiring for wake sequence (entity reads current-state.md on start)
4. `grep-past-sessions.sh` helper script
5. `.state/context-usage-watcher.sh` — cron/stop-hook that triggers current-state.md refresh at 60% context
6. Test: manually trigger compaction, verify wake-sequence reload works
7. Chronicle entry describing the three-layer recovery architecture

---

## Connections

- **B5 — retrieval-first hooks** — current-state.md is a *persistent output*; writing it triggers the retrieval gate. This is fine — the entity must consult recent files before writing state.
- **B6 — sleep loop** — job 3 is the scheduled current-state.md refresh
- **/carryover skill (existing)** — this brief extends it for entity-aware operation
- **/session-id skill (existing)** — used to populate session_id field

---

## Open Questions

- How often should context-usage-watcher poll? Every tool call is expensive; every 30 seconds misses fast conversations. Likely: every 10 tool calls OR 2 minutes, whichever comes first.
- What's the "What To Re-Read First On Wake" heuristic? Recently-edited + high-traffic files? Manual entity selection? Sleep-loop selection?
- How long to retain prior_session_ids? All of them is unwieldy; last 3–5 is probably right. Sleep loop archives older ones to a historical index.

---

## Estimated Effort

1 day. Existing `/carryover` skill does much of the work; this brief adapts it.
