# Stream 2: Multi-Entity Coordination Systems
**Research Date:** 2026-04-15
**Researcher:** Claude Code (claude-sonnet-4-6)
**Session:** Multi-entity coordination prior art sweep

This document covers systems where multiple persistent LLM agents coordinate as an organization — with shared knowledge bases, role-based access/permissions, org charts/reporting structures, and cross-agent communication protocols.

Prior-known systems (already documented, not repeated here): nwiizo/ccswarm, open-gitagent/gitagent, Squad (GitHub Blog), CoVibe.

---

## 1. Paperclip

**URL:** https://paperclip.ing | https://github.com/paperclipai/paperclip

**What it is:** Paperclip is an open-source Node.js server (React dashboard) that models AI agents as a structured company — with org charts, roles, reporting lines, budgets, and governance. Created by pseudonymous developer @dotta, launched March 4, 2026, crossed 30,000 GitHub stars within three weeks. Self-described as "the open-source operating system for zero-human companies" and "the human control plane for AI labor."

**Persistence model:** PostgreSQL-backed with an embedded instance for local development. Configuration is file-versioned and revisioned — config changes can be rolled back. Agents maintain task-context state across heartbeats, resuming where they left off rather than restarting.

**Identity model:** Agents have a title, boss, and job description within the org chart. Every entity is company-scoped, enabling one deployment to run many companies with separate data and audit trails.

**Coordination model:** The heartbeat is the core execution primitive — agents wake on a scheduled cadence, assess available work, execute tasks, and sleep. Delegation flows up and down the org chart through a ticket-based system. Tasks carry "full goal ancestry" so agents consistently see the "why" behind their work. Every tool call, API request, and decision is logged in an append-only immutable audit trail.

**Safety model:** Budget enforcement is atomic — task checkout and budget enforcement happen together, preventing double-work and runaway spend. Agents auto-pause at 100% budget utilization with warnings at 80%. Humans function as the board: approve hires, override strategy, pause or terminate any agent at any time. Agents cannot hire new agents without human approval.

**Knowledge sharing:** SKILLS.md files are runtime-injected — agents can learn Paperclip workflows and project context at runtime without retraining. Goal hierarchies propagate context through task ancestry.

**Role-based access:** Human as board of directors. Supervisory control with override/pause/terminate at any level.

**What we can learn:**
- The heartbeat as the atomic execution unit (not "respond to prompt") is the right primitive for persistent entities
- Task ancestry ("why" context propagation) solves the context loss problem between delegation hops
- Atomic budget enforcement prevents the runaway cost problem
- Immutable audit log is the accountability layer, not an afterthought
- Company-scoped isolation enables multi-tenancy from day one

**What's missing relative to our design:**
- No explicit identity persistence beyond session (entities are roles, not selves with history)
- No epistemic state (what the agent believes, with what confidence)
- No behavioral consistency enforcement (same agent can act differently each heartbeat)
- No emotional/prosodic layer
- Budget is cost-only; no capability budgeting or tool-scope constraints per role
- Knowledge sharing is SKILLS.md injection, not a navigable graph

---

## 2. MetaGPT / MGX

**URL:** https://github.com/FoundationAgents/MetaGPT | https://arxiv.org/abs/2308.00352

**What it is:** MetaGPT encodes a software company's SOPs (Standardized Operating Procedures) into prompt sequences for a multi-agent team. Takes a one-line requirement and outputs user stories, competitive analysis, requirements, data structures, APIs, and code — by routing through internal Product Manager, Architect, Project Manager, and Engineer agents. Published at ICLR 2024 (oral). Launched commercial product MGX (MetaGPT X) in February 2025 as "the world's first AI agent development team."

**Persistence model:** No persistent identity between runs. Agents are role-players instantiated per task, not long-running entities.

**Identity model:** Roles are hardcoded archetypes (PM, Architect, Engineer, QA). Each agent operates on shared structured documents (PRDs, technical specs, code) as the coordination medium.

**Coordination model:** Assembly line / sequential pipeline. Structured documents are the shared state — each role produces and consumes typed artifacts. SOPs are encoded into the prompt sequences, guiding what each role produces and in what format.

