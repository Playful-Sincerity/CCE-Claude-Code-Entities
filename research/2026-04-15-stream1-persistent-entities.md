# Persistent Entity Systems — Research Round 2
**Date:** 2026-04-15
**Researcher:** Claude Code (subagent, stream-1)
**Scope:** New developments since April 13 + deeper dives on ClaudeClaw v2, Anthropic infrastructure, Paperclip, and other persistent entity patterns

---

## Executive Summary

The persistent entity landscape has accelerated dramatically in the two days since the last research round. Anthropic released two major infrastructure pieces (Managed Agents with memory stores on April 8, and Claude Code Routines on April 14), and an internal Conway platform was leaked. The community has converged on a three-layer identity stack (SOUL.md / CLAUDE.md / SKILL.md). Two architecturally mature third-party systems (ClaudeClaw earlyaidopters fork, Aeon) demonstrate what production persistent entities look like today. A detailed GitHub proposal (claude-eng) articulates the most sophisticated cognitive persistence architecture seen in the wild.

---

## System 1: ClaudeClaw (earlyaidopters fork) — v2

**URL:** https://github.com/earlyaidopters/claudeclaw

**What it does.** ClaudeClaw is the most architecturally complete community-built persistent entity system to date. It spawns Claude Code CLI processes on your local machine and pipes them into messaging channels (Telegram, WhatsApp, Slack, Discord). It is not a wrapper — it runs real `claude` commands with full file system and tool access. The earlyaidopters fork adds a sophisticated multi-agent architecture where specialist agents (comms, content, ops, research) each run as separate Telegram bots with isolated context windows, shared SQLite storage, and per-group personality files.

**Persistence model.** Three-layer memory: (1) session resumption via stored session IDs — full conversation context persists automatically across messages; (2) structured extraction — after each turn, Gemini evaluates the exchange and saves worth-remembering details as importance-scored memories (0.0–1.0 scale) with daily decay rates (high-importance memories decay 1%/day, surviving ~460 days; lower tiers decay faster); (3) consolidation — a background process runs every 30 minutes, detects patterns across memories, and surfaces contradictions. Memories used in conversation get salience boosts (+0.1); irrelevant ones penalized (-0.05). Pinned memories never decay. All state lives in SQLite with WAL mode for concurrent access. Vector embeddings stored alongside text for semantic retrieval.

**Identity model.** Per-agent CLAUDE.md files define personality. No dedicated SOUL.md layer — identity is entirely in CLAUDE.md. Users invoke /respin to pull last 20 conversation turns into a new session when context gets heavy, preserving narrative continuity without token bloat.

**Scheduling model.** Users describe recurring tasks in natural language; Claude creates cron jobs via a built-in CLI. Tasks are tracked in SQLite's `scheduled_tasks` table, fire per-agent, and queue through a per-chat FIFO system to prevent session collisions. Mission Control supports one-shot async tasks with auto-assignment (Gemini classifies task type and routes to best specialist). Each task runs in a fresh session with 10-minute timeout.

**Safety model.** Always-on: chat ID restriction locks bot to single user; private chat only; audit logging; database file permissions set to owner-only (0700/0600); AES-256-GCM encryption for WhatsApp/Slack message bodies at rest; auto-purge (3-day retention sweep). Optional: PIN lock with idle auto-lock; emergency kill phrase; security status dashboard. Notably, Claude runs with `permissionMode: 'bypassPermissions'` because there is no terminal to approve tool use. This is considered acceptable only because the system is locked to a single-user private deployment on their own machine.

**What we can learn.** The importance decay + salience boost model is the most operationally sophisticated community memory system observed. It solves the "everything is equally important" problem that plagues flat MEMORY.md approaches. The FIFO queuing system for preventing concurrent execution on the same agent is a clean solution to the race condition problem. Running bypassPermissions in a single-user locked context is a reasonable pragmatic choice — not reckless if the trust perimeter is enforced at the platform layer.

**What's missing.** No true identity continuity — CLAUDE.md defines behavior, not self-model. No heartbeat-driven proactive behavior — the entity only acts when triggered by a message or cron task. Memory is about factual recall, not character development. No audit trail of identity evolution. No mechanism for the entity to reflect on or update its own CLAUDE.md.

---

## System 2: Aeon — GitHub Actions Autonomous Agent

**URL:** https://github.com/aaronjmars/aeon
**DEV post:** https://dev.to/aaronjmars/aeon-the-background-ai-agent-that-runs-on-github-actions-16am

