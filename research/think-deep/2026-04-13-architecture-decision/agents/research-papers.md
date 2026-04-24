# Academic Papers Stream — PS Bot Architecture Decision
**Think Deep Session: 2026-04-13**
**Question: Which foundation should PS Bot build on? Hermes Agent vs Claude Agent SDK vs OpenClaw vs Custom Build**
**Stream: Academic Papers — cross-modal memory, confidence-modulated speech, agent learning loops**

---

## 1. Cross-Modal Memory Continuity

### State of the Art

The field has moved aggressively toward multimodal memory in 2025-2026, but **voice + text sharing a single memory store for a personal assistant remains substantially uncharted territory**.

**M3-Agent** (arxiv.org/abs/2508.09736, ByteDance, Aug 2025) is the closest academic system. It uses an entity-centric memory structure where memories are indexed by entity rather than by modality — meaning a "face" and a "voice" belonging to the same person can be linked in the same memory node. Its tri-path hybrid retrieval (dense text embeddings + BM25 sparse + cross-modal image embeddings fused via Reciprocal Rank Fusion) handles text/image. Voice is not included, but the entity-centric architecture is exactly the right abstraction for PS Bot's cross-modal goal.

**M2A** (arxiv.org/html/2602.07624) introduces a dual-layer architecture: raw message store (append-only, chronological) plus a semantic memory store with high-level knowledge. Text and images are unified via tri-path retrieval. Again, no voice, but the two-layer design (raw logs + structured semantics) maps cleanly onto what PS Bot needs: raw transcript store + compressed semantic store, modality-agnostic.

**Memoria** (arxiv.org/abs/2512.12686) uses a weighted knowledge graph for user modeling across sessions. Its innovation is interpretability — user facts are explicit entities and relationships rather than opaque vectors. For PS Bot, this matters: a knowledge graph lets voice and text interactions write to the same user model transparently.

**MemVerse** (arxiv.org/html/2512.03627v1) explicitly frames multimodal memory for lifelong learning agents and converts different modalities into aligned representations before storage. The alignment step — converting modality-specific features into a shared space — is the key architectural primitive PS Bot needs.

**Memory fabric** (Springer Nature, 2026) tackles shared and persistent multiuser memory for conversational AI agents. Its contribution is treating memory as infrastructure rather than a feature — a "fabric" that multiple agents and users write to and read from. Architecturally relevant for PS Bot's eventual multi-device / multi-context use case.

**Contextual Memory Intelligence** (arxiv.org/html/2506.05370v1) introduces a paradigm of reflective memory with explicit support for multi-modal inputs, cross-session continuity, and dynamic forgetting.

### Novelty Assessment for PS Bot

The innovation PS Bot aims for — voice and text interactions both writing to and reading from a single persistent memory store, with the agent's responses in either modality drawing on the same context — **is not present in any surveyed production system**. The closest analogs are M3-Agent (entity-centric, no voice) and MemVerse (modality alignment, research stage). The architectural primitives exist; the combination for voice+text personal assistant has not been assembled.

**PS Bot's cross-modal memory is genuinely novel at the product level.** Academically, it synthesizes entity-centric memory (M3-Agent), knowledge graph user modeling (Memoria), and modality alignment (MemVerse). No prior work unifies all three for a voice+text personal assistant with cross-session persistence.

### Key Gap

None of the surveyed systems handle voice-to-text normalization for memory storage: when a user speaks, what form does that memory take? Raw transcript? Semantic summary? The Associative Memory architecture (graph-based, LLM as engine) is better-positioned than any academic system found — it can receive both voice transcripts and text messages as inputs to the same graph update mechanism.

---

## 2. Confidence-Modulated Speech Synthesis

### Psycholinguistic Foundation

Research on prosodic uncertainty markers provides a validated empirical basis for PS Bot's confidence-prosody mapping.

**PMC study on uncertainty prosody** (PMC11513626, 2024) using articulatory synthesis isolated three primary acoustic parameters that reliably communicate uncertainty:
- **Silent pauses** (1-4 seconds before response): strongest marker of strong uncertainty
- **Hesitation particles** ("uh", "um"): moderate uncertainty signal
- **Intonation rise**: 8 semitones for moderate uncertainty, 13 semitones for strong uncertainty; falling intonation signals certainty

