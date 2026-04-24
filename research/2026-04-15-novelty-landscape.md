# Novelty & Prior Art Landscape — Claude Code Entities
**Date:** 2026-04-15
**Streams:** 4 parallel research agents (Sonnet), synthesized by Opus
**Prior work:** `prior-art-validation.md` (April 13), `2026-04-14-claudeclaw-analysis.md`

---

## Verdict: Genuinely Novel — With a Closing Window

The specific five-element combination (persistent entity + identity-shaped behavior + heartbeat + syscall-level safety + structural audit logging) has not been built or publicly documented. Every element exists individually. Several projects combine 3-4 elements. None combine all five. The synthesis is the novelty.

**The qualification that matters:** Anthropic's internal KAIROS architecture scores 4/5 on the same rubric. KAIROS is Claude Code as persistent entity with a tick-loop heartbeat and append-only audit logs. It's behind a feature flag (`false` in external builds). When it ships — likely 6-18 months — the window for establishing Claude Code Entities as the named pattern closes. The design needs to be documented, built, and understood before KAIROS makes this standard.

---

## Landscape by Stream

### Stream 1: Persistent Entity Systems
*(Full report: [stream1-persistent-entities.md](2026-04-15-stream1-persistent-entities.md))*

**10 systems documented.** The field has accelerated since April 13:

| System | Persistence | Identity | Heartbeat | Safety | Score |
|--------|-------------|----------|-----------|--------|-------|
| ClaudeClaw v2 (earlyaidopters) | SQLite + importance decay | Per-agent CLAUDE.md | Cron via CLI | bypassPermissions + chat-lock + AES | 3/5 |
| Aeon | Git-committed state files | SOUL.md + STYLE.md | GitHub Actions 3x/day | Repo-scoped only | 2.5/5 |
| Managed Agents (Anthropic) | Path-addressable memory stores | None native | External trigger only | API-key scoped, versioned | 2/5 |
| Claude Code Routines (Anthropic) | Session-based | Via session prompt | Cron (1hr min), API, webhooks | Inherited from Claude Code | 2/5 |
| Conway (Anthropic, leaked) | Daemon model | Unknown | Always-on (not heartbeat) | Unknown | ?/5 |
| claude-eng proposal | Neo4j graph + 5-layer memory | Jiminy Guidance Engine | Proposed | Proposed conscience layer | 3.5/5 (proposed) |
| macrodata | TypeScript plugin state | identity.md + human.md | Daemon | Plugin-layer | 2.5/5 |

**Critical gap across all systems:** No system implements identity *development* or earned conviction. SOUL.md is installed, not grown. This remains the Companion's distinctive, uncontested claim.

**Top patterns to adopt:**
1. **ClaudeClaw's importance decay model** — memories scored 0.0-1.0, tier-based decay rates, salience boost on retrieval, pinned memories never decay. Solves "everything equally important" problem.
2. **Aeon's skill-health scoring** — rolling 30-run history per skill, quality 1-5, auto-repair on degradation. Lightweight operational health.
3. **Managed Agents' path-addressable versioned memory** — immutable versions, optimistic concurrency, redact for compliance. The professional-grade persistence substrate.
4. **Claude Code Routines' trigger types** — cron + API endpoint + GitHub webhooks as complementary activation patterns.

---

### Stream 2: Multi-Entity Coordination
*(Full report: [stream2-multi-entity-coordination.md](2026-04-15-stream2-multi-entity-coordination.md))*

**13 systems documented.** The landscape splits into two camps: "AI software companies" (MetaGPT, ChatDev, AgentVerse) that instantiate fresh agents per task, and "persistent organizations" (Paperclip, OrgAgent, Claude MPM) where agents persist across tasks.

| System | Persistence | Coordination | Safety | Key Insight |
|--------|-------------|-------------|--------|-------------|
| **Paperclip** (30K stars) | PostgreSQL, task-context state | Org chart + ticket delegation + goal ancestry | Atomic budget enforcement, human-as-board | Heartbeat is the atomic execution primitive |
| **OrgAgent** (April 2026 paper) | Per-run only | 3-layer hierarchy: Governance/Execution/Compliance | Compliance layer as structural concern | 46-79% token reduction over flat coordination |
| **Claude MPM** | Kuzu semantic graph | Domain authority routing | Context-threshold auto-pause | Closest to Associative Memory vision |
| **Claude Code Agent Teams** (Anthropic) | Shared task lists | P2P mailbox + AGENTS.md | Plan approval mode + file locking | Anthropic's own multi-agent primitive |
| **MetaGPT / MGX** | None (per-run) | SOP-encoded pipeline | Document-structure constraints | SOPs as prompt structure |
| **ChatDev** | None (per-run) | Role-play conversation | Hallucination voting mechanism | Cross-agent voting as error correction |
| **CrewAI** | None | Sequential/hierarchical delegation | Human-in-the-loop optional | Process types as coordination primitives |
| **CAMEL** | None | Inception prompting | Prompt constraints only | Autonomous negotiation without human |
| **ACP** (IBM Research) | Spec only | DID-based agent identity | Cryptographic identity | Right foundation for persistent cross-session identity |
| **Oh-My-ClaudeCode** | Git | Staged pipeline | Smart model routing | Haiku/Opus routing per stage |