**Safety model:** Human-in-the-loop at key artifact stages; structured document constraints limit scope drift.

**Knowledge sharing:** Through shared structured artifacts — the PRD is shared with the Architect, the design doc is shared with Engineers. No persistent memory layer.

**What we can learn:**
- Encoding SOPs into prompt structure is powerful — it makes the workflow explicit and auditable
- Document-as-coordination (shared artifacts each role produces and consumes) is more reliable than conversational coordination
- Role-based division of labor with typed output formats reduces hallucination

**What's missing relative to our design:**
- No persistent identity — each run is fresh
- No heartbeat — tasks are batch jobs, not ongoing processes
- No shared knowledge graph; artifacts are ephemeral per-project
- No safety model beyond document structure
- No org chart with reporting lines — it's linear pipeline, not hierarchy

---

## 3. ChatDev

**URL:** https://github.com/OpenBMB/ChatDev | https://arxiv.org/abs/2307.07924

**What it is:** ChatDev is a chat-powered virtual software company where LLM-driven agents (CEO, CTO, CPO, Programmer, Reviewer, Tester) collaborate through structured natural language conversations to build software from a single requirement. Originally a research prototype; ChatDev 2.0 expanded to a "Zero-Code Multi-Agent Platform for Developing Everything." Published at ACL 2024.

**Persistence model:** No persistent agents; roles are instantiated per task. ChatDev 2.0 adds "Iterative Experience Refinement" (IER) — agents build shortcut experiences across tasks and refine them, creating a form of cross-run learning.

**Identity model:** Role archetypes with fixed responsibilities. Communication follows a "chat chain" — structured multi-turn conversations decomposed into subtasks.

**Coordination model:** Chat chain decomposes each development phase into subtasks with specific agent pairs. MacNet (introduced June 2024) enables directed acyclic graph topologies for agent collaboration, supporting 1000+ agent cooperation without exceeding context limits. "Communicative dehallucination" pattern: agents request more detail before responding, reducing hallucination by surfacing ambiguity.

**Safety model:** Structured phase gating — each phase must produce specific artifacts before the next begins. No explicit resource constraints.

**Knowledge sharing:** IER (Iterative Experience Refinement) builds a shortcut experience library across task runs. Agents learn efficient paths through common subtasks.

**What we can learn:**
- MacNet's DAG topology for agent communication — more flexible than strict hierarchies for complex task graphs
- Communicative dehallucination is a real pattern: agents asking for clarification before acting reduces errors more than validation after the fact
- Experience refinement (IER) is a simple form of cross-run organizational learning

**What's missing relative to our design:**
- Still no persistent entities with identity
- No heartbeat — pure task-execution model
- MacNet DAGs are task-topology, not org structure
- No shared navigable knowledge base
- Experience library is not entity-specific — it's shared across all agent instances of a role

---

## 4. CrewAI

**URL:** https://crewai.com | https://github.com/crewaiinc/crewai

**What it is:** CrewAI is an open-source framework for coordinating multiple AI agents in role-based "crews." The crew metaphor structures agents with defined roles (Manager, Worker, Researcher), tools, and a shared goal. 100,000+ certified developers, 1M+ monthly downloads as of 2025-2026.

**Persistence model:** Sessions are stateless by default; persistent memory must be explicitly integrated (e.g., via Mem0 or similar). When paired with persistent memory, agents retain context, adapt behavior, and build on prior interactions.

**Identity model:** Agents are defined by role, goal, and backstory in configuration. Role-based differentiation is the primary identity mechanism — no unique persistent self across invocations.

**Coordination model:** Hierarchical — Manager agents oversee task distribution, Worker agents execute, Researcher agents gather information. Senior agents can override junior decisions and redistribute resources. Supports sequential, parallel, and conditional task execution.

**Safety model:** No explicit budget enforcement. Hierarchical override (senior can redirect junior) provides a soft safety mechanism.

**Knowledge sharing:** No built-in shared knowledge graph; relies on external memory integrations. Agents share context through task outputs passed between crew members.

**What we can learn:**
- Role definition via (role, goal, backstory) triplet is a clean interface for identity bootstrapping
- Hierarchical override with explicit authority levels maps naturally to org chart governance
- Parallel and conditional task execution patterns are worth adopting