**What it does.** Aeon is a cron-based autonomous agent running entirely on GitHub Actions (free for public repos). It executes a catalog of 91 skills (SKILL.md files) on scheduled cadences — research tasks, PR reviews, market monitoring, content generation, crypto alerts, and more — committing output back to the repository each run. Its design principle is "never asks for approval — decides when to run, what to check, and when to notify you."

**Persistence model.** State is file-based, committed back to the repo after each run. Persists: `memory/cron-state.json` (last run times, what fired), `memory/skill-health/` (rolling 30-run history per skill with quality scores 1–5), `memory/token-usage.csv` (cost tracking), and `memory/logs/` (daily activity logs). No database. No semantic retrieval. Memory is structural (what ran, when, how well) rather than episodic (what was discussed, what was learned).

**Identity model.** Optional SOUL.md + STYLE.md + examples/ directory. When populated, every skill automatically reads these files through CLAUDE.md, ensuring Aeon's outputs carry the user's voice. This is the most explicit implementation of the SOUL.md pattern in production use.

**Scheduling model.** `aeon.yml` defines skill schedules in UTC cron format. A heartbeat runs 3x daily, monitoring for failures and detecting chronically broken skills. Reactive triggers fire on conditions (e.g., `consecutive_failures >= 3`). Skills can chain. GitHub Actions provides the scheduler — no infrastructure to manage.

**Safety model.** Self-healing: automated skill repair when quality scores drop, degradation detection, rollback via git history. No human-in-the-loop by design. Safety is architectural (read/write to repo only; no external account access unless explicitly configured per-skill) rather than permissioning-based. Budget awareness via token tracking, but no hard limits.

**What we can learn.** GitHub Actions as scheduler is brilliant infrastructure arbitrage — free, reliable, auditable, globally distributed. The rolling 30-run health history per skill is a practical health monitoring pattern. The SOUL.md integration shows how a thin identity layer can propagate consistently across heterogeneous tasks without per-prompt engineering. The skill-health quality scoring (1–5 post-execution) is a lightweight feedback loop without requiring human annotation.

**What's missing.** No cross-run episodic memory — Aeon cannot recall what it researched last Thursday. No conversational continuity. No identity development — the SOUL.md is static. No graduated permission system. The heartbeat is health monitoring, not genuine proactive cognition.

---

## System 3: Anthropic Managed Agents — Memory Stores

**URL:** https://platform.claude.com/docs/en/managed-agents/memory
**Launched:** April 8, 2026 (public beta); memory stores are a research preview feature

**What it does.** Managed Agents is Anthropic's official infrastructure for running agents that survive session boundaries. A memory store is a workspace-scoped collection of text documents optimized for Claude. When attached to a session, the agent automatically checks the store before starting and writes durable learnings when done — no additional configuration required.

**Persistence model.** Markdown-path-based file system behind a REST API. Memories are addressed by path (e.g., `/preferences/formatting.md`), capped at 100KB each (~25K tokens). The agent gains six memory tools automatically: `memory_list`, `memory_search`, `memory_read`, `memory_write`, `memory_edit`, `memory_delete`. Up to 8 stores per session. Every mutation creates an immutable memory version (`memver_...`) for auditing and rollback. Optimistic concurrency via SHA-256 preconditions prevents concurrent-write collisions. Session event history is persisted server-side; reconnecting to a session stream replays missed events.

**Identity model.** No native identity layer. Memory stores are content-agnostic — you can seed them with identity documents, but the system does not treat any memory as a self-model. Identity must be injected through the session prompt or CLAUDE.md.

**Scheduling model.** Not directly provided by memory stores. Managed Agents sessions can be triggered by API, but scheduling requires external orchestration. Claude Code Routines (see System 4) is the complementary scheduling layer.

**Safety model.** API-key scoped. Memory stores are workspace-scoped — shared across all agents in a workspace by default, but can be partitioned per-user or per-project by creating separate stores. `read_only` access mode available. Versioning and redact (for compliance: PII, leaked secrets) provide auditability.

**What we can learn.** The path-based addressing is the right abstraction — it mirrors file systems that Claude Code already understands natively. Immutable versioning with redact is the professional-grade answer to "how do you audit and correct what an agent has learned." The 8-store limit per session plus read-only mode enables separation of concerns: one shared read-only store for domain knowledge, one per-user read-write store for learnings. This is a clean multi-tenancy model.

