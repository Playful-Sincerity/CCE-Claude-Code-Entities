# GitHub Research: PS Bot Architecture Decision
**Stream:** GitHub — deep dive into actual codebases
**Date:** 2026-04-13
**Question:** Which foundation should PS Bot build on? Hermes Agent vs Claude Agent SDK vs OpenClaw vs Custom Build

---

## 1. Hermes Agent (NousResearch/hermes-agent)

### Repo Stats
- **Stars:** 76,596 | **Forks:** 10,237 | **Open Issues:** 3,850
- **License:** MIT | **Language:** Python
- **Current Version:** v0.9.0 (released April 13, 2026 — *today*)
- **Development velocity:** 487 commits, 269 PRs merged, 24 contributors in the v0.8.0→v0.9.0 cycle alone (about 5 days)
- **Topics include:** anthropic, claude, claude-code, openclaw — explicitly positioned in this ecosystem

### Architecture (what the code actually shows)

**Entry point and daemon architecture:**
The main agent class is `AIAgent` in `run_agent.py`. It is NOT a daemon by default — the gateway layer runs the daemon. The gateway (`gateway/run.py`) is the long-running process. It runs three persistent background threads:
1. `_session_expiry_watcher()` — memory flush every 5 minutes
2. `_platform_reconnect_watcher()` — exponential backoff reconnects
3. Process checkpoint recovery — resumes background tasks from crashes

**Platform gateway:**
`gateway/platforms/` contains 18 platform adapters: `telegram.py`, `slack.py`, `whatsapp.py`, `discord.py`, `signal.py`, `matrix.py`, `bluebubbles.py` (iMessage), `weixin.py` (WeChat), `email.py`, `sms.py`, and more. Each adapter inherits from `BasePlatformAdapter` and implements `connect()`, `disconnect()`, and message handlers. The gateway uses a factory pattern — adapters are conditionally instantiated based on config. Message routing is centralized through `DeliveryRouter`.

**Critical concurrency detail:** A sentinel object (`_AGENT_PENDING_SENTINEL`) prevents race conditions where two messages for the same session could both pass the "is agent running?" check during the async gap between validation and agent creation. This is production-grade thinking.

**Session persistence:**
SQLite with WAL mode at `~/.hermes/` — state.db stores full conversation history with FTS5 full-text search. Sessions are linked via `parent_session_id` for context-compression-triggered splits. Gateway stores voice preferences, runtime status, and clean-shutdown markers as JSON files.

**Memory architecture:**
`MemoryManager` is a pluggable provider system. Builtin provider always registered first; maximum one external provider at a time (prevents tool schema bloat). Lifecycle: `build_system_prompt()` → `prefetch_all()` → `handle_tool_call()` → `sync_all()`. Memory context wrapped in XML-style fencing to prevent prompt injection.

Available memory plugins (in `plugins/memory/`): `honcho`, `mem0`, `hindsight`, `holographic`, `byterover`, `supermemory`, `retaindb`, `openviking` — 8 options.

**Honcho integration (actual code):**
Exposes four operations: `honcho_profile` (peer card snapshot), `honcho_search` (semantic search, no LLM synthesis), `honcho_context` (dialectic LLM reasoning), `honcho_conclude` (persist user facts). System prompt injection happens on first turn — auto-fetches and caches user representation, peer card, and AI self-representation. Tools mode available for opt-in injection.

**Skill document system:**
Skills are markdown files (`SKILL.md`) in `~/.hermes/skills/`. YAML frontmatter declares metadata, config variables, setup state. `_inject_skill_config()` extracts declared vars and injects as `[Skill config: ...]` blocks. This is directly analogous to Wisdom's skill system.

**Cron/proactive scheduler:**
`cron/scheduler.py` — `tick()` called every 60 seconds from background thread. File-based lock prevents duplicate runs. Jobs run in thread pool with 600s inactivity timeout. Agent receives context indicating cron execution — messaging/clarify toolsets disabled to prevent self-delivery attempts. `next_run_at` advances *before* execution so crashes don't replay tasks. HEARTBEAT.md pattern in nanobot (similar project) for even simpler proactive triggers.

**Self-evolution (GEPA+DSPy):**
Separate repo `NousResearch/hermes-agent-self-evolution` (1,634 stars). Phase 1 (skill file optimization) is implemented. Phases 2-5 (tool descriptions, system prompts, code, continuous automation) are planned. Cost ~$2-10 per optimization run. Currently experimental — not production. Main repo does NOT include this by default.

