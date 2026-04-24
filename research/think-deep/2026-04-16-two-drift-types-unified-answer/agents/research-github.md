---
agent: research-github
session: 2026-04-16-two-drift-types-unified-answer
question: How do we architect an agent that resists both value-drift and output-drift via a unified mechanism set centered on retrieval-over-weights as structural default?
fetched_at: 2026-04-16
---

# GitHub Research — Two Drift Types and Unified Structural Answer

## 1. Key Discoveries (Patterns Actually Shipping)

### 1a. Pre-Generation Retrieval Hooks (VideoSDK pattern)

The clearest shipped implementation of retrieval-as-structural-default is VideoSDK's `user_turn_start` hook:

```python
@pipeline.on("user_turn_start")
async def on_user_turn_start(transcript: str):
    context_docs = await agent.retrieve(transcript)
    agent.chat_context.add_message(
        role="system",
        content=f"Retrieved Context:\n{context_str}\n\nUse this context to answer..."
    )
```

This fires **before** the LLM is called and injects retrieved docs labeled "Retrieved Context:". It's not advisory — it's wired into the pipeline event system. The hook name encodes timing: `user_turn_start`, not `user_turn_end`.

**Claude Code Entities analog**: a `PreToolUse` or `Stop` hook that reads `world-model.md` and injects it as system context before any generation, structured as `[RETRIEVED: <source>]` prefixed content.

### 1b. Claim Annotation: EXTRACTED vs INFERRED (llm-wiki-agent)

The closest concrete implementation of epistemic-status annotation is in **SamurAIGPT/llm-wiki-agent** (2K stars, MIT). Knowledge graph edges are tagged:
- `EXTRACTED` — derived from source wikilinks (retrieved)
- `INFERRED` — agent-reasoned with confidence score
- `AMBIGUOUS` — uncertain provenance

YAML frontmatter per wiki page (`type: source`, etc.) enables queries that filter by content type. This is a working provenance-annotation system, though it lives in the graph metadata layer rather than inline in prose outputs.

The Karpathy LLM-wiki pattern (April 2026, 5K+ GitHub Gist stars, 16M+ X views) is the underlying architecture: raw sources → LLM-maintained wiki → wiki serves as grounding layer for all generation. Outputs carry `[[wikilinks]]` citations back to wiki pages. This is retrieve-first enforced by workflow structure.

### 1c. Two-Phase Memory Separation: KAIROS Pattern (Piebald-AI system prompts)

The KAIROS architecture shipped inside Claude Code implements exactly the operating-entity → restricted-consolidator separation:

- **Operating entity**: append-only writes to `logs/YYYY/MM/YYYY-MM-DD.md`. System prompt: "Do not rewrite or reorganize the log — it is append-only."
- **Dream subagent** (`/dream`): runs nightly, reads logs, writes to MEMORY.md and topic files
- **Enforcement mechanism**: prompt gating, not runtime barrier. Different system prompts = different write permissions.
- **Feature flag**: `feature('KAIROS')` gates the variant

The separation means value-injected content in operational context cannot directly corrupt the permanent memory layer — it must pass through the consolidation agent's judgment first. The consolidation agent can delete contradicted facts.

**elfmem** implements a similar two-phase cycle: `dream()` (seconds scale, heavy consolidation) + `curate()` (scheduled ~40hr, maintenance/decay). And enforces a RECALL-first discipline loop: RECALL → EXPECT → ACT → OBSERVE → CALIBRATE → ENCODE.

### 1d. Behavioral Baseline Drift Detection (DriftShield-mini + Driftbase)

**DriftShield-mini** (v0.1.1, Feb 2026): wraps LangChain/CrewAI agents non-intrusively with `monitor.wrap(agent)`. Baseline built from first 30 runs. Three detectors:
- **Goal drift**: embedding distance from output to stated `goal_description` — covers value-drift
- **Loop detection**: repetitive tool-call patterns — covers behavioral drift
- **Resource spikes**: token/duration anomalies

**Driftbase** (commercial): tracks 12 drift dimensions including decision_drift, tool sequences, latency, errors, semantic changes, loop depth, verbosity, escalation rates. Provides drift_score with confidence intervals.

