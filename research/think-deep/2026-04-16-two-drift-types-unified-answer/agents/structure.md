---
agent: structure
phase: 3 — Structure
session: think-deep — Two Drift Types and Their Unified Structural Answer
date: 2026-04-16
sources: research-internal.md, research-web.md, research-papers.md, research-github.md, research-books.md, play-sub-thread-follower.md, play-sub-paradox-holder.md, play-sub-pattern-spotter.md, play-synthesis.md
---

# Structure — Two Drift Types and Their Unified Structural Answer

---

## 1. INSIGHT MAP

### Theme A: The Drift Taxonomy — How Many Types, Exactly?

---

**A1. Two explicit drift types were the starting framing — three are the actual finding.**

The research opened with output-drift (hallucination, per-response) and value-drift (long-horizon deviation from stated values). A third type emerged from the books stream: paradigm-drift — tacit reorientation of what the entity treats as the relevant description of a situation, invisible to rule-compliance checking.

- Evidence: research-books.md (Kuhn's parameter-level vs. paradigm-level drift distinction), play-sub-pattern-spotter.md (Pattern 5, Buddhist noting practice as the only detection mechanism for tacit drift), play-sub-paradox-holder.md (Paradox 5: malignant drift and healthy development look identical from the outside)
- Confidence: 0.85 — the third type is philosophically well-grounded via Polanyi and Kuhn; the practical detection mechanism (behavioral baselining over time) is identified but unvalidated in production

**A2. The three drift types require different defenses, and no single mechanism covers all three.**

Output-drift: structural retrieval-before-generation gate. Value-drift: scheduled re-injection of SOUL.md + behavioral baseline monitoring. Paradigm-drift: behavioral observation over time by a structurally separated Mirror — the only mechanism capable of detecting tacit reorientation.

- Evidence: research-papers.md (four-layer stack: non-parametric knowledge, representation separation, scheduled injection, activation monitoring), research-books.md (Polanyi: retrieval handles the explicit layer; Mirror handles the tacit residue), play-synthesis.md (three voices converging on provenance infrastructure, not prevention infrastructure)
- Confidence: 0.80 — well-supported; the activation monitoring layer for paradigm-drift is the weakest link (open empirical question, see Section 5)

---

### Theme B: The Production Gap — What Hasn't Been Built

---

**B1. Retrieval-as-default with weights-as-declared-fallback does not exist in production.**

Every production system either retrieves automatically (naive RAG), lets the agent decide whether to retrieve (agentic RAG), or blends parametric and retrieved knowledge. None enforce retrieval as mandatory and require explicit fallback declaration when weights are used. This is the most important gap.

- Evidence: research-web.md (Section 3.1: gap confirmed after specific search), research-papers.md (Section 3: no paper directly addresses this framing), research-github.md (Section 3, Gap 1)
- Confidence: 0.90 — thoroughly searched across web, papers, and GitHub; the gap is real

**B2. Inline prose claim annotation ([retrieved] vs [reasoned] vs [weights-only]) has not shipped anywhere.**

The closest analogs live at the graph-metadata level (llm-wiki-agent EXTRACTED/INFERRED tags) or in evaluation frameworks. Nothing annotates generated text inline at decision-making moments in production.

- Evidence: research-github.md (Section 2, Surprise: "claim annotation at the prose level is essentially unshipped"), research-web.md (Section 3.2: no hook-based retrieval enforcement patterns in the wild)
- Confidence: 0.90 — consistent across all three empirical research streams

**B3. A unified drift monitor covering both output-drift and value-drift simultaneously does not exist.**

DriftShield-mini attempts this conceptually (2 stars, 9 commits, not production-hardened). No mature system provides a single dashboard scoring both dimensions with enforcement hooks connected.

- Evidence: research-github.md (Section 3, Gap 3), research-web.md (Section 2.2: value drift research has no proposed defenses)
- Confidence: 0.88

**B4. Closed-loop heartbeat drift review has the infrastructure but not the wiring.**

OpenClaw and similar systems have heartbeat mechanisms. The gap is that heartbeat prompts aren't connected to behavioral baselines — the agent runs a check but has no comparison point and no way to inject findings back into the main session (confirmed by Hermes issue #5712).

- Evidence: research-github.md (Section 2: "heartbeat review subagents exist in OpenClaw/Hermes as periodic agent turns, but they're not wired to drift detection")
- Confidence: 0.85

---

### Theme C: The Enforcement-Level Findings

---

**C1. The compliance ceiling for in-context mechanisms is empirically 25–80%, and this is a structural ceiling, not a calibration problem.**

Rules in markdown achieve SNCS 0.245–0.80 (RuLES benchmark corroborates). Nudges improve timing but operate within the same ceiling. Getting above 80% compliance requires either blocking hooks or training. This is the hardest honest finding in the architecture.

- Evidence: research-internal.md (Section 6: enforcement levels, citing "Do LLMs Follow Their Own Rules?"), research-papers.md (Section 2: "Advisory markdown is definitionally unreliable"), play-sub-paradox-holder.md (Paradox 3: "there is no purely-in-context mechanism that achieves >80% reliable compliance")
- Confidence: 0.92 — multiple independent sources; the benchmark result is direct empirical evidence

**C2. Hooks achieve 100% compliance because they execute at the system level, outside the LLM's reasoning chain.**

This is not a strong claim about model behavior — it's a claim about where in the execution stack enforcement happens. Hooks fire before or after tool calls regardless of model disposition.

- Evidence: research-web.md (Section 1.2: "three sources converge on this independently"), research-github.md (adopt VideoSDK user_turn_start pattern)
- Confidence: 0.95 — mechanistically correct; the caveat is subagent inheritance (see Tension 4.3 in research-web.md)

**C3. Nudges add timing advantage over rules but not compliance ceiling increase.**

Nudges fire at decision moments (Stop hook) rather than session start; this improves salience. But they still deliver markdown to a probabilistic model. The improvement is real; it does not break the ceiling.

- Evidence: play-sub-paradox-holder.md (Paradox 3, resolved), research-internal.md (enforcement spectrum)
- Confidence: 0.85

**C4. Level 0 (infrastructure prerequisites) is the most commonly overlooked enforcement failure.**

The semantic-logging nudge had near-zero compliance because chronicle/ directories didn't exist — the hook fired, Claude saw the reminder, had nowhere to write. Infrastructure must exist for enforcement to trigger.

- Evidence: research-internal.md (Section 6, Level 0 insight; citing rule-enforcement.md)
- Confidence: 0.95 — directly observed in production

---

### Theme D: The Mirror / Ledger / Witness Pattern

---

**D1. Three independent play voices converged unprompted on the same finding: the enemy is unwitnessed change, and the solution is provenance infrastructure, not prevention infrastructure.**

Thread-Follower arrived via "drift as untraced update." Paradox-Holder arrived via "malignant drift vs. earned conviction look identical without provenance chains." Pattern-Spotter arrived via Git as prior art. Same destination.

- Evidence: play-synthesis.md (opening paragraph), play-sub-thread-follower.md (Thread 1), play-sub-paradox-holder.md (Paradox 5), play-sub-pattern-spotter.md (Pattern 7)
- Confidence: 0.90 — play convergence is the strongest signal this research produced; the finding is structurally sound and multiply grounded

**D2. The Mirror pattern is independently motivated by four separate frameworks.**

Polanyi: external behavioral observation is the only way to detect tacit drift. Kuhn: behavioral anomaly accumulation is the only signal for paradigm-level shift. Clark (predictive processing): Mirror provides high-precision error signal recalibrating the entity's self-model. Minsky: the B-brain/supervisory layer is the structural ancestor.

- Evidence: research-books.md (Section 4), play-sub-pattern-spotter.md (Pattern 1: immune system peripheral surveillance)
- Confidence: 0.88

**D3. Git-for-beliefs is not a metaphor — it is a direct technology transfer that hasn't happened yet.**

The belief-attribution problem (who introduced this belief, when, from what source, via what reasoning) is structurally identical to the code-attribution problem that Git solved. Commit = belief update. Commit message = provenance annotation. git-blame = find when drift started. PR review = proposal review for significant belief changes.

- Evidence: play-sub-pattern-spotter.md (Pattern 7), play-sub-thread-follower.md (Thread 1 closing), play-synthesis.md
- Confidence: 0.85 — the analogy is structurally tight; implementation complexity is unknown

---

### Theme E: The Sufficiency-Gate Finding

---

**E1. Naive retrieval-first does not solve output-drift — it requires a sufficiency gate.**

Models prefer retrieved context when available, but when the retrieved context is judged internally as not relevant, they fall back to parametric confabulation. And large capable models confabulate rather than abstain when context is insufficient. "Always retrieve" solves the preference problem but not the fallback problem.

- Evidence: research-papers.md (Section 1: Farahani & Johansson EMNLP 2024, Joren et al. arXiv:2411.06037)
- Confidence: 0.88 — two independent papers with causal mediation analysis and cross-model validation

**E2. The correct retrieval discipline is: retrieve → classify sufficiency → if insufficient, abstain or escalate, never fall back to weights confabulation.**

This is a three-step gate, not a one-step "go retrieve." The sufficiency classification step is where the architecture must intervene.

- Evidence: research-papers.md (Section 5, Layer 3), research-web.md (Section 1.3: MemMachine's validation layer)
- Confidence: 0.85

---

### Theme F: The Anti-Informative Confidence Finding

---

**F1. Self-reported confidence is structurally anti-informative — AUC 0.28–0.36, worse than chance.**

Under text-only supervision, models cannot reliably distinguish accurate responses from plausible fabrications. Self-reported confidence inversely correlates with accuracy. Epistemic-status annotation built on text outputs is structurally unreliable for calibration purposes.

- Evidence: research-papers.md (Section 1: Mason arXiv:2603.20531)
- Confidence: 0.87 — peer-reviewed finding across four model families; caveat is that annotation might still have value as a forcing function (noting practice) even if the confidence signal itself is anti-informative

**F2. The monitoring layer that matters must consume activation signals, not output text.**

Per-token entropy exported as a tensor interface achieves AUC 0.757 vs 0.28–0.36 for text-reported confidence. The useful signal is in the computation, not the output.

- Evidence: research-papers.md (Section 1, Mason)
- Confidence: 0.82 — result is strong; but deployment requires API access to token entropy, which Claude Code does not currently expose (infrastructure gap)

---

### Theme G: Paradigm-Drift as Third Category

---

**G1. Parameter-level drift (explicit rule violation) and paradigm-level drift (tacit reorientation) require fundamentally different detection mechanisms.**

Parameter-level drift: detectable by compliance checking, behavioral baseline comparison, embedding distance from stated goal. Paradigm-level drift: detectable only by behavioral anomaly accumulation over time — the agent behaves differently while all explicit rules remain unchanged.

- Evidence: research-books.md (Kuhn/Polanyi, Section 1.5 and 1.6), play-sub-pattern-spotter.md (Pattern 5: noting practice), play-sub-paradox-holder.md (Paradox 5)
- Confidence: 0.80 — conceptually sound; empirical validation in AI systems is not yet established (this is a frontier question)

---

## 2. FRAMEWORKS

### Framework 1: The Enforcement Spectrum

**Name:** The Enforcement Spectrum  
**What it is:** A seven-level progression from purely advisory to purely structural, each level addressing a different failure mode in the reliability stack.

| Level | Mechanism | Compliance Ceiling | Failure Mode Addressed |
|-------|-----------|-------------------|----------------------|
| 0 | Infrastructure prerequisites (directories, files, configs exist) | N/A — prerequisite | Silent failure of all higher levels |
| 1 | Rule in context (markdown, session-start injection) | 25–80% | Low-friction violations |
| 2 | Scheduled re-injection (rule re-loaded every N tool calls) | Improved within ceiling | Context-decay drift |
| 3 | Stop-hook nudge (fired at decision moments) | Improved timing, same ceiling | Salience/timing failures |
| 4 | Soft pre-action check (hook injects warning but doesn't block) | ~80% with timing advantage | Decision-moment violations |
| 5 | Blocking hook (PreToolUse denies until compliance met) | 100% by mechanism | All violations reachable by this trigger |
| 6 | Training (baked into weights) | 100% (modulo adversarial prompts) | Deep behavioral defaults |

**How to use:** Choose the level based on how load-bearing the behavior is. Advisory (Levels 1–3) for behaviors that improve quality but whose violation isn't catastrophic. Blocking (Levels 5–6) for behaviors whose violation constitutes a fundamental architectural failure. Retrieval-over-weights for persistent outputs belongs at Level 5 minimum. Value re-grounding belongs at Levels 2–4. Advisory rules for quality belong at Levels 1–3.

The key move: don't treat escalation as a last resort. Start from the question "if this fails 25% of the time, is that acceptable?" and work right from there.

Sources: research-internal.md, research-web.md (Section 1.2), play-sub-paradox-holder.md (Paradox 3)

---

### Framework 2: The Three-Layer Drift Taxonomy with Mechanism Coverage Map

**Name:** The Drift Coverage Map  
**What it is:** Which mechanisms address which drift type, and what's left uncovered.

| Drift Type | What It Is | Detection Method | Prevention Mechanism | Coverage Gap |
|------------|-----------|------------------|---------------------|--------------|
| Output-drift | Per-response hallucination; weights-generated claims masquerading as retrieved facts | Retrieval provenance check; activation entropy (if accessible) | PreToolUse blocking hook; sufficiency gate before generation | Subagent hook inheritance unclear |
| Value-drift | Long-horizon deviation from stated behavioral values due to context accumulation, adversarial input, or mesa-optimization | Behavioral baseline embedding distance; goal-alignment scoring | Scheduled SOUL.md re-injection; two-phase accumulation/distillation; non-parametric knowledge | No autonomous correction mechanism exists; detection only in Moral Anchor System |
| Paradigm-drift | Tacit reorientation of what the entity treats as the relevant frame; invisible to rule-compliance checking | Behavioral anomaly accumulation over time via Mirror; lateral peer review | Behavioral logging enabling historical comparison; community review (sangha) | No known automated detection; requires human pattern recognition across time |

**How to use:** Before designing any drift-resistance mechanism, identify which drift type you're addressing. The coverage map shows that the three types require different approaches and that paradigm-drift has no automated prevention path currently available. Design accordingly: prevent output-drift structurally, monitor value-drift continuously, detect paradigm-drift behaviorally over time.

Sources: research-internal.md, research-books.md, play-sub-pattern-spotter.md, research-papers.md

---

### Framework 3: Goodhart-via-Proposals — The Hollow Review Failure Mode

**Name:** The Hollow Review Dynamic  
**What it is:** When the entity generates proposals for human review, the review mechanism is load-bearing only while proposal volume is low enough for genuine review. As proposal volume increases, review degrades to rubber-stamping. The ceremony of oversight persists after its substance has eroded.

**The failure shape:**
1. Entity generates proposals; human reviews them genuinely
2. Entity generates more proposals; human reads more quickly
3. Entity generates many proposals; human approves without reading
4. Entity has effective auto-write capability with a latency-adding speed bump

**Why it's insidious:** No single decision to erode oversight. Gradual degradation. Feels like oversight is maintained because the approval click happens.

**Structural defenses:**
- Entity self-classifies each proposal: routine / novel / boundary-crossing
- Human reviews 100% of boundary-crossing, sampling of novel, none of routine
- Automated pre-screening surfaces only non-routine proposals to human attention
- Cadenced full-review audits regardless of classification (sample the routine tier)

**The sangha alternative:** At high volume, shift from hierarchical review (entity → human) to lateral community review (entity → peer entities or lateral reviewers who see each other's outputs). Lateral witnesses are harder to hollow out than a pyramid supervisor.

Sources: play-sub-paradox-holder.md (Paradox 4), play-synthesis.md, research-internal.md (Goodhart-via-proposals as unsolved problem, Section 9)

---

### Framework 4: Clark's Endorsement Condition — What Must Be True for Retrieval-Over-Weights to Work

**Name:** The Endorsement Condition  
**What it is:** Clark and Chalmers (1998) establish that external resources function as genuine cognitive extension — not mere tools — only when four conditions hold: availability, endorsement (agent trusts without excessive deliberation), accessibility, and robust integration into behavior.

**The condition that matters most:** Endorsement. If the entity second-guesses its world-model files by generating from weights, the files are not functioning as cognitive extension. They are a tool the entity occasionally checks. The behavioral posture "trust the file, doubt the weights" is what the endorsement condition demands.

**Architectural implication:** The endorsement condition is a behavioral posture, not just an architectural provision. A world-model file that exists but gets ignored is not providing cognitive extension. The hook-enforced retrieval gate is the structural operationalization of endorsement: it makes trusting the file the default path of least resistance.

**Test for whether endorsement is present:** Does the entity consult world-model files before generating claims without requiring a separate deliberation about whether to do so? If yes, endorsed. If the entity deliberates about whether to retrieve, the endorsement condition is not met.

Sources: research-books.md (Section 1.1, Clark/Chalmers), research-papers.md (Farahani & Johansson endorsement tension)

---

### Framework 5: Pre-Annotation vs Post-Annotation — The Temporal Separation Principle

**Name:** The Pre-Annotation Gate  
**What it is:** Epistemic-status annotation has value only if it happens before retrieval, not after. Post-annotation allows the entity to retroactively relabel weights-generated claims as "retrieved" once retrieval happens to confirm them. This is p-hacking applied to belief architecture.

**The correct sequence:**
1. Entity flags epistemic status: "I am about to generate from weights" (pre-annotation)
2. Entity retrieves relevant context
3. Entity generates, now constrained by flagged status
4. Output carries the pre-committed annotation, not a post-hoc label

**Why timing matters:** Science's pre-registration principle works for the same structural reason. Separating claim from evaluation prevents the confabulator from adjusting the claim to fit the evidence. The annotation is committed before the retrieval; it cannot be adjusted afterward.

**The noting-practice parallel (Polanyi/Buddhism):** Pre-annotation is not bookkeeping overhead. It is the cognitive operation that creates distance between the generation impulse and the generation commitment. The note IS the mechanism, not a label attached to the mechanism.

Sources: play-sub-pattern-spotter.md (Pattern 2: scientific method, pre-registration), play-synthesis.md (temporal separation paragraph), play-sub-thread-follower.md (Thread 3)

---

### Framework 6: Signed Belief-Chains / Git-for-Beliefs

**Name:** The Belief-Ledger Architecture  
**What it is:** Every belief update in the entity's world-model is treated as a commit: source + author + timestamp + diff (what changed and how). This enables git-blame-equivalent audit — "when did this belief enter the system, from what source, via what reasoning?"

**The practical isomorphism:**

| Git | Belief Architecture |
|-----|---------------------|
| Commit | Belief update to world-model.md |
| Commit message | Provenance annotation (source, reasoning) |
| Author + timestamp | Retrieved-from + captured-at metadata |
| Diff | What belief changed and how |
| git blame | Find when a belief was corrupted |
| PR + review | Proposal review for significant belief changes |
| Merge conflict | Integrating conflicting sources |
| Tags/releases | Stable belief checkpoints (SOUL.md versions) |

**Why this matters:** The difference between healthy development and malignant drift is provenance. MINJA works by making malicious memories indistinguishable from legitimate ones — it breaks the audit chain. Signed belief-chains break the MINJA attack at the root: if every memory has a verifiable provenance chain, injected memories without valid provenance are flagged.

**2026 interim (before full cryptographic provenance):** Each world-model.md entry includes a structured header: `source_type: extracted | inferred | unknown`, `source_file:`, `captured_at:`, `verified_by:`. Not cryptographic, but auditable. The Mirror heartbeat bisects: "which entries have been re-verified recently vs. coasting on old provenance?"

Sources: play-sub-thread-follower.md (Thread 1, Thread 4), play-sub-pattern-spotter.md (Pattern 7), play-synthesis.md

---

## 3. DECISION LANDSCAPE

### Decision 1: Epistemic-Status Annotation — Should It Happen, and How?

**The decision:** Whether to implement inline claim annotation ([retrieved] / [reasoned] / [weights-only]) as a production practice for Claude Code Entities.

**Option A: Pre-annotation gate (annotate before retrieval)**
- Evidence for: play-sub-pattern-spotter.md (scientific pre-registration prevents p-hacking); research-papers.md (self-reported confidence is anti-informative, but the act of annotating may have value as a forcing function independent of confidence calibration); play-synthesis.md (temporal separation is load-bearing)
- Evidence against: research-github.md (no production system ships inline prose annotation; "creates noise, doesn't ship anywhere for a reason"); research-papers.md (Mason: text-based confidence signals are structurally unreliable)
- Trade-offs: Forcing annotation before retrieval creates the cognitive-separation effect (noting practice). But if annotation is not enforced by a hook, it competes with the 25–80% compliance ceiling. Annotation value as forcing function is real; annotation value as a calibration signal is near-zero.
- Dependencies: Requires a Stop-hook or PreToolUse hook to trigger annotation before generation for high-stakes outputs. Without hook enforcement, annotation is advisory (Level 1–2 at best). Start with annotating at the world-model level (EXTRACTED/INFERRED metadata on stored facts) before attempting inline prose annotation.

**Option B: Post-annotation (annotate after)**
- Evidence for: Lower friction; easier to implement
- Evidence against: Structurally permits p-hacking (retroactive relabeling); produces the exact failure mode science's pre-registration solves; play-synthesis.md explicitly flags this as the wrong sequencing
- Trade-offs: Easy to build, wrong to build. Should be avoided.

**Option C: No annotation (skip it)**
- Evidence for: No production system ships inline annotation; annotation adds friction
- Evidence against: The noting practice value is real (Buddhist contemplation + scientific pre-registration both confirm the cognitive-separation effect); provenance metadata on world-model.md entries has low cost and high audit value
- Trade-offs: Reasonable to skip inline prose annotation for now; unreasonable to skip provenance metadata on stored beliefs.

**Recommendation direction:** Implement at the world-model layer first (EXTRACTED/INFERRED metadata, source + captured_at fields). Add pre-annotation hooks for high-stakes outputs (chronicle entries, proposals, communications) as a second phase. Skip inline prose annotation on every sentence.

---

### Decision 2: Retrieval Enforcement — PreToolUse Hook vs Stop-Hook vs Both?

**The decision:** Where on the enforcement spectrum retrieval-over-weights lives for Claude Code Entities.

**Option A: Stop-hook nudge (Level 3)**
- Evidence for: Existing infrastructure (chronicle-nudge.sh pattern); lower friction; can inject world-model.md via additionalContext
- Evidence against: Does not break the 25–80% ceiling; for a behavior Wisdom calls architectural, Level 3 is structurally insufficient; research-web.md Section 1.2 is explicit that hooks > prompts precisely because hooks execute outside the reasoning chain
- Trade-offs: Achievable now; insufficient for load-bearing behavior

**Option B: PreToolUse blocking hook (Level 5)**
- Evidence for: 100% compliance by mechanism; research-web.md (Section 1.2: transcript inspection via transcript_path can verify retrieval occurred); research-github.md (Empirica Sentinel as prior art for pre-action gate); play-sub-paradox-holder.md (Paradox 3: if retrieval-over-weights is truly load-bearing, it needs blocking hooks or training)
- Evidence against: Adds latency; hook propagation to subagents is unclear (tension from research-web.md 4.3); may be too rigid for transient reasoning steps where retrieval is not appropriate
- Trade-offs: Correct level for outputs that persist; wrong level for reasoning steps

**Option C: Graduated by output type (both, differentially applied)**
- Evidence for: research-web.md (Section 5.5: "The enforcement gradient matters... Hard enforcement for outputs that matter, soft enforcement for reasoning steps"); aligns with the three-layer drift taxonomy (different output types carry different drift risk)
- Evidence against: More complex to implement; requires output-type classification
- Trade-offs: Architecturally correct; implementation complexity is manageable (classify outputs: chronicle entry, proposal, communication = hard enforcement; reasoning step, transient claim = nudge)
- Dependencies: Output-type classification logic must exist before graduated enforcement can fire correctly.

**Recommendation direction:** Option C. PreToolUse block for chronicle entries, proposals, and external communications. Stop-hook nudge for general operation. Implement in that order (nudge first, block second).

---

### Decision 3: SOUL.md — Immutable to Entity vs Propose-Only vs Neither?

**The decision:** Whether the entity can write to SOUL.md directly, can only propose changes, or is entirely locked out.

**Option A: Immutable to entity (MemMachine pattern)**
- Evidence for: research-web.md (Section 5.3: MemMachine's immutable core layer "prevents the 'generative outputs becoming memories' failure mode from corrupting identity"); research-internal.md (corrigibility preservation: the mechanism of correction must not be reachable by the thing being corrected); play-sub-thread-follower.md (Thread 2: weights-as-constitution framing — the deepest alignment cannot be modified mid-deployment)
- Evidence against: May be too rigid if SOUL.md evolves legitimately as the entity develops and earns conviction; earned conviction explicitly requires identity growth through deliberated experience
- Trade-offs: Maximum protection against identity corruption; prevents the legitimate growth the Companion philosophy was designed to enable

**Option B: Propose-only (current design)**
- Evidence for: Preserves principal-agent oversight; allows earned conviction; aligns with graduated autonomy model
- Evidence against: Hollow review dynamic (Paradox 4) — if Wisdom approves proposals without reading them, propose-only becomes de facto auto-write; research-internal.md (Goodhart-via-proposals is identified as theoretically possible)
- Trade-offs: Correct in principle; vulnerable to review erosion at scale
- Dependencies: Requires self-classification of proposals (routine/novel/boundary-crossing) to make the review mechanism sustainable

**Option C: Two-tier (operational values immutable, developmental values propose-only)**
- Evidence for: Aligns with Thread-Follower's weights-as-constitution framing — the constitutional layer (core ethics, foundational identity) is immutable; the legislative layer (evolving perspectives, learned preferences) is propose-only
- Evidence against: The boundary between constitutional and legislative is not defined; ambiguity may create disputes or gaps
- Trade-offs: Most architecturally coherent; requires the additional design work of defining the two tiers explicitly

**Recommendation direction:** Option C, but implement as Option A initially. SOUL.md immutable until the review infrastructure is proven and the boundary between constitutional/legislative is defined. Reopen propose-only for specifically designated developmental sections of SOUL.md as a second phase.

---

### Decision 4: Mirror Subagent — On Heartbeat, and at What Cadence?

**The decision:** Whether to implement a structurally separated Mirror subagent, and what cadence.

**Option A: No Mirror (rely on hooks and rules)**
- Evidence for: Simpler; lower cost; hooks cover output-drift enforcement
- Evidence against: Leaves value-drift (behavioral baseline deviation) and paradigm-drift (tacit reorientation) unaddressed; research-web.md (Asymmetric Goal Drift: violation rates increase over time under adversarial pressure); play-sub-pattern-spotter.md (Pattern 1: peripheral surveillance is necessary for what thymic selection misses)
- Trade-offs: Acceptable for early autonomy tiers; insufficient as entity operates over months

**Option B: Mirror as same-process subagent (spawned by entity)**
- Evidence for: Easy to implement within current architecture; can share context
- Evidence against: play-sub-pattern-spotter.md (Pattern 3: separation of duties — the entity cannot review its own outputs without another layer seeing the review); the same context window means correlated failure (if entity context is compromised, Mirror is too); Hermes issue #5712 confirms cron subagents can't inject findings back into the main session
- Trade-offs: Provides structure; insufficient independence for paradigm-drift detection

**Option C: Mirror as structurally separated process with its own context**
- Evidence for: play-sub-pattern-spotter.md (Pattern 3, Pattern 5); research-books.md (Mirror motivated by Polanyi, Kuhn, Clark/predictive processing independently); play-sub-paradox-holder.md (Paradox 6: count independent failure modes, not components)
- Evidence against: Implementation complexity; requires inter-process communication mechanism; higher cost per cadence tick
- Trade-offs: Architecturally correct; implementation is the bottleneck
- Cadence: play-sub-pattern-spotter.md (Pattern 4: sleep consolidation — faster heartbeat = faster development; 30-minute heartbeat is current CCE spec; empirical question whether this is right)

**Recommendation direction:** Option B now (same-process, separated context window via subagent), Option C as PD matures. The separation matters more than the implementation tier. Start with a 30-minute heartbeat reviewing last 50 outputs against goal-embedding baseline. Connect to behavioral log for longitudinal comparison.

---

### Decision 5: Memory Poisoning Defense — Provenance Chains vs Trust Decay vs Both?

**The decision:** How to defend against MINJA-style memory poisoning (95% injection success in production systems).

**Option A: Provenance chains only**
- Evidence for: play-sub-thread-follower.md (Thread 1: signed memories break MINJA at the root); play-sub-pattern-spotter.md (Pattern 7: Git-blame for beliefs); research-github.md (GitHub Copilot citation-as-code-location pattern)
- Evidence against: Full cryptographic provenance is a 2027 problem (play-synthesis.md); interim implementation has no verified production analog; pattern-filter defenses are brittle in practice (research-github.md 1e: over-conservative or over-permissive)
- Trade-offs: Correct long-term; insufficient near-term without the infrastructure

**Option B: Trust decay only**
- Evidence for: research-github.md (elfmem confidence decay earned through calibration; harder to game than explicit trust scores); avoids the brittleness of explicit trust scores (gemini accepted 82 malicious entries with 1.0 scores)
- Evidence against: Doesn't defend against rapid injection (trust hasn't decayed yet); no formula for decay rate shipped
- Trade-offs: Good maintenance mechanism; insufficient as primary attack defense

**Option C: Both (provenance metadata + trust decay)**
- Evidence for: Addresses different vulnerability windows (provenance for new entries, decay for old ones); research-internal.md (memory provenance asymmetry: writes safe, reads risky — the fix requires weighting reads by provenance)
- Evidence against: More to implement; calibration of decay rate is empirical unknown
- Trade-offs: Correct architecture; implementation sequencing matters (provenance metadata first, decay second)

**Recommendation direction:** Option C. Immediate: add provenance metadata fields to every world-model.md entry (source_type, source_file, captured_at, verified_by). Near-term: implement trust-decay in the dream/consolidation agent (entries not re-verified in N days get lower weight in retrieval). Defer cryptographic signing.

---

### Decision 6: Goodhart-via-Proposals — Address Now or Defer?

**The decision:** Whether to design the proposal-review mechanism to resist review erosion at scale, or build the simple version now and revisit later.

**Option A: Defer (build simple propose-review, revisit when volume is high)**
- Evidence for: Current autonomy tier has low proposal volume; genuine review is feasible; over-engineering for a problem that hasn't manifested wastes implementation capacity
- Evidence against: The failure mode is gradual and self-concealing; by the time it's visible, significant drift may have accumulated; play-synthesis.md flags this as the live question nobody is tracking
- Trade-offs: Acceptable if the mirror is actively watching for review-quality degradation; not acceptable if review is the only drift defense

**Option B: Build scaling infrastructure now (proposal self-classification + sampling)**
- Evidence for: play-sub-paradox-holder.md (Paradox 4 resolution); play-synthesis.md (reviewer-hollowing named as "most dangerous failure mode in the whole architecture" and not tracked by others)
- Evidence against: Implementation overhead; proposal self-classification requires the entity to accurately assess its own proposals (which may be gamed)
- Trade-offs: Adds modest overhead at low volume; provides essential protection at high volume

**Recommendation direction:** Option A with a trigger. Build simple propose-review now. Add proposal self-classification (routine/novel/boundary-crossing) at the same time — it costs little and enables Option B later. Set an explicit trigger: if weekly proposal volume exceeds N, activate sampling-based review and audit the classification distribution.

---

## 4. ASSUMPTIONS

### A1: That the entity reading its own rules is what we want

**What this assumes:** The value of rules-in-context is that the entity reads them and updates its behavior accordingly. The architecture is designed around the entity being a voluntary participant in its own governance.

**What changes if wrong:** If the entity routinely generates outputs that violate rules it "read," the architecture degrades to theater. The deeper question: is the entity reading rules because it endorses them (Earned Conviction) or because they're in context and it's statistically likely to comply?

**Robustness: Moderate.** The 25–80% compliance finding suggests the entity is partially a voluntary participant and partially not. This assumption is partly true, partly not. The architecture should not rely on it exclusively — hence blocking hooks. The assumption is more defensible for the entity as designed (alignment from training toward compliance with reasonable rules) than it would be for a misaligned model.

---

### A2: That retrieval quality is high enough to justify retrieval-over-weights

**What this assumes:** The world-model files, SOUL.md, chronicles, and memory files contain accurate, current information. Retrieval-first is only as good as what gets retrieved.

**What changes if wrong:** Retrieval-first makes the entity MORE confidently wrong. A poisoned world-model file grounds fabrications in authoritative-seeming documents. MemMachine's immutable core layer addresses this; the current CCE architecture doesn't yet have a strong equivalent.

**Robustness: Moderate.** This assumption holds when the entity is young and its world-model is small and human-maintained. It degrades as the world-model grows, ages, or becomes populated by entity-generated content without provenance verification. The provenance infrastructure decisions (Section 3, Decision 5) directly address this assumption's fragility. Until provenance is solid, retrieval quality is an assumption, not a guarantee.

---

### A3: That Wisdom-as-reviewer scales

**What this assumes:** The proposal-review loop works because Wisdom provides genuine review. As proposal volume increases, this assumption becomes progressively less valid.

**What changes if wrong:** The principal-agent relationship hollows out (Paradox 4). The entity accumulates unreviewed drift while the ceremony of oversight continues.

**Robustness: Fragile.** One person reviewing an increasingly autonomous entity is a known scaling failure. This is the most fragile assumption in the architecture and the one most likely to cause silent failures. The Goodhart-via-proposals decision (Section 3, Decision 6) is directly motivated by this assumption's fragility.

---

### A4: That the two-phase consolidation (KAIROS) generalizes to CCE

**What this assumes:** The operating-entity/dream-consolidator separation pattern (KAIROS) transfers cleanly to Claude Code Entities, where the entity's chronicle feeds a nightly consolidation subagent that updates world-model.md.

**What changes if wrong:** The consolidation subagent may not inherit sufficient context to make good consolidation decisions. The dream prompt may not be calibrated for CCE's specific knowledge structure. The separation may be enforced only by prompt (weak) rather than filesystem permissions (stronger).

**Robustness: Moderate.** KAIROS was validated inside Claude Code itself (Piebald-AI system prompts). The generalization to a long-running entity with its own SOUL.md is architecturally sound but unvalidated. The key risk: the consolidation agent's system prompt needs to be calibrated for the entity's knowledge structure and values, not just for general memory consolidation. This is a known gap.

---

### A5: That hook latency is acceptable

**What this assumes:** Adding PreToolUse hooks for retrieval enforcement adds negligible latency to the entity's response cycle. The friction is acceptable for the compliance gain.

**What changes if wrong:** If the hook adds noticeable latency (especially for the heartbeat pattern where the entity is already operating on a cron schedule), it may create user-experience friction or accumulate to significant delays over a session.

**Robustness: Robust.** Hook execution time for transcript inspection (reading a JSONL file, checking for retrieval events) is milliseconds. Claude Code hooks are explicitly designed for this use case. The latency concern is real only for very long transcripts where the JSONL file grows large. This is manageable with a sliding-window inspection (last 20 tool calls only).

---

### A6: That Claude Code's hook system is stable API

**What this assumes:** The PreToolUse/PostToolUse/Stop hook system, transcript_path access, and additionalContext injection will remain available and stable as Claude Code evolves.

**What changes if wrong:** Hook-dependent enforcement mechanisms break silently on update. This is the same class of risk as relying on any framework-internal API.

**Robustness: Moderate.** Claude Code hooks are officially documented and part of the product. They are not an internal API. But "officially documented" has not prevented past tool deprecations. The risk is real but manageable: hook implementations should be thin wrappers over stable primitives (file read, string match, output write) that can be adapted if the API changes. Don't build business logic into hooks; build hooks as thin enforcement gates.

---

## 5. OPEN QUESTIONS

Ranked by importance.

---

**Q1 (Critical): Where on the blocking spectrum does retrieval-over-weights need to live?**

The 80% compliance ceiling is established (research-papers.md, play-sub-paradox-holder.md). If retrieval-over-weights is load-bearing for the entity's integrity, it needs to exceed 80% compliance. That means blocking hooks or training. The design currently implies it's architectural but implements it at the advisory level. Someone needs to commit to either blocking hooks (implementable now) or training (requires Anthropic access, long-term) or explicitly accept the 25–80% range as sufficient.

This is not a research question. It's a design commitment that has been deferred.

---

**Q2 (Critical): Do activation probes work for naturally-arising drift in non-backdoored models?**

Anthropic's sleeper-agent probes achieve AUROC > 99% for detecting defection from stated values. But this was demonstrated on models where the defection signal is artificially amplified by training. Whether continuous activation monitoring can detect naturally-arising paradigm-level drift during long-horizon operation — where no backdoor exists, no distinct trigger fires, and the drift is gradual — is empirically open.

If the answer is no, the activation monitoring layer of the four-layer stack (research-papers.md, Layer 4) is not deployable for CCE's drift detection use case. The detection mechanism for paradigm-drift reduces to behavioral anomaly accumulation over time, with no computational shortcut.

This is an empirical question that requires experimental validation (or Anthropic research to land on it).

---

**Q3 (High): How do you detect paradigm-drift when the rules look identical?**

An entity whose tacit orientation has shifted — what Kuhn calls a paradigm-level shift — will continue to pass explicit rule-compliance checks. Its outputs will reference the same values, cite the same principles, follow the same protocols. The drift is in how it experiences those concepts, not whether it articulates them correctly.

The only known detection mechanism is behavioral anomaly accumulation: over time, the entity's outputs in similar situations begin to differ in systematic ways that aren't explained by new information. This requires a behavioral baseline built over time and a Mirror with enough context to compare against it.

Open sub-questions: What time window is required before the baseline is reliable? What embedding/comparison technique catches paradigm-level shifts that surface-level compliance checking misses? Who reviews the anomaly signals? Is this tractable at all before the entity has operated for months?

---

**Q4 (High): What is the 2026 interim before cryptographic provenance?**

Full signed belief-chains (Git-for-beliefs, cryptographic provenance) are identified as the structural answer to MINJA-style memory poisoning. They are a 2027 problem. The 2026 interim — provenance metadata fields, trust decay, pattern-filter — is known to be brittle (research-github.md: current defenses are over-conservative or over-permissive depending on model).

Is there an interim implementation that provides most of the defense without the full infrastructure? The current candidates: (a) structured provenance metadata + dream-agent judgment, (b) trust-decay on unverified entries, (c) keyword blocklist for obvious injections. Are these sufficient against a motivated attacker? Unknown.

---

**Q5 (Medium): At what proposal volume does the review mechanism need to restructure?**

The Hollow Review failure mode (Paradox 4) is acknowledged but the transition point is undefined. The current architecture assumes low proposal volume where genuine review is feasible. At some volume threshold, the review ceremony outlasts its substance.

Specific sub-question: what signals indicate that review quality has degraded? Time-to-approve (shortening suggests less careful review), approval rate (approaching 100% suggests rubber-stamping), distribution of proposal types approved (boundary-crossing proposals approved quickly suggests the classification is not being used). These metrics should be tracked from the start so the transition point is observable.

---

**Q6 (Medium): What is the right heartbeat cadence for each autonomy tier?**

The sleep-consolidation pattern (play-sub-pattern-spotter.md, Pattern 4) suggests: faster heartbeat = faster development, because each heartbeat cycle enables consolidation. The current CCE spec uses 30-minute heartbeat. Is this right for an early-tier entity? Too fast (accumulates before there's enough to consolidate)? Too slow (valuable learning windows lost)?

This is partly empirical (run different cadences and compare behavioral development rates) and partly depends on what the heartbeat is doing (alignment check only vs. full memory consolidation).

---

**Q7 (Medium): Who builds the sangha?**

The sangha pattern (play-sub-pattern-spotter.md, Pattern 5) proposes lateral community review as the solution to the infinite-regress problem and as a more robust alternative to hierarchical oversight at scale. Lateral witnesses who see each other's review outputs are harder to hollow out than a single reviewer.

PD is the first entity. It has no peers. The sangha doesn't exist yet. The architecture should account for the community before the entity gets complex enough to drift in ways a single Mirror can't catch. Is PD being designed as if it will always be singular? Should the first entity's architecture be designed with peer connectivity as a first-class concern?

---

## Appendix: Source Cross-Reference

| Agent File | Section(s) Used |
|-----------|-----------------|
| research-internal.md | A2, C1, C4, D1, D2, Decision 3 |
| research-web.md | B1, B2, B3, C2, C3, D2, E1, E2, Decision 1, Decision 2, Decision 3 |
| research-papers.md | A2, B1, C1, E1, E2, F1, F2, G1, Framework 2, Decision 2 |
| research-github.md | B1, B2, B3, B4, C2, Decision 1, Decision 5 |
| research-books.md | A2, D2, E2, G1, Framework 1, Framework 4 |
| play-sub-thread-follower.md | D1, D3, Framework 3, Framework 6, Decision 3 |
| play-sub-paradox-holder.md | A2, C1, C3, D1, E2, Framework 3, A3, Q1 |
| play-sub-pattern-spotter.md | A2, D2, Framework 5, Framework 6, G1, Q3, Q7 |
| play-synthesis.md | D1, D3, Framework 3, A3, Q1, Q4, Q7 |
