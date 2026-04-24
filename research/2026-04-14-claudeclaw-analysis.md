# ClaudeClaw v2 Analysis — Prior Art for Claude Code Entities

**Date:** 2026-04-14
**Source:** YouTube video by Mark Kashef (Early AI Dopters), transcript + visual guide PDF + assessment prompt + power packs guide + rebuild mega prompt
**Video:** https://www.youtube.com/watch?v=rVzGu5OYYS0
**Upload date:** April 2026

---

## What ClaudeClaw Is

A personal AI assistant system built on Claude Code + Agent SDK. Uses existing Claude Code subscription (no API costs). TypeScript codebase (~8,000 lines) with Python War Room (~800 lines). Runs on Mac via launchd, accessible via Telegram/Slack/Discord/WhatsApp/browser dashboard/voice War Room.

## Architecture

- **Bridge:** Agent SDK (`@anthropic-ai/claude-agent-sdk@^0.2.34`) spawns real Claude Code CLI as subprocess
- **Session persistence:** Each chat maps to a session ID in SQLite, SDK's `resume` option continues conversations
- **Permission mode:** `bypassPermissions` — no tool-use confirmation prompts (would hang in headless mode)
- **Safety limits:** `maxTurns: 30` (prevents runaway tool loops), `AGENT_TIMEOUT_MS: 900000` (15 min)
- **Infrastructure:** Mac Mini + launchd (auto-start on boot) + Cloudflare Tunnel (remote access)

## Key Systems

### Multi-Agent (5 agents, max 20)
- Main (triage/delegation), Comms, Content, Ops, Research
- Each agent: own Telegram bot, own CLAUDE.md, own working directory, own MCP tool allowlist
- Coordination via "hive mind" — shared SQLite table where agents log significant actions
- Agent config in `agent.yaml` (not separate files), MCP filtering inline
- Default model: `claude-sonnet-4-6`
- Agent IDs: `/^[a-z][a-z0-9_-]{0,29}$/`
- 615-line agent creation wizard with Telegram API token validation
- Session isolation: composite key `(chat_id, agent_id)`
- External config: `CLAUDECLAW_CONFIG` env var, defaults to `~/.claudeclaw`

### Memory v2
- **Extraction:** Gemini `gemini-3-flash-preview` processes every conversation, extracts facts as structured data (summary, entities, topics, importance 0-1, salience 0-5)
- **Embeddings:** `gemini-embedding-001`, 768-dim vectors stored as Float32Array→Buffer in SQLite
- **Duplicate detection:** 0.85 cosine similarity threshold
- **5-layer retrieval:** semantic (cosine >0.3), FTS5 keyword, recent high-importance, consolidation insights, conversation history (7-day window)
- **Consolidation:** Every 30 minutes, Gemini finds patterns/contradictions across unconsolidated memories
- **Decay:** Importance-weighted rates: pinned=0%, high (≥0.8)=1%/day, mid (≥0.5)=2%/day, low (<0.5)=5%/day. Hard-delete at salience <0.05
- **Pinning:** User-controlled, exempt from decay forever
- **Supersession:** Newer contradicting memories override older ones (old gets `superseded_by` pointer)
- **Relevance feedback:** Post-response, Gemini evaluates which surfaced memories were useful. Useful ones get +0.1 salience, unused get -0.05
- **Nudging:** Configurable intervals (default 10 turns or 2 hours) trigger proactive memory surfacing
- **Fire-and-forget:** Extraction never blocks the user-facing response