Crucially: these markers are **additive** — combining pause + hesitation + rising intonation produces stronger perceived uncertainty than any single cue. This directly validates PS Bot's multi-parameter confidence mapping: don't just slow speech rate, combine markers.

**Voicing Uncertainty** (arxiv.org/abs/2408.08438, IEEE VIS 2024) found that speech-forward uncertainty presentations lead to more risky decisions by listeners. Counterintuitively, higher pitch increased decision confidence by ~4%. This creates a design tension for PS Bot: the system should signal its own uncertainty authentically, but the acoustic markers that communicate uncertainty may alter user decision-making in ways that need to be intentional.

### The Calibration Problem

**Anthropomimetic Uncertainty** (arxiv.org/html/2507.10587v1) is the most significant finding for PS Bot's confidence architecture. It identifies a deep problem: LLMs produce systematically uncalibrated verbalized uncertainty due to:
1. Pretraining data skew (number distributions)
2. Instruction-finetuning that rewards confident language
3. RLHF penalizing hedging as "unhelpful"

This means that if PS Bot simply asks Claude "how confident are you?" and uses that to modulate prosody, the confidence signal will be miscalibrated. The paper recommends building uncertainty expression on actual epistemic evidence rather than self-reported confidence scores.

**Implication for PS Bot**: The confidence-prosody pipeline should route through a separate calibration layer — comparing Claude's stated confidence against verifiable signals (retrieval quality, source recency, contradictions in memory graph) — rather than using raw confidence from the LLM output.

### TTS Systems for Prosody Control

**NVSpeech** (arxiv.org/html/2508.04195v1) builds the most complete system for paralinguistic vocalization synthesis — 18 categories including physiological sounds and discourse markers, treated as first-class decoding targets. It enables explicit token-level control: insert `[Uhm]` at any word position. This is directly usable: PS Bot can generate a confidence score, map it to paralinguistic tokens, and inject them into the TTS stream.

**NVSpeech is the clearest path to implementing confidence-modulated prosody** without requiring a full custom TTS system. The Chatterbox Turbo + NVSpeech combination deserves evaluation.

**Controllable TTS survey** (arxiv.org/html/2412.06602v1) confirms that VAE-based disentangled latent representations are the standard for prosody style transfer. This is relevant if PS Bot needs fine-grained continuous control rather than discrete paralinguistic tokens.

---

## 3. Agent Self-Improvement / Learning Loops

### GEPA — The Most Relevant Architecture

**GEPA: Reflective Prompt Evolution** (arxiv.org/abs/2507.19457, ICLR 2026 Oral) is both the academic foundation and the practical implementation path for Hermes Agent's self-evolution system.

Core algorithm:
1. Execute agent on minibatch, collect full execution traces (reasoning chains, tool calls, intermediate outputs)
2. LLM reflects on traces in natural language: diagnose failures, assign credit, propose prompt updates
3. Mutate current prompt candidate based on reflection
4. Maintain Pareto frontier of non-dominated candidates (top performance on at least one training instance)
5. Validate on larger dataset before adding to candidate pool

Key results: outperforms GRPO (RL) by up to 20% while using 35× fewer rollouts. Generates prompts 9.2× shorter than MIPROv2 with better performance.

**For PS Bot's architecture decision**: GEPA is available via DSPy (`dspy.GEPA`). Any framework that supports DSPy integration can use GEPA. This is not a Hermes-exclusive advantage — it's an open, well-documented approach available to custom builds too.

**ARIA: Self-Improving Agents at Test Time** (arxiv.org/abs/2507.17131) adds human-in-the-loop guidance to the self-improvement loop. Relevant for PS Bot's companion dynamics: the agent assesses its own uncertainty through structured self-dialogue and proactively identifies knowledge gaps. This maps to the "earned conviction" philosophy in The Companion design.

**Survey: Self-Evolving Agents** (arxiv.org/html/2507.21046v4) maps the trajectory from agents modifying prompts (GEPA) to agents modifying their own training data to agents directly updating parameters. PS Bot sits at the prompt-evolution tier — attainable now without fine-tuning infrastructure.

