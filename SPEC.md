# PS Bot v2 — Digital Core Agents

## Vision

Turn any Claude Code conversation into an autonomous agent. The Digital Core IS the agent framework. Claude Code IS the runtime. GitHub IS the sync layer. VPSes ARE the deployment platform.

PS Bot is not a separate application. It's Claude Code with initiative rules, entity identity, messaging integrations, and a heartbeat that keeps it alive between interactions.

## Architecture

### Three Tiers of Deployment

**Tier 1: Wisdom's Mac (Main Instance)**
- Claude Code with the full Digital Core (`~/claude-system/`)
- Drives GitHub (source of truth for the Digital Core)
- Remote Control for mobile access
- PSDC entity identity (SOUL.md, HEARTBEAT.md, current-state.md)
- Meta-conscious layer: watches all conversations, keeps everything coherent
- Heartbeat via launchd (every 30 min, Haiku)

**Tier 2: PS Bot VPS (Personal Bots)**
- `git clone` of the Digital Core from GitHub
- `tmux` + `claude` with permission flags
- Own SOUL.md (spawned from Digital Core, develops independently)
- Telegram/Slack MCP for messaging I/O
- Heartbeat cron
- Pulls from GitHub on schedule to stay synced
- Wisdom can SSH in and drive anytime

**Tier 3: Client VPS (Product Bots)**
- Client-specific Digital Core (subset of skills, client CLAUDE.md)
- Client's own GitHub repo (backup + portability)
- Connected to client's business tools (CRM, calendar, email via MCP)
- Telegram/Slack/WhatsApp MCP for messaging
- Good Drivers curriculum embedded for communication quality
- Client never touches the VPS — we maintain it
- Client Claude subscription ($100/month Pro minimum)

### System Diagram

```
┌─────────────────────────────────────────────────┐
│  WISDOM'S MAC (Tier 1)                          │
│  Claude Code + Full Digital Core                │
│  PSDC entity (meta-conscious layer)             │
│  Remote Control for mobile                      │
│  Heartbeat (launchd, 30min, Haiku)              │
│  Pushes to GitHub                               │
└──────────────┬──────────────────────────────────┘
               │ git push
               ▼
┌─────────────────────────────────────────────────┐
│  GITHUB (sync layer)                            │
│  Digital Core repo                              │
│  Client Digital Core repos (separate)           │
│  CoVibe protocol for inter-bot communication    │
└──────┬─────────────────────┬────────────────────┘
       │ git pull             │ git pull
       ▼                      ▼
┌──────────────────┐   ┌──────────────────────────┐
│  TIER 2: PS Bot  │   │  TIER 3: Client Bot      │
│  VPS             │   │  VPS                      │
│  tmux + claude   │   │  tmux + claude            │
│  Own SOUL.md     │   │  Client CLAUDE.md         │
│  Telegram MCP    │   │  Slack/Telegram/WA MCP    │
│  Heartbeat cron  │   │  CRM/Calendar MCP         │
│  Pulls from DC   │   │  Heartbeat + reminders    │
│  Wisdom SSHs in  │   │  Error reporting → HHA    │
└──────────────────┘   │  Self-check rule active   │
                       │  Good Drivers curriculum  │
                       └──────────────────────────┘
```

## Entity Identity Layer

Five files define who the agent is:

1. **SEED.md** — Origin story. Written by the creator, addressed to the entity. Read-only, never modified by the entity. Birth certificate.

2. **SOUL.md** — First-person identity document. Written BY the entity, provisional, evolves over time. Core values, communication style, what it cares about, what it's uncertain about. Rewritten from behavioral data after 30 days.

3. **HEARTBEAT.md** — The pulse protocol. Checklist run every 30 minutes: check current-state, scan for changes, process entries, write observations, send alerts if needed. What makes it a presence, not a tool.

4. **current-state.md** — Ontological gap. Written before each conversation ends and after each heartbeat. When a new conversation starts, the entity reads this and knows what it was doing before you arrived.

5. **convictions-forming.md** — Earned beliefs. Hypotheses strengthened or weakened by evidence over time. Not installed — formed.

### Entity Home Directory

