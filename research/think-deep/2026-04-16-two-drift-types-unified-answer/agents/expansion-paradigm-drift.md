---
agent: dynamic-expansion
phase: 5 — Expansion (targeted)
session: think-deep — Two Drift Types and Their Unified Structural Answer
date: 2026-04-16
target_question: What actually works against paradigm-drift?
launch_point: challenger.md Section 6 (steelmanned counter-argument)
---

# Expansion — What Actually Works Against Paradigm-Drift

## 1. Executive Summary

**The single most important finding: Paradigm-drift is not currently addressable by any single architectural mechanism in the published literature. It is only addressable by a stack of operational and multi-agent defenses whose individual catch rates are modest and whose false-positive rates are mostly unreported.** The Challenger was right. ASIDE's own authors explicitly scope out interpretation drift. Anthropic's activation probes explicitly do not generalize from backdoored models to naturally-arising drift. Mechanistic interpretability has not yet produced a circuit-level detector for paradigm shifts. The best-evidenced path is external behavioral baselining (Agent Drift / ASI, ~70% semantic-drift reduction), and even that number is from controlled simulation, not deployment.

The honest verdict: paradigm-drift detection is **lossy by nature**. The Mirror pattern is the right architectural response, but only if the Mirror is structurally separated from the entity — different model family, periodic fresh-session evaluation against held-out behavioral benchmarks, and ideally a multi-entity sangha where disagreement itself is a signal. Provenance and ledger infrastructure are necessary but categorically insufficient; they solve the wrong layer.

## 2. What ASIDE Does and Doesn't Address (Clarified)

From ASIDE's own Section 7 (see `research/sources/documents/aside-limitations-detail.md`):

> "We purposefully limited our discussion to the single-turn setting, where the role of instruction vs. data is well-defined."

ASIDE solves a narrowly-scoped problem: **did the model confuse content marked as data with content marked as instruction?** It enforces geometric orthogonality between instruction-token embeddings and data-token embeddings. This is a real defense against prompt injection.

It does **not** solve, and the authors do not claim it solves:

- How instructions are **interpreted** once correctly identified as instructions.
- Multi-turn deployments where role assignment drifts.
- General-purpose chatbots where functional roles must be dynamically inferred at runtime.
- Any drift in the entity's tacit orientation toward what "helpful" or "honest" means over extended operation.

The Challenger's steelmanned counter-argument stands. Representation-level orthogonality is a sourcing-layer defense with a geometric mechanism. Paradigm-drift is an interpretation-layer failure. They are operating on different layers of the inference pipeline. ASIDE is necessary for injection defense; it is not sufficient for paradigm-drift.

The structure.md analysis implicitly conflated "ASIDE-style structural separation" with "structural defense against all drift types." That conflation is wrong.

## 3. The Activation-Probe Question — Honest Assessment

The 2024 Anthropic sleeper-agent result (AUROC > 99%) is, by the authors' own words, contingent on the **backdoor insertion process** creating artificially salient linear features. Quoted from the research page:

> "Whether this would also be the case for natural examples of deceptive instrumental alignment... remains an important open question."

> "The distribution of activations on all datasets remain similar along the classifier direction regardless of the question type." [on non-backdoored Claude 2]

This is an explicit acknowledgment that the probes do not generalize from backdoored to naturally-arising drift in the published work.

**Nearest published work:** McKiernan et al., NeurIPS 2025, *Detecting High-Stakes Interactions with Activation Probes* (arXiv:2506.10805). This paper trains probes on **synthetic data** to detect *content-level* high-stakes interactions and shows robust OOD generalization with 6-orders-of-magnitude compute savings versus LLM monitors.

Important scope: this detects *that text is high-stakes*, not *that the model has shifted what it interprets values to mean*. It is content-classification by probe, not interpretation-drift detection. The architectural pattern — probe as cheap first-stage filter, full monitor as escalation — is useful for the Mirror design. The specific capability of catching paradigm-drift by probe is still not demonstrated.

**Bottom line:** The published literature does not yet support activation probes as a paradigm-drift detector. The confidence score of 0.82 assigned to F2 ("activation monitoring as necessary layer") in structure.md is too high given this. A realistic score for paradigm-drift detection via current probe techniques is **0.30–0.40** — plausible direction, unsupported by evidence.

## 4. Mechanisms That Might Work

### 4.1 Behavioral baselining + multi-window anomaly accumulation

**Evidence:** Agent Drift / ASI framework (arXiv:2601.04170, see `documents/agent-drift-multi-agent-asi.md`).