### War Room (Voice)
- Browser-based on port 7860, Pipecat framework (Python)
- **Live mode (default):** Gemini Live handles STT+reasoning+TTS end-to-end. Tool functions: `delegate_to_agent`, `answer_as_agent`, `get_time`, `list_agents`. Auto-mode: Gemini acts as router.
- **Legacy mode:** Deepgram (STT) → Router → Agent Bridge → Cartesia (TTS). More control, more latency.
- GoT-themed personas: Main=Hand of the King (Charon), Research=Grand Maester (Kore), Comms=Master of Whisperers (Aoede), Content=Royal Bard (Leda), Ops=Master of War (Alnilam)
- 3-rule routing: broadcast ("everyone"), name prefix ("hey research"), pinned agent (`/tmp/warroom-pin.json`), default→Main
- Agent bridge: Python subprocess calls `node dist/agent-voice-bridge.js` which spawns real Claude Code
- `--quick` flag limits to 3 turns for snappy voice responses
- 69KB cinematic HTML UI with boardroom intro animation

### Mission Control
- 60-second cron polling scheduler
- Priority ordering (1-5, where 1 is highest)
- Agent assignment per task
- Mission queue for one-shot async tasks
- Auto-assignment via Gemini classification (cheap model)
- Stuck task recovery on startup (`resetStuckTasks()`)
- CLI: `schedule-cli.ts` (create, list, pause, resume, delete), `mission-cli.ts`

### Security (215 lines, single file)
- **PIN lock:** salted SHA-256, stored as `salt:hash`. `crypto.timingSafeEqual()` for comparison.
- **Idle auto-lock:** configurable minutes (default 30)
- **Emergency kill phrase:** case-insensitive exact match → SIGTERM all `com.claudeclaw.*` services → `process.exit(1)` after 5s
- **Exfiltration guard (separate file):** 15+ regex patterns scanning outbound messages. Catches: sk-, pk_, AKIA, xoxb-, ghp_, hex strings, Bearer tokens, base64-encoded secrets, URL-encoded secrets. Returns `SecretMatch[]` with type/position/length/preview. Replaces with `[REDACTED]`.
- **Audit log:** 7 event types (message, command, delegation, unlock, lock, kill, blocked)

### Voice (504 lines, single file)
- **STT cascade:** Groq Whisper (primary) → whisper-cpp (local fallback)
- **TTS cascade:** ElevenLabs (eleven_turbo_v2_5) → Gradium (45K free/month) → Kokoro (any OpenAI-compatible server, zero cost) → macOS `say`
- Automatic failover between providers

### Dashboard (Hono on port 3141)
- Token auth via `?token=` query param
- Memory timeline with search
- Token usage tracking with Chart.js graphs
- Agent status cards with model override + creation wizard
- Mission task queue with create/assign/reassign
- Hive mind activity log
- Audit trail browser
- War Room management endpoints
- SSE for real-time updates via `chatEvents` EventEmitter
- Privacy blur toggle
- 1,370 lines server + 3,200+ lines embedded HTML/CSS/JS (no React, no build step)

### Meeting Bot (792 lines)
- Joins Google Meet / Zoom with video avatar (Pika) or voice-only (Recall.ai)
- 75-second pre-flight briefing: Calendar (next 24h) + Gmail (30 days per attendee) + Memory
- Post-meeting summary with action items
- Cost: ~$0.275/min (Pika video)

### Message Pipeline
Each inbound message passes through 8 stages:
1. Telegram/Discord/etc → 2. FIFO Queue (per chat) → 3. Security gate (PIN + allowlist) → 4. Message classifier (simple vs complex) → 5. Memory inject (5-layer retrieval) → 6. Agent SDK (Claude Code subprocess) → 7. Exfiltration guard → 8. Cost footer → Reply

### Cost Footer (5 modes)
- compact: `[sonnet-4]`
- verbose: `[sonnet-4 | 2.1k in / 890 out]`
- cost: `[sonnet-4 | ~$0.03]`
- full: all fields
- off: nothing

---

## Comparison: ClaudeClaw vs Claude Code Entities

### Same Core Insight
Both systems arrive at the same conclusion: Claude Code IS the agent framework. Don't build a wrapper around Claude — use Claude Code's existing primitives (CLAUDE.md, rules, skills, MCP, settings.json) as the complete agent OS. Layer features on top.