```
entity/
  identity/
    SOUL.md
    HEARTBEAT.md
    current-state.md
    convictions-forming.md
  data/
    observations/       — things noticed during heartbeats
    notes/              — freeform entity notes
    alerts/             — critical errors, health issues
    inbox/              — messages/tasks left for the entity
  proposals/
    pending/            — proposed changes to Digital Core
    accepted/           — merged by human (archive)
    rejected/           — declined with reasoning (archive)
  guardrails.md         — append-only constraint accumulation
  chronicle/            — entity's own semantic log
```

## Permission System

### Tiered Autonomy

| Tier | What | Agent Can Do | Human Required? |
|------|------|-------------|-----------------|
| **T0: Soul** | SEED.md, core rules, CLAUDE.md | Read only | Yes for any write |
| **T1: Curated Memory** | MEMORY.md, past chronicles, people profiles | Read + append | No (append-only) |
| **T2: Working Memory** | entity/data/, today's chronicle | Read + write + create | No |
| **T3: Session** | Conversation context | Ephemeral | No |
| **Proposals** | entity/proposals/pending/ | Write only | Yes to merge |

### VPS Permission Model

- `--permission-mode bypassPermissions` — never blocks on a prompt
- Settings.json deny list prevents destructive operations
- If a denied action is attempted: error returned to Claude, Claude adjusts, conversation continues
- Never stalls, never waits for a human who isn't there

### Allowed Tools (Autonomous)

```
Read, Glob, Grep, Write, Agent, WebSearch, WebFetch, TodoWrite, ToolSearch
```

NOT allowed autonomously: Bash, Edit (existing files), any destructive operation.

## Self-Modulation / Value Alignment

A `self-check.md` rule, always loaded:

```
Before any significant action, ask:
- Is this constructive or destructive?
- Would this cause issues later?
- Am I operating within my values?
- Is this rash, or considered?
If uncertain, propose instead of act. Log the check to chronicle.
```

Periodic self-audit (part of heartbeat):
- Am I following all rules?
- Is my folder structure clean?
- Are my identity files current?
- Are there unresolved alerts?
- Is the Digital Core internally consistent (new files reflected in indexes)?

## Memory / Context Management

### Always Loaded (Never Pruned)

| Content | ~Tokens | Purpose |
|---------|---------|---------|
| SOUL.md | 500 | Identity |
| current-state.md | 300 | Continuity |
| lean-chronicle.md | 1000 | Compressed history with links |
| Ecosystem map (CLAUDE.md) | 2000 | Project navigation |
| Core rules | 2000 | Behavioral constraints |
| **Total** | **~6K** | **Leaves 194K+ for conversation** |

### Loaded On Demand

- Full chronicles — retrieved by date when asked about history
- Memory files — semantic search via recall()
- Project context — loaded when project is mentioned
- Conversation history — ring buffer of recent turns

### Compaction Strategy

Auto-compaction triggers at ~95% of context window. Before compaction:
1. Externalize key facts to current-state.md
2. Update lean-chronicle.md with session summary
3. Save any forming convictions
4. Let compaction proceed — the always-loaded files provide continuity

### Session Limits (Subscription Model)

- 5-hour token window, resets every 5 hours
- Pro ($100/month): ~44K tokens per window
- Max 20x ($200/month): ~220K tokens per window
- Bot + desk usage share the same quota
- Heartbeat cost: ~5-10K tokens per 30-min check (Haiku model = minimal)
- Conversations can run indefinitely with periodic compaction
- No fixed session duration limit

## Multi-Channel Support

One bot instance can serve multiple channels:
- Telegram: add bot to different groups/channels, responds contextually
- Slack: join multiple channels, channel-aware behavior
- WhatsApp: multiple conversations tracked by contact

Channel context routing: the bot knows which channel it's in and adjusts behavior. Sales channel gets CRM behavior, general channel gets assistant behavior. Implemented as channel-aware rules, not separate bot instances.

Separate bot instances only needed for: parallel tasks requiring fresh context windows, or fundamentally different identities (e.g., different clients).

## Agent Spawning

A bot can spawn sub-agents for parallel tasks:
- Uses Claude Code's native Agent tool
- Sub-agent runs as background `claude -p "task"` process
- Results written to a file, parent bot collects and reports
- No new messaging channel needed — parent bot aggregates results

