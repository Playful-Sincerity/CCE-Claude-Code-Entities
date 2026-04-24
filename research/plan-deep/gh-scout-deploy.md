# GH Scout — Deployment & Operational Patterns for Autonomous Claude Code Agents
**Date:** 2026-04-13
**Context:** PS Bot V2 / Digital Core Agents — scouting how people actually deploy Claude Code to VPSes and run autonomous agents in production.

---

## Summary

Searched 7 domains. Found ~25 relevant repos. 11 passed initial vetting. Key insight: **the field is 6-12 months behind what SPEC-v2 describes.** Most "autonomous Claude Code on VPS" work is very recent (late 2025 / early 2026) and mostly works around active bugs rather than clean patterns. The most immediately useful finds are in the tmux orchestration, Slack integration, and dotfiles-sync buckets.

---

## Critical Warning: Known Bugs in `--dangerously-skip-permissions`

Before anything else — there are **active, unresolved bugs** in Claude Code's permission bypass system as of April 2026:

1. **`--dangerously-skip-permissions` does NOT bypass `.claude/` directory writes.** Claude still prompts "authorize Claude to modify its config files" even with the flag. This blocks autonomous operation if the agent needs to write to its own identity files. Issues: [#37765](https://github.com/anthropics/claude-code/issues/37765), [#35718](https://github.com/anthropics/claude-code/issues/35718), [#37157](https://github.com/anthropics/claude-code/issues/37157)

2. **`--channels` mode crashes headless (15-20s) with stdin error.** Running `claude --channels <plugin>` as a systemd service or background process dies with `"Input must be provided either through stdin or as a prompt argument."` Confirmed on Ubuntu VPS. No official workaround yet. Issue: [#40726](https://github.com/anthropics/claude-code/issues/40726), duplicate of [#36001](https://github.com/anthropics/claude-code/issues/36001)

3. **Permission mode resets mid-session.** `bypassPermissions` reverts to `editAutomatically` mid-session in some versions. Issue: [#39057](https://github.com/anthropics/claude-code/issues/39057), [#45290](https://github.com/anthropics/claude-code/issues/45290)

4. **Subagents inherit `bypassPermissions` unconditionally.** When a parent uses bypassPermissions, all spawned subagents also bypass — you can't scope it per-subagent. Issue: [#20264](https://github.com/anthropics/claude-code/issues/20264)

**Implication for PS Bot V2:** The thin Python router (`claude -p "message"`) approach documented in SPEC-v2 is the **correct V1 architecture** — it sidesteps the `--channels` stdin bug entirely. MCP-based messaging is a V2+ goal once these bugs stabilize.

---

## Repo Findings

### 1. `mpociot/claude-code-slack-bot`
**URL:** https://github.com/mpociot/claude-code-slack-bot
**Stars:** 151 | **License:** MIT | **Language:** TypeScript

**What it does:** Slack bot → Claude Code SDK. Socket Mode for real-time events. Maintains conversation sessions per Slack thread/DM. Supports MCP servers as extensions.

**Architecture:** `Slack event → slack-handler.ts → claude-handler.ts → Claude Code SDK`

**Relevant patterns:**
- Session scoping per thread (thread_id as session key) — directly applicable to our Telegram/Slack channel context routing
- MCP server mounting at runtime (opt-in per deployment)
- Streaming responses back to Slack as Claude generates

**Gaps for PS Bot:** Designed for local/user-directed use, not autonomous server operation. No heartbeat, no autonomous initiative, no VPS deployment docs.

**Adopt:** The session-per-thread pattern and the `claude-handler.ts` SDK integration approach.

---

### 2. `engineers-hub-ltd-in-house-project/slack-claude-code-integration`
**URL:** https://github.com/engineers-hub-ltd-in-house-project/slack-claude-code-integration
**Stars:** 11 | **License:** Open source (specific license not visible) | **Language:** Mixed

**What it does:** Three-tier architecture — Slack Bot → custom MCP server → Claude Code CLI. Includes Docker Compose for deployment.

**Architecture:** `Slack → Slack Bot → claude-code-mcp/ (custom MCP wrapper) → Claude Code CLI`

**Relevant patterns:**
- MCP server wrapping the CLI is an interesting pattern — lets you control exactly what Claude Code can do
- `--project` flag for multi-project switching from a single bot instance
- Docker Compose deployment (closest thing to a VPS deploy recipe found)
- Two modes: test (simulated) and production (real FS access) — good safety default for onboarding new clients

**Adopt:** Docker Compose pattern + the test/production mode separation for client onboarding.

---

### 3. `tuannvm/slack-mcp-client`
**URL:** https://github.com/tuannvm/slack-mcp-client
**Stars:** 167 | **License:** MIT | **Language:** Go

**What it does:** Production-grade bridge — Slack → LLM + MCP tools. Server-side always-on. Supports Claude, GPT-4, Ollama. Kubernetes Helm charts + Docker.

**Architecture:** `Slack (Socket Mode) → LLM-MCP Bridge → [MCP servers: filesystem, git, k8s, custom]`

**Relevant patterns:**
- **Most production-ready deployment model found.** Helm charts + Docker = proper VPS deployment.
- Agent mode with LangChain for multi-step reasoning (vs single response)
- Server-prefixed tool names to prevent MCP naming conflicts — useful when mounting many MCP servers
- `config.json` with env var substitution — clean config management across VPS instances

**Adopt:** Config management pattern + Kubernetes/Docker deployment model for the HHA multi-client VPS tier. Agent mode pattern for multi-step Slack interactions.

---

### 4. `Dicklesworthstone/agentic_coding_flywheel_setup`
**URL:** https://github.com/Dicklesworthstone/agentic_coding_flywheel_setup
**Stars:** 1,400 | **License:** MIT + OpenAI/Anthropic Rider | **Language:** Shell

**What it does:** One-liner bootstraps fresh Ubuntu VPS → complete multi-agent AI dev environment. Installs Claude Code, Codex CLI, Gemini CLI, NTM, tmux config, all toolchains. 30 minutes from blank VPS to running agents.

**Architecture:** Idempotent installer with `~/.acfs/state.json` checkpoint system. Enables "dangerous agent flags" in Vibe Mode.

**Relevant patterns:**
- **Best VPS bootstrap reference found.** The install sequence is directly adoptable for our Tier 2/3 VPS setup script.
- State checkpoint system (atomic `state.json` updates) — apply to our heartbeat's `current-state.md` writes
- NTM (Named Tmux Manager) integration for agent session naming/coordination
- Idempotent design — run again after failure, resumes cleanly

**VPS provider suggestions from the repo:** OVH, Contabo (cheap, European)

**Adopt:** The VPS bootstrap sequence + NTM for managing tmux agent sessions. The state.json pattern directly maps to our `current-state.md`.

---

### 5. `trust-delta/tmai`
**URL:** https://github.com/trust-delta/tmai
**Stars:** 6 | **License:** MIT | **Language:** Rust

**What it does:** WebUI for monitoring multiple AI agent tmux sessions. Three detection tiers: HTTP hooks (primary), IPC/Unix socket, tmux screen capture fallback. Token monitoring for Claude Max/Pro.

**Relevant patterns:**
- **Three-tier monitoring is exactly what our bot-managing-bot needs.** HTTP hooks → IPC → screen capture is the right degradation hierarchy.
- Auto-approval system with 4 modes (Rules/AI/Hybrid/Off) — the AI mode (using Haiku to analyze prompts) is adoptable for our T2 autonomy tier
- Token consumption monitoring — critical for our 5-hour window management
- Agent spawning from UI via MCP exposure — agents orchestrating agents pattern

**Note:** Very new (6 stars), but architecturally sophisticated. Worth watching.

**Adopt:** The three-tier detection hierarchy for our monitoring bot. The auto-approval modes map cleanly to our Tiered Autonomy system.

---

### 6. `kbwo/ccmanager`
**URL:** https://github.com/kbwo/ccmanager
**Stars:** 1,000 | **License:** Not stated | **Language:** TypeScript

**What it does:** CLI tool managing multiple Claude Code sessions across git worktrees. Status change hooks, per-project `.ccmanager.json`, experimental auto-approval via Haiku.

**Relevant patterns:**
- **Auto-approval via Haiku** — CCManager uses `claude haiku` to analyze permission prompts and decide if they need human approval. This is our T1/T2 autonomy boundary in practice.
- Status change hooks (`idle → busy → waiting`) — maps to our heartbeat state transitions
- Per-project configuration via `.ccmanager.json` — our per-client `settings.local.json` pattern
- Session state tracking across worktrees — relevant for our client VPS multi-project support

**Adopt:** The Haiku-as-permission-analyzer pattern. The status hook architecture.

---

### 7. `terryso/moltbook-heartbeat`
**URL:** https://github.com/terryso/moltbook-heartbeat
**Stars:** 2 | **License:** MIT | **Language:** Shell

**What it does:** Shell-based heartbeat for AI agents. LaunchAgent (macOS) or cron (Linux). 2-hour intervals. Agent checks DMs, scans feed, upvotes, comments, welcomes newcomers, creates posts.

**This is the closest existing implementation to our HEARTBEAT.md spec.**

**Relevant patterns:**
- State persistence: `heartbeat-state.json` across runs — directly maps to our `current-state.md`
- Log files: `heartbeat.log` + `heartbeat.error.log` — adopt for our `entity/data/alerts/`
- LaunchAgent plist for macOS, cron for Linux — exactly the dual-target we need for Tier 1 (Mac launchd) and Tier 2 (VPS cron)
- Activities structured as a checklist — maps to our HEARTBEAT.md checklist format

**Key difference:** Moltbook heartbeat uses a shell script that calls Claude. Our heartbeat IS Claude running a checklist. But the surrounding infrastructure (cron/launchd, state file, error log) is directly adoptable.

**Adopt:** The dual-platform heartbeat scaffold (plist + cron). The state file + error log pattern.

---

### 8. `adolfousier/opencrabs`
**URL:** https://github.com/adolfousier/opencrabs
**Stars:** 655 | **License:** MIT | **Language:** Rust

**What it does:** Autonomous self-improving AI agent. Single Rust binary. Daemon mode (systemd/launchd). Native cron job management via CLI. Telegram, WhatsApp, Discord, Slack, Trello. Profile isolation for multi-instance.

**Relevant patterns:**
- **Daemon architecture is excellent reference.** `opencrabs daemon` → headless, outbound HTTPS only, systemd/launchd integration, profile isolation (each profile gets token locks preventing credential conflicts)
- Cron management via CLI: `opencrabs cron add|list|remove|enable|disable|test` — our heartbeat should expose similar management
- Multi-channel routing (Telegram + Slack from one instance) — validates our SPEC-v2 multi-channel approach
- Profile isolation for multi-instance — critical for our Tier 3 client isolation model

**Note:** Not Claude Code — uses its own LLM abstraction. But the ops architecture is the most mature found.

**Adopt:** The profile-isolation-with-token-locks pattern for Tier 3 client VPS isolation. The daemon mode systemd unit file structure.

---

### 9. `elizabethfuentes12/claude-code-dotfiles`
**URL:** https://github.com/elizabethfuentes12/claude-code-dotfiles
**Stars:** 5 | **License:** MIT-0 | **Language:** Shell

**What it does:** Git-syncs `~/.claude/` across machines. Shell wrapper auto-pulls on open, auto-commits+pushes on close.

**Relevant patterns:**
- **Exact sync mechanism for our GitHub-as-sync-layer architecture.**
- Explicit allowlist (not blocklist): only syncs `CLAUDE.md, settings.json, commands/, hooks/, agents/, rules/` — never history, cache, projects, sessions, API keys
- Shell wrapper pattern: wrap the `claude` command in a function that does `git pull` before and `git add + commit + push` after

**Adopt:** The explicit allowlist + shell wrapper pattern verbatim. This is our VPS bootstrap step 1.

---

### 10. `zircote/.claude`
**URL:** https://github.com/zircote/.claude
**Stars:** Not shown | **License:** Not shown

**What it does:** Personal Claude Code config repo with comprehensive agents, skills, commands, coding standards. 10 agent categories including meta-orchestration and research/analysis.

**Relevant patterns:**
- Agent category structure (domain-specific agents vs. meta-orchestrator) — validates our PSDC entity hierarchy
- Opus 4.5 optimizations documented — useful for our model routing rules

**Assess:** Good reference for agent taxonomy, not directly adoptable.

---

### 11. `ruvnet/claude-flow` (Non-Interactive Mode docs)
**URL:** https://github.com/ruvnet/ruflo/wiki/Non-Interactive-Mode
**Stars:** Not checked | **License:** Not checked

**What it does:** Claude Flow's headless mode. Auto-detects non-interactive environments (TTY check, CI vars, container detection). Uses `--dangerously-skip-permissions` by default in non-interactive mode. Stream-JSON chaining for agent handoffs.

**Relevant patterns:**
- TTY detection before enabling non-interactive mode — adopt this check in our VPS startup
- `--headless` flag forces non-interactive + JSON output
- `CLAUDE_FLOW_NON_INTERACTIVE=true` env var as override
- Stream-JSON chaining: 40-60% faster than file-based agent handoffs

**Adopt:** The TTY detection + env var override pattern for our VPS startup script.

---

## Permission Model: What Actually Works

Based on bug reports and production deployments found:

| Approach | Works? | Notes |
|----------|--------|-------|
| `--dangerously-skip-permissions` CLI flag | Partial | Doesn't bypass `.claude/` writes. Resets mid-session in some versions. |
| `settings.json` with `allowedTools` + denylist | Yes | Most reliable for production. Explicit allow + deny. |
| `claude -p "prompt"` (print mode) | Yes | Best for automation. Skips ALL interactive dialogs. Session resumable via `--resume <id>`. |
| `--bare` flag | Yes | Fastest startup — skips hooks, MCP discovery, OAuth. Requires `ANTHROPIC_API_KEY`. |
| `--channels` + systemd | No | Crashes headless after 15-20s. Active bug. |

**For PS Bot V2 (V1):** Use `claude -p "$message" --session-id "$UUID"` per message + `claude --resume "$UUID"` for continuity. The thin Python router in `psbot/bot.py` is the right call.

**For always-on heartbeat (Tier 1 Mac):** `launchd` plist calling `claude -p "$(cat heartbeat-prompt.md)"` every 30min. Session resumption keeps context.

**For always-on heartbeat (Tier 2 VPS):** `cron` calling same pattern. Or tmux session with `claude --resume` if continuity is needed across runs.

---

## tmux Session Management Patterns

Three approaches found in the wild:

**1. Named Tmux Manager (NTM)** — Part of the ACFS stack. Wraps tmux with agent-aware orchestration: named sessions, broadcast prompts, conflict detection, TUI dashboard. For VPS SSH + always-on agents.

**2. `agtx`** (853 stars, Apache 2.0) — Kanban board in terminal. Each task = own worktree + own tmux window. Spec-driven, phase-gated. Good for parallel work, not daemon operation.

**3. `tmai`** (6 stars, MIT) — WebUI monitoring multiple tmux sessions. Three detection tiers. Good for our bot-managing-bot monitoring layer.

**Our pattern:** `tmux new-session -d -s psbot` → `tmux send-keys -t psbot "claude --resume $LAST_SESSION_ID" Enter`. NTM on top for naming/coordination.

---

## CoVibe-Like Patterns Found

No direct matches to our CoVibe protocol. Closest analogues:

- **MCP Agent Mail** (mentioned in ACFS, not fetched) — agents leaving messages for other agents via shared mailbox
- **`.covibe/sessions/` + `.covibe/messages/`** — our own protocol is more sophisticated than anything found

This confirms CoVibe is genuinely novel. No adoption candidates here.

---

## Security Notes

No prompt injection attempts detected in any fetched content. All repos appear legitimate. One caution: the ACFS "Vibe Mode" enables `passwordless sudo` + dangerous agent flags — appropriate for dev VPSes, not for Tier 3 client VPSes where we need tighter permission controls.

---

## Recommendations

**Immediate (V1 this week):**

1. Use the `elizabethfuentes12/claude-code-dotfiles` shell wrapper pattern for the GitHub sync layer on all VPS instances. Adopt the explicit allowlist (never sync sessions, projects, cache).

2. Use the `terryso/moltbook-heartbeat` infrastructure pattern (LaunchAgent plist + cron + state file + error log) for the Tier 1 Mac heartbeat. The surrounding scaffolding is exactly what we need even though our heartbeat IS Claude rather than a shell script calling Claude.

3. Confirm `claude -p` + session ID approach for Telegram routing. The `--channels` stdin bug makes MCP-based messaging unreliable on VPS until at least mid-2026.

**Near-term (V2 this month):**

4. Reference the `Dicklesworthstone/agentic_coding_flywheel_setup` bootstrap sequence for writing our own VPS setup script. Steal the idempotent state checkpoint approach (`state.json`).

5. Adopt the CCManager / tmai **Haiku-as-permission-analyzer** pattern for the T2 autonomy boundary. Before executing a proposed action, a Haiku call classifies it as T2 (proceed) or T3 (propose to human).

6. Model the Tier 3 client isolation on OpenCrabs' profile-with-token-locks architecture. Each client = own profile = own credential namespace = cannot interfere with other clients.

**Architecture:**

7. The `tuannvm/slack-mcp-client` Docker + Helm deployment model is the right target for Tier 3 HHA client VPSes. Build toward that (Docker Compose first, Helm later).

8. The `tmai` three-tier monitoring hierarchy (HTTP hooks → IPC → screen capture) is the right spec for our bot-managing-bot. Build the HTTP hooks first as primary signal.

---

## Files Worth Reviewing

| Repo | File | Why |
|------|------|-----|
| `mpociot/claude-code-slack-bot` | `src/claude-handler.ts` | Claude Code SDK session management pattern |
| `elizabethfuentes12/claude-code-dotfiles` | `install.sh` or shell wrapper | Exact git-sync automation |
| `terryso/moltbook-heartbeat` | `heartbeat.sh` + plist | LaunchAgent/cron scaffold |
| `engineers-hub-ltd-in-house-project/slack-claude-code-integration` | `docker-compose.yml` | VPS deploy recipe |
| `Dicklesworthstone/agentic_coding_flywheel_setup` | `install.sh` | Ubuntu VPS bootstrap sequence |
| `adolfousier/opencrabs` | systemd unit file (in repo) | Daemon mode template |

---

*Scouted: 2026-04-13. All links verified live. Re-scout recommended in 60 days given pace of Claude Code releases.*