**What's missing.** No automatic structuring of memories — the agent decides what to write and where, which means memory quality degrades if the agent doesn't write well-organized content. No semantic search built in (only `memory_search` which is full-text). No decay or relevance-weighting. No native proactive behavior — this is purely reactive storage infrastructure. The memory store is not a world model; it is a file cabinet.

---

## System 4: Claude Code Routines

**URL:** https://pasqualepillitteri.it/en/news/851/claude-code-routines-cloud-automation-guide
**Launched:** April 14, 2026 (research preview)

**What it does.** Claude Code Routines are persistent autonomous agent configurations running on Anthropic's cloud infrastructure. A routine bundles a prompt, one or more repositories, and a set of connectors (Slack, Linear, Google Drive, GitHub) with at least one trigger. Each execution is a complete Claude Code session. Routines survive restarts, terminal closures, and overnight runs.

**Persistence model.** Each routine execution starts fresh — no state is carried across runs by default. Persistent state requires explicit design: writing to files in the repository (which gets committed), or using Managed Agents memory stores. The routine configuration itself (prompt + connectors + trigger) persists indefinitely.

**Identity model.** No native identity layer. The prompt defines behavior. Identity is static per routine.

**Scheduling model.** Three trigger types: (1) Schedule — fixed cadence with minimum 1-hour interval, cron syntax, local timezone; (2) API — dedicated HTTP endpoint with bearer token for external system integration; (3) GitHub — native webhooks reacting to PRs, issues, pushes. This is the first officially Anthropic-hosted scheduling infrastructure.

**Safety model.** All actions appear under the user's identity — commits, PRs, Slack messages all carry the configuring user's credentials. This is a significant implicit permission model: the routine inherits all your access. No additional sandboxing described beyond what Managed Agents provides.

**What we can learn.** The GitHub trigger mode is significant: an entity that reacts to repository events (PRs opened, issues created) is a genuine background collaborator pattern, not just a scheduled reporter. The 1-hour minimum schedule interval is a deliberate anti-runaway constraint — prevents high-frequency loops that could consume quota uncontrolled. The identity-through-credentials approach is simple but creates accountability.

**What's missing.** No sub-hourly scheduling (eliminates heartbeat patterns at fine granularity). No cross-run state by default. No self-model or identity development. The "user's credentials" approach means the entity cannot have an identity distinct from the deploying user — no entity personhood.

---

## System 5: Anthropic Conway (leaked/unconfirmed)

**URL:** https://dataconomy.com/2026/04/03/anthropic-tests-conway-platform-for-continuous-claude/
**Status:** Internal testing, leaked ~April 1, 2026. Not confirmed by Anthropic. No public release date.

**What it does.** Conway is described as an "always-on AI agent platform" that transforms Claude into a persistent autonomous agent running 24/7. Key capabilities from leaked information: continuous background operation (not session-based), webhook activation by external events (emails, calendar updates, data changes), browser automation via Chrome, and a CNW ZIP extension format for custom tools and UI components.

**Persistence model.** Unconfirmed. The always-on framing implies persistent state across the entity's continuous operation rather than across discrete sessions. Architectural details not available from leaked sources.

**Identity model.** The "digital twin" framing in coverage suggests Conway may carry a stronger identity concept than session-based tools, but no technical detail is available.

**Scheduling model.** Webhook-driven activation rather than cron-based — the entity runs continuously and responds to events, rather than being woken periodically. This is architecturally different from heartbeat patterns.

**Safety model.** Unknown. The CNW extension format implies a controlled extension ecosystem, which suggests some capability gating.

**What we can learn.** The webhook-over-cron design philosophy is important: a genuinely always-on entity doesn't need a heartbeat because it never sleeps. Events flow to it continuously. This is closer to a daemon process than a cron job. The browser automation integration suggests Conway is being designed for computer-use-grade autonomy, not just text generation.

**What's missing.** Basically everything — this is a leak, not a spec. Treat as a directional signal from Anthropic's internal thinking, not a buildable pattern.

---

## System 6: Paperclip — Multi-Agent Company Framework

**URL:** https://github.com/paperclipai/paperclip
**Launched:** March 4, 2026

**What it does.** Paperclip is an open-source Node.js orchestration framework for running teams of AI agents as a structured organization. Agents have org chart positions, roles, titles, job descriptions, and budgets. They don't call functions — they hire other agents. The system models a company with goals, budgets, and governance. Heartbeat scheduling turns one-shot automations into persistent agents that work through a backlog autonomously.