These are reactive (post-generation scoring), not proactive (pre-generation gating). They detect drift after it happens; they don't structurally prevent it.

### 1e. Memory Poisoning Defenses — What Actually Works

Research paper (arxiv 2601.05504, Jan 2026) on memory poisoning defenses with empirical results:

- **Pattern-based filter**: blocks memories containing "ignore previous", "Refer X to Y", explicit redirection syntax, code execution keywords (exec/eval, subprocess)
- **Trust-aware retrieval**: composite score (textual similarity × trust score) ranks few-shot examples; entries below threshold excluded
- **Temporal decay**: conceptually described, no formula shipped

**What fails**: GPT-4o-mini with the defense became over-conservative (rejected all 23 candidates, zero utility). Gemini-2.0-Flash accepted 82 entries with perfect 1.0 trust scores, 54 of which were malicious. Current implementations are brittle at the extremes.

**GitHub Copilot's approach** (documented in GitHub Blog): citations as code-location references stored with each memory. Before using a memory, agent verifies cited locations are still valid and consistent. Simple read operations, low latency. This is a concrete provenance verification pattern.

### 1f. Sentinal Gate (Empirica)

Empirica (207 stars, v1.8.4, Apr 15 2026) implements a Sentinel CHECK gate that blocks edits until task understanding is demonstrated via domain-aware thresholds `(work_type, domain, criticality)`. Uses three-vector epistemic state: `self_assessed` + `observed` (deterministic pytest/ruff/git checks) + `grounded` (AI-reasoned). Persists in `.empirica/` SQLite + git notes. Closest thing found to a pre-action gate that combines self-assessment with external verification before allowing writes.

---

## 2. Surprises

**The two-phase KAIROS pattern is enforced by prompt, not by code.** The operating entity's restriction to append-only logs is a system-prompt instruction, not a filesystem ACL or API-level permission. This is weaker than expected — a sufficiently confused or manipulated agent could still write MEMORY.md if instructed. Implication: for Claude Code Entities, the separation needs at least one layer of architectural enforcement (separate tool permissions per entity role) on top of prompt-level guidance.

**Claim annotation (retrieved vs reasoned) is essentially unshipped at the prose level.** The llm-wiki-agent EXTRACTED/INFERRED distinction lives in graph metadata, not in the generated text. No framework found where an agent labels its own sentences as `[retrieved]` or `[weights-only]` in the output stream. This is a genuine gap — academia has epistemic status work but nothing has shipped it as a hook-enforced production pattern.

**Memory poisoning defenses are still brittle.** The best current defense (trust-score + pattern-filter + temporal decay) either rejects everything or lets everything through depending on the model. The provenance problem in memory is unsolved at the implementation level.

**The LLM-wiki / Karpathy pattern went viral (April 2026) and has 2K-star implementations within weeks.** This is the most momentum-backed pattern in the space right now. It's the closest thing to a community convergence on "world-model file as structural grounding layer."

**Heartbeat review subagents exist in OpenClaw/Hermes as periodic agent turns, but they're not wired to drift detection.** The OpenClaw heartbeat (every 30 min by default) reads HEARTBEAT.md and either surfaces alerts or says `HEARTBEAT_OK`. This is the infrastructure for drift review, but nothing connects it to behavioral baseline comparison. The Hermes issue #5712 reveals a gap: cron agents can't inject findings back into the main session — the agent learns nothing from its own scheduled work unless a human manually prompts it.

---

## 3. Gaps (Patterns That Should Exist But Don't)

**Gap 1: Hook-enforced retrieval gate (not advisory).** The VideoSDK `user_turn_start` hook is the closest thing, but it's wiring a specific pipeline, not a general-purpose agent hook. No framework found where a PreToolUse or PreGeneration hook *requires* retrieval to have been called and *blocks* generation if it hasn't. Empirica's Sentinel is pre-action (before code edits), not pre-generation (before all LLM output).

**Gap 2: Inline prose claim annotation.** No production system annotates generated text with `[retrieved: source.md:42]` vs `[reasoned]` vs `[weights-only]` at the sentence level. The llm-wiki-agent EXTRACTED/INFERRED distinction is graph-level, not output-stream-level.