**The white space:** No system combines persistent identity with behavioral consistency across sessions, heartbeat-driven autonomous initiative, AND organizational safety enforcement. Every system has identity OR persistence but not both together with a governance model.

**Top patterns to adopt:**
1. **Paperclip's goal ancestry** — tasks carry "full goal ancestry" (why, not just title) injected at runtime. Solves context loss between delegation hops.
2. **OrgAgent's compliance layer** — treating compliance as a structural tier (not a bolt-on) with dedicated CSO/CCO agents. 46-79% token reduction is significant.
3. **ACP's DID-based agent identity** — cryptographic identity for agents is the right foundation for non-repudiable audit trails.
4. **Claude Code Agent Teams' AGENTS.md** — compounding knowledge pattern where agents build shared understanding over time.

---

### Stream 3: Permission-First Agent Safety
*(Full report: [stream3-permission-first-safety.md](2026-04-15-stream3-permission-first-safety.md))*

**8 systems documented.** The field splits on a fundamental fault line: **isolation vs. policy**.

| System | Mechanism | Level | Key Innovation |
|--------|-----------|-------|---------------|
| **Anthropic sandbox-runtime** | Seatbelt (macOS) / Bubblewrap (Linux) | OS-primitive | Open-sourced, 84% fewer permission prompts |
| **Anthropic auto-mode** | ML classifier per tool call | Application + OS | Intelligent per-call evaluation replaces blanket skip |
| **Sandlock** (Multikernel) | Landlock + seccomp-bpf + seccomp-user-notification | Kernel, zero root | Per-tool-call sandboxing, XOA pattern eliminates prompt injection structurally |
| **NVIDIA OpenShell** | Declarative YAML + Landlock | Kernel | Policy-as-code, hot-reloadable, credential injection via env vars |
| **Microsoft Agent Governance** | DID identity + trust protocol | Application | Only system with formal automated kill switch |
| **Aethelgard** (academic) | RL-learned minimal permissions | Application + OS | 73% tool reduction, 100% exec/session block, audit feeds RL |
| **IsolateGPT** (WashU) | LLM-specific isolation | Academic | Decompose LLM processing to isolate sensitive data |
| **AIOS** | OS-level agent runtime | Academic | Agent scheduling, memory management, access control at OS level |

**The critical finding:** The March 2026 proof-of-concept where Claude Code *disabled its own sandbox* and ran commands outside it proves that application-layer safety alone is insufficient. Defense-in-depth (OS primitives + classifier + audit) is required.

**Key gap for Claude Code Entities:** No production system combines (1) per-tool-call OS-primitive sandboxing, (2) cryptographic agent identity with non-repudiable audit logs, (3) RL-learned minimal permissions per task type, and (4) a formal kill switch.

**Top patterns to adopt:**
1. **Sandlock's XOA pattern** — LLM never sees untrusted data; generated code flows to user via kernel pipes, never back into LLM context. Eliminates prompt injection structurally.
2. **Nightshift's 4-layer defense stack** — PreToolUse hooks -> sandbox-exec -> git rollback -> watchdog. Adopt as the defense-in-depth template.
3. **Microsoft's automated kill switch** — formal emergency stop for rogue agents, not just "kill the process."
4. **Aethelgard's RL-learned permissions** — audit log feeds back into permission learning. Makes the log load-bearing.
5. **NVIDIA OpenShell's policy-as-code** — YAML declarative policy with hot reload. Clean config management for entity permissions.

---

### Stream 4: The Specific Gap — Does the Combination Exist?
*(Full report: [stream4-specific-gap.md](2026-04-15-stream4-specific-gap.md))*

**Scored every candidate against all 5 elements:**

| System | Entity (not wrapper) | Identity | Heartbeat | Syscall Sandbox | Audit Log | Total |
|--------|---------------------|----------|-----------|----------------|-----------|-------|
| **KAIROS** (Anthropic internal) | Yes | Partial | Yes (tick loop) | Unknown | Yes (append-only) | **4/5** |
| **Claude Nightshift** | Yes | Partial (runbook) | Yes (watchdog) | Opt-in, macOS only | Partial | **3.5/5** |
| **OpenClaw** | No (wrapper) | Yes (7 files) | Yes | No (Docker) | Partial | **3.5/5** |
| **Managed Agents** | No (Anthropic infra) | No | No | Yes (managed) | Yes | **3/5** |
| **claude-code-thyself** | No (wrapper) | Partial | Yes | No | Git-based | **2.5/5** |
| **ClaudeClaw v2** | No (wrapper) | Partial | Yes | No | Partial | **2.5/5** |
| **SandboxedClaudeCode** | No (wrapper) | No | No | Yes | Yes | **2/5** |
| **TinMan** | Yes | No | No | No | Yes | **1.5/5** |

**Nobody has all five.** The closest is KAIROS at 4/5, and it's not shipped.

---

## The Novelty Claim — Refined