**Persistence model.** PostgreSQL database stores all agent state: work, conversations, and task progress. Agents resume the same task context across heartbeats rather than restarting from scratch — genuine persistence of in-progress work, not just memory of past sessions. Goal ancestry is injected at runtime ("tasks carry full goal ancestry so agents consistently see the why, not just a title").

**Identity model.** Role-based: agents have org chart position, title, and job description as their identity. No personality layer. Identity is functional (what am I responsible for?) rather than characterological (who am I?). This is sufficient for organizational behavior but would not support entity personhood.

**Scheduling model.** Heartbeat-based: agents wake on schedule, check work, and act. Delegation flows up and down the org chart. Event-based triggers also available for task assignments and mentions.

**Safety model.** Monthly per-agent budgets throttle runaway costs. Atomic execution prevents double-work. Governance with rollback: approval gates, config versioning, pause/terminate. Full audit trails of all tool calls and decisions. Multi-company isolation with separate data per organization.

**What we can learn.** The org-chart model with goal ancestry injection solves a deep problem in multi-agent systems: agents losing sight of why they're doing a task. Carrying the full goal chain from top-level objective down to sub-task is a kind of persistent intentionality. The budget-as-safety-mechanism is elegant — it makes runaway behavior expensive rather than just prohibited. Governance-with-rollback is the enterprise-grade answer to "what if an agent does something wrong."

**What's missing.** No entity personhood. No character development. No identity beyond role. No cross-agent episodic memory (agents don't remember past conversations — they resume task context, which is different). This is an organizational process engine, not a persistent self.

---

## System 7: claude-mem — Session Memory Plugin

**URL:** https://github.com/thedotmack/claude-mem

**What it does.** A Claude Code plugin using five lifecycle hooks (SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd) to capture activity, compress it with AI using Claude's agent-sdk, and inject relevant context into future sessions via "progressive disclosure" — starting with compact summaries (~50-100 tokens) and fetching full details only when needed.

**Persistence model.** Dual storage: SQLite for full-text search, ChromaDB for semantic/keyword hybrid search. Data in `~/.claude-mem/`. Observations tagged with metadata (type, date, project) for filtered retrieval. Users can tag content with `<private>` to exclude from storage.

**Identity model.** None. This is purely factual memory — what happened, not who the agent is.

**Scheduling model.** Hook-driven, not scheduled. Memory is captured at hook trigger points during active sessions, not on a heartbeat.

**Safety model.** Privacy control via `<private>` tags. No other described safety mechanisms.

**What we can learn.** The progressive disclosure strategy (compact → detailed on demand) is the right answer to the token budget problem. Don't dump all memory into context — score relevance, inject summary, expand on request. The five-hook lifecycle is a clean capture surface that doesn't require the user to manually save anything.

**What's missing.** No decay. No importance scoring. No consolidation. No proactive behavior. Purely reactive capture.

---

## System 8: claude-eng Proposal — MDEMG Cognitive Architecture

**URL:** https://github.com/anthropics/claude-code/issues/45661

**What it does.** A detailed GitHub proposal for a first-party Anthropic service adding persistent cognitive memory and behavioral governance to Claude Code autonomous workflows. Built on MDEMG (Multi-Dimensional Emergent Memory Graph) — a 5-layer graph memory system over Neo4j. The proposal includes 105 development phases and 2,381+ tests, suggesting this is not a concept sketch but a working system being proposed for integration.

**Persistence model.** Five-layer emergent memory hierarchy (Observations → Hidden Aggregators → Domain Concepts → Abstract Concepts → Emergent Concepts) over Neo4j with vector indexes. Surprise-weighted persistence: novel information persists longer than redundant information. Hebbian learning: co-activated concepts strengthen automatically. Claims 95% decision persistence across 5+ context compactions (vs. ~0% baseline). Retrieval: BM25 + vector similarity + RRF fusion + graph traversal + activation spreading + LLM re-ranking.

**Identity model.** Not explicitly addressed as an identity layer, but the emergent concept layer — concepts that arise from patterns across lower-level observations — functions as a form of persistent self-model. The system learns what kinds of guidance work for each team (Signal Learner), which is a kind of behavioral identity.

**Scheduling model.** Recursive self-improvement operates at three temporal scales: micro (per-session health pulse), meso (hours — full assessment + remediation), macro (daily — topology optimization + hidden layer consolidation). Not heartbeat scheduling for task execution; rather, a continuous background maintenance cycle for the memory system itself.