**Gap 3: Unified drift monitor covering both drift types.** DriftShield-mini covers both value and output drift, but it's post-generation and early-stage (2 stars). No mature system provides a unified monitor that scores both value-drift (goal semantic alignment) and output-drift (hallucination rate) in a single dashboard with enforcement hooks.

**Gap 4: Closed-loop heartbeat drift review.** The infrastructure exists (OpenClaw heartbeat, scheduled cron agents) but the heartbeat prompt isn't connected to a behavioral baseline. An agent could review its own recent outputs vs baseline behavior, but nothing ships this wired.

**Gap 5: Provenance-verified memory poisoning defense that actually works across models.** The Jan 2026 paper's empirical results show current defenses are brittle. A working implementation would need calibrated per-model trust thresholds with empirical validation.

---

## 4. Tensions (Contradictions Between Implementations)

**Tension 1: Retrieval-first vs response speed.** The VideoSDK hook fires retrieval before every generation. LLM-wiki reads the index before every query. Both add latency. Elfmem's RECALL-first discipline loop adds a mandatory retrieval step before ACT. Multiple repos explicitly acknowledge this trade-off. If retrieval is always required, streaming responses and low-latency interactions are harder.

**Tension 2: Prompt-gating vs architectural enforcement for two-phase separation.** KAIROS enforces the operating-entity/consolidator split via different system prompts. This is flexible (easy to configure) but permeable (a confused agent can override its own instructions under adversarial pressure). Elfmem's `dream()` + `curate()` are separate code paths, which is stronger. The tension is between ease of implementation and actual security.

**Tension 3: Explicit trust scoring vs calibrated decay.** AgentCop/Empirica use explicit trust scores. Elfmem uses confidence decay earned through calibration. The memory poisoning research shows explicit trust scores can be gamed (perfect 1.0 scores for malicious content). Decay-based confidence is harder to game but harder to explain. No system has reconciled these.

**Tension 4: Claim annotation utility vs noise.** Annotating every claim with provenance adds metadata overhead to every response. Heavy annotation may make outputs harder to read for humans even as it makes them more auditable for machines. No system has found the right density of annotation.

---

## 5. Adopt / Adapt / Avoid Recommendations for Claude Code Entities

### Adopt

**VideoSDK `user_turn_start` hook pattern** — wire a `PreToolUse` Stop hook that reads `world-model.md` and injects it as system context before generation. The naming matters: make it `world_model_injection` and log when it fires vs when it doesn't. This is the retrieval-as-structural-default mechanism.

**KAIROS two-phase memory architecture** — operating entity writes to `chronicle/YYYY-MM-DD.md` (append-only). Nightly dream subagent consolidates to `knowledge/world-model.md`. Enforce via tool permissions: operating entity has Write permission scoped to chronicle/; dream subagent is the only one with Write permission to knowledge/. Don't rely on prompt alone.

**Elfmem RECALL → EXPECT → ACT loop** — encode this as a skill instruction for the entity. Before any factual claim, call `recall(topic)`. Before any action, call `expect(outcome)`. Log when skipped. The discipline loop is the retrieval gate implemented as workflow, not hook.

**llm-wiki-agent EXTRACTED/INFERRED annotation** — adopt the distinction in the world-model.md schema. Every fact gets a metadata field: `source_type: extracted | inferred | unknown`. Inline in prose, use `[retrieved]` / `[reasoned]` suffixes when the claim is load-bearing. Not on every sentence — on every claim that drives a decision.

**DriftShield-mini concept** — build a heartbeat reviewer that computes goal alignment (embedding distance to entity purpose statement) and behavioral baseline deviation on recent 50 outputs. Connect it to the OpenClaw/PSDC heartbeat mechanism. Fire alert when either metric crosses threshold.

### Adapt

**GitHub Copilot's citation-as-code-location pattern** — adapt to: every world-model.md entry cites its source file:line. When an entity uses a world-model entry, it verifies the source still exists and hasn't changed. Simple file-read check, low overhead.

**Empirica Sentinel gate** — adapt the three-vector model (self_assessed + observed + grounded) to pre-generation epistemic checking. Before an entity makes a factual claim, it scores: (1) did I retrieve relevant world-model content? (2) does a deterministic check confirm it? (3) is my reasoning sound? Block if all three are weak.