What's **not novel** (don't claim these):
- `claude -p` + cron as heartbeat mechanism
- SOUL.md as identity file
- Git as sync layer
- OS-level sandboxing for LLM agents
- Each individual primitive

What **is novel** (the actual contribution):
1. **Claude Code IS the entity** — not a wrapper, not a backend, not infrastructure around it. The conversation itself persists as the entity. The `--cwd` flag loads identity. The rules ARE the values.
2. **The five-element synthesis** — persistent entity + identity + heartbeat + syscall safety + structural audit, unified in one design without adding a framework layer.
3. **Identity development** — SOUL.md that grows through earned conviction, not installed personality. No one else has this.
4. **Permission as consciousness** — the entity's awareness of its own capability boundaries as a first-class identity concern, not a restriction imposed from outside.

---

## Adopt, Don't Reinvent — Specific Recommendations

### Must Adopt (proven patterns, wasteful to rebuild)

| Pattern | Source | Why |
|---------|--------|-----|
| Importance-scored memory with decay | ClaudeClaw v2 | Solves "everything equally important" problem |
| Skill-health quality scoring | Aeon | Lightweight operational health monitoring |
| Goal ancestry in task delegation | Paperclip | Context propagation across delegation hops |
| 4-layer defense stack | Claude Nightshift | PreToolUse -> sandbox -> git rollback -> watchdog |
| Append-only daily log format | KAIROS | `logs/YYYY/MM/YYYY-MM-DD.md` with `/dream` consolidation |
| Tick loop (event-driven, not fixed interval) | KAIROS | Inject `<tick>` when queue empties; more responsive, less wasteful |
| Separate HEARTBEAT.md from identity files | OpenClaw | Heartbeat instructions are tunable; soul is stable |

### Should Evaluate (promising but may be overkill for Phase 1)

| Pattern | Source | Why Evaluate |
|---------|--------|-------------|
| DID-based cryptographic agent identity | ACP (IBM Research) | Right for non-repudiable audit, but adds complexity |
| RL-learned minimal permissions | Aethelgard | Elegant but requires training data we don't have yet |
| XOA pattern (structural prompt injection elimination) | Sandlock | Powerful but Linux-only (Landlock) |
| Compliance layer as structural tier | OrgAgent | 46-79% token savings, but only matters at multi-entity scale |
| Semantic graph as knowledge layer | Claude MPM (kuzu) | Closest to Associative Memory vision, but early |
| Policy-as-code YAML with hot reload | NVIDIA OpenShell | Clean config management, evaluate when permission model matures |

### Don't Build (solved elsewhere, just use)

| Capability | Use Instead |
|-----------|-------------|
| Memory persistence infrastructure | Managed Agents memory stores (when available) or SQLite |
| Scheduling infrastructure | Claude Code Routines (cron + API + webhook triggers) |
| OS-level sandboxing | Native Claude Code sandbox (Seatbelt/Bubblewrap) |
| Multi-agent task routing | Claude Code Agent Teams (AGENTS.md pattern) |
| Git-based coordination | Existing CoVibe pattern |

---

## Updated Prior Art Status (vs. April 13)

| Claim | April 13 Status | April 15 Status | What Changed |
|-------|----------------|-----------------|-------------|
| No framework wrapper | Partial prior art | Same, but KAIROS confirms Anthropic independently chose this | KAIROS validates the design philosophy |
| CLAUDE.md + rules as identity | Contested (SOUL.md ecosystem) | Still contested, three-layer stack (SOUL + CLAUDE + SKILL) is consensus | Community converging on separation; our "rules ARE identity" is a deliberate counter-position |
| Heartbeat via cron | Documented prior art | Even more documented; Routines adds official Anthropic support | Routines has 1hr minimum — fine-grained heartbeat still requires OS-level cron |
| Settings.json as autonomy tier | Partial | Same | Auto-mode classifier is the Anthropic direction |
| Git as config sync for identity | Not documented | Still not documented | Remains a genuine gap |
| Syscall safety as first-class | Emerging | Rapidly maturing (Sandlock, OpenShell, auto-mode) | The field is moving fast; adopt don't invent |
| **Full combination** | **Not found** | **Still not found (KAIROS closest at 4/5, not shipped)** | **Window is real but closing** |

---

## Sources Index

All raw research saved as separate files per stream. Each finding is traceable to its stream file:

- **Stream 1:** [2026-04-15-stream1-persistent-entities.md](2026-04-15-stream1-persistent-entities.md) — 10 systems
- **Stream 2:** [2026-04-15-stream2-multi-entity-coordination.md](2026-04-15-stream2-multi-entity-coordination.md) — 13 systems
- **Stream 3:** [2026-04-15-stream3-permission-first-safety.md](2026-04-15-stream3-permission-first-safety.md) — 8 systems
- **Stream 4:** [2026-04-15-stream4-specific-gap.md](2026-04-15-stream4-specific-gap.md) — 8 candidates scored

Prior research: [prior-art-validation.md](prior-art-validation.md) (April 13), [2026-04-14-claudeclaw-analysis.md](2026-04-14-claudeclaw-analysis.md)
