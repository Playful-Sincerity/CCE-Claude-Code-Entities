# Session Brief: Behavioral Config — Global Rules + PD's CLAUDE.md [PARALLEL — needs Phase 1B]

**Dependencies:** Phase 1B (PD Identity Test) must complete first — need validated identity
**Can run parallel with:** 01-frank-jen-entity (if Phase 1A is also done)
**Feeds into:** Phase 3E (infrastructure needs behavioral config in place)
**Blocks:** Phase 3E can't start until behavioral rules exist

## Context

Claude Code Entities is a system for turning Claude Code conversations into autonomous agents. This session creates the behavioral configuration layer — the rules and instructions that make Claude Code act as an autonomous entity rather than a generic assistant.

Two zones:
- **Zone A — Global rules** (`~/.claude/rules/`): improve ALL conversations everywhere, not just entity sessions
- **Zone B — PD's CLAUDE.md**: behavioral instructions that only activate inside PD's `--cwd` context

**Project directory:** `~/Playful Sincerity/PS Software/Claude Code Entities/`

Read these files first:
- `CLAUDE.md` — project overview
- `plan.md` — Section 2 (Behavioral Configuration)
- `plan-section-behavioral.md` — full Section 2 plan with drafts for all rules and CLAUDE.md sections
- `psdc/entity/identity/SOUL.md` — PD's validated identity (from Phase 1B)
- `psdc/CLAUDE.md` — minimal version from Phase 1B (to be expanded here)
- `~/.claude/rules/` — existing global rules (check for overlaps)
- `~/.claude/rules/suggest-debate.md` — skill-router overlaps with this (keep both, delegate)
- Phase 1B results: `sessions/v1-build/phase-1-foundation/results/pd-test-transcript.md`

## Task

### Zone A: Three Global Rules

#### 1. Write `~/.claude/rules/self-check.md`

Pre-action reflection check. Before any significant action (infrastructure changes, proposals, multi-step sequences), pause and answer 4 questions: constructive or destructive? Downstream issues? Within values? Considered or rash?

Draft is in `plan-section-behavioral.md`. Refine based on what we learned during Phase 1B about how PD actually behaves.

Start at enforcement Level 1 (rule only). Observe compliance. Escalate to hook if needed.

#### 2. Write `~/.claude/rules/dc-freshness.md`

After creating any new file, check: would a future session navigating by CLAUDE.md or MEMORY.md know this file exists? Three levels of freshness check based on file type.

Draft is in `plan-section-behavioral.md`.

#### 3. Write `~/.claude/rules/skill-router.md`

Auto-invoke the right skill based on context patterns. Must be dynamic — reads `~/.claude/skills/` rather than hardcoding a list. Includes deployment tier awareness (Tier 1/2/3). References `suggest-debate.md` for debate mode selection rather than duplicating.

Draft is in `plan-section-behavioral.md`.

### Zone B: PD's Full CLAUDE.md

Expand `psdc/CLAUDE.md` from the minimal Phase 1B version to the full behavioral configuration. Eight sections as specified in `plan-section-behavioral.md`:

1. **Session Start** — read SOUL.md + current-state.md
2. **Identity** — what PD is, how it relates to the Digital Core
3. **Permission Pattern** — decision tree (do it / ask first / just propose). Use permission model from Phase 1A results.
4. **Initiative Protocol** — thinking partner level: connect dots, surface ideas, propose improvements
5. **Proposal Review Ritual** — entity's side of the review process + what Wisdom's side looks like
6. **Heartbeat Protocol Reference** — pointer to HEARTBEAT.md + session-end protocol
7. **Conversation Access** — how to search past session JSONL files for continuity
8. **Idea Resurfacing** — during heartbeat, scan ideas/ for things that have become contextually relevant

### Zone C: PD's settings.json

Use the permission model from Phase 1A. Write `psdc/.claude/settings.json` with the appropriate allow/deny configuration.

### Verification

The Section 2 checkpoint: start a normal VS Code session → bot behaviors do NOT appear. Start `claude -p --cwd psdc/` → bot behaviors DO appear (entity reads SOUL.md, operates with permission pattern, skill routing works).

## Output

- `~/.claude/rules/self-check.md` — global rule
- `~/.claude/rules/dc-freshness.md` — global rule
- `~/.claude/rules/skill-router.md` — global rule
- `psdc/CLAUDE.md` — full 8-section behavioral config
- `psdc/.claude/settings.json` — permission configuration
- Chronicle entry with decisions and surprises

## Success Criteria

- [ ] Three global rules exist, load without errors, and don't interfere with normal VS Code sessions
- [ ] `skill-router.md` dynamically reads from `~/.claude/skills/` (not a hardcoded list)
- [ ] PD's CLAUDE.md has all 8 sections with entity-specific behavioral instructions
- [ ] Normal `claude` session: no entity identity loading, no permission pattern
- [ ] `claude -p --cwd psdc/`: entity reads SOUL.md + current-state.md first, permission pattern activates
- [ ] Session ending: entity writes updated current-state.md