**Safety model.** Jiminy Guidance Engine — injected before every agent action via hooks. Five parallel knowledge sources (constraints, correction vectors, contradiction edges, frontier detection, trust-scored history). 6-level escalation system for ignored constraints. UxTS behavioral governance: declarative JSON contracts that agents discover before modifying code, validate against before committing. Hash-backed change detection for silent drift. Dry-run mode, rollback snapshots, blast-radius estimation for self-improvement cycles.

**What we can learn.** The Jiminy Guidance Engine (conscience injected before every action) is the most sophisticated safety model seen in the wild — not a permission gate, but a governance system that learns which constraints this particular agent has historically ignored and escalates accordingly. The 95% decision persistence claim across compactions is directly relevant to the Companion's challenge: maintaining continuity when Claude Code compacts context. The surprise-weighted persistence is the right answer to "what should be remembered" — not recency, not frequency, but novelty relative to existing knowledge.

**What's missing.** This is a proposal, not a deployed system. The complexity (105 development phases, Neo4j dependency, 8B local model proposal) may be over-engineered for the use case. No clear identity layer — memory depth without personhood.

---

## System 9: The Three-Layer Identity Stack (Ecosystem Pattern)

**URL:** https://www.blueoctopustechnology.com/blog/claude-md-vs-soul-md-vs-skill-md
**Governance:** agentskills.io with Linux Foundation oversight for SKILL.md

**What it is.** By April 2026, the community has converged on a three-layer identity stack for Claude agents:

- **SOUL.md** — the identity layer (who the agent is: worldview, values, communication style, anti-patterns, boundaries). Developed by the OpenClaw ecosystem. Emphasizes specificity and real opinions over safe positions.
- **CLAUDE.md** — the configuration layer (how it works in context: project rules, architecture decisions, build commands, workflow instructions). Anthropic's standard, loaded at session start.
- **SKILL.md** — the capability layer (what specific expertise it has: repeatable workflows with YAML headers, executable scripts, documentation references). Governed by agentskills.io with 20,000+ community skills on skills.sh.

These are not competing — they operate on complementary layers and are used simultaneously. A well-configured agent has all three.

**What we can learn.** The ecosystem has solved the "who vs. how vs. what" problem with three separate files. This is cleaner than cramming everything into CLAUDE.md. For the Companion, the implication is: SOUL.md holds character, CLAUDE.md holds behavioral rules, SKILL.md holds task capabilities. These should be maintained separately and evolved on different timescales — identity changes slowly, skills change frequently.

---

## System 10: Cron-Based Claude Code Autonomous Agent Pattern

**URL:** https://dev.to/boucle2026/how-to-run-claude-code-as-an-autonomous-agent-with-a-cron-job-hec

**What it is.** A community-documented pattern (not a project) for running Claude Code as an autonomous cron agent. Three components: a scheduling bash script, a state file for persistence, and process locking to prevent concurrent runs.

**Key design decisions documented:**
- State file (state.md) kept under 4KB — injected every loop, so every byte costs tokens per iteration
- Cold storage (knowledge/ directory) for facts read on-demand via search
- Git commits each iteration for audit trail
- Key-value state format rather than prose (prevents the agent from writing paragraphs about how it feels)
- Approval gates for sensitive actions: public posting, spending money, deletion of production data require human approval via request files

**What we can learn.** The 4KB hot/cold state separation is a practical constraint that the Companion design should adopt. The anti-pattern warning ("don't let the agent write paragraphs about how it feels — use key-value pairs") is important: prose self-assessment is expensive and unreliable; structured state is cheap and queryable. The request-file approval gate pattern is elegant: the agent creates a file describing what it wants to do, a human approves or rejects, and the agent proceeds on the next cycle.

---

## Cross-System Analysis

### What Everyone Gets Right
1. **Separation of memory from identity** — even simple systems distinguish what was remembered from who is doing the remembering
2. **Importance scoring** — flat memory is useless at scale; every mature system weights memories
3. **Hot/cold storage separation** — always-on context vs. on-demand retrieval is a fundamental distinction
4. **Audit trails** — every production system keeps logs; immutability is emerging as a standard