### Key Differences

| Dimension | ClaudeClaw | Claude Code Entities |
|-----------|-----------|---------------------|
| **Transport** | Agent SDK (persistent process, session resumption) | `claude -p` (one-shot invocations) |
| **Identity** | Static CLAUDE.md per agent | SOUL.md (entity-authored, evolves), SEED.md (origin, read-only) |
| **Memory** | SQLite + Gemini extraction + embeddings + decay | Markdown files (current-state.md, chronicles, observations) |
| **Continuity** | Session resumption via SDK session ID | current-state.md letter-to-self |
| **Agents** | Specialized workers (Comms, Content, Ops, Research) | Entities with tuned identity (PD thinking partner, Frank/Jen on-call assistant) |
| **Autonomy** | All agents same permission model | Graduated per-entity (observe → propose → act) |
| **Self-modification** | No — CLAUDE.md is static | Yes — entity proposes rule changes, forms convictions |
| **Growth** | Agents don't change over time | convictions-forming.md, guardrails.md (learned from rejections) |
| **Code volume** | ~8,000 lines TypeScript + ~800 lines Python | Minimal code — mostly markdown + configuration |
| **Cost** | Higher (persistent processes, Gemini API for memory) | Lower (~$0.05/day heartbeat with Haiku) |
| **Voice** | Pipecat + Gemini Live / Deepgram+Cartesia (working) | Planned V2 (Whisper + Chatterbox + confidence prosody) |
| **Dashboard** | Full web UI (3,200+ lines) | None planned yet |
| **Commercial** | Paid community (Skool), power packs as upsell | HHA client product (per-entity pricing) |

### What ClaudeClaw Has That We Should Adopt

1. **Message Queue (FIFO per chat)** — Prevents race conditions when heartbeat fires during user message. Simple pattern, high value.

2. **Exfiltration Guard** — 15+ regex patterns scanning outbound messages. We have web-content-safety for inbound, nothing for outbound. Critical for autonomous entities.

3. **Memory Decay + Pinning** — Our memory is append-only. Decay prevents bloat. Pinning preserves fundamentals. The importance-weighted tiers are elegant.

4. **Gemini as Memory Classifier** — Cheap model decides what's worth remembering. We could use Haiku during heartbeat for this.

5. **Cost Tracking per Entity** — Token usage tracking with budget warnings. Important for HHA pricing model.

6. **Dashboard** — Web UI for monitoring entities. Huge for client-facing product.

7. **Session Resumption** — Agent SDK's `resume: sessionId` gives much better continuity than our current `claude -p` approach. Consider for V2.

8. **Error Classification with Retry** — Categorizes errors (auth, rate_limit, context_exhausted, timeout, etc.) and maps to recovery strategies. We don't have this.

9. **`maxTurns` Safety Limit** — Prevents runaway tool-use loops. We have `--max-turns 10` in heartbeat but should make this configurable per entity.

10. **Stuck Task Recovery** — On startup, resets any tasks left in 'running' state. Prevents orphaned heartbeats.

### What We Have That ClaudeClaw Doesn't

1. **SOUL.md** — Entity writes and revises its own identity. ClaudeClaw agents have static CLAUDE.md.
2. **SEED.md** — Origin story, read-only forever. Birth certificate concept.
3. **convictions-forming.md** — Earned beliefs tracked with evidence and confidence scores.
4. **guardrails.md** — Append-only constraint accumulation from rejected proposals.
5. **Proposal system** — Entity proposes changes, human approves/rejects, entity learns from rejections.
6. **Entity tuning model** — Same infrastructure, different tuning per user (PD vs Frank/Jen vs client).
7. **current-state.md as letter-to-self** — Human-readable, debuggable continuity that survives compaction.
8. **Digital Core as cognitive architecture** — Rules aren't just configuration, they're the entity's values interpreted through experience.
9. **Graduated autonomy spectrum** — On-call → observant → thinking partner → autonomous explorer.
10. **Earned conviction architecture** — Beliefs strengthen/weaken based on evidence, not installed.