**Agent Skills paper** (arxiv.org/html/2602.12430v3) surveys the full landscape of skill acquisition architectures for LLM agents. Key finding: skill synthesis from execution traces (what GEPA does) is more sample-efficient than reward-based learning for skill acquisition in low-data settings, which describes PS Bot's environment (one user, accumulating slowly over time).

---

## 4. Proactive Conversational Agents

### Inner Thoughts — Strongest Academic Finding

**Proactive Conversational Agents with Inner Thoughts** (arxiv.org/abs/2501.00383, CHI 2025) is directly applicable to PS Bot's initiative-taking feature.

The framework's five-stage architecture:
1. **Trigger**: new message or pause >10 seconds
2. **Retrieval**: semantic similarity + temporal decay activates relevant memories
3. **Thought Formation**: dual-process model (System 1 fast / System 2 deliberate)
4. **Evaluation**: intrinsic motivation score from 8 heuristics (relevance, information gaps, urgency, impact, coherence, originality, balance, conversational dynamics)
5. **Participation**: three-tier decision (self-selection turns, allocated turns, interrupt threshold)

Results: 82% user preference over baseline, significant improvements in turn appropriateness (p=2.4×10⁻⁶) and coherence (p=1.6×10⁻⁵).

The **motivation scoring system** is PS Bot's roadmap for when to speak. The 8-heuristic LLM chain-of-thought evaluator maps directly onto PSSO's "Content Inaction" principle: the agent only speaks when motivation score exceeds threshold, defaulting to silence.

**Towards Human-centered Proactive Conversational Agents** (arxiv.org/abs/2404.12670, SIGIR 2024) adds a taxonomy: Intelligence (anticipate + plan), Adaptivity (learn user patterns), Civility (ethical + social norms). PS Bot needs all three tiers. The Civility dimension is underemphasized in most technical systems but critical for a companion that lives alongside someone.

### Content Inaction — Design Validation

Across multiple papers, the principle that agents should default to silence and require positive motivation to speak is consistently validated. The Inner Thoughts paper's finding that participants could distinguish "non-stop chatter" (69% accuracy) from "active" (50%) suggests that calibrating the motivation threshold is the key design parameter — lower threshold → more proactive, higher threshold → more selective. This is a tunable system parameter, not an architectural constraint.

---

## 5. Persistent Agent Architecture

### Long-Running State Management

**Sophia / Persistent Agent Framework** (referenced in search results) establishes that "artificial life" persistence requires explicit separation of behavioral state, knowledge state, and conversational state. This three-way separation is architecturally sound for PS Bot.

**OpenDev terminal agent** (arxiv.org/html/2603.05344v1) uses four persistent stores: Config Manager, Session Manager (JSON conversation histories), Provider Cache, and operation log. It applies five-stage progressive compaction as context grows. The progressive compaction approach is directly applicable to PS Bot's long-running voice sessions.

**Persistent Memory and User Profiles** (arxiv.org/abs/2510.07925) validates that the combination of persistent memory + dynamic user profiles + self-validation is the right architecture for personalized long-term agents. The paper uses multi-agent collaboration for cross-source retrieval.

**Improving Coherence and Persistence in Agentic AI** (arxiv.org/html/2603.21321) directly addresses context coherence during long-horizon tasks — a PS Bot concern given extended voice sessions.

**Memory for Autonomous LLM Agents survey** (arxiv.org/html/2603.07670v1, 2026) provides the most current taxonomy: in-context working memory, external episodic memory, parametric semantic memory, procedural memory (skills). PS Bot needs at minimum episodic + semantic, with the Associative Memory graph potentially serving both.

### Moshi — Cross-Modal Warning Signal

**Moshi** (arxiv.org/abs/2410.00037, Kyutai 2024) is the most sophisticated unified speech-text model available. Its "inner monologue" (text tokens as prefix to audio tokens) improves speech quality but serves generation quality, not memory. **Critically: Moshi has no cross-session memory**. Each conversation starts fresh. This is the fundamental gap that PS Bot aims to fill — Moshi proves that excellent real-time voice dialogue is solvable; PS Bot's innovation is adding the persistent memory layer on top.

---

## 6. Architecture Decision Implications

### What the Academic Literature Says About Foundation Choice

The papers surveyed do not directly compare Hermes Agent, Claude Agent SDK, or OpenClaw. But they reveal three architectural requirements that should drive the decision:

**Requirement 1 — Memory as Infrastructure**: Every strong paper (M3-Agent, Memoria, MemVerse, Memory Fabric) treats memory as a separate, modular layer, not embedded in the agent loop. The foundation framework should not own the memory layer — PS Bot should.

**Requirement 2 — DSPy-Compatible Self-Improvement**: GEPA (ICLR 2026 Oral) is the validated path for self-improvement via execution traces. It's available via DSPy. The framework that makes DSPy integration easiest wins this dimension.

**Requirement 3 — Prosody Control Pipeline Independence**: The TTS confidence-modulation architecture (NVSpeech tokens, calibration layer, multi-parameter mapping) is independent of the agent framework. The foundation just needs to surface a confidence signal and support pre-TTS processing.

**Implication**: These three requirements favor a **thin, composable foundation** — one that doesn't impose its own memory or TTS architecture. Custom build or Claude Agent SDK (minimal abstractions) over Hermes Agent (has its own memory/evolution opinions) or any framework that owns the execution loop too tightly.

---

## Key Discoveries

1. **Cross-modal memory is genuinely novel** at the product level. No surveyed system unifies voice + text in a single persistent memory store for a personal assistant. The architectural primitives exist (entity-centric indexing, modality alignment, knowledge graphs) but haven't been assembled for this use case.

2. **GEPA is not Hermes-exclusive.** It's open-source via DSPy, ICLR 2026 Oral. Any framework can use it. This neutralizes Hermes's self-improvement differentiator.

3. **Inner Thoughts is the academic template for proactive initiative.** The 8-heuristic motivation scoring system maps directly to PSSO's Content Inaction principle. It's implementable as a module on top of any framework.

4. **Confidence calibration is broken at the LLM level.** RLHF actively penalizes uncertainty expression, so raw LLM confidence scores are miscalibrated. PS Bot needs a separate calibration layer to route through before mapping to prosody.

5. **Prosodic uncertainty markers are validated and implementable.** Pause (1-4s) + hesitation tokens + rising intonation (8-13 semitones) are the empirically validated combination. NVSpeech provides token-level control for inserting these markers.

6. **Moshi has no cross-session memory.** It's the best real-time voice dialogue system but starts fresh each conversation. This is PS Bot's exact opportunity.

---

## Surprises

- **Higher pitch increases listener confidence** (Voicing Uncertainty, 2024) — counterintuitive to the intuition that deeper/slower voice signals certainty. Acoustic perception of confidence is less straightforward than expected.
- **RLHF actively suppresses uncertainty** (Anthropomimetic Uncertainty) — the training pipeline creates systematic overconfidence. A companion designed for "earned conviction" has to fight its own base model's tendency.
- **GEPA generates shorter prompts that outperform longer ones** — self-improvement via reflection produces more concise, effective prompts than Bayesian optimization approaches that add demonstrations.
- **The Inner Thoughts threshold for interruption can distinguish agent personalities** — this is a tunable parameter that maps to PS Bot's character. This is underappreciated as a design surface.

---

## Gaps

- **No paper directly addresses voice + text sharing a memory store.** M3-Agent (entity-centric, no voice), MemVerse (multimodal alignment, research stage), and Moshi (no cross-session memory) each solve part of the problem.
- **No paper on TTS confidence modulation from LLM confidence scores end-to-end.** NVSpeech + paralinguistic tokens is the closest, but the calibration layer between LLM confidence and TTS parameters is unaddressed in literature.
- **Proactive agent research focuses on group/multi-party settings** — Inner Thoughts was designed for multi-party conversation. Adaptation to single-user companion context needs work.
- **No research on agent behavior during extended silence** (user not interacting for hours/days). The Content Inaction design space for a persistent companion is unexplored academically.

---

## Tensions