**What's missing relative to our design:**
- Identity is role-based configuration, not persistent self
- No heartbeat or scheduled autonomous work
- Memory is external plumbing, not first-class architecture
- No entity-level audit trail
- No budget/cost safety at the framework level

---

## 5. CAMEL (Communicative Agents for Mind Exploration)

**URL:** https://github.com/camel-ai/camel | https://arxiv.org/abs/2303.17760

**What it is:** CAMEL is the earliest multi-agent coordination framework (2023), pioneering role-playing coordination where a task-specific agent and two cooperating agents (User/Assistant pair) collaborate via structured role assignment. Now expanded to include Workforce, Society, and Memory modules. Community-driven research collective with 100+ researchers.

**Persistence model:** Agent context is a state-transition process with both short-term and long-term memory. Recent versions support persistent memory across runs (lightweight cross-session retention).

**Identity model:** Role-playing is the identity mechanism — agents are assigned personas at task time. RolePlaying module sets up "agent societies" where each takes a specific role. No persistent self across invocations.

**Coordination model:** Roleplay conversation between User/Assistant pair guided by task-specific instructions. Society module enables coordinated groups (Planner, Researcher, Writer, Critic, Finalizer). Communication is JSON-based with iterative refinement loops. Workforce module coordinates task distribution across agent pools.

**Safety model:** Role constraints limit agent scope. No explicit resource enforcement.

**Knowledge sharing:** Memory module supports multiple memory types: short-term (chat), long-term (persistent storage), episodic, and semantic. Agents can retrieve relevant past experience. Workforce module distributes knowledge across agent pools.

**What we can learn:**
- The User/Assistant role-play structure elegantly enforces goal alignment without external orchestration
- Explicit memory architecture (short-term + long-term + episodic + semantic) is a mature multi-layer model worth adopting
- Society/Workforce modules show that the same agents can be organized at different granularities (pair, group, workforce)

**What's missing relative to our design:**
- Role-playing identity is not persistent self — same agent instance can play any role
- No heartbeat or scheduled autonomous execution
- Memory is per-agent, not shared organizational knowledge graph
- No org chart or reporting hierarchy
- No budget/safety enforcement

---

## 6. AgentVerse

**URL:** https://proceedings.iclr.cc/paper_files/paper/2024/file/578e65cdee35d00c708d4c64bce32971-Paper-Conference.pdf | OpenReview

**What it is:** AgentVerse (ICLR 2024) is a multi-agent framework that orchestrates collaborative groups of expert agents, inspired by human group dynamics. Its key innovation is dynamic team composition — the group adjusts membership based on task progress and evaluation feedback.

**Persistence model:** No persistent entities; agents are instantiated for tasks.

**Identity model:** Agents are "expert descriptions" dynamically generated based on task goals. The group composition adapts based on evaluation stage feedback.

**Coordination model:** Dynamic expert recruitment — rather than fixed roles, the system generates appropriate expert descriptions for the task and adjusts group membership based on evaluation. Solves the "static org chart" problem by making team composition adaptive.

**Safety model:** Evaluation stage provides quality gate before proceeding.

**Knowledge sharing:** Agents share a common task context; no persistent shared knowledge base.

**What we can learn:**
- Dynamic team composition (recruit experts per task) vs. fixed org chart is a meaningful design choice — fixed charts give identity continuity, dynamic recruitment gives optimal expertise
- Evaluation-driven membership adjustment is worth adopting as a quality signal
- Auto-generating expert descriptions from task goals scales better than hand-authoring every role

**What's missing relative to our design:**
- No persistent agents — full ephemeral model
- No org chart (dynamic composition is the opposite)
- No shared knowledge base
- No heartbeat

---

## 7. OrgAgent

**URL:** https://arxiv.org/html/2604.01020

**What it is:** OrgAgent (April 2026, hot off the press) explicitly frames multi-agent systems as companies, with a three-layer organizational hierarchy that maps to corporate roles: CEO/CTO/COO at the governance layer, Drafter/Reviewer/Specialist at the execution layer, CSO/CCO at the compliance layer. Published just before this research session.

