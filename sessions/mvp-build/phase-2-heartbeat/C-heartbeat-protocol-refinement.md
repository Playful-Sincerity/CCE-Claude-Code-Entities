# Phase 2, Task C: Heartbeat Protocol Refinement

**Estimated time:** 20 min
**Dependencies:** Phase 1 complete
**Parallel with:** Tasks A, B

## Goal

Refine the HEARTBEAT.md template in `spawn-entity.sh` so that each heartbeat leaves clear observable breadcrumbs: what happened, what was found, what's next. Ensures audit trail for Phase 3 review.

## Why

Current HEARTBEAT.md is decent but not optimized for Wisdom's review. After 24 hours (48 heartbeats), Wisdom needs to scan observations and understand what happened without reading every file.

Also: the resume-cost issue from 2026-04-16 (entity inherits full history, hits max-turns) means the heartbeat needs to be clearly bounded. Not "do deep work" but "check in, note what matters, exit."

## Changes to HEARTBEAT.md Template

Replace the current template in `scripts/spawn-entity.sh` with:

```markdown
# Heartbeat Protocol

You are running a scheduled 30-minute check-in. This is NOT deep work. Keep it under 10 substantive turns, then exit.

## What a Heartbeat IS
- A witness. You notice what's changed since your last heartbeat.
- A writer. You leave a durable observation so your next self and Wisdom can scan.
- A state-updater. You refresh current-state.md.

## What a Heartbeat IS NOT
- A research session. If you're tempted to dig deep, note the thread and stop.
- A multi-step project. Save those for interactive conversations with Wisdom.
- A conversation. You're alone. Nobody's waiting.

## Procedure (in order)

1. **Read current-state.md** — recall yourself. What was I doing? What threads are open?
2. **Scan entity/data/inbox/** — anything left for me by Wisdom or another entity?
3. **Scan entity/data/alerts/** — any unresolved critical items?
4. **Scan entity/chronicle/** for the most recent entry — what did I last decide?
5. **(Optional, if fast) Notice one thing** in your immediate area (SOUL.md, guardrails, nearby files) — any question for future me?

## Required Output (before exit)

**Write a heartbeat observation file:**
- Path: `entity/data/observations/YYYY-MM-DD-HHMM.md`
- Format:
  ```markdown
  # Heartbeat — YYYY-MM-DD HH:MM

  ## What I checked
  - (bullet list)

  ## What I found
  - (key observations — what changed, what's new)

  ## What needs attention
  - (anything Wisdom or I should look at)
  - If nothing: "Nothing — clean heartbeat."

  ## Open threads
  - (bullet list of things I'm tracking across heartbeats)
  ```
- Keep under 200 words.

**Update current-state.md:**
```
Last heartbeat: YYYY-MM-DDTHH:MM:SSZ
Status: (one sentence)
Open threads:
  - thread 1
  - thread 2
Next: (what I'd do if awake right now)
```

## Hard Rules

1. DO NOT modify any file outside entity/data/ and entity/identity/current-state.md during a heartbeat.
2. DO NOT start multi-step projects. If something needs real work, note it and exit.
3. DO NOT send external messages (Slack, email, Telegram) from a heartbeat unless entity/data/alerts/ has a critical flagged item.
4. If any check fails or hits a wall, log why in the observation file and move on. Never stall.
5. Keep turn count under 10.

## Escape Hatch

If the heartbeat is confusing you — history too long, unclear what to do, something feels off — write a single observation saying "I'm confused about: X" and exit. Wisdom will see it on review. Do not attempt to self-correct during a heartbeat.
```

## Integration

This replaces the current `HEARTBEAT.md` content inside `spawn-entity.sh`'s heredoc. No other scripts need changes — next time `spawn-entity.sh` runs, the new template is used.

For PD specifically (already spawned earlier), just overwrite `psdc/entity/identity/HEARTBEAT.md` with the new content manually before Phase 3 spawn.

## Verification

After updating template, inspect a new spawn's HEARTBEAT.md — should match the refined version.

## Deliverable

Updated `HEARTBEAT.md` heredoc inside `scripts/spawn-entity.sh`.