### What Neither System Has Yet

1. **True persistent memory across context windows** — Both rely on reconstructing context each time
2. **Associative Memory integration** — Graph-based memory that navigates rather than retrieves
3. **Confidence-modulated voice prosody** — Speaking style that reflects epistemic state
4. **Cross-modal memory** — Voice and text sharing one memory store
5. **Persona drift detection** — Detecting when entity behavior diverges from SOUL.md
6. **Self-governance** — Entity managing its own resource allocation

---

## Documented Failure Modes (from ClaudeClaw experience)

1. **Overlapping runs corrupting state** — Two heartbeats running simultaneously. Fix: lockfile pattern.
2. **PATH in cron/launchd** — `claude` not found because cron doesn't load shell profile. Fix: hardcode full binary path.
3. **Auth in headless context** — API key not available. Fix: explicit env sourcing.
4. **Context bloat** — State files grow unboundedly. Fix: cap hot state at ~4KB, move cold data to searchable storage.
5. **Memory feedback loops** — Agent self-validates without external check, becomes optimistic. Fix: external relevance evaluation.
6. **OGA vs OGG** — Telegram voice notes are .oga, Groq Whisper rejects .oga. Same format, rename to .ogg.
7. **`bypassPermissions` required** — Without it, Claude pauses for confirmation and the bot hangs.
8. **Typing indicator expiry** — Telegram's typing expires after 5s. Must refresh every 4s.
9. **FTS5 trigger amplification** — Triggers on non-content columns cause write amplification during decay sweeps. Restrict to content columns only.
10. **PIN timing attacks** — Use `crypto.timingSafeEqual()`, not `===`. String comparison short-circuits.
11. **Gemini embedding storage** — Store as Float32Array→Buffer (3072 bytes), not JSON (10x larger).
12. **Agent bridge subprocess timeout** — Must match AGENT_TIMEOUT_MS (900s/15min).

---

## Commercial Model

- Paid community on Skool (Early AI Dopters)
- Power Packs as modular upsell (8 packs, each self-contained)
- Free resources (blueprints, PDF guide) to drive community signups
- Assessment prompt for existing users → identifies which packs to buy
- One-click clone for full repo access (paid tier)

---

## Sources

- Video transcript: ~4,570 words, 22 minutes
- Visual guide PDF: 35 pages with hand-drawn diagrams
- Assessment prompt: Feature checklist for auditing existing installs
- Power Packs guide: Detailed technical specs for each of 8 modular packs
- Rebuild mega prompt: Complete build specification (~25,000 words, covers all 45+ files)

---

## Ideas for Claude Code Entities (from this analysis)

### Immediate (V1)
- Add message queue pattern to prevent heartbeat/user message race conditions
- Add `--max-turns` as configurable parameter in entity settings
- Add stuck task recovery to heartbeat (reset any orphaned running states)

### V1.5
- Add exfiltration guard (adapt web-content-safety to outbound messages)
- Add cost tracking per entity per day
- Consider Agent SDK for session resumption instead of `claude -p`
- Add error classification with retry policies

### V2
- Browser dashboard for entity monitoring (steal patterns from ClaudeClaw's 3,200-line embedded HTML)
- Memory decay + pinning (importance-weighted, pinned memories persist forever)
- Gemini/Haiku as memory classifier during heartbeat
- Pipecat integration for voice War Room
- Meeting bot with pre-flight briefing (Calendar + email + memory)

### Commercial (HHA)
- Power Packs model is interesting — modular feature add-ons at fixed prices
- Assessment prompt pattern — audit existing setup, recommend upgrades
- Dashboard as client-facing product differentiator
- ClaudeClaw charges via community membership; HHA charges per-entity monthly
