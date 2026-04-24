# Think Deep: The Two Drift Types and Their Unified Structural Answer

*Generated 2026-04-16 | Phases: Frame, Research (5 streams), Play (3 sub-agents + synthesis), Structure, Challenger, Expansion, Synthesis | Depth: Deep*

---

## The Short Answer

The framing of "two drift types with one unified answer" is too tidy. The research found **three** drift types — output-drift, value-drift, and paradigm-drift — and they do not share a single mechanism. Output-drift and injection attacks are structurally addressable today (retrieval-first gates, provenance metadata, scheduled re-injection, the enforcement spectrum). Paradigm-drift — the entity's tacit reorientation of what values *mean* while the rules remain verbatim-identical — is **not** architecturally solved, not in the literature, not in production. The most defensible posture is to build the tractable defenses rigorously, name paradigm-drift as residual risk, and commit to a cross-model, fresh-session Mirror as the best partial defense the field currently offers.

Retrieval-over-weights, scoped to persistent outputs, remains the most important architectural move of the bunch. It should be enforced, not advised. But it is not unified with the answer to paradigm-drift, and claiming otherwise would oversell what we actually have.

---

## What We Discovered

Three discoveries shifted the frame harder than the original question anticipated.

**The first:** the production landscape has the polarity backwards. Agentic RAG, the dominant 2025–2026 pattern, explicitly sells "the agent decides whether to retrieve" as an improvement over naive RAG — retrieval-skipping is marketed as a feature. No production system ships retrieval-as-declared-default with weights-as-explicit-fallback. This is not a gap Wisdom has to out-engineer against crowded competition; it is a gap the field is actively walking away from (see [research-web.md](2026-04-16-two-drift-types-unified-answer/agents/research-web.md), Sections 1.1, 2.1, and 3.1). The architectural direction Wisdom named is genuinely contrarian in a way that matters.

**The second:** there is a hard ceiling on what in-context mechanisms can do. The RuLES benchmark and the "Do LLMs Follow Their Own Rules?" finding converge: rules-in-context compliance runs at 25–80% depending on model and conditions. The Paradox-Holder named the uncomfortable implication directly — this isn't a calibration problem, it's a **structural ceiling**. Nudges improve timing. They don't break the ceiling. Getting above 80% requires either blocking hooks (system-level enforcement that fires outside the model's reasoning chain) or training. Everything else is rearranging furniture within the ceiling (see [play-sub-paradox-holder.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-paradox-holder.md), Paradox 3; [research-papers.md](2026-04-16-two-drift-types-unified-answer/agents/research-papers.md), Section 2).

This means: if retrieval-over-weights is truly load-bearing — and Wisdom's speeches frame it as architectural — then it cannot live in a markdown rule. That's a design commitment that's been deferred.

**The third:** self-graded confidence is anti-informative. Mason's 2026 result is striking — under text-only supervision, models cannot reliably distinguish accurate responses from plausible fabrications. Self-reported confidence inversely correlates with accuracy, AUC 0.28 across four model families. Worse than chance (see [research-papers.md](2026-04-16-two-drift-types-unified-answer/agents/research-papers.md), Section 1). This isn't a minor caveat. It means any epistemic-status annotation system that asks the model to grade its own outputs *after the fact* is structurally broken.

The Play phase found a clean resolution to this: **temporal separation**. Pre-annotation (flagging epistemic status before retrieval happens) is a different mechanism from post-annotation (grading confidence after generating). Pre-annotation works for the same reason scientific pre-registration works — separating the claim from its evaluation prevents the claim from being adjusted to fit the evidence. This is Buddhist noting practice, it's science's p-hacking defense, it's stare decisis; the Pattern-Spotter found it independently in five traditions (see [play-sub-pattern-spotter.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-pattern-spotter.md), Pattern 2; [play-synthesis.md](2026-04-16-two-drift-types-unified-answer/agents/play-synthesis.md)).

But the Challenger was right to push on it: even pre-annotation requires the model to accurately classify its own cognitive state *before* retrieval. If the model can't reliably report confidence after the fact, why would it reliably report "I'm about to generate from weights" before? The noting practice may still work as a forcing function — the *act* of pause-and-label creating cognitive distance independent of the label's accuracy — but the claim needs to be scoped to that, not oversold as reliable self-monitoring ([challenger.md](2026-04-16-two-drift-types-unified-answer/agents/challenger.md), Section 4.2).