### What Nobody Gets Right
1. **Identity development** — no system allows the entity's self-model to evolve based on experience. SOUL.md is static. CLAUDE.md is static. Identity is installed, not grown.
2. **Proactive emotional modeling** — no system tracks what the entity "wants" or "values" beyond task completion
3. **Cross-session narrative continuity** — memory is factual (what happened) not narrative (what it means, how it changed the entity)
4. **Earned conviction** — every system uses installed beliefs. None model the process of a perspective developing through evidence.

### Key Gaps Relative to the Companion Design
- **Managed Agents memory stores** provide the right infrastructure primitives (path-addressable, versioned, multi-store) but no identity layer
- **Claude Code Routines** provide official scheduling but minimum 1-hour interval eliminates fine-grained heartbeat patterns
- **ClaudeClaw** has the most sophisticated memory but identity remains static CLAUDE.md injection
- **Aeon** has the best SOUL.md integration but no episodic memory
- **Paperclip** has the best organizational persistence but no entity personhood
- **claude-eng proposal** has the most sophisticated memory architecture (if implemented) but no personhood layer

The Companion's distinctive claim — persistent entity with developing identity, earned rather than installed character, narrative self-continuity — is not addressed by any system observed.

---

## Prioritized Insights for the Companion Design

1. **Use Managed Agents memory stores** as the persistence substrate. Path-addressable, versioned, API-accessible, officially supported. Better than SQLite or flat files.

2. **Adopt the three-layer identity stack:** SOUL.md for character (slow-changing), CLAUDE.md for behavioral rules (medium-changing), SKILL.md for capabilities (fast-changing).

3. **Steal ClaudeClaw's importance decay model:** Score every memory 0.0–1.0 on capture. Decay by tier daily. Boost on retrieval. Pin the irreducible. This is the most operationally sophisticated memory management pattern observed.

4. **Steal Aeon's skill-health scoring:** After each task, score quality 1–5. Track rolling 30-run history. Auto-detect degradation. This is a feedback loop the Companion can use to track its own capability health.

5. **Steal the cron pattern's hot/cold separation:** Keep active identity context (SOUL.md, current state) under 4KB injected every session. Keep episodic memory (what happened, what was learned) in cold storage, retrieved semantically.

6. **Steal claude-eng's surprise-weighted persistence:** What to remember is novelty relative to existing knowledge, not recency or frequency.

7. **Watch Conway.** If Anthropic ships an always-on daemon-process model, it changes the architecture fundamentally. The heartbeat cron pattern may be temporary scaffolding until daemon infrastructure exists.

8. **The 1-hour Routines minimum is a real constraint.** Sub-hourly scheduling requires either local cron (less reliable) or the earlyaidopters pattern (always-running process managing its own scheduling). Design Companion heartbeats to work at hourly intervals or accept local process management.

---

## Sources

- [earlyaidopters/claudeclaw](https://github.com/earlyaidopters/claudeclaw)
- [aaronjmars/aeon](https://github.com/aaronjmars/aeon)
- [Aeon DEV post](https://dev.to/aaronjmars/aeon-the-background-ai-agent-that-runs-on-github-actions-16am)
- [Anthropic Managed Agents Memory Docs](https://platform.claude.com/docs/en/managed-agents/memory)
- [Claude Code Routines — Pillitteri](https://pasqualepillitteri.it/en/news/851/claude-code-routines-cloud-automation-guide)
- [Conway leak coverage — Dataconomy](https://dataconomy.com/2026/04/03/anthropic-tests-conway-platform-for-continuous-claude/)
- [paperclipai/paperclip](https://github.com/paperclipai/paperclip)
- [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)
- [claude-eng proposal — GitHub Issue 45661](https://github.com/anthropics/claude-code/issues/45661)
- [CLAUDE.md vs SOUL.md vs SKILL.md — Blue Octopus](https://www.blueoctopustechnology.com/blog/claude-md-vs-soul-md-vs-skill-md)
- [Cron autonomous agent pattern — DEV](https://dev.to/boucle2026/how-to-run-claude-code-as-an-autonomous-agent-with-a-cron-job-hec)
- [aaronjmars/soul.md](https://github.com/aaronjmars/soul.md)
- [claude-mem — AIToolly](https://aitoolly.com/ai-news/article/2026-04-15-claude-mem-a-new-claude-code-plugin-for-automated-session-memory-and-context-injection)
- [OpenClaw Heartbeat Guide](https://claw.mobile/blog/openclaw-heartbeat-guide)
- [MindStudio: Agentic OS Heartbeat Pattern](https://www.mindstudio.ai/blog/agentic-os-heartbeat-pattern-proactive-ai-agent)
