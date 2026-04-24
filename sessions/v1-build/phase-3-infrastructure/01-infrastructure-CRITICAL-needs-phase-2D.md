# Session Brief: Infrastructure — Heartbeat + Slack + Telegram [CRITICAL — needs Phase 2D]

**Dependencies:** Phase 2D (Behavioral Config) must complete first — behavioral rules must exist before autonomous systems go live
**Can run parallel with:** Nothing — this is the final build session
**Feeds into:** V1 complete. Entity goes live.
**Blocks:** Nothing downstream

## Context

Claude Code Entities is a system for turning Claude Code conversations into autonomous agents. This session wires up the infrastructure that makes entities autonomous: heartbeat (launchd), Slack integration (MCP + listener), and Telegram refinement.

**Project directory:** `~/Playful Sincerity/PS Software/Claude Code Entities/`

Read these files first:
- `CLAUDE.md` — project overview
- `plan.md` — Sections 3, 4, 5 (Heartbeat, Slack, Telegram)
- `plan-section-infrastructure.md` — full infrastructure plan with plist template, Slack listener code, Telegram additions
- `research/plan-deep/scout-components.md` — scouted launchd patterns, Slack MCP, session parsers
- `research/plan-deep/gh-scout-deploy.md` — moltbook-heartbeat LaunchAgent scaffold, VPS bootstrap patterns
- `psdc/entity/identity/HEARTBEAT.md` — PD's heartbeat protocol (should exist from Phase 2D)
- `psdc/CLAUDE.md` — PD's behavioral config (from Phase 2D)
- `psdc/.claude/settings.json` — PD's permissions (from Phase 1A/2D)

## Task

### Section 3: Heartbeat System

#### 1. Write PD's HEARTBEAT.md (if not done in Phase 2D)

Fill in the heartbeat protocol from the template. PD's checks:
1. Read current-state.md — orient
2. Check `entity/data/inbox/` — messages from Wisdom
3. Scan Digital Core git log for recent changes
4. Check `entity/data/ideas/` — anything ripe to revisit
5. Check `entity/proposals/pending/` — anything stale (>5 days)
6. Write observations + update current-state.md

#### 2. Create launchd plist

File: `~/Library/LaunchAgents/com.ps.entity-heartbeat.plist`

Use the template from `plan-section-infrastructure.md`. Key parameters:
- StartInterval: 1800 (30 min)
- RunAtLoad: false
- claude binary: `/opt/homebrew/bin/claude` (confirmed in Phase 0)
- `--cwd` pointing to PD's directory
- `--model haiku` for cost efficiency
- `--max-turns 10`
- `--allowedTools "Read,Glob,Grep,Write"`
- Log output to `entity/data/heartbeat.log`
- Source `~/.env-heartbeat` for API key

#### 3. Create `~/.env-heartbeat`

Template (Wisdom fills in the actual key):
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

#### 4. Test heartbeat

```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.ps.entity-heartbeat.plist
launchctl kickstart -k gui/$(id -u)/com.ps.entity-heartbeat
```

Wait 90 seconds, then verify:
- `ls entity/data/observations/` — new dated file
- `cat entity/identity/current-state.md` — has "Last heartbeat" timestamp
- `cat entity/data/heartbeat.log` — shows claude run output

### Section 4: Slack Integration

#### 1. Document Slack app setup steps

Write a checklist for Wisdom to create the Slack app at api.slack.com:
- Create app, add bot scopes, install to workspace, get token + team ID
- Invite bot to relevant channels

#### 2. Add Slack MCP to global settings

Add to `~/.claude/settings.json` mcpServers section. Use env var pattern for tokens.

#### 3. Test Slack MCP

Start `claude -p --cwd psdc/` and ask it to post a message to a test channel.

#### 4. Write thin Python listener (optional for V1)

The `psbot/slack_listener.py` from `plan-section-infrastructure.md` — ~80 lines aiohttp server that routes Slack events to `claude -p`. Only needed if real-time Slack responses are wanted for V1.

### Section 5: Telegram Bot Refinement

#### 1. Add tool-use notifications

Modify `psbot/claude_proc.py` to yield `tool_use` events (code in `plan-section-infrastructure.md`).

#### 2. Add `/verbose` toggle

Add command handler to `psbot/bot.py` (code in `plan-section-infrastructure.md`).

#### 3. Clean up error handling

Replace raw exception messages with categorized user-friendly errors.

### Section 3b: Frank/Jen Heartbeat

Create a separate launchd plist for Frank/Jen's heartbeat:
- Same structure, different `--cwd` (points to `entities/frank-jen/`)
- Different heartbeat checks (calendar, morning practice, reminders)
- Same cost model (Haiku, 30-min interval)

## Output

- `~/Library/LaunchAgents/com.ps.entity-heartbeat.plist` — PD heartbeat
- `~/Library/LaunchAgents/com.ps.entity-heartbeat-frank.plist` — Frank/Jen heartbeat
- `~/.env-heartbeat` — API key template (not committed)
- Slack MCP added to `~/.claude/settings.json`
- `psbot/slack_listener.py` — thin Slack event listener (if built)
- `psbot/claude_proc.py` — tool notification additions
- `psbot/bot.py` — /verbose toggle + error handling cleanup
- Chronicle entry covering all infrastructure decisions

## Success Criteria

- [ ] PD heartbeat fires via launchd, produces observations, updates current-state.md
- [ ] Frank/Jen heartbeat fires, checks calendar context, updates state
- [ ] Heartbeat cost confirmed: ~$0.05-0.10/day per entity (Haiku)
- [ ] Slack MCP works: can post messages from `claude -p` session
- [ ] Telegram tool notifications appear for slow tools (Bash, Agent, WebFetch)
- [ ] `/verbose` toggle works in Telegram
- [ ] Error handling gives user-friendly messages, not raw exceptions
- [ ] Heartbeat log captures output for debugging
- [ ] Both heartbeats are non-blocking on denied actions