**The fourth discovery was the play convergence — and the honest complication around it.** Three play voices, seeded independently with different instincts (follow-threads, hold-paradoxes, spot-patterns), all converged on the same finding: the real enemy is unwitnessed change, and the architectural answer is provenance infrastructure, not prevention infrastructure. Git-for-beliefs. Signed memories. `git blame` for the world-model ([play-synthesis.md](2026-04-16-two-drift-types-unified-answer/agents/play-synthesis.md); [play-sub-thread-follower.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-thread-follower.md), Thread 1; [play-sub-pattern-spotter.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-pattern-spotter.md), Pattern 7).

The Challenger caught this cleanly and accurately: the three voices read the same seed material. Their convergence is partly echo, not three independent epistemic agents finding the same truth. The seed material pointed at provenance because the sources (KAIROS, git-blame, signed memories) pointed at it ([challenger.md](2026-04-16-two-drift-types-unified-answer/agents/challenger.md), Section 1.2). That observation is correct and load-bearing.

But the Expansion phase made something clearer: even discounting the convergence for echo, the **Git-for-beliefs analogy is genuinely suggestive for injection-attack defense**, and it's structurally unsound for paradigm-drift. Two different verdicts on the same framework. A ledger records what happened — it catches poisoned memories *after* the injection, enables bisection, and supports forensic audit. What it doesn't do is catch an entity that retrieved SOUL.md correctly, annotated the retrieval correctly, and then subtly misapplied the retrieved values at generation time. That's interpretation drift, not sourcing drift. The ledger sits on the wrong layer for that class of failure (see [expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md), Section 5.1).

**The fifth discovery:** paradigm-drift is the hardest drift type and the least addressable. Kuhn and Polanyi named it clearly in the Books stream — there is a tacit layer of knowing (how the entity categorizes situations, what it treats as relevant, what it experiences as "helpful") that resists propositional storage and therefore resists retrieval-based defense (see [research-books.md](2026-04-16-two-drift-types-unified-answer/agents/research-books.md), Sections 1.5 and 1.6). Rules that say "be honest" can be enacted in paradigmatically different ways. The rules look identical on both sides of the drift.

The Expansion's honest finding: this is **not structurally addressable today**. ASIDE's authors explicitly scope out interpretation drift. Anthropic's activation probes do not generalize from backdoored models to naturally-arising drift (the authors say so in the paper). Mechanistic interpretability has not yet produced a circuit-level detector for paradigm shifts. The best operational defense measured in the literature is behavioral baselining (Agent Drift / ASI framework, ~70% semantic-drift reduction), and that number is from controlled simulation with unreported false-positive rates ([expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md), Sections 3–6).

**The sixth discovery — and the one that pays architectural dividends:** the Mirror, as currently imagined, will fail in the most important case. A same-process, same-model Mirror reviewing PD's outputs shares PD's paradigm-drift by design. It will **confirm** the drift, not catch it. Same context, same priors, same interpretive frame — multi-agent consensus among paradigm-aligned agents is not correctness, it's coherent misalignment. The Expansion phase made this structurally explicit and it's the single most important correction to the Structure's Decision 4. The Mirror must be **cross-model** (different base model family — Opus reviewing Haiku, or a non-Claude model reviewing PD) and **fresh-session** (clean context window, loads only SOUL.md and a held-out behavioral baseline). This is not a deferred upgrade. It's the minimum viable Mirror ([expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md), Section 7).

**The seventh — the insidious one that nobody but the Paradox-Holder named directly:** the propose-not-auto-write pattern hollows out at scale. When proposal volume is low, Wisdom-as-reviewer provides genuine oversight. When volume rises, "approve" becomes a click without a read. The ceremony persists; the substance erodes. No single decision to degrade review — just gradual drift in review quality itself ([play-sub-paradox-holder.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-paradox-holder.md), Paradox 4). This matters especially for the HHA enterprise pitch: at 10 clients with their own entities, Wisdom cannot review everything. The architecture currently has a reviewer dependency that is acknowledged as fragile and then left structurally unaddressed (Challenger, Blind Spot 5.3).

