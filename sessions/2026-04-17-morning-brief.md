# Morning Brief — 2026-04-17

*Created 2026-04-16 evening. Read first thing in the morning.*

## Where We Are

- **Claude Code Entities framework:** infrastructure proven, partially built. Phase 0 stumble-through passed. SOUL.md, current-state.md, psdc/CLAUDE.md exist. PD responds in character. The `/entity` skill works end-to-end.
- **Build remaining:** Sections 1-6 of plan.md (heartbeat install, global rules, Slack, Telegram polish, permissions config, full identity layer).
- **Autonomous Venture Studio:** planning phase, not built. Builds on top of Claude Code Entities (Director + CEO entity architecture). Two days old.

## Flagged from 2026-04-16 — Tool Limits Investigation

These affect Wisdom's daily Claude Code work AND future entity operations:

### Quick wins (do today)
1. **Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=70`** in environment — compact before quality degrades, not at 83.5% when it's already too late.
2. **Audit MCP servers** — each loaded server adds 8-30% context overhead. Prune idle ones (Figma, n8n, Wolfram, etc. — only load what current work needs).
3. **Enable MCP Tool Search** if any server has 50+ tools (85% context reduction).

### Worth building (small, high-value)
4. **Auto-continue Stop hook** — detects "tool-use limit for this turn" and auto-prompts "continue". Would fix the manual-Continue friction Wisdom is seeing daily. Open Anthropic bug #33969, no fix coming soon. We can patch it ourselves.

### Architectural reminder (for entity work)
5. Per-turn tool limit = ~20 calls. Entity tasks should externalize state to files between phases, never try to do everything in one invocation. Max 3 concurrent entities to avoid rate limits.

## Decision Points for Today

1. **PD or AVS first?** PD's full autonomy build is 1-2 days. AVS is weeks. AVS depends on entities working. Recommend: finish PD first.
2. **Frank/Jen entity — start now or after PD?** Could be built in parallel. The architecture is the same, just different tuning.
3. **Tool-limit hook — build it?** ~30 min build, immediate quality-of-life improvement.

## Files Ready to Use

- `~/Playful Sincerity/PS Software/Claude Code Entities/plan.md` — reconciled build plan
- `~/Playful Sincerity/PS Software/Claude Code Entities/SPEC.md` — full system spec
- `~/Playful Sincerity/PS Software/Claude Code Entities/research/tool-limits-investigation.md` — tool limits research
- `~/Playful Sincerity/PS Software/Claude Code Entities/psdc/entity/identity/SOUL.md` — PD's identity
- `~/Playful Sincerity/PS Software/Claude Code Entities/psdc/entity/identity/current-state.md` — letter from PD to PD
- `~/remote-entries/2026-04-14/frank-bot-use-cases.md` — what Frank/Jen actually want
- `~/Playful Sincerity/PS Software/Autonomous-Venture-Studio/SPEC.md` — AVS spec (planning phase)

## Open Questions

- Should we explore the Docker repo clone deployment model now or defer to V1.5?
- Conversation clone routing — separate session brief exists at `sessions/conversation-clone-session-brief.md`, ready to spin up
- Read-protection / PII handling — file opened today (`sessions/2026-04-16-read-protection-PII.md`) — review status?

## What This Brief Is Not

Not a plan or a commitment. The things you'd want to know waking up to this project so they don't get lost in context. Decide priority in the morning.