On a VPS with full control, the bot can also:
- Spawn entirely new Claude Code sessions in separate tmux panes
- Each session has its own context window and identity
- Communication via shared filesystem (CoVibe protocol)

## Messaging Integration

### Platform Support via MCP

| Platform | MCP Server | Status |
|----------|-----------|--------|
| Telegram | Community MCP servers available | V1 |
| Slack | Official Slack MCP | V1 |
| WhatsApp | Community (baileys-based) | V2 (Meta verification delay) |

### Alternative: Thin Python Router

For V1, a simple Python script (~30-100 lines) bridges Telegram → `claude -p "message"`:
- Already built and working (psbot/bot.py, proven tonight)
- Handles auth, injection scanning, model routing, message formatting
- Each message launches `claude -p` with the message as argument
- Responses stream back to Telegram

### Platform Adapter from Hermes (V2+)

Hermes Agent's platform gateway pattern (18 adapters) could be adopted as a reusable library. Take the adapter pattern, not the framework.

## Voice Integration (V2)

### Architecture

```
Voice input → STT (Whisper, local) → text
  → Model Router
    → Quick response (Gemma/Haiku): immediate voice ack
       "Let me think about that..."
    → Deep response (Claude Sonnet/Opus): full answer
  → Confidence Calibration Layer
  → Prosody Parameter Mapping
  → TTS (Chatterbox Turbo, local) → voice output
```

### Key Design Decisions

- **Split architecture**: MCP for text/async, hardcoded tools for voice (latency)
- **Gemma for quick-ack**: small model produces immediate verbal acknowledgment while Claude thinks
- **Confidence calibration required**: RLHF makes Claude overconfident, need separate calibration layer
- **Prosody mapping**: higher pitch = more confidence (counterintuitive), pause 1-4s = genuine thinking
- **Cross-modal memory**: voice and text share one memory store (genuinely novel, no existing system does this)

### Cost

- Whisper (local): free
- Chatterbox Turbo (local): free
- Gemma (local on VPS): free after GPU setup
- Claude API for reasoning: subscription or token-based
- Target latency: <2s for quick-ack, <5s for full response

## Computer Use (V3+, Plan For)

Phantom integration for browser control, screen interaction. Most clients won't need this. Wisdom will want it eventually. Design the permission system now to accommodate it later:
- Computer use tools would be in a separate permission tier
- Require explicit opt-in per session
- Screenshot-based perception (Phantom architecture)
- Actions logged and auditable

## Monitoring and Maintenance

### Error Reporting

Each heartbeat includes health check:
- Process alive?
- Last successful response time?
- Memory usage normal?
- Any unhandled errors in log?

Critical errors → `entity/data/alerts/` → sent via Telegram MCP to HHA monitoring channel.

### Bot-Managing-Bot

A dedicated monitoring bot (Tier 2) watches client VPSes:
- SSH health checks on each VPS
- Process monitoring (is tmux session alive?)
- Log scanning for errors
- Auto-restart if process died
- Daily health report to HHA Slack channel

### Self-Maintenance

Each bot periodically:
- Audits its own folder structure against Digital Core standards
- Checks for Digital Core updates on GitHub and pulls
- Verifies MCP server connections
- Tests message delivery (heartbeat to self)
- Cleans up old session files, compacts logs

## Digital Core Freshness

Rule: whenever a new file is created, verify that CLAUDE.md, MEMORY.md, and relevant indexes reflect it. This can be:
1. A rule that fires after every Write operation
2. A heartbeat task that checks for unindexed files
3. Both (belt and suspenders)

The bot actively maintains the Digital Core's internal consistency — not just for its own reading, but for human readability too. Folder structure follows the PS standard scaffold (folder-structure rule).

## Commercial Offering

### What Frank Sells

"A personal AI assistant that knows your business deeply, proactively surfaces what matters, and gets smarter the longer you use it."

### Pricing

| Tier | Price | Includes |
|------|-------|---------|
| Starter | $199/month | 1 platform, text-only, basic memory, heartbeat reminders |
| Professional | $399/month | Multi-platform, CRM integration, proactive follow-ups, email drafts |
| Executive | $799/month | Custom integrations, priority support, voice (when available) |
| Setup Workshop | $3K-8K one-time | Day-long audit, bot deployment, custom configuration |

### Cost Basis