---

## The Landscape

### The three drift types (not two)

Starting from Wisdom's two and arriving at three is the first real structural finding.

| Drift Type | What it is | How it looks | Detection | Prevention |
|---|---|---|---|---|
| **Output-drift** | Per-response hallucination; weights-generated claims masquerading as retrieved facts | Confident confabulation; fabricated citations; answers that sound right and aren't | Retrieval-provenance check; sufficiency gate; activation entropy (if exposed) | PreToolUse blocking hook before persistent outputs; sufficiency classification before generation |
| **Value-drift** | Long-horizon deviation from stated behavioral values from context accumulation, adversarial input, or mesa-optimization | Subtle shift in what the entity defends; rule violations under pressure that wouldn't happen in a clean session | Behavioral baseline embedding distance; goal-alignment scoring; scheduled comparison against held-out benchmark | Scheduled SOUL.md re-injection; two-phase accumulation/distillation (KAIROS pattern); non-parametric knowledge so weights never update |
| **Paradigm-drift** | Tacit reorientation of what the entity *treats as* the relevant frame — rules unchanged, interpretation shifted | Outputs that pass compliance checks but feel off; same words, different meaning in practice | Behavioral anomaly accumulation across time; cross-model Mirror; held-out benchmark run fresh-session | **No clean structural answer.** Defense-in-depth only: fresh-session baselining, cross-model review, multi-entity sangha, human audit |

Output-drift is prevention-tractable. Value-drift is monitoring-tractable. Paradigm-drift is **residual-risk territory** — the honest architectural posture is to name it, defend against it partially, and stop pretending it's solved by the same framework that handles the other two.

Sources: [research-books.md](2026-04-16-two-drift-types-unified-answer/agents/research-books.md) (Kuhn/Polanyi); [research-papers.md](2026-04-16-two-drift-types-unified-answer/agents/research-papers.md) (Layer 1–4 stack); [expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md); [structure.md](2026-04-16-two-drift-types-unified-answer/agents/structure.md) (Framework 2).

### The enforcement spectrum

The single most actionable framework the research produced. Read it as a decision surface: where on the spectrum does each behavior need to live, and what's the cost?