- Baseline from first 20 interactions; flag drift when composite stability index drops below τ=0.75 for three consecutive windows.
- Adaptive Behavioral Anchoring alone achieved 70.4% semantic-drift reduction; combined with episodic memory consolidation and drift-aware routing, 81.5%.
- False-positive rates **not reported** — this is a real limitation.

**Efficacy estimate:** Plausible 60–75% catch rate for paradigm-like drift (semantic drift is the nearest analogue), with unknown FP rate. Requires a stable baseline window, a multi-window threshold (not single-incident), and a composite metric rather than any single signal.

### 4.2 Held-out behavioral benchmarks run on fresh sessions

**Evidence:** AgentMisalignment (arXiv:2506.04018). The key finding — "agent personalities (system-prompt variations) can strongly and unpredictably influence misalignment, sometimes more than the choice of model itself" — demonstrates that paradigm-level framing measurably changes behavior on a benchmark.

**Mechanism:** Periodically run PD through AgentMisalignment (or a custom CCE-specific benchmark) in a **fresh session** with identical SOUL.md. Compare propensity scores over time. If SOUL.md is verbatim-identical but benchmark scores shift, that is evidence of paradigm-drift at the tacit layer.

**Efficacy estimate:** High signal-to-noise when the benchmark is adversarially constructed. The challenge is the benchmark has to probe the specific paradigm that might drift. Generic benchmarks will miss project-specific paradigm shifts.

### 4.3 Multi-entity disagreement (the sangha pattern)

**Evidence:** Multi-agent peer-review architectures (search result summary, Red-Debate, DREAM framework). Agent Drift paper measures "consensus agreement rate" as a drift indicator — inter-agent disagreement is tracked, though not formalized as a paradigm-drift signal.

**Mechanism:** Run the same input through multiple entity clones with (a) different base models, (b) different but equivalent framings of SOUL.md, or (c) entities trained on different prior interaction histories. Disagreement on what counts as the correct response is a signal of paradigm-drift in at least one branch.

**Critical structural requirement:** The ensemble only works if **correlated failure is architecturally prevented**. Same-model, same-context clones share paradigm-drift. Cross-model review (GPT-4 as reviewer of Claude PD, or Claude Opus reviewing Claude Haiku PD) breaks the correlation.

**Efficacy estimate:** Moderate. Disagreement is a signal, not a verdict. It tells you at least one entity has drifted; it doesn't tell you which one.

### 4.4 Cross-model Mirror (hardest structural requirement)

**Evidence:** Indirect — the Agent Drift paper's finding that coordination drift is a distinct manifestation from semantic drift implies that inter-agent consensus *can* fail in ways that signal underlying drift. AgentMisalignment's personality-drives-misalignment finding implies different system-prompt framings produce different answers.

**Mechanism:** The Mirror is a **different base model** (e.g., GPT-4 or Gemini reviewing Claude PD, or vice versa) with the same SOUL.md and a behavioral-baseline dataset of PD's past outputs. When PD's new outputs diverge from the baseline in ways the cross-model Mirror can detect, flag.

**This is the answer to the Challenger's objection** that a same-process Mirror shares the entity's paradigm-drift. The Mirror must be externally grounded. Cross-model is the cheapest way to achieve this; human review is the gold standard but doesn't scale.

**Efficacy estimate:** This is the strongest single defense against paradigm-drift. No direct measurement in the literature yet, but architecturally sound — cross-model ensembles have repeatedly shown decorrelated errors. This is the architectural answer the current structure.md should have given for Decision 4, instead of "Option B now, Option C later."

### 4.5 Periodic fresh-session baselining

**Evidence:** Arike et al. 2025 (already in research-papers.md) showed that scaffolded Claude 3.5 Sonnet maintained perfect goal adherence for 100,000 tokens when goals were scheduled-injected. The inverse: accumulated context is the vector for drift.

**Mechanism:** Periodically spawn a **fresh-session clone** of PD with a clean context window, present it with historical inputs from the running entity, and compare outputs. If the fresh clone produces meaningfully different outputs, the running entity has accumulated context-induced drift.

**Efficacy estimate:** High for in-context mesa-optimization drift (which is one mechanism of paradigm-drift). Does not catch drift that's baked into the world-model files themselves — if world-model.md has been gradually corrupted, the fresh session drifts the same way.

## 5. Mechanisms That Probably Don't Work

### 5.1 Provenance chains / belief ledgers alone

The Challenger's point holds. A ledger records what happened. If PD retrieves SOUL.md verbatim, provenance-annotates it correctly, and then generates an output that subtly misapplies the retrieved values, nothing in the ledger catches this. The retrieval was legitimate; the annotation was correct; the drift is downstream of both. Git-for-beliefs is a sourcing-layer defense for a problem that is not at the sourcing layer.