**Persistence model:** No persistent entities — agents are role instantiations per problem. But the framework enforces structural persistence through fixed layer architecture.

**Identity model:** Corporate role archetypes (CEO, CTO, COO, Drafter, Reviewer, Specialist, CSO, CCO). Also maintains a skill-based worker pool with six reusable orientations: Technical, Quantitative, Reasoning, Domain, Communications, Data.

**Coordination model:** Three-layer sequential workflow: (1) governance layer determines execution configuration, (2) execution layer runs with bounded interaction rounds (up to 5 rounds for FULL MAS mode), (3) compliance layer validates output. Four execution modes (DIRECT, LIGHT MAS, FULL MAS, AUTO) enable cost/quality tradeoff. Key finding: hierarchical organization reduces token usage 46-79% vs flat peer-to-peer approaches.

**Safety model:** CCO (Chief Compliance Officer) validates structural compliance. CSO (Chief Solutions Officer) formats final answers. Framework increases abstention rates for unanswerable questions — agents learn to say "I don't know" rather than hallucinate.

**Role-based access:** Explicit separation of governance, execution, and compliance into distinct layers with sequential authority.

**What we can learn:**
- The governance / execution / compliance three-layer model is a powerful conceptual framework applicable to entity design
- Compliance as its own layer (not just error-checking) changes the safety model from "catch bugs" to "ensure organizational integrity"
- 46-79% token reduction from hierarchy vs. flat — compelling evidence that structure pays off
- AUTO mode (adaptive configuration selection) is the right default — don't require humans to specify execution depth

**What's missing relative to our design:**
- No persistent entities
- No heartbeat or scheduled execution
- No shared knowledge graph
- No cross-run learning or memory
- Hierarchical coordination is sequential, not concurrent

---

## 8. LangGraph (Supervisor Pattern)

**URL:** https://github.com/langchain-ai/langgraph | https://docs.langchain.com/oss/python/langgraph/workflows-agents

**What it is:** LangGraph is LangChain's graph-based framework for stateful multi-agent workflows. The supervisor pattern is its primary multi-agent coordination model: a coordinator routes queries to specialized agents based on capability matching. The framework provides explicit, reducer-driven state management with persistence checkpointing.

**Persistence model:** Strong. MemorySaver, SqliteSaver, and PostgresSaver persist state after every node execution. Supports pause-and-resume across computing environments. Automatic crash recovery from last checkpoint.

**Identity model:** Agents are graph nodes with typed state schemas. Role specialization is through node definition, not persona. Identity is functional, not personal.

**Coordination model:** Supervisor pattern — central coordinator routes to specialists. Specialists maintain their own scratchpad while supervisor orchestrates via message history and task delegation. Supports parallel subgraph execution. State is a centralized, shared schema accessible to all nodes.

**Safety model:** Human-in-the-loop interrupt points can be inserted at any node. State is explicit and inspectable — no hidden side effects. Checkpointing enables rollback.

**Knowledge sharing:** Centralized state schema is the shared medium. All nodes read from and write to the same state. External storage can be plugged in for longer-term memory.

**What we can learn:**
- Centralized typed state schema as the coordination medium is robust — no implicit message passing, everything is explicit
- Interrupt points (human-in-the-loop checkpoints) as first-class architecture, not bolt-on
- Checkpointing for crash recovery is a production requirement, not a nice-to-have

**What's missing relative to our design:**
- No persistent agent identity — nodes are functional, not personal
- No heartbeat — workflow is triggered, not autonomous
- Supervisor is a router, not a manager with authority to override
- No org chart with reporting lines and delegation
- No organizational knowledge graph

---

## 9. AutoGen / AG2

**URL:** https://github.com/ag2ai/ag2

**What it is:** AG2 (formerly AutoGen) is Microsoft Research's multi-agent conversation framework, now maintained as open-source AgentOS. GroupChat is the primary coordination primitive: multiple agents in a shared conversation with a selector determining who speaks next. SocietyOfMindAgent wraps a GroupChat as a single external agent, enabling hierarchical composition.

**Persistence model:** Conversation history is in-memory by default. External storage plugins available for persistence. No native cross-session agent identity.