**Dependencies and resource requirements:**
Core: openai, python-dotenv, fire, httpx, rich, tenacity, prompt_toolkit, pyyaml, pydantic v2, PyJWT, jinja2. Optional: python-telegram-bot ≥22.6, discord.py, aiohttp. For $5 VPS: 2GB RAM sufficient for 2 channels, 1GB if no browser tools. Docker image is 2-4GB+ with Playwright/Chromium/FFmpeg — but the no-browser install is much lighter.

**Code quality signals:**
- Comprehensive test structure: `tests/agent/`, `tests/gateway/`, `tests/cron/`, `tests/e2e/`, `tests/integration/`, `tests/skills/`, `tests/honcho_plugin/`
- Issues are immediate (created today) — ultra-active community
- 250 commits between two recent releases (v0.8.0→v0.9.0)
- Issue titles show professional engineering hygiene (SSRF guards, timing attacks, WAL mode, session token validation)
- GEPA self-evolution is a separate experimental repo — main codebase is not self-modifying

**What's NOT in the codebase that marketing implies:**
- The "learning loop" is pluggable context slots + Honcho user modeling, not autonomous unsupervised learning
- Self-evolution (GEPA/DSPy) is a separate experimental project, Phase 1 only
- Background "proactive" behavior is pattern-matched cron jobs, not autonomous initiative
- No built-in voice synthesis in the core — voice is via edge-tts (free) or Voxtral

---

## 2. OpenClaw (openclaw/openclaw)

### Repo Stats
- **Stars:** 356,516 | **Forks:** 72,267 | **Open Issues:** 18,495
- **License:** MIT | **Language:** TypeScript
- **Updated:** April 13, 2026

### Architecture (what the code actually shows)

**Scale and complexity:**
The top-level tree reveals massive scope: `packages/` directory contains 100+ packages including individual adapters for every platform (telegram, slack, discord, whatsapp, signal, matrix, imessage via bluebubbles, wechat, wecom, feishu, line, dingtalk, etc.) plus deep integrations (anthropic, openai, deepseek, groq, elevenlabs, deepgram, runway, fal, exa, firecrawl, perplexity, tavily...). This is a platform, not a library.

**SOUL.md (identity persistence):**
Lives in the agent's workspace, loaded at session start, injected into system prompt. Defines behavior, personality boundaries, and identity. The `aaronjmars/soul.md` companion repo (separate) provides tooling to build SOUL.md from personal data using Claude Code. 162+ production-ready SOUL.md configs exist in `mergisi/awesome-openclaw-agents`.

**Channel architecture:**
Implemented via plugin SDK — each channel calls `api.registerChannel()`. The `openclawcity/openclaw-channel` repo has a `plugin_build_spec.md`. Fully extensible. Every platform is a package, not a built-in.

**Core stack:** TypeScript/Node.js — important for PS Bot which is currently Python-based. Full rewrite cost if choosing OpenClaw.

**Why it was previously decided as "inspiration not dependency":** At 356K stars and 18,495 open issues, the surface area is enormous. TypeScript-first. Every feature update ripples. For PS Bot's specific needs, it's overkill and the wrong language.

**Unique value:** SOUL.md pattern is genuinely useful as a design pattern for any implementation. Extensibility model is well-documented.

---

## 3. Claude Agent SDK (anthropics/claude-agent-sdk-python)

### Repo Stats
- **Stars:** 6,300 | **Forks:** 877
- **Language:** Python | **Updated:** April 13, 2026
- **Also:** `claude-agent-sdk-typescript` (1,277 stars), `claude-agent-sdk-demos` (2,167 stars)

### Architecture (what the code actually shows)

**Package structure:**
```
src/claude_agent_sdk/
  client.py         # ClaudeSDKClient — stateful sessions
  query.py          # query() — stateless one-shot
  types.py          # type definitions
  _internal/        # private implementation (subprocess mgmt, message parsing)
```

**`query()` function:**
Stateless, async generator, fire-and-forget. No session state. Suitable for automated scripts and CI/CD. Not for persistent bots.

**`ClaudeSDKClient` (the relevant one):**
Wraps Claude Code CLI as subprocess. Stateful sessions via session IDs. API:
- `connect()` / `disconnect()` / context manager
- `query(prompt, session_id="default")` — maintains conversation state
- `fork_session()`, `delete_session()`, `list_sessions()`, `get_session_messages()`
- `get_mcp_status()`, `reconnect_mcp_server()`, `toggle_mcp_server()` — full MCP control
- `interrupt()`, `stop_task(task_id)` — agent control
- `rewind_files(user_message_id)` — file checkpointing
- `get_context_usage()` — track context by category
- `set_permission_mode()`, `set_model()`