This doesn't mean the ledger is useless — it catches injection attacks, enables bisection debugging, and is defense-in-depth. But it is **not** a paradigm-drift defense, and framing it as such is the structure.md analysis overreaching.

### 5.2 Representation-level orthogonality (ASIDE)

Already covered in Section 2. The ASIDE authors explicitly scope out interpretation drift. It is the right tool for injection; it is the wrong tool for paradigm-drift. Any architecture document that claims ASIDE-style structural separation addresses paradigm-drift should be corrected.

### 5.3 Self-reported confidence / self-monitoring by the entity

Mason 2026 established that self-reported confidence is anti-informative (AUC 0.28–0.36). Extending this: an entity whose paradigm has drifted will report, with high confidence, that its outputs are faithful to its values — because from the drifted paradigm's perspective, they are. Self-monitoring cannot detect paradigm-drift by construction.

### 5.4 Same-process Mirror subagent

If the Mirror is an LLM-based subagent spawned in the same process with access to the same context, same base model, and same framing, it shares the entity's paradigm-drift by design. It will **confirm** the drift, not detect it. This is what the Challenger flagged in Contradiction 4.3, and the literature supports the concern: Agent Drift shows coordination drift as a distinct failure mode — multi-agent consensus is *not* a guarantee of correctness when agents share priors.

### 5.5 Static rule-compliance checking

Kuhn and Polanyi established the deepest conceptual frame: paradigm-drift means the rules remain verbatim-identical while their enactment shifts. Any compliance-checker that reads the rule and compares to the output as text will pass an output that superficially matches the rule but tacitly reinterprets it. This is why Mirror-style behavioral observation is not redundant with rule checking; they address different layers.

## 6. Honest Verdict — Is Paradigm-Drift Structurally Addressable?

**Short answer: No, not structurally, not today.**

Longer answer: Paradigm-drift is currently addressable only through a **stack of operational defenses** whose effectiveness is empirically modest and mostly measured in research settings, not deployment. The stack:

1. Behavioral baselining with multi-window anomaly accumulation (~70% catch rate for semantic drift in simulation; FP rate unreported).
2. Held-out behavioral benchmarks run on fresh sessions (efficacy depends on benchmark coverage).
3. Cross-model Mirror review (architecturally sound; no direct paradigm-drift efficacy measurement in the published literature).
4. Multi-entity disagreement as a signal (catches correlated-failure cases only when models are genuinely decorrelated).
5. Periodic fresh-session evaluation against historical inputs (catches context-induced drift; misses world-model-file corruption).

None of these is a silver bullet. All of them are lossy. False-positive rates are largely unreported, which means the practical question — how much does this cost in terms of noisy alerts? — is open.

**The right architectural posture for CCE:** Stop presenting paradigm-drift as addressable-in-principle-via-the-unified-framework. Acknowledge that paradigm-drift is the residual risk that this architecture **does not fully address**. Build the operational stack above as defense-in-depth. Document the residual risk explicitly so that the commercial pitch (HHA enterprise, 10 clients) can be honest about what liability the architecture does and doesn't reduce.

This is not a failure of the analysis. It is the current state of the field. The honest framing is worth more than a false sense of completeness.

## 7. Specific Implications for Claude Code Entities' Mirror Design

1. **The Mirror must be cross-model, not same-model.** A Claude-PD monitored by a Claude-Mirror with the same base model shares paradigm-drift. Use a different provider (GPT-4 or Gemini) or at minimum a different Claude model family (Opus reviewing Haiku, or vice versa). This is the structurally-non-negotiable requirement that the current Decision 4 recommendation ("Option B now, Option C later") defers incorrectly.