- **Authenticity vs. calibration**: Users trust voices expressing appropriate uncertainty (PMC study), but RLHF makes LLMs systematically overconfident (Anthropomimetic Uncertainty). Designing the right calibration layer requires choosing: correct for the model's overconfidence, or let the model's natural expression through?
- **Proactivity vs. relevance**: Inner Thoughts found that more proactive agents scored higher on engagement but participants could also more easily detect the "non-stop chatter" mode. The motivation threshold must be tuned — too low and the agent feels pushy, too high and it feels passive.
- **Memory richness vs. latency**: Rich cross-modal memory (full graph traversal, MemVerse alignment) adds latency. Real-time voice response (Moshi's 160ms target) conflicts with comprehensive memory retrieval. PS Bot will need a tiered memory access strategy: fast working memory for in-session context, slower deep memory for background enrichment.

---

## Sources

| Source | Type | Relevance |
|--------|------|-----------|
| [M3-Agent: Seeing, Listening, Remembering, Reasoning](https://arxiv.org/abs/2508.09736) | Paper (Aug 2025) | Entity-centric multimodal memory; cross-modal retrieval architecture |
| [M2A: Multimodal Memory Agent](https://arxiv.org/html/2602.07624) | Paper (Feb 2026) | Dual-layer hybrid memory; tri-path retrieval for voice/text unification |
| [Memoria: Scalable Agentic Memory](https://arxiv.org/abs/2512.12686) | Paper (Dec 2025) | Knowledge graph user modeling; interpretable cross-session persistence |
| [MemVerse: Multimodal Memory for Lifelong Agents](https://arxiv.org/html/2512.03627v1) | Paper (Dec 2025) | Modality alignment layer; model-agnostic memory framework |
| [Memory Fabric for Conversational AI](https://link.springer.com/article/10.1007/s44163-026-00992-z) | Paper (2026) | Shared persistent multiuser/multi-agent memory infrastructure |
| [Proactive Conversational Agents with Inner Thoughts](https://arxiv.org/abs/2501.00383) | Paper, CHI 2025 | 8-heuristic motivation scoring; when-to-speak architecture |
| [Towards Human-centered Proactive Agents](https://arxiv.org/abs/2404.12670) | Paper (2024) | Intelligence/Adaptivity/Civility taxonomy for proactive agents |
| [GEPA: Reflective Prompt Evolution](https://arxiv.org/abs/2507.19457) | Paper, ICLR 2026 Oral | Self-improvement via execution traces; outperforms RL 35× efficiency |
| [ARIA: Self-Improving Agents at Test Time](https://arxiv.org/abs/2507.17131) | Paper (2025) | Human-in-loop self-improvement; self-dialogue for uncertainty detection |
| [Survey: Self-Evolving Agents](https://arxiv.org/html/2507.21046v4) | Survey (2025) | Full taxonomy of self-improvement approaches; trajectory to ASI |
| [Moshi: Speech-Text Foundation Model](https://arxiv.org/abs/2410.00037) | Paper (2024) | Best real-time voice dialogue; no cross-session memory (the gap PS Bot fills) |
| [PMC: Prosodic Cues of Uncertainty](https://pmc.ncbi.nlm.nih.gov/articles/PMC11513626/) | Study (2024) | Validated acoustic parameters: pause + hesitation + rising intonation |
| [Voicing Uncertainty: Speech vs. Text](https://arxiv.org/abs/2408.08438) | Paper, IEEE VIS 2024 | Higher pitch → more listener confidence; speech promotes riskier decisions |
| [Anthropomimetic Uncertainty](https://arxiv.org/html/2507.10587v1) | Paper (2025) | RLHF suppresses uncertainty; calibration layer required for authentic expression |
| [NVSpeech: Paralinguistic Vocalization Pipeline](https://arxiv.org/html/2508.04195v1) | Paper (2025) | Token-level control for hesitations and discourse markers in TTS |
| [Persistent Memory and User Profiles](https://arxiv.org/abs/2510.07925) | Paper (2025) | Multi-agent collaboration for personalized long-term persistence |
| [OpenDev Terminal Agent](https://arxiv.org/html/2603.05344v1) | Paper (2026) | Progressive compaction strategy for long-running conversational agents |
| [Memory for Autonomous LLM Agents Survey](https://arxiv.org/html/2603.07670v1) | Survey (2026) | Current taxonomy: in-context / episodic / semantic / procedural memory types |
| [Contextual Memory Intelligence](https://arxiv.org/html/2506.05370v1) | Paper (2025) | Reflective memory paradigm; cross-modal + cross-session continuity |

---

*Research completed: 2026-04-13 | Stream: Academic Papers | Session: Think Deep — PS Bot Architecture Decision*
