# Claude Code Tool Limits Investigation
*Researched 2026-04-16 — affects how we build Claude Code Entities and how Wisdom uses Claude Code daily*

## The Big Findings

### 1. Per-turn tool call limit regressed to ~20 in March 2026
- Active bug: [anthropics/claude-code#33969](https://github.com/anthropics/claude-code/issues/33969), unresolved as of April 16, 2026
- Was 60-80+ tool calls per turn, now ~20
- Hits "Claude reached its tool-use limit for this turn" → manual Continue required
- Underlying mechanism: `stop_reason="pause_turn"` from server-side sampling loop
- Documented default: 10 iterations
- THIS IS THE "TOOL INTERRUPTED" WISDOM IS SEEING

### 2. Context quality degrades at 20-40% of capacity, not 100%
- Million-token window is theoretical
- Reliable zone for complex agentic work: ~200-256K of the 1M window
- Auto-compaction at ~83.5% (default) is too late
- Workaround: `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=70` to compact earlier

### 3. 5-hour rolling window (token budget by tier)
- Pro ($20/mo): ~44K tokens / 5 hours
- Max 5x ($100/mo): ~88K tokens / 5 hours
- Max 20x ($200/mo): ~220K tokens / 5 hours
- Weekly caps also apply (Aug 28, 2025): Max 20x = 24-40 Opus hours/week

### 4. Parallel agent rate limits
- 5 concurrent Agent Teams hits 429/529 within 5-10 minutes on Max 20x
- Bug: [anthropics/claude-code#44481](https://github.com/anthropics/claude-code/issues/44481)
- `/batch` (up to 30 subagents) also rate-limits at scale
- Each concurrent entity multiplies rate consumption

### 5. MCP tool count overhead
- Before MCP Tool Search (Jan 2026): 50+ tools = ~77K tokens at session start
- One server with 135 tools = 125K tokens
- MCP Tool Search reduces this 85% (~8.7K tokens via dynamic loading)
- Performance degrades above ~50-100 tools loaded upfront

## What Causes Stalls

1. Per-turn tool call limit regression (~20 calls) — requires manual Continue
2. SSE streaming stall — fixed in v2.1.105 (now aborts after 5 min)
3. High-thinking-mode hang — intermittent, still being investigated
4. Context thrashing — compaction loop without progress
5. Rate limiting (429/529) under concurrent load

## Workarounds

### For Wisdom's Daily Claude Code Use
- **Enable MCP Tool Search** if any server has 50+ tools (huge context savings)
- **Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=70`** — compact before quality degrades
- **Prune idle MCP servers** — each adds 8-30% context overhead
- **Auto-continue hook** — could be a Stop hook that detects "tool-use limit" message and sends "continue" automatically (worth investigating)

### For Claude Code Entities (Future Autonomous Operation)
- **Entity sessions must be short-lived** — ~15-20 tool calls, externalize to files, exit
- **Don't run 5+ entities concurrently** — rate limits hit fast. Stagger launches, max 3 concurrent during heavy work
- **Per-entity MCP config** — only load what that entity needs
- **Route subagents to Haiku** — 25x cheaper, far less rate consumption

## Implications for Architecture

The heartbeat-as-fresh-`claude -p`-invocation pattern accidentally sidesteps the per-turn limit because each invocation gets a fresh counter. This is a happy accident, not why we designed it that way. The heartbeat is for periodic check-ins, not for resetting tool limits.

For entity work that needs more than ~20 tool calls in one go: design tasks to externalize state to files between phases, then a separate invocation continues. This was already our pattern but now we know WHY it's necessary.

## Sources
- GitHub issues: anthropics/claude-code#33969, #44481
- Anthropic docs on usage limits: claude.com/docs
- Community reports on stalls and degradation
- v2.1.105 release notes (SSE streaming fix)

## Action Items
- [ ] Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=70` in Wisdom's environment
- [ ] Audit MCP servers — disable idle ones
- [ ] Investigate auto-continue Stop hook for the per-turn limit bug
- [ ] Enable MCP Tool Search if not already on
- [ ] Flag for tomorrow morning's brief