**Identity model:** ConversableAgent instances with custom roles and system prompts. GroupChat manages turn-taking; GroupChatManager runs the coordination. SocietyOfMindAgent hides internal group complexity behind a single external interface.

**Coordination model:** GroupChat selector (round-robin or custom heuristic) determines speaker turn. SocietyOfMind enables agent hierarchies through composition — inner groups can be nested. Agents can spawn sub-conversations.

**Safety model:** Code execution sandbox (Docker). Human proxy agent pattern — humans can intercept and respond at any turn. No budget enforcement.

**Knowledge sharing:** Shared conversation window (bounded by context limit). No persistent shared knowledge base across sessions.

**What we can learn:**
- SocietyOfMindAgent as the hierarchical composition primitive — a group can act as a single agent to external observers, enabling clean org chart nesting
- Human proxy pattern (human-as-agent-in-conversation) is a clean interface for supervision without breaking the agent protocol
- GroupChat selector as explicit coordination policy deserves study — who speaks next is an important design decision

**What's missing relative to our design:**
- No persistent identity
- No heartbeat
- No org chart with authority
- No shared knowledge graph
- GroupChat selector is turn-taking, not organizational governance

---

## 10. Claude Code Agent Teams (Official)

**URL:** https://code.claude.com/docs/en/agent-teams

**What it is:** Anthropic's own experimental multi-agent feature for Claude Code (v2.1.32+, disabled by default). One session acts as team lead; teammates are separate Claude Code instances with independent context windows. Coordination through shared task list and peer-to-peer mailbox.

**Persistence model:** Team config stored at `~/.claude/teams/{team-name}/config.json`. Task list at `~/.claude/tasks/{team-name}/`. No persistent agent identity beyond session — teammates cannot be resumed after shutdown without re-spawning.

**Identity model:** Lead + named teammates. Lead assigns names; teammates can message any other by name. Team config includes `members` array with names, agent IDs, and types. Roles defined by spawn prompt, not persistent configuration.

**Coordination model:** Shared task list (three states: pending, in-progress, completed) with dependency tracking. File locking prevents race conditions when teammates claim tasks simultaneously. Peer-to-peer mailbox for direct messaging; broadcast available but discouraged (cost scales linearly). Teammates auto-notify lead on idle. Tasks automatically unblock when dependencies complete.

**Safety model:** Human stays in control — lead won't spawn without approval, teammates can't spawn sub-teams. Hook system (TeammateIdle, TaskCreated, TaskCompleted) for quality gates. Permission inheritance from lead. Plan approval mode: teammates submit plans before implementing; lead approves or rejects.

**Role-based access:** Subagent definitions (with tools allowlist and model specification) can be referenced for teammates, giving per-role capability constraints.

**Knowledge sharing:** CLAUDE.md and AGENTS.md shared across all teammates (same project context). AGENTS.md compounds across sessions — agents read it and update it, accumulating project knowledge.

**What we can learn:**
- File locking for task claiming is the right primitive for concurrent coordination without distributed consensus
- Plan approval before implementation is a trust-building mechanism applicable to our design
- AGENTS.md as a compounding shared knowledge file is a simple but powerful pattern
- TeammateIdle hook enables quality gates at the framework level — extend this

**What's missing relative to our design:**
- No persistent identity — teammates don't persist between sessions
- No org chart with authority hierarchy — lead is fixed, no promotion/delegation
- No heartbeat — reactive to task assignment, not autonomous wakeup
- Limited knowledge sharing (AGENTS.md is flat markdown, not navigable graph)
- No budget enforcement per agent/role
- One team per session; no nested teams

---

## 11. Claude MPM (Multi-Agent Project Manager)

**URL:** https://github.com/bobmatnyc/claude-mpm

**What it is:** Claude MPM is an orchestration layer for Claude Code with 47+ specialized agents (Python, TypeScript, Rust, Go, Java, Ruby, PHP, QA, Security, DevOps, and more). The PM agent routes tasks to domain specialists via a channel hub. Enterprise-grade features: graph memory, GitHub integration, OAuth 2.0, encrypted token storage.

**Persistence model:** Strong. Graph memory (kuzu-memory) for persistent semantic project knowledge. Session resume with full context preservation. Auto-pause summaries at 70%/85%/95% context thresholds. GitHub-native context injection (branch/PR/repo state).

