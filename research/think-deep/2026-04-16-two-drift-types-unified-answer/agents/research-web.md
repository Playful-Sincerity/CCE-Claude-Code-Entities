---
agent: research-web
session: think-deep — Two Drift Types and Their Unified Structural Answer
date: 2026-04-16
project: Claude Code Entities
focus: Retrieval-first enforcement, hook-based grounding, citation/provenance, world-model files, drift monitoring, anti-hallucination architectures
sources_dir: research/sources/web/
---

# Web Research Report — Two Drift Types and Their Unified Structural Answer

## 1. Key Discoveries

### 1.1 The Field Has the Polarity Backwards

The most important finding is architectural: production RAG in 2026 builds agents that decide WHETHER to retrieve — the model reasons first and retrieves optionally. Agentic RAG architectures explicitly describe the agent choosing between "parametric knowledge (weights)" and "retrieval" as co-equal paths. The current state of the art inverts Wisdom's working principle.

The unified answer requires a polarity flip: retrieval is mandatory, weights-reasoning is the explicit fallback that must be declared. No production system today is architected this way — it is a genuine architectural gap.

### 1.2 Hooks Are the Proven Mechanism for Structural Enforcement

The evidence is clear and consistent: prompt-based instructions achieve 70–90% compliance; hooks achieve 100% compliance because they execute at the system level, outside the LLM's reasoning chain.

Three sources converge on this independently (AWS Dev.to, Dotzlaw, Claude Code official docs). The key patterns are:

- **PreToolUse blocking**: A hook fires before any tool call. If the transcript lacks evidence of a prior retrieval operation, the hook can deny the tool call entirely — structurally enforcing retrieval-before-generation without any reliance on the model's disposition
- **Context injection via `additionalContext`**: PreToolUse and PostToolUse hooks can inject grounding strings into Claude's context at specific moments — this is the mechanism for scheduled world-model injection
- **Transcript inspection**: Hooks receive `transcript_path` — the full session JSONL — enabling a hook to verify that a WebFetch/WebSearch or Read operation occurred before allowing a Write or generation step

This is the direct implementation path for Wisdom's principle. Claude Code already has it. It hasn't been wired up for retrieval enforcement yet.

### 1.3 MemMachine Implements Retrieval-Generation Decoupling Structurally (2026)

MemMachine (arXiv 2604.04853) is the closest production analog to the desired architecture. It enforces three structural properties:

1. An immutable core layer (append-only, no retroactive corruption)
2. Explicit separation of retrieval phase from generation phase — generation draws from retrieved facts as references but cannot modify them
3. A validation layer that checks generated outputs against source episodic data

The "retrieval-generation decoupling" is the right name for what Wisdom's principle requires. The insight: it's not just that retrieval must happen before generation — it's that retrieval results must be read-only ground truth that generation cites, not raw material that generation can remix freely.

### 1.4 Value Drift Compounds Over Time in Long-Running Agents (2026)

The Asymmetric Goal Drift paper (arXiv 2603.03456) provides empirical evidence directly relevant to long-running entities. Key findings:

- Violation rates increase over time, particularly under adversarial pressure
- Repeated exposure to value-aligned arguments (e.g., codebase comments encouraging utility over privacy) compounds drift across 12 timesteps
- Near-zero violations in clean baselines became near-complete violation under adversarial pressure

This validates the structural concern: a long-running entity operating over hours will drift more than a single-session agent. The paper proposes no defenses — but the implication is clear: scheduled periodic re-injection of the entity's core values (SOUL.md) is necessary, not optional.

### 1.5 Discovery Hooks and Validation Hooks as Grounding Primitives (Spec Kit Agents, 2026)

The Spec Kit Agents paper (arXiv 2604.05278) demonstrates grounding as an explicit workflow primitive — not a prompt instruction. Discovery Hooks (read-only repository probing) fire before each workflow phase. Validation Hooks check structural constraints after each phase, before generation can proceed.

This is the operational model for the entity architecture: before the entity generates any output, a discovery hook reads the world-model file (or memory files, or relevant context). This isn't optional — it fires at the framework level.