**MCP integration pattern:**
```python
options = ClaudeAgentOptions(
    mcp_servers={"calc": calculator},
    allowed_tools=[...]
)
```
Tools follow `mcp__<server_id>__<tool_name>` naming. In-process MCP servers run directly in Python app. Also supports external MCP servers (separate processes). Full dynamic enable/disable/reconnect control.

**Hooks system (5 events):**
1. `PreToolUse` — block/allow before execution
2. `PostToolUse` — review output after
3. `UserPromptSubmit` — intercept at submission
4. `SessionStart` — trigger at session begin
5. Stop/Error conditions

Hooks registered via `ClaudeAgentOptions.hooks` dict. Matchers target specific tools or all tools. Callbacks return JSON with `permissionDecision`, `continue_`, system messages.

**Multi-agent pattern:**
Declarative via `AgentDefinition` in `ClaudeAgentOptions.agents` dict. No explicit spawning — agent routing is implicit (call agent by name in prompt). Async message streaming.

**What it CANNOT do out of the box:**
- No multi-platform gateway — CLI/subprocess only
- No built-in voice, media handling
- No cron scheduler
- No memory persistence (relies on Claude Code session persistence, which lives in Claude Code's own state)
- Cannot run as a standalone persistent daemon without wrapping code
- Subprocess transport adds latency (CLI spawn per operation)
- `continue_conversation=True` has a known bug — starts new session instead of resuming (issue #809)

**Critical insight:** The SDK's `.claude/` directory exists in the repo, meaning it uses Claude Code's own CLAUDE.md and skills infrastructure for its development. This is a strong signal that CLAUDE.md/Digital Core is the natural integration layer.

**Velocity:** 59 releases in the changelog. Recent issues show production bugs (error context destroyed through exception flattening, cancel scope leaks in subprocess transport). Still maturing.

---

## 4. Emerging Alternatives Discovered

### nanobot (HKUDS/nanobot)
- **Stars:** 39,375 | **Language:** Python | **Updated:** April 13, 2026
- Self-described as "inspired by OpenClaw, 99% fewer lines of code"
- Two-stage "Dream" memory: live conversation + background consolidation (runs as scheduled background pass, git-versioned)
- 13+ platforms including Telegram, Discord, WhatsApp, WeChat, Feishu, DingTalk, Slack, Matrix, Email
- MCP support, sandbox execution via bubblewrap, cross-platform session continuity
- HEARTBEAT.md pattern: gateway checks this file every 30 minutes — if tasks listed, agent executes them and delivers to most recently active chat channel. **This is a simple proactive behavior pattern worth stealing.**
- Known issues: memory consolidation bugs (TypeError, LLM doesn't call save_memory), session history growing unbounded (issue #2638)
- v0.1.4.post6 current — still v0.x

### claude-code-telegram (RichardAtCT)
- **Stars:** 2,426 | **Language:** Python
- Production-grade Telegram bot over Claude Agent SDK
- SQLite persistence, per-project session management, event bus pattern
- 16 configurable tools, allowlist/disallowlist, multi-layer auth, rate limiting, audit logging
- SDK-first with CLI fallback
- Active: updated today

### claude-telegram-relay (godagoo)
- **Stars:** 325 | **Language:** TypeScript
- Minimal pattern for Claude Code as always-on Telegram bot
- Cross-platform daemon setup included
- More template than framework

---

## 5. Best Practices Captured

**Platform abstraction:** Both Hermes and OpenClaw use adapter/plugin patterns where each platform is an isolated module implementing a base interface. Gateway acts as router. The `BasePlatformAdapter` pattern in Hermes is clean and extensible.

**Memory persistence:** SQLite + WAL mode is the production standard. FTS5 full-text search is the right approach for semantic memory over structured queries. XML fencing around injected memory context prevents prompt injection.

**Session management:** Sentinel-object pattern prevents race conditions in async multi-platform gateways. File-based locks prevent cron job duplication. `next_run_at` advances before execution to prevent crash-replay.

**Proactive behavior:** Cron + prompt injection is simpler than autonomous initiative and actually reliable. HEARTBEAT.md pattern (nanobot) is an elegant "passive proactive" pattern — agent checks a file, not an LLM deciding to reach out.

**Skill/capability management:** Markdown files with YAML frontmatter is the universal pattern (Hermes skills ≈ Claude Code skills ≈ CLAUDE.md). Config injection via frontmatter variables is cleaner than hardcoding.

**Deployment:** 2GB RAM minimum for lightweight deployment without browser tools. Docker without Playwright/FFmpeg brings image to manageable size. Python venv via `uv` is now standard for Hermes.

**Learning loops:** None of these systems have true unsupervised learning. What exists: execution trace analysis + human-reviewed prompt mutations (GEPA, experimental), user modeling via Honcho (production but requires external API), memory consolidation via Dream pattern (nanobot, still buggy).

**MCP integration:** Claude Agent SDK has the cleanest MCP story — `mcp__server__tool` naming, in-process or external, full dynamic control. Hermes also supports MCP but as one of many integration patterns.

---

## Key Tensions

**Hermes marketing vs. code reality:**
- "Self-improving" implies autonomous learning — code shows experimental Phase 1 skill optimization with human review and $2-10/run cost
- "Learning loop" is memory provider plugins + Honcho, not a training loop
- "Proactive" is scheduled cron jobs, not autonomous initiative
- These are honest limitations, not criticism — the architecture is solid

**OpenClaw's gravitational pull:**
Both Hermes (listed in topics) and nanobot (self-described) position against OpenClaw. The ecosystem is fragmenting into OpenClaw (TypeScript, maximal) vs. Python alternatives (Hermes, nanobot) that interoperate with it. PS Bot is Python-native — this matters.

**Claude Agent SDK's subprocess architecture:**
Wrapping Claude Code CLI adds latency per operation (subprocess spawn). For a persistent bot processing many messages, this is real overhead. Hermes talks directly to LLM APIs. SDK's advantage is deep Claude Code integration, Digital Core awareness, and MCP control — at a speed cost.

---

## Gaps

1. **True voice integration** (confidence-modulated prosody) doesn't exist in any framework — this is custom build territory in all scenarios
2. **Digital Core integration** (loading Wisdom's CLAUDE.md rules, skills, memory, chronicles into bot context) — no framework does this natively; Hermes skills ≈ Digital Core skills but require custom bridge
3. **Honcho** (Hermes's richest memory plugin) requires a hosted Honcho account or self-hosted server — additional infrastructure dependency
4. **GEPA self-evolution** is too experimental and too expensive for initial PS Bot build
5. **Multi-session Convergence** (integrating Associative Memory + Phantom + Companion) — no framework anticipates this; custom orchestration layer required regardless of foundation

---

## Sources

- [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) — Main Hermes repo, v0.9.0 today
- [Hermes v0.9.0 release notes](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.4.13) — Full changelog
- [hermes-agent/run_agent.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/run_agent.py) — Agent class and daemon architecture
- [hermes-agent/gateway/run.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/gateway/run.py) — Multi-platform gateway architecture
- [hermes-agent/agent/memory_manager.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/agent/memory_manager.py) — Memory provider system
- [hermes-agent/agent/skill_commands.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/agent/skill_commands.py) — Skill document system
- [hermes-agent/cron/scheduler.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/cron/scheduler.py) — Proactive cron scheduler
- [hermes-agent/hermes_constants.py](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/hermes_constants.py) — Default paths, config locations
- [hermes-agent/Dockerfile](https://raw.githubusercontent.com/NousResearch/hermes-agent/main/Dockerfile) — Docker resource analysis
- [NousResearch/hermes-agent-self-evolution](https://github.com/NousResearch/hermes-agent-self-evolution) — GEPA+DSPy, experimental
- [openclaw/openclaw](https://github.com/openclaw/openclaw) — OpenClaw main repo, 356K stars
- [openclaw/openclaw AGENTS.md](https://github.com/openclaw/openclaw/blob/main/AGENTS.md) — Architecture docs
- [aaronjmars/soul.md](https://github.com/aaronjmars/soul.md) — SOUL.md personality builder
- [anthropics/claude-agent-sdk-python](https://github.com/anthropics/claude-agent-sdk-python) — Official SDK, 6,300 stars
- [claude-agent-sdk examples/mcp_calculator.py](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/examples/mcp_calculator.py) — MCP integration pattern
- [claude-agent-sdk examples/hooks.py](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/examples/hooks.py) — Hooks system
- [claude-agent-sdk examples/agents.py](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/examples/agents.py) — Multi-agent patterns
- [claude-agent-sdk CHANGELOG.md](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/CHANGELOG.md) — Development history
- [HKUDS/nanobot](https://github.com/HKUDS/nanobot) — Ultra-lightweight alternative, 39K stars
- [RichardAtCT/claude-code-telegram](https://github.com/RichardAtCT/claude-code-telegram) — Production Claude Code Telegram bot, 2,426 stars
- [godagoo/claude-telegram-relay](https://github.com/godagoo/claude-telegram-relay) — Minimal always-on pattern, 325 stars
- [Hermes Agent docs — VPS deployment](https://hermes-agent.nousresearch.com/docs/) — Resource requirements confirmed
- [Evolution Host — Hermes VPS guide](https://evolution-host.com/blog/how-to-set-up-hermes-on-a-vps.php) — 2GB RAM minimum confirmed