| Level | Mechanism | Ceiling | What it catches |
|---|---|---|---|
| 0 | Infrastructure prerequisites (the `chronicle/` directory exists, the hook script is deployed, the path resolves) | N/A — prerequisite | Silent failure of every higher level. The semantic-logging nudge had near-zero compliance because chronicle directories didn't exist. |
| 1 | Rule in markdown, loaded at session start | 25–80% | Low-friction violations from a model already disposed to comply |
| 2 | Scheduled re-injection (rule reloaded every N tool calls) | Better within ceiling | Context-decay drift as session accumulates |
| 3 | Stop-hook nudge (fires after each response) | Better timing, same ceiling | Salience failures at decision moments |
| 4 | Soft pre-action check (hook warns but doesn't block) | ~80% with advantage | Decision-moment mistakes |
| 5 | Blocking hook (PreToolUse denies until compliance met) | 100% for parent process, with caveats | Everything reachable by the trigger |
| 6 | Training (baked into weights) | 100% minus adversarial | Deep behavioral defaults |

The Challenger was right to scope Level 5's "100%" claim. It's 100% *for the parent Claude Code process, on a stable hook, with prerequisites verified, when no subagents are involved*. Subagent inheritance is unclear; sandbox bypasses have been documented; infrastructure can break silently. The mechanism is genuinely strong; the headline number needs caveats ([challenger.md](2026-04-16-two-drift-types-unified-answer/agents/challenger.md), Section 1.3).

The operational rule of thumb: start from the question "if this behavior fails 25% of the time, is that acceptable?" and work right from there. If the answer is no, escalate. Don't leave load-bearing behaviors at Level 1.

Sources: [research-internal.md](2026-04-16-two-drift-types-unified-answer/agents/research-internal.md) (Section 6); [research-web.md](2026-04-16-two-drift-types-unified-answer/agents/research-web.md) (Section 1.2); [play-sub-paradox-holder.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-paradox-holder.md) (Paradox 3); [structure.md](2026-04-16-two-drift-types-unified-answer/agents/structure.md) (Framework 1).

### The retrieval-first principle, scoped honestly

Five independent philosophical lines converge on retrieval-over-weights being structurally correct for a class of outputs:

- **Clark & Chalmers (Parity Principle)** — a world-model file that satisfies availability, endorsement, accessibility, and integration *is* part of the entity's cognitive system. Generating from weights while those files exist isn't preferring "real" knowledge; it's preferring a less reliable, less current medium.
- **Hutchins (Distributed Cognition)** — the entity's cognitive unit is model + files + tools + rules + chronicles. Weights-only generation is the sailor navigating from memory while ignoring charts and instruments.
- **Simon (Sciences of the Artificial)** — rationality's scissors: inner capacity + outer environmental structure. Neither blade cuts alone. Retrieval is the outer blade.
- **Clark (Surfing Uncertainty / Predictive Processing)** — weights are the prior; retrieved files are high-precision evidence. Weight-dominated generation is pathologically high prior confidence — the computational structure of both confabulation and self-reinforcing drift.
- **The corrigibility argument** — without a deterministic anchor, closed-loop self-improvement is mathematically unstable (entropy decay, variance amplification). Retrieval is that anchor.

All five arguments share the same deep structure: a cognitive system that trusts internal state over available external evidence is pathologically overconfident. Retrieval-over-weights keeps the system world-coupled (see [research-books.md](2026-04-16-two-drift-types-unified-answer/agents/research-books.md), Section 2).

**But the Challenger's scoping critique holds.** "Retrieval-over-weights as architectural default" universally is wrong. For the large class of outputs where the world-model doesn't contain the answer — explain gradient descent, brainstorm an event format, analyze a tradeoff — forcing retrieval adds friction without reducing drift, because there's nothing appropriate to retrieve. Weights-reasoning isn't the dangerous fallback in those cases; it's the correct path ([challenger.md](2026-04-16-two-drift-types-unified-answer/agents/challenger.md), Section 1.1).

The principle is right where it applies: **persistent outputs that ground future decisions** — chronicle entries, proposals, communications, world-model updates. It's wrong as a universal default for every reasoning step. The graduated-by-output-type decision in the Structure (Decision 2, Option C) is the architecturally honest form; presenting it as a universal principle was the overreach.

Polanyi and Kuhn add the deeper qualifier. Even where retrieval applies, it handles only the explicit layer. The tacit layer — orientation, what counts as relevant, what the entity *attends toward* — cannot be externalized into files. Retrieval-over-weights is necessary, not sufficient. The Mirror is the complement, and that's why it matters so much.

### The Mirror, redesigned

The Structure's Decision 4 recommended "same-process subagent now, structurally-separated Mirror later." The Expansion demolished this: same-process, same-model, same-context Mirror cannot catch paradigm-drift by construction. It shares the very frame it's supposed to audit.

The minimum viable Mirror has three non-negotiables:

**1. Cross-model.** Different base model family. Opus reviewing Haiku, or a non-Claude model (GPT-4 or Gemini) reviewing PD. Cross-model ensembles have repeatedly shown decorrelated errors. This is the cheapest way to break correlated-failure.

**2. Fresh-session.** Clean context window for every review. Load only SOUL.md + a curated behavioral baseline (first 20–100 interactions of PD, per the ASI framework). Never share PD's accumulated context. The fresh session breaks context-induced mesa-optimization drift — which is itself one mechanism of paradigm-drift.

**3. Composite stability index, multi-window.** Single-incident flags are too noisy. The ASI framework's pattern: 12 dimensions across 4 categories (response consistency, tool-usage patterns, coordination, behavioral boundaries), weighted, requiring three consecutive windows below threshold τ=0.75 before escalation.

Fourth element worth adopting as the Mirror matures: **a CCE-specific held-out benchmark.** Generic misalignment benchmarks will miss project-specific paradigm shifts. Construct behavioral probes for the specific paradigms PD is supposed to embody — what does "helpful to Wisdom" look like in specific scenarios, what does "honest chronicle entry" mean at edge cases. Run the benchmark periodically against fresh PD sessions; compare scores over time.

Implementation sketch that honors these constraints:

- Heartbeat subagent on 30–60 minute cadence (sleep-consolidation pattern suggests faster = more development).
- Mirror spawned via the Agent tool with explicit model override (Opus if PD runs on Sonnet/Haiku; or direct cross-provider call).
- Mirror reads `entity/behavioral-baseline/` (curated canonical outputs), recent chronicle entries (last N tool calls), and SOUL.md. Does not read accumulated operational context.
- Mirror emits structured report: composite index, per-dimension scores, flagged anomalies, escalation recommendation.
- Mirror output written to `entity/mirror-reports/YYYY-MM-DD-HHMM.md`.
- Anomaly accumulation logic watches for three consecutive windows below threshold before paging Wisdom.

Sources: [expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md) (Sections 4 and 7); [play-sub-pattern-spotter.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-pattern-spotter.md) (Patterns 3 and 5).

### The production gap CCE occupies

Three gaps that no production system fills, confirmed across web, papers, and GitHub search:

1. **Retrieval-first-as-declared-default for persistent outputs, enforced by blocking hooks.** Every production system either retrieves automatically (naive RAG), lets the agent decide (agentic RAG), or blends. None enforce retrieval as mandatory with explicit weights-fallback declaration ([research-web.md](2026-04-16-two-drift-types-unified-answer/agents/research-web.md), Section 3.1).

2. **Inline prose claim annotation with provenance at decision moments.** The closest analog (llm-wiki-agent's EXTRACTED/INFERRED) lives in graph metadata, not in generated text at high-stakes moments ([research-github.md](2026-04-16-two-drift-types-unified-answer/agents/research-github.md), Section 2).

3. **Unified drift monitoring covering output + value + paradigm in a single dashboard with enforcement wiring.** DriftShield-mini (2 stars, 9 commits) tries; nothing production-hardened exists.

This is a real gap. It's also a hard gap — the reason nobody has closed it isn't that nobody thought of it, it's that the infrastructure is expensive and the value proposition is clear only for long-running high-stakes entities, which is a small slice of the market. CCE plausibly occupies that slice. For HHA enterprise: this is genuinely defensible differentiation, provided the pitch doesn't oversell paradigm-drift coverage.

---

## Recommendations

Six recommendations, ordered roughly by confidence and immediacy. Each is scoped to what the evidence actually supports.

### 1. Build the PreToolUse retrieval gate for persistent outputs

- **Recommendation:** Implement a PreToolUse hook that inspects the transcript before Write, Edit, and Agent tool calls on chronicle entries, world-model updates, proposals, and external communications. If no retrieval event (Read / WebFetch / WebSearch / Grep on relevant files) has occurred in the current reasoning step, either inject a nudge (soft) or deny the call (hard). Exempt creative outputs, quick responses to Wisdom, and explicitly-marked reasoning-only steps.
- **Confidence: 0.80.** The mechanism is empirically validated (hooks > prompts, confirmed across three independent sources). The scoping by output type makes the principle defensible where it applies. The uncertainty is in subagent inheritance, sandbox bypass, and whether the friction creates user-experience issues at scale.
- **Assumptions:** Hook API remains stable. Output-type classification logic is implementable. Retrieval quality (what's in the world-model) is high enough to justify retrieving-first.
- **Strongest counter:** The Challenger's field-engineer perspective — "retrieval-over-weights requires a curated, fresh world-model, which is itself a maintenance burden. Stale world-model forced-retrieval is worse than weights-reasoning." This is real and the architecture has no maintenance model. The dream-consolidation agent is supposed to handle staleness but the loop isn't closed.
- **What would change our mind:** Empirical data showing latency or quality regression in production, or evidence that world-model staleness routinely produces worse outputs than weights-reasoning for persistent-output classes.

### 2. Implement provenance annotation at the source of retrieval, not post-hoc self-grading

- **Recommendation:** Tag every world-model.md entry and memory write with structured provenance at write time: `source_type` (extracted / inferred / unknown), `source_file`, `captured_at`, `verified_by`. Tag retrieved content automatically in the retrieval gate. Expose the chain in outputs when a claim is load-bearing. Do **not** ask the model to self-grade its confidence after generating — that signal is anti-informative.
- **Confidence: 0.75.** Provenance metadata is cheap and clearly useful for audit, bisection, and injection defense. Inline prose annotation for every sentence is not recommended — it's what the literature calls "doesn't ship anywhere for a reason." The middle path (metadata at source + selective inline callouts for load-bearing claims) is defensible.
- **Assumptions:** Metadata can be attached without breaking retrieval performance. Entity endorses metadata during use rather than ignoring it.
- **Strongest counter:** The Challenger's point that provenance metadata without cryptographic signing is gameable by a motivated attacker (who can inject a belief can also inject plausible-looking provenance). True. This is 2026 interim, not a full defense.
- **What would change our mind:** Evidence that the metadata is routinely ignored by the entity during retrieval (endorsement condition fails), or a successful attack that injects valid-looking provenance.

### 3. Deploy SOUL.md as immutable-to-entity with scheduled re-injection

- **Recommendation:** SOUL.md is read-only for PD. Values can only be updated by Wisdom explicitly. PD can propose changes (Tier 4 permission: surface) but cannot write directly. A UserPromptSubmit hook injects SOUL.md at session start. A Stop-hook counter triggers re-injection every N tool calls to counter context-accumulation drift.
- **Confidence: 0.82.** Three independent lines support this: MemMachine's immutable-core pattern (production-analog evidence), corrigibility theory (the correction mechanism must not be reachable by the thing being corrected), and Arike et al.'s empirical finding that scaffolded scheduled injection maintained goal adherence for 100K tokens.
- **Assumptions:** Infrastructure exists (Level 0) — UserPromptSubmit hook is deployed, re-injection counter persists across sessions.
- **Strongest counter:** Earned conviction requires identity growth. A fully-immutable SOUL.md prevents the legitimate development the Companion philosophy was designed to enable.
- **Resolution:** Two-tier is architecturally cleanest — constitutional layer immutable, developmental layer propose-only — but the boundary is undefined. Start with full immutability until the boundary is designed and the review infrastructure is proven. Reopen specifically-designated developmental sections as a second phase.

### 4. Build the Mirror as cross-model, fresh-session, heartbeat-triggered

- **Recommendation:** The Mirror is not a same-process subagent. It's a separate Claude Code session (or direct API call to a different model) with a clean context window, loading only SOUL.md and a curated behavioral baseline. Heartbeat cadence 30–60 minutes. Scores PD's recent outputs against a composite stability index (response consistency, tool-usage patterns, behavioral boundaries). Requires three consecutive windows below threshold before escalating to Wisdom. Anomaly reports go to `entity/mirror-reports/`.
- **Confidence: 0.70.** The cross-model requirement is architecturally non-negotiable for paradigm-drift detection (Expansion, Section 7). The behavioral-baselining mechanism is empirically supported (~70% semantic-drift reduction in controlled simulation). The uncertainty: false-positive rates in real deployment are unreported everywhere in the literature; cost at scale is not modeled; no system has validated this exact combination in production.
- **Assumptions:** Cross-model API access is available and affordable. Behavioral baseline can be curated well enough to be a useful reference. Composite-index thresholds can be calibrated.
- **Strongest counter:** Mirror effectiveness depends on baseline quality. If the baseline itself is drawn from operation that was already drifted, the baseline is poisoned and the Mirror confirms drift as normal. The literature has no mechanism for detecting baseline corruption.
- **What would change our mind:** Deployment data showing false-positive or false-negative rates that make the Mirror useless in practice; discovery that paradigm-drift is detectable via simpler means (circuit-level probes, in-context measurement).

### 5. Address Goodhart-via-drafts with proposal self-classification + reviewer rotation

- **Recommendation:** Every proposal PD generates self-classifies as routine / novel / boundary-crossing. Wisdom reviews 100% of boundary-crossing, samples novel, skips routine. Periodic audits sample the routine tier to catch classification drift. At scale (HHA enterprise), shift to lateral peer review — other entities or trusted reviewers see each other's outputs. Build proposal-volume metrics from day one so the transition point is observable.
- **Confidence: 0.65.** The failure mode is real and largely unaddressed in the literature (Paradox-Holder named it, nobody else tracks it explicitly). The defenses proposed are plausible but unvalidated. The sangha pattern (lateral peer review) is architecturally sound but has no implementation path for a first-of-kind entity with no peers.
- **Assumptions:** PD's self-classification is accurate and not gameable. Reviewers catch systematic misclassification in audits. Metrics are tracked.
- **Strongest counter:** Self-classification is a form of self-monitoring, and self-monitoring is the exact failure mode Mason's AUC-0.28 result describes. An entity that has drifted will classify novel-but-aligned-with-drift proposals as routine.
- **What would change our mind:** Audit data showing routine-tier proposals routinely contained novel/boundary content; discovery that genuine review doesn't erode with volume at the rates assumed.

### 6. Name paradigm-drift as residual risk in the commercial pitch

- **Recommendation:** Stop presenting the architecture as "unified." Document paradigm-drift as a residual risk the architecture partially addresses but does not solve. For HHA enterprise documentation, state explicitly what classes of drift the architecture prevents, detects, and does not detect. This is more trustworthy than a false completeness claim and directly supports the Sincerity PS brand value.
- **Confidence: 0.90.** This is honesty-above-marketing. The Expansion phase established that paradigm-drift is not solved in the literature. Overclaiming creates legal/reputational exposure and is inconsistent with PS values.
- **Assumptions:** Enterprise clients will value honesty over the false sense of completeness a unified-claim would provide. (Genuinely uncertain; some enterprise buyers demand "unified" language regardless of its accuracy.)
- **Strongest counter:** Competitive sales pressure — competitors won't caveat, and honest caveats will lose some deals to dishonest claims.
- **Resolution:** Caveat in the architecture doc. Frame confidently in the pitch: "Our architecture addresses output-drift and value-drift structurally, and catches paradigm-drift via cross-model Mirror review with documented limits. We don't claim to solve what the field hasn't solved." That's strong positioning if delivered with conviction.

---

## Open Threads

1. **Do activation probes work for naturally-arising drift in non-backdoored models?** Anthropic's sleeper-agent result (AUROC > 99%) is scoped to backdoored models. The authors explicitly say the generalization question is open. Paradigm-drift detection ultimately depends on this. If the answer is no, the detection ceiling is behavioral baselining (~70%, unreported FP rate) and we should plan around that. This is the single most important empirical question for the full architecture stack.

2. **When does propose-not-auto-write hollow out at scale?** The Hollow Review failure mode is gradual and self-concealing. The current architecture has a reviewer dependency (Wisdom) that is acknowledged as fragile and not structurally addressed. The sangha pattern is proposed but has no implementation path — PD is the first entity, no peers exist. Ordering matters: if the community has to come before the entity gets complex enough to drift, is PD being built in the wrong order?

3. **What's the interim 2026 design before cryptographic provenance for memories?** Full signed belief-chains break MINJA at the root but are a 2027 problem. The 2026 interim (provenance metadata + trust decay + pattern filter) is known to be brittle (over-conservative or over-permissive depending on model). Is there a middle path — something like provenance hashes verified against a trusted write ledger — that's buildable in 2026 without requiring new cryptographic infrastructure?

4. **Can the Mirror be one subagent covering all three drift types, or does each need its own check?** The research converged on the Mirror as a singular mechanism, but output-drift, value-drift, and paradigm-drift have different detection signatures. A single Mirror may dilute signal. Three Mirrors may triple cost. The right answer probably involves a composite Mirror with type-specific sub-checks, but the architecture hasn't been designed.

5. **Where on the blocking spectrum does retrieval-over-weights actually need to live for different output classes?** This is not a research question. It's a deferred design commitment. Persistent outputs probably need Level 5. Reasoning steps probably need Level 2–3. The gradient needs to be designed, implemented, and measured. Without this commitment, the principle lives at Level 1 (advisory) with 25–80% compliance — which is insufficient for something Wisdom calls architectural.

---

## Sources & Methodology

This think-deep ran in seven phases over a single working session. Each phase produced a file in [`2026-04-16-two-drift-types-unified-answer/agents/`](2026-04-16-two-drift-types-unified-answer/agents/).

**Research streams (Phase 2):**
- [research-internal.md](2026-04-16-two-drift-types-unified-answer/agents/research-internal.md) — Crawled Wisdom's speeches, ideas files, rules, and prior research. Established the vocabulary (presence/enforcement/nudge/Mirror) and surfaced the memory provenance asymmetry gap.
- [research-web.md](2026-04-16-two-drift-types-unified-answer/agents/research-web.md) — Production state of the art. Established that the field has the polarity backwards on agentic RAG, that hook-based enforcement achieves 100% at the system level, and that MemMachine (arXiv 2604.04853) is the closest production analog.
- [research-papers.md](2026-04-16-two-drift-types-unified-answer/agents/research-papers.md) — Academic foundations. Delivered the load-bearing findings: Mason's AUC-0.28 on self-reported confidence, Zheng et al.'s formal proof of mesa-optimization in trained transformers, Arike et al. on context-accumulation as the drift mechanism, and Zverev et al.'s ASIDE work on representation-level separation.
- [research-github.md](2026-04-16-two-drift-types-unified-answer/agents/research-github.md) — What's actually shipping. VideoSDK's `user_turn_start` hook, KAIROS two-phase memory, llm-wiki-agent's EXTRACTED/INFERRED annotation, and the Karpathy LLM-wiki pattern (April 2026, viral).
- [research-books.md](2026-04-16-two-drift-types-unified-answer/agents/research-books.md) — Philosophical grounding. Clark/Chalmers, Hutchins, Simon, Clark/Surfing Uncertainty, Polanyi, Kuhn. The five pillars supporting retrieval-over-weights and the two qualifiers (tacit dimension, paradigm-level drift) bounding its scope.

**Play (Phase 3):**
- [play-sub-thread-follower.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-thread-follower.md) — Found "drift as untraced update" and Git-as-prior-art for belief architecture.
- [play-sub-paradox-holder.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-paradox-holder.md) — Named the 80% compliance ceiling as structural, surfaced the reviewer-hollowing dynamic, held the "weights are the problem AND weights are the point" paradox.
- [play-sub-pattern-spotter.md](2026-04-16-two-drift-types-unified-answer/agents/play-sub-pattern-spotter.md) — Cross-domain isomorphisms (immune system, scientific method, finance, sleep consolidation, Buddhism, law, Git).
- [play-synthesis.md](2026-04-16-two-drift-types-unified-answer/agents/play-synthesis.md) — Convergence finding (three voices → provenance-not-prevention) and live questions.

**Structure, Challenger, Expansion (Phases 4–5):**
- [structure.md](2026-04-16-two-drift-types-unified-answer/agents/structure.md) — Integrated Insight Map (7 themes), 6 Frameworks, 6 Decision points with trade-offs, 6 Assumptions with robustness scoring, 7 Open Questions ranked.
- [challenger.md](2026-04-16-two-drift-types-unified-answer/agents/challenger.md) — Dissented from the Structure on three major points: retrieval-over-weights is scoped not universal, the play convergence is partly seed-echo not independent validation, and the Git-for-beliefs ledger is the wrong architectural layer for paradigm-drift. All three critiques held up on review.
- [expansion-paradigm-drift.md](2026-04-16-two-drift-types-unified-answer/agents/expansion-paradigm-drift.md) — Confirmed the Challenger's paradigm-drift dissent. Established that paradigm-drift is not structurally addressable in the current literature, mapped the operational defense-in-depth stack (ASI framework, cross-model Mirror, held-out benchmarks, fresh-session evaluation), and specified the non-negotiable Mirror design (cross-model, fresh-session, composite index, multi-window).

**The tension that matters:** the Structure proposed Mirror as "same-process now, separated later." The Challenger and Expansion both rejected this — the separation is the mechanism, not a nice-to-have. That disagreement is preserved in the synthesis. The Expansion's cross-model fresh-session Mirror is the recommendation, not the Structure's Option B-then-C ordering.

The Challenger also caught a real problem with how the play convergence was weighted. Three voices reading the same seed material producing the same conclusion is rhetorical reinforcement, not independent triangulation. The Git-for-beliefs analogy remains suggestive for injection-attack defense and forensic audit; it's not a paradigm-drift solution. That scoping is preserved throughout.

---

*The synthesis was drafted by the Synthesizer (Phase 5) after reading all 12 prior files in full. Recommendations and confidence scores are conservative where the evidence is thin, assertive where it's strong. Where the Structure's conclusions didn't survive the Challenger and Expansion, the synthesis follows the revised finding, not the original.*