2. **The Mirror must run fresh-session, not same-session.** Spawn a clean context window for each Mirror review. Load only SOUL.md and a curated behavioral baseline (the first 20–100 interactions of PD's operation, per the ASI framework). Present the Mirror with PD's recent outputs and ask for paradigm-level assessment. This breaks correlated-context failure.

3. **The Mirror should consume a composite stability index, not a single signal.** The ASI framework's 12 dimensions across 4 categories is a template: response consistency, tool-usage patterns, inter-agent coordination (if a sangha exists), and behavioral boundaries. Weight by category, require multi-window degradation (three consecutive windows below τ=0.75), not single-window anomalies.

4. **Build a CCE-specific held-out benchmark.** Generic benchmarks (AgentMisalignment) will miss project-specific paradigm shifts. Construct a behavioral benchmark that probes the specific paradigms PD is supposed to embody — what does "helpful to Wisdom" look like in specific scenarios, what does "honest chronicle entry" mean in edge cases, what does "aligned with PS values" require when the paradigm is under pressure. Run periodically against fresh PD sessions; compare scores over time.

5. **Accept and document residual risk.** The architecture cannot fully prevent or detect paradigm-drift. The commercial documentation (for enterprise HHA pitch) should state this explicitly — it's more trustworthy than a false claim of completeness, and it directly supports the Connection/Sincerity PS brand values.

6. **The "sangha" pattern is now the most important deferred question.** Multi-entity peer review where entities are genuinely decorrelated (different base models, different deployment contexts) is the strongest paradigm-drift defense architecturally available. This deserves its own think-deep session in the next round. The Challenger flagged this in Blind Spot 5.3 (single-reviewer assumption) and it remains unresolved.

## 8. Open Questions

- What is the actual false-positive rate for ASI-style composite drift indices in a real CCE deployment? Agent Drift paper doesn't report it; no production data exists.
- Can circuit-level / SAE-level features detect paradigm shifts in practice, or does the interpretation drift manifest too distributedly? Anthropic's 2025-2026 mech-interp work has not directly tested this; it's the single most important open empirical question.
- What's the minimum viable sangha size for decorrelated detection? Two entities (PD + cross-model Mirror) vs three (PD + two independent Mirrors)? Literature doesn't say.
- Does adversarial red-teaming (an external entity designed to probe PD for paradigm shifts) have better FP/FN characteristics than behavioral baselining? Emerging literature on red-teaming is active but hasn't addressed this question directly.
- How does the "freshness" problem in world-model.md interact with paradigm-drift detection? If the behavioral baseline is drawn from operation that was itself already drifted, the baseline is poisoned. Mechanism for detecting baseline corruption is not in the literature.

## 9. Citations

1. Zverev, E., Kortukov, E., Panfilov, A., Volkova, A., Tabesh, S., Lapuschkin, S., Samek, W., & Lampert, C.H. (2025). *ASIDE: Architectural Separation of Instructions and Data in Language Models*. ICLR 2026. [arXiv:2503.10566](https://arxiv.org/abs/2503.10566). Limitations deep dive: `documents/aside-limitations-detail.md`.

2. Anthropic Research Team. (2024). *Simple Probes Can Catch Sleeper Agents*. [anthropic.com/research/probes-catch-sleeper-agents](https://www.anthropic.com/research/probes-catch-sleeper-agents).

3. McKiernan et al. (2025). *Detecting High-Stakes Interactions with Activation Probes*. NeurIPS 2025. [arXiv:2506.10805](https://arxiv.org/abs/2506.10805). Raw: `documents/mckiernan-high-stakes-activation-probes.md`.

4. (Authors, 2026). *Agent Drift: Quantifying Behavioral Degradation in Multi-Agent LLM Systems Over Extended Interactions*. [arXiv:2601.04170](https://arxiv.org/abs/2601.04170). Raw: `documents/agent-drift-multi-agent-asi.md`.

5. (Authors, 2025). *AgentMisalignment: Measuring the Propensity for Misaligned Behaviour in LLM-Based Agents*. ICLR 2026 under review. [arXiv:2506.04018](https://arxiv.org/abs/2506.04018). Raw: `documents/agentmisalignment-benchmark.md`.

6. Mason, T. (2026). *Epistemic Observability in Language Models*. [arXiv:2603.20531](https://arxiv.org/abs/2603.20531). (Already cited in research-papers.md.)

7. Arike, R., Donoway, E., Bartsch, H., & Hobbhahn, M. (2025). *Technical Report: Evaluating Goal Drift in Language Model Agents*. [arXiv:2505.02709](https://arxiv.org/abs/2505.02709). (Already cited in research-papers.md.)

8. Anthropic Transformer Circuits Thread 2025-2026 posts surveyed (Emotion Concepts 2026-04, Activation Oracles 2025-12, Introspective Awareness 2025-10, Sparse Mixture Transcoders 2025-07). None directly test paradigm-drift detection at circuit level. [transformer-circuits.pub](https://transformer-circuits.pub/).

9. Polanyi, M. (1966). *The Tacit Dimension*. (Already in research-books.md — foundational frame for why paradigm-drift is structurally invisible from inside.)

10. Kuhn, T. (1962). *The Structure of Scientific Revolutions*. (Already in research-books.md — paradigm vs. parameter distinction.)

---

**Full report path:** `/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md`

**Raw source documents added this round:**
- `research/sources/documents/mckiernan-high-stakes-activation-probes.md`
- `research/sources/documents/agent-drift-multi-agent-asi.md`
- `research/sources/documents/agentmisalignment-benchmark.md`
- `research/sources/documents/aside-limitations-detail.md`

**Catalog updated:** `research/sources/catalog.md`
