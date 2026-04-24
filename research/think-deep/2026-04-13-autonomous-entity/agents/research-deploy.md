# Research: Claude Managed Agents as Bot Platform + Fast Deployment Paths

**Stream:** Deploy path analysis
**Date:** 2026-04-13
**Researcher:** Claude Sonnet 4.6 (subagent)

---

## Key Discoveries

### 1. Claude Managed Agents (launched April 8, 2026) — NOT a messaging platform backend

Managed Agents is an agent execution harness, not a persistent stateful bot service. The model is:

- **Agent** = model + system prompt + tools (defined once, reused)
- **Environment** = cloud container with packages + network access
- **Session** = one running task instance (starts, runs to completion, goes idle)
- **Events** = SSE stream of messages in/out

Sessions emit `session.status_idle` when done. They are task-oriented, not conversation-persistent. There is no native "keep a session alive for a user's ongoing Telegram thread" model — you'd spin a new session per message or manage session IDs yourself in a database.

**Pricing:** $0.08 per session-hour + standard token costs.

**What it's good for:** Long-running autonomous tasks (minutes to hours), multi-tool execution, background work. Not optimized for rapid-fire conversational back-and-forth.

**MCP access:** Yes — you can mount MCP servers on an agent definition. Tools include bash, file ops, web search/fetch, and MCP servers.

**API:** Fully programmable. Python/TS/Go/Ruby/PHP SDKs. Beta header: `managed-agents-2026-04-01`.

**Research-preview features** (require separate access request): memory, multi-agent coordination, outcome-based self-evaluation.

**Verdict for messaging bot:** Viable as the *execution backend* for complex tasks triggered via Telegram. Not the right tool as the *conversation layer* itself — that glue code is yours to write.

### 2. Fastest Telegram + Claude Path — Official Channels Plugin (< 30 min)

Anthropic's official Telegram channel plugin (`claude-plugins-official/external_plugins/telegram`) is the fastest path:

1. Create bot via @BotFather → copy token
2. `claude --channels plugin:telegram@claude-plugins-official`
3. DM your bot → messages forward to your running Claude Code session

**Limitations:** Requires Claude Code session to be running (not always-on unless you daemonize). Best for personal use or dev access, not multi-tenant product sales.

**For a real always-on product:** You need a lightweight webhook server that bridges Telegram → Claude API → Telegram. Minimal stack: Python + python-telegram-bot + Anthropic SDK + SQLite for per-user conversation history. This is 100-200 lines of code and deployable in under 2 hours.

Reference architecture (FastAPI-based, from danoncoding.com):
- FastAPI receives Telegram webhook POST
- Load user's conversation history from SQLite
- Call `client.messages.create()` with history
- Store assistant reply, send back via Telegram Bot API

### 3. Hermes Agent — Under 1 Hour to Deployable Multi-Platform Bot

Hermes Agent (Nous Research) is the most complete out-of-box solution:

**Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

**Platforms supported natively:** Telegram, Discord, Slack, WhatsApp, Signal, CLI — all from a single gateway process.

**Memory:** Built-in skill document system. Generates reusable markdown records after complex tasks. Persistent in `~/.hermes/`.

**Setup time:** Under 1 hour from fresh VPS to working Telegram-connected agent (KVM 2 VPS, ~$5-10/month).

**Limitation:** Not Claude-native (uses its own model layer, Ollama-compatible). Less tight integration with your existing Digital Core, rules, and skills.

### 4. WhatsApp — Significantly More Friction

WhatsApp requires Meta Business Verification + approved templates. Even with Twilio abstracting Facebook's approval process, setup takes days not hours. Not viable for a 2-3 day sprint. Twilio handles webhook hosting, but:
- Per-message pricing on top of API costs
- Marketing messages explicitly excluded from volume discounts
- Approval gating on message templates

**Verdict:** Skip for MVP. Add post-launch.

### 5. OpenClaude / Hindsight Pattern — 30 Min with Persistent Memory

Claude Code + official Telegram channel plugin + Hindsight memory engine:
- Hindsight extracts structured facts (decisions, preferences, relationships) from conversations
- Injects relevant context before each prompt automatically
- ~30-minute setup for a persistent-memory agent accessible from phone