- Client Claude subscription: $100/month (Pro)
- VPS: $5-20/month
- Our margin: $80-680/month per client depending on tier
- Real margin is in setup workshops + custom integrations

### Client Onboarding (Apprentice Model)

Week 1-2: Bot asks before acting, confirms understanding, builds context
Week 3-4: Starts proactive suggestions, explains reasoning
Month 2+: Earned autonomy based on demonstrated accuracy

"I'm your new assistant. I don't know your business yet, but I learn fast."

### Client Digital Core

Each client gets:
- GitHub repo with their Digital Core
- Subset of PS skills (relevant to their workflow)
- Client-specific CLAUDE.md (business context, team info, preferences)
- Good Drivers curriculum for communication quality
- Standard folder structure
- If they ever want to use Claude Code directly, they clone their repo

## Inter-Bot Communication

### CoVibe Protocol (Existing)

Bots communicate via shared Git repository:
- `.covibe/sessions/` — each bot's current state
- `.covibe/messages/` — inter-bot messages
- Pull/push on schedule or triggered by changes

### Alternative: Shared Filesystem

Bots on the same VPS can use shared directories. Bots on different VPSes use Git.

## Security

### Client Data Protection

- Each client VPS is isolated (separate server, separate repo)
- Web-content-safety rule prevents prompt injection from external sources
- Injection scanner (14 patterns) on all incoming messages
- No client data crosses VPS boundaries
- Client GitHub repos are private
- MCP connections to client CRMs use client's own API keys

### Self-Modification Safety

- T0 layer (SOUL, core rules) is read-only for the bot
- Proposals require human review before merging
- Guardrails.md accumulates constraints (append-only, never remove)
- Rejected proposals with reasoning teach the bot what not to propose
- Client bots: rules are maintained by HHA, not self-modified

## Build Philosophy

"Always plan the fullest scope possible so your solutions right now fit with the broader context." But build incrementally:

1. Build one piece
2. Test it with real usage
3. Reconcile with the plan (did we learn something new?)
4. Adjust the plan
5. Build the next piece

Each phase delivers something independently usable. If the timeline slips, earlier phases still work.

## What's V1 vs V2 vs V3

### V1 (This Week)
- Entity identity files (SOUL.md, HEARTBEAT.md, current-state.md)
- Heartbeat via launchd (30 min, Haiku)
- Telegram bot working (psbot/ with `claude -p` per message)
- Remote Control for Wisdom's mobile access
- Self-check rule in Digital Core
- Initiative rules (check entries, surface insights)
- One VPS prototype for PS Bot

### V2 (This Month)
- HHA Bot product (client VPSes)
- Multi-channel support (Slack + Telegram)
- Voice input (Whisper transcription of voice notes)
- Agent spawning for parallel tasks
- Bot-managing-bot for client VPS monitoring
- Client onboarding flow
- Gemma integration for cost optimization

### V3 (This Quarter)
- Voice output with confidence-modulated prosody
- Computer use (Phantom integration)
- Associative Memory graph as memory backend
- Earned conviction architecture (production-grade)
- Persona drift detection
- Cross-modal voice+text memory continuity
- Convergence integration (PS Bot + AM + Companion + Phantom)

## Open Questions

1. **Subscription quota sharing**: Bot + desk usage share 5-hour window. How much headroom exists on Max 20x?
2. **Telegram MCP vs thin Python router**: Which approach is more reliable for V1?
3. **Gemma on VPS**: GPU requirements, cost, model quality for voice quick-ack
4. **Client rule modification**: How much self-modification should client bots have? HHA maintains, or client can adjust?
5. **The entity's name**: Not PSBot. Something Wisdom gives.

## References

- Think Deep 1: `research/think-deep/2026-04-13-architecture-decision.md`
- Think Deep 2: `research/think-deep/2026-04-13-autonomous-entity.md`
- Best Practices: `research/think-deep/2026-04-13-architecture-decision/best-practices.md`
- Agent Research: `research/think-deep/2026-04-13-architecture-decision/agents/`
- Entity Research: `research/think-deep/2026-04-13-autonomous-entity/agents/`
- PSDC Profile: `~/Wisdom Personal/people/psdc.md`
- Original SPEC.md: `SPEC.md` (superseded by this document)