**Identity model:** Domain-specialized agents defined via hierarchical BASE-AGENT.md template inheritance. 47+ agents with domain authority system for intelligent routing. Skills as first-class citizens with auto-discovery.

**Coordination model:** PM (Project Manager) agent is the central orchestrator — receives tasks, routes to specialists. Channel Hub is the multi-session message bus. Event Bus is file-based queue for sidecar agent-to-PM communication. 6 hook events (start, stop, pause, resume, complete, error) for workflow integration.

**Safety model:** Input validation across all services. Encrypted token storage (Fernet + system keychain). OAuth 2.0 for external integrations. ~60 service-oriented isolation. No uncontrolled process spawning.

**Knowledge sharing:** Graph memory (kuzu) enables semantic relationship storage across project runs. Domain authority system enables skill auto-discovery. GitHub state is continuously available to all agents.

**What we can learn:**
- Graph memory (kuzu) as the persistent knowledge layer — not markdown files, but a navigable semantic graph. This is the closest to our AM vision.
- Domain authority system as a routing layer — agents self-advertise capabilities, PM queries the registry rather than hard-coding routes
- Context threshold auto-pause (70/85/95%) is a practical safety mechanism for long-running agents
- BASE-AGENT.md template inheritance enables DRY agent definition at scale

**What's missing relative to our design:**
- PM agent is a router, not an authority with org-chart position
- No heartbeat — still task-triggered
- No entity identity persistence beyond knowledge graph
- Safety is system-level (encryption, OAuth), not organizational (who can authorize what)

---

## 12. Oh-My-ClaudeCode (OMC)

**URL:** https://github.com/Yeachan-Heo/oh-my-claudecode

**What it is:** OMC is a multi-agent orchestration plugin for Claude Code with 19 specialized agents and 36 skills. Trended #1 on GitHub (858 stars in 24 hours). Claims 3-5x speedup and 30-50% token savings through staged pipeline orchestration on top of native Claude Code Agent Teams.

**Persistence model:** Session artifacts (`.omc/sessions/*.json`), replay logs (`.omc/state/agent-replay-*.jsonl`). Ralph mode: persistent loops with verify/fix cycles until task completes fully.

**Identity model:** Skill-centric rather than agent-centric. Skills are reusable patterns (`.omc/skills/`) auto-injected via keyword triggers. 19 agents with tier variants.

**Coordination model:** Team mode runs a staged pipeline: `team-plan → team-prd → team-exec → team-verify → team-fix`. Built on top of native Claude Code Agent Teams. Smart model routing (Haiku for simple, Opus for complex). Multiple orchestration modes: Team, Autopilot, Ralph, Pipeline.

**Safety model:** Not explicitly documented. Ralph mode's completion loops prevent silent partial failures.

**Knowledge sharing:** Skill auto-injection based on keyword triggers. Project-level skills override user-scoped defaults, enabling project-specific organizational knowledge.

**What we can learn:**
- Layered staged pipeline (plan → PRD → exec → verify → fix) formalizes the SDLC as an entity coordination protocol
- Smart model routing as coordination policy — not all agents need the same model
- Skill keyword injection is a lightweight dynamic context injection mechanism
- Ralph mode (verify/fix loops) is a useful pattern for high-stakes tasks that must complete

**What's missing relative to our design:**
- Built entirely on top of ephemeral Agent Teams — no persistent identity
- No org chart or authority structure
- No shared knowledge graph — skills are static files
- No heartbeat

---

## 13. Agent Communication Protocol (ACP)

**URL:** https://arxiv.org/html/2602.15055v1

**What it is:** ACP is a proposed formal protocol for agent-to-agent communication, sponsored by IBM Research, aiming for standardization under the Linux Foundation. Defines a layered model for how heterogeneous agents discover each other, negotiate capability contracts, and execute delegated tasks.

**Persistence model:** Agent Cards (machine-readable identity documents) persist and are discoverable via DHT. Global Reputation Ledger tracks post-interaction scores.

**Identity model:** Decentralized Identifiers (DIDs) — each agent has a cryptographically-controlled identity not issued by any central authority. Verifiable Credentials prove capability claims.