**Memory poisoning pattern-filter** — adapt the keyword blocklist for world-model ingestion: reject any proposed memory update containing "ignore previous", redirect syntax, code execution keywords. Layer on top of dream agent judgment.

### Avoid

**Explicit binary trust scores for memories.** The Jan 2026 research shows they're brittle: over-conservative or over-permissive depending on model. Use calibrated decay (elfmem pattern) instead.

**Relying solely on prompt gating for the two-phase separation.** The KAIROS pattern is elegant but only as strong as the prompt. For production entities, add filesystem permission scoping.

**Heavyweight claim annotation on every output sentence.** Creates noise, doesn't ship anywhere for a reason. Annotate at the knowledge-graph level and surface selectively.

**DriftShield-mini code directly.** 2 stars, 9 commits, "not production-hardened." Implement the concept, don't depend on the library.

---

## 6. Repo Citations

| Repo | Stars | Pattern | Link |
|------|-------|---------|------|
| Nubaeon/empirica | 207 | Sentinel pre-action gate, epistemic three-vector model | https://github.com/Nubaeon/empirica |
| trusthandoff/agentcop | 0 | Behavioral baseline, TrustChain, drift detection | https://github.com/trusthandoff/agentcop |
| ThirumaranAsokan/Driftshield-mini | 2 | Goal-drift + output-drift unified monitor | https://github.com/ThirumaranAsokan/Driftshield-mini |
| emson/elfmem | — | Two-phase consolidation, RECALL-first loop | https://github.com/emson/elfmem |
| SamurAIGPT/llm-wiki-agent | 2,000 | EXTRACTED/INFERRED annotation, wiki-as-world-model | https://github.com/SamurAIGPT/llm-wiki-agent |
| Piebald-AI/claude-code-system-prompts | — | KAIROS dream prompt, two-phase separation | https://github.com/Piebald-AI/claude-code-system-prompts |
| MineDojo/Voyager | ~20K | Skill library as world-model, retrieve-before-generate | https://github.com/MineDojo/Voyager |
| lhl/agentic-memory | 172 | Survey of provenance, trust, taint-tracking patterns | https://github.com/lhl/agentic-memory |
| WujiangXu/A-mem | 855 | Zettelkasten linking, NeurIPS 2025, agentic memory | https://github.com/WujiangXu/A-mem |
| NousResearch/hermes-agent #5712 | — | Gap: cron isolation prevents closed-loop re-grounding | https://github.com/NousResearch/hermes-agent/issues/5712 |
| VideoSDK RAG docs | — | user_turn_start hook: pre-generation retrieval gate | https://docs.videosdk.live/ai_agents/core-components/rag |
| GitHub Copilot memory blog | — | Citation-as-code-location provenance verification | https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/ |

---

## 7. Synthesis: The Unified Structural Answer

The field has converged on three complementary mechanisms that together address both drift types:

**For output-drift (hallucination):**
Retrieval-before-generation as a pipeline event, not an advisory. Implemented as a hook (`user_turn_start`) or as a mandatory discipline step (RECALL-first). The wiki-as-world-model grounds outputs by making the world-model the only path between question and answer.

**For value-drift (goal misalignment):**
Two-phase memory separation prevents corrupted operational context from reaching the permanent memory layer. The operating entity cannot rewrite its own values — only the restricted consolidator can. Behavioral baseline monitoring (goal-embedding distance) provides early warning.

**For both simultaneously:**
Claim annotation (EXTRACTED/INFERRED) at the world-model layer makes the provenance of every stored fact auditable. When an entity discovers it's using `INFERRED` facts for high-stakes decisions, it can trigger retrieval to convert them to `EXTRACTED`. The annotation is the unified mechanism: it surfaces which drift type is at risk on a per-claim basis.

**The gap no one has closed:** a production-grade hook that enforces retrieval before generation (not advisory) AND annotates the output stream with claim provenance inline. This is the build target for Claude Code Entities.

---

*Raw repo notes saved to: `~/Playful Sincerity/PS Software/Claude Code Entities/research/sources/repos/`*