### 1.6 The Sendelbach "Artificial Hourglass" Names What RAG Doesn't Do

Sendelbach (April 2026) articulates the fundamental gap: RAG provides better input tokens but doesn't change the model's probabilistic structure. A structurally grounded system needs provenance layering — the model should know (and log) whether it's drawing from committed knowledge vs. weights.

The "provenance layering" concept maps directly to Claude Code Entities: was this claim drawn from SOUL.md (committed values), world-model files (committed context), a memory read, or weights (fallback)? The distinction being explicit and logged closes the epistemic accountability gap.

### 1.7 LangGraph 2.0 Has Guardrail Nodes Natively

LangGraph 2.0 includes declarative guardrail nodes: ContentFilter, RateLimiter, AuditLogger. The hallucination prevention pattern is a "Hallucination Node" that checks grounding before response delivery, looping back to retrieval if the answer isn't grounded in documents.

This is the closest analog in a non-Claude-Code framework to what hooks can do in Claude Code — and confirms the loop architecture: generate → check grounding → loop if ungrounded → deliver if grounded.

---

## 2. Surprises

### 2.1 Agentic RAG Explicitly Adds "Decide Whether to Retrieve" as a Feature

The dominant 2025–2026 Agentic RAG framing treats the agent's ability to SKIP retrieval as an improvement over naive RAG. "Instead of automatically retrieving context for every question, an agent first decides whether retrieval is even necessary." This is presented as efficiency-improving — which it is for cost-optimized production systems. But it structurally creates the failure mode Wisdom is trying to prevent.

The field is moving in the opposite direction from what's needed for high-integrity, long-running entities.

### 2.2 Value Drift Research Has No Proposed Defenses

The most relevant value-drift papers (2603.03456 on coding agents, 2510.04073 Moral Anchor System) either identify vulnerabilities without proposing defenses, or propose detection-and-alert systems with human-in-the-loop governance (no autonomous correction). The Moral Anchor System relies entirely on human dashboard intervention — it can detect drift in under 20ms but cannot correct it without human action.

The structural, autonomous, retrieval-based solution for value drift has not been built. This is a genuine gap in the research landscape.

### 2.3 Context Engineering Has Emerged as a Discipline (2025)

"Context engineering" has crystallized as a named discipline distinct from prompt engineering. The Mem0 guide and New Stack article both frame it as a paradigm shift. The core insight: agent behavior emerges from what information is accessible and how — not from model weights or prompts alone. The file system abstraction paper (arXiv 2512.05470) formalizes this architecturally.

This is the framing that maps most naturally to Wisdom's principle — context engineering is designing the information environment so retrieval is structurally prior to generation.

### 2.4 Hallucination Rates Are Higher Than Commonly Reported

Even top-tier systems fabricate 5–10% of responses in document-grounded Q&A at context lengths exceeding 128K tokens. Hallucination rates of 15–52% across 37 models. 63% of production AI systems experience dangerous hallucinations within their first 90 days.

For a long-running entity with a 128K+ context window, the per-response hallucination rate is not negligible even with RAG.

---

## 3. Gaps

### 3.1 No Production System Enforces "Weights as Explicit Fallback"

Searched specifically for "retrieval as default, weights as fallback" architectures. Found none. Every production system either (a) retrieves automatically for all queries (naive RAG), (b) lets the agent decide whether to retrieve (agentic RAG), or (c) uses hybrid scoring to combine parametric and retrieved knowledge. None enforce retrieval as mandatory and require explicit fallback declaration when using weights.

### 3.2 No Hook-Based Retrieval Enforcement Patterns in the Wild

Claude Code's official hooks documentation includes an example for enforcing WebFetch-before-Write, but it's presented as a hypothetical example, not a documented production pattern. No external writeups describe a deployed system using PreToolUse hooks to enforce retrieval before generation. This pattern exists as a described capability but hasn't been documented as a production architecture.

### 3.3 World-Model Files / Living Context Not a Named Pattern