**Coordination model:** Four-layer stack: Transport (gRPC/WebSocket/HTTPS), Semantic (JSON-LD intent translation), Negotiation (Agent Card exchange + SLA contracts), Governance (zero-trust enforcement). Four-stage A2A lifecycle: Inquiry (PROBE) → Proposal (BID) → Agreement (COMMIT) → Execution + Settlement. Recursive delegation: agents accepting tasks can themselves become requesters, enabling self-organizing swarms.

**Safety model:** Zero-trust architecture. Every action is cryptographically signed (Proof-of-Intent). Non-repudiation via signed messages. Global Reputation Ledger creates accountability pressure. No agent can impersonate another (DID-based identity).

**Knowledge sharing:** Agent Cards as the capability discovery layer. DHT-backed consortium blockchain for immutable, transparent cross-platform agent registries.

**Performance:** ~58ms average latency in federated mode. O(log N) DHT discovery, sub-100ms with 500+ agents.

**What we can learn:**
- DID-based identity is the right cryptographic foundation for persistent agent identity across systems
- Agent Cards as machine-readable capability advertisements enables dynamic discovery rather than hard-coded routing
- Proof-of-Intent (signed action authorization) is a strong safety primitive — every action is traceable to an authorized intent
- Global Reputation Ledger introduces a cross-organizational accountability mechanism

**What's missing relative to our design:**
- ACP is a protocol spec, not an implementation — no heartbeat, no org chart, no shared knowledge graph in the protocol itself
- Zero-trust is good but orthogonal to organizational trust (manager-subordinate authority)
- Reputation system is cross-org, not intra-org governance

---

## Synthesis: Design Space Map

### Dimension 1: Persistence Model
| System | Persistence Level |
|--------|------------------|
| Paperclip | Strong (PostgreSQL, config versioning, heartbeat resumption) |
| Claude MPM | Strong (graph memory, session resume, context thresholds) |
| LangGraph | Strong (checkpoint-based, SqliteSaver/PostgresSaver) |
| OMC | Moderate (session artifacts, replay logs) |
| Claude Agent Teams | Weak (config file, no identity resumption) |
| MetaGPT / ChatDev / CrewAI / CAMEL | None to weak (ephemeral per task) |

### Dimension 2: Identity Model
| System | Identity |
|--------|----------|
| ACP | Cryptographic (DID + Verifiable Credentials) |
| Paperclip | Role + org position (persistent across heartbeats) |
| Claude MPM | Domain authority + template inheritance |
| OrgAgent | Corporate role archetype |
| CrewAI | (Role, Goal, Backstory) triplet |
| CAMEL | Role-play assignment per task |
| MetaGPT/ChatDev | Fixed archetype, ephemeral instance |

### Dimension 3: Coordination Model
| System | Coordination |
|--------|-------------|
| Claude Agent Teams | Shared task list + P2P mailbox + file locking |
| LangGraph | Centralized typed state schema + supervisor routing |
| Paperclip | Org chart delegation + heartbeat + ticket system |
| OrgAgent | Three-layer sequential authority (governance / exec / compliance) |
| AG2/AutoGen | GroupChat selector + SocietyOfMind composition |
| MetaGPT | SOP-encoded sequential pipeline |
| ChatDev | Chat chain + MacNet DAG |

### Dimension 4: Safety Model
| System | Safety |
|--------|--------|
| ACP | Zero-trust, DID, Proof-of-Intent, Reputation Ledger |
| Paperclip | Atomic budget enforcement, human-as-board, approval gates |
| Claude Agent Teams | Plan approval mode, hooks (TeammateIdle/TaskCreated/TaskCompleted) |
| LangGraph | Interrupt points, explicit state, checkpointing + rollback |
| OrgAgent | Compliance layer (CCO), abstention enforcement |
| AG2 | Code sandbox, human proxy, interrupt at any turn |

