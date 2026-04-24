---
timestamp: "2026-04-14 16:00"
category: idea
related_project: Claude Code Entities
source: ClaudeClaw v2 analysis
---

# Agent SDK vs claude -p — Transport Decision

**Update 2026-04-14:** `claude -p` DOES support session resumption natively via `--resume <session-id>` or `--continue` (resumes most recent session in that --cwd). No Agent SDK needed.

This means the heartbeat can inject prompts into the same ongoing session:

```bash
claude -p --continue --cwd psdc/ --model haiku --max-turns 10 \
  "Run the heartbeat protocol from entity/identity/HEARTBEAT.md"
```

The entity maintains one continuous conversation. Heartbeats, user messages (via Telegram/Slack listener), and interactive sessions all feed into the same session. current-state.md becomes a backup for compaction recovery, not the primary continuity mechanism.

This is simpler than the Agent SDK approach AND gives the same session persistence. Zero additional code — just a CLI flag.

**Three transport options:**

1. `claude -p` (cold start, no history) — only useful for testing
2. `claude -p --continue` (resume most recent session in --cwd) — V1, simple, zero code
3. Agent SDK with `resume: sessionId` (programmatic, TypeScript) — V2 if we need streaming/events

Priority: **V1 — use `--continue` immediately.** Agent SDK is a V2 consideration only if we need programmatic control beyond what CLI flags provide.