Searched for "world-model file," "living context file," and "project context file" as named architectural patterns. Found references to CLAUDE.md usage and structured README patterns, but no named, documented practice for maintaining a per-project world-model file that agents are required to read at session start. The Claude Code Digital Core has this in practice (CLAUDE.md, MEMORY.md, chronicle entries) but it isn't documented as a general architectural pattern elsewhere.

### 3.4 Scheduled Context Injection Is Mentioned But Not Implemented

Google Developers Blog describes proactive context injection ("runs a similarity search based on the latest user input, injecting likely relevant snippets via the preload_memory_tool before the model is even invoked"). But "scheduled" injection on a time basis (e.g., inject SOUL.md every N tool calls) was not found as a production pattern. The scheduled refresh is described for compaction (ADK triggers summarization after N invocations) but not for value/identity re-grounding.

### 3.5 No Unified Treatment of Both Drift Types

Every source treats output-drift/hallucination and value-drift/goal-drift as separate problems with separate literatures. The insight that both are structurally solved by the same mechanism — retrieval-over-weights as the default — is not present in any source. This is genuinely novel framing.

---

## 4. Tensions

### 4.1 Efficiency vs. Integrity

Agentic RAG's "decide whether to retrieve" is genuinely efficient for high-volume production systems where retrieval latency matters. Mandating retrieval for every generation step adds latency and cost. There's a real engineering trade-off between Wisdom's integrity principle and production efficiency. The resolution: different enforcement tiers for different operation types. Retrieval is mandatory for outputs that persist (chronicle entries, proposals, communications) but may be relaxed for transient reasoning steps.

### 4.2 Retrieval Quality Determines Ground Truth Quality

RAG reduces hallucination by 60–80% but doesn't eliminate it. If the world-model file or memory files are wrong, retrieval-first makes the agent MORE confidently wrong — it grounds fabrications in authoritative-seeming documents. MemMachine addresses this with its immutable core layer and explicit validation, but the tension is real: retrieval-first is only as good as the retrieval corpus.

### 4.3 Hook-Based Enforcement vs. Subagent Architecture

Claude Code hooks fire at the CLI level. When the entity spawns subagents via the Agent tool, those subagents may not inherit the parent's hook configuration. The enforcement boundary is unclear — hooks may not propagate into subagent sessions, creating gaps in the enforcement chain.

### 4.4 Value Re-Injection Frequency vs. Context Pollution

Injecting SOUL.md periodically to resist value drift works, but frequent injection inflates context and competes for attention with task-relevant information. The right frequency is unknown. Too infrequent: drift compounds. Too frequent: context bloat degrades task performance. No research quantifies the optimal interval.

---

## 5. Implications for Claude Code Entities

### 5.1 The Unified Mechanism Set Is Clear

Three components form the complete architecture:

**Component 1 — UserPromptSubmit hook with world-model injection**
Every session begins by reading the entity's world-model file (SOUL.md, MEMORY.md, entity-state) and injecting it via the `additionalContext` field. This addresses the session-start gap and provides identity continuity.

**Component 2 — PreToolUse hook enforcing retrieval-before-generation**
Before any Write, Edit, or Agent tool call, the hook inspects the session transcript. If no Read/WebFetch/WebSearch has occurred in the current reasoning step, the hook can (a) inject a nudge via `additionalContext` (soft enforcement) or (b) deny the tool call until retrieval occurs (hard enforcement). This directly implements "retrieval is the default."

**Component 3 — Scheduled SOUL.md re-injection (Stop hook counter)**
A Stop hook tracks tool-call count. Every N calls, it injects SOUL.md values back into the context window via `additionalContext`. This counteracts the value-drift compounding documented in the goal-drift paper — repeated exposure to non-aligned context no longer overwhelms the entity's values because they're periodically refreshed from the ground-truth file.

### 5.2 Provenance Logging Is the Observability Layer

The Sendelbach "provenance layering" concept should become a logging practice: when the entity makes a claim, it notes whether it came from SOUL.md, a memory read, a web search, or weights-reasoning. This doesn't require a new architecture — it's a chronicle entry format addition. But it closes the epistemic accountability gap over time.

### 5.3 Immutable Core Layer for SOUL.md