### Dimension 5: Knowledge Sharing
| System | Knowledge Model |
|--------|----------------|
| Claude MPM | Semantic graph (kuzu), domain authority registry |
| CAMEL | Multi-layer memory (short/long/episodic/semantic) |
| Claude Agent Teams | AGENTS.md (compounding flat file) |
| Paperclip | SKILLS.md injection + goal ancestry |
| ChatDev | IER experience library (cross-run shortcut learning) |
| MetaGPT | Shared structured artifacts (PRD, design docs) |
| LangGraph | Centralized typed state (per-workflow) |

---

## Key Findings for Claude Code Entities Design

**1. The heartbeat is the right atomic primitive — Paperclip proved it.** No other system has executed on this as cleanly. The alternative (task-triggered activation) loses the autonomous initiative that distinguishes entities from agents.

**2. Three-layer hierarchy (OrgAgent) is a powerful conceptual frame.** Governance / Execution / Compliance maps directly to our need for strategic authority, task work, and safety enforcement. Formalizing this as distinct layers (not just roles) is a design principle worth adopting.

**3. Graph memory (Claude MPM with kuzu) is the closest thing to the AM vision in production.** Semantic relationships stored as a persistent graph — not flat files — enables the navigable organizational knowledge base we need.

**4. Task ancestry ("why" context propagation, Paperclip) solves context loss across delegation hops.** Every subagent in our system should receive not just the task but the full goal chain it serves.

**5. Atomic budget enforcement (Paperclip) + Plan approval (Claude Agent Teams) are the two best safety patterns.** Both prevent the runaway / rogue execution failure mode without breaking autonomous operation.

**6. DID-based identity (ACP) is the right cryptographic foundation for persistent entity identity** — especially if entities will eventually coordinate across multiple Claude Code instances or systems.

**7. AGENTS.md as compounding organizational knowledge (Claude Agent Teams)** is a low-friction starting point. The right evolution is AGENTS.md → kuzu graph → Associative Memory.

**8. OrgAgent's 46-79% token reduction from hierarchy vs flat** is empirical evidence that organizational structure is not just governance overhead — it is efficiency infrastructure.

**9. Nobody has built persistent entity identity with behavioral consistency across sessions.** Every system either has identity (role-based, ephemeral) or persistence (checkpoint-based, stateless). The combination — an entity that is the same self across heartbeats, with consistent beliefs, values, and history — is the white space.

**10. The compliance layer is underbuilt everywhere except OrgAgent.** Most systems treat safety as "don't do bad things" rather than "continuously verify organizational integrity." CCO-pattern agents that check structure, not just content, are worth building.

---

## Sources

- [Paperclip GitHub](https://github.com/paperclipai/paperclip)
- [Paperclip.ing homepage](https://paperclip.ing/)
- [MetaGPT GitHub](https://github.com/FoundationAgents/MetaGPT)
- [MetaGPT paper (ICLR 2024)](https://arxiv.org/abs/2308.00352)
- [ChatDev GitHub](https://github.com/OpenBMB/ChatDev)
- [ChatDev paper (ACL 2024)](https://arxiv.org/abs/2307.07924)
- [CrewAI GitHub](https://github.com/crewaiinc/crewai)
- [CrewAI Collaboration docs](https://docs.crewai.com/en/concepts/collaboration)
- [CAMEL GitHub](https://github.com/camel-ai/camel)
- [CAMEL paper (NeurIPS 2023)](https://arxiv.org/abs/2303.17760)
- [AgentVerse paper (ICLR 2024)](https://proceedings.iclr.cc/paper_files/paper/2024/file/578e65cdee35d00c708d4c64bce32971-Paper-Conference.pdf)
- [OrgAgent paper (arXiv April 2026)](https://arxiv.org/html/2604.01020)
- [Claude Code Agent Teams docs](https://code.claude.com/docs/en/agent-teams)
- [Claude MPM GitHub](https://github.com/bobmatnyc/claude-mpm)
- [Oh-My-ClaudeCode GitHub](https://github.com/Yeachan-Heo/oh-my-claudecode)
- [ACP paper (arXiv Feb 2026)](https://arxiv.org/html/2602.15055v1)
- [LangGraph docs](https://docs.langchain.com/oss/python/langgraph/workflows-agents)
- [AG2 GitHub](https://github.com/ag2ai/ag2)
- [Multi-Agent Collaboration Survey](https://arxiv.org/html/2501.06322v1)