Best option if you want to demonstrate "learns your business over time" — the Hindsight memory layer is already solving that problem.

---

## Surprises

1. **Managed Agents is task-oriented, not conversation-persistent.** The session model is designed for "run this task to completion," not "maintain an ongoing relationship with a user." Treating it as a always-on chat backend would be awkward and expensive ($0.08/session-hour adds up if sessions stay open).

2. **The official Anthropic Telegram plugin already exists and takes minutes to configure.** This was not widely known. It's an official MCP server in `anthropics/claude-plugins-official`.

3. **Hermes supports WhatsApp natively** — the only option surveyed that does without Meta Business API friction.

4. **Your existing Digital Core is already the hardest part.** The system prompt, rules, skills, and knowledge base that make Wisdom's setup powerful — that's the moat. The Telegram bridge is commodity plumbing (~150 lines).

5. **Session persistence in Managed Agents** is event-history-based (fetchable), not conversational-memory-based. For a CRM-capture use case, you'd still need your own storage layer.

---

## Fastest Verified Path

### To "working bot on Telegram" in under 24 hours:

**Option A — Personal/demo use (< 1 hour):**
Claude Code + official Telegram channels plugin. No server needed. Sessions persist as long as Claude Code runs. Good for demoing to Frank, showing prospects, dogfooding.

**Option B — Sellable product (2-4 hours):**
Minimal custom webhook server:
1. Create Telegram bot (@BotFather) — 5 min
2. Deploy a Python FastAPI webhook to Railway/Fly.io — 30 min
3. Wire Anthropic SDK with per-user SQLite conversation history — 1 hour
4. Upload your existing system prompt + knowledge base as the agent's identity — 30 min
5. Configure webhook URL in Telegram — 5 min

Total: 2-3 hours to a multi-user Telegram bot with conversation memory, running your Digital Core system prompt.

**Option C — Multi-platform without custom code (< 1 hour):**
Deploy Hermes Agent on a $5 VPS. Get Telegram + Discord + Slack + WhatsApp in one install. Trade-off: not Claude-native, less integration with your existing infrastructure.

### To "sellable product on multiple platforms" in under 1 week:

Start with Option B (Telegram), add Slack via the same webhook pattern in day 2, then evaluate whether Hermes is worth adopting for WhatsApp access. Managed Agents becomes relevant when you want to offer "run a complex task for me" (not "be my ongoing assistant") — e.g., "research this prospect and enter them into my CRM."

---

## Sources

- [Claude Managed Agents Overview](https://platform.claude.com/docs/en/managed-agents/overview)
- [Claude Managed Agents Quickstart](https://platform.claude.com/docs/en/managed-agents/quickstart)
- [Claude Managed Agents Deep Dive (DEV Community)](https://dev.to/bean_bean/claude-managed-agents-deep-dive-anthropics-new-ai-agent-infrastructure-2026-3286)
- [Anthropic Launches Claude Managed Agents for Enterprise AI (Winbuzzer)](https://winbuzzer.com/2026/04/10/anthropic-launches-claude-managed-agents-enterprise-ai-xcxwbn/)
- [Claude Code Telegram Plugin README (anthropics/claude-plugins-official)](https://github.com/anthropics/claude-plugins-official/blob/main/external_plugins/telegram/README.md)
- [OpenClaude: Claude Code Agent with Long-Term Memory via Telegram (Hindsight)](https://hindsight.vectorize.io/blog/2026/03/23/claude-code-telegram)
- [Building an AI Telegram Agent with Python and Claude (Dan on Coding)](https://danoncoding.com/building-an-ai-telegram-agent-with-python-and-claude-2f18a0d1a6dc)
- [Hermes Agent Setup Guide — VPS + Telegram (Medium)](https://medium.com/@0xmega/hermes-agent-the-complete-setup-guide-telegram-discord-vps-no-mac-mini-required-dda315a702d3)
- [Hermes Agent GitHub](https://github.com/nousresearch/hermes-agent)
- [WhatsApp Business API + Twilio Overview](https://www.twilio.com/docs/whatsapp/api)
- [Claude Code Channels Documentation](https://code.claude.com/docs/en/channels)
- [RichardAtCT/claude-code-telegram (GitHub)](https://github.com/RichardAtCT/claude-code-telegram)