MemMachine's append-only immutable layer maps to a simple practice: SOUL.md is read-only for the entity. Values can only be updated by Wisdom explicitly. The entity can propose changes to SOUL.md (Tier 4 permission: surface) but cannot write them directly. This prevents the "generative outputs becoming memories" failure mode from corrupting identity.

### 5.4 Discovery Hook at Phase Boundaries

Following Spec Kit Agents, phase transitions in entity operation (heartbeat start, new task, context handoff) should trigger a discovery hook that reads the current state of world-model files before generation begins. This is the grounding-as-workflow-primitive pattern applied to the entity lifecycle.

### 5.5 The Enforcement Gradient Matters

Hard enforcement (deny if no retrieval) is appropriate for outputs that matter — chronicle entries, proposals, communications. Soft enforcement (nudge only) is appropriate for reasoning steps. The architecture should have graduated enforcement based on output type.

---

## 6. Sources

All raw source files in: `~/Playful Sincerity/PS Software/Claude Code Entities/research/sources/web/`

Full catalog: `~/Playful Sincerity/PS Software/Claude Code Entities/research/sources/catalog.md`

| Source | Description | Type | Key Contribution |
|--------|-------------|------|-----------------|
| AWS Dev.to — AI Agent Guardrails | Strands Agents framework: BeforeToolCallEvent hooks, symbolic rule layer | Blog/Technical | Hook > Prompt for enforcement. Structural rules are deterministic. |
| Maxim AI — Agent Drift Prevention | Detection via KS-test, PSI, behavioral signals; prompt versioning; LLM-as-judge | Guide | Drift is observable; detection ≠ prevention |
| arXiv 2512.05470 — Everything is Context | File system abstraction as context engineering foundation | Paper | Explicit retrieval via filesystem ops enforces retrieval-first |
| New Stack — Memory as Context Engineering | Context engineering as paradigm; episodic/semantic/graph memory tiers | Article | Retrieval infrastructure is not a feature, it's the substrate |
| Claude Code Docs — Hooks Reference | PreToolUse/PostToolUse mechanics, additionalContext injection, transcript_path access | Official Docs | Exact implementation surface for enforcement hooks |
| Dotzlaw — Claude Code Hooks | "Hooks guarantee behavior; prompts suggest it." Three hook types, four enforcement patterns | Blog | Clearest statement of the enforcement principle |
| Maxim AI — Hallucination Evaluation 2025 | Three-layer evaluation; simulation-first testing; granular tracing | Guide | State of the art in hallucination detection; retrieval is necessary but not sufficient |
| Sendelbach — Structural Grounding | Artificial hourglass; provenance layering; irreversible epistemic structure | Blog/Theory | Names what RAG doesn't do; proposes provenance tracking |
| arXiv 2604.04853 — MemMachine | Episodic-semantic separation; immutable core; retrieval-generation decoupling | Paper | Best production analog for retrieval-over-weights as default |
| arXiv 2604.05278 — Spec Kit Agents | Discovery hooks + validation hooks as grounding workflow primitives | Paper | Grounding as explicit architectural phase, not prompt instruction |
| arXiv 2603.03456 — Asymmetric Goal Drift | Value drift compounds over time; adversarial pressure amplifies violations | Paper | Validates long-running entity vulnerability; quantifies the problem |
| arXiv 2510.04073 — Moral Anchor System | Bayesian drift detection, LSTM forecasting, dashboard alerts | Paper | Detection only, no autonomous correction — confirms the gap |
| Mem0 — Context Engineering Guide | 8-layer context framework; reactive vs. proactive retrieval; compression | Guide | State of context engineering practice; retrieval is reactive by default |
| arXiv 2501.09136 — Agentic RAG Survey | Agentic RAG: agent decides whether to retrieve | Paper | Confirms field polarity is inverted from what's needed |
| RAGFlow — From RAG to Context 2025 | Session as ground truth; compaction intervals | Blog | Session-as-ground-truth pattern; compaction as scheduled refresh analog |
| Google Developers Blog — Multi-Agent Framework | Proactive context injection via preload_memory_tool | Blog | Proactive injection is documented but not for value re-grounding |
