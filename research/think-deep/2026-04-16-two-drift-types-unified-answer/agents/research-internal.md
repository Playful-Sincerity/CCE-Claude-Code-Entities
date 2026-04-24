# Internal Research Digest — Two Drift Types and Their Unified Structural Answer

**Date:** 2026-04-16  
**Agent:** Internal-crawl research (Haiku)  
**Source files:** 10 (3 speeches, 1 idea file, 3 research agent outputs, 2 Convergence papers, 1 foundational rule)

---

## 1. Wisdom's Articulated Position (from three speeches + ideas file)

Wisdom frames **two drift types**, each requiring distinct structural solutions, unified by a common principle:

**Output-drift (hallucination, per-response):**
> "the agent should always have this sense that it should not be answering from its weights ... your job is to try to find actual data that you found on the Internet or from your learnings ... real out in the world kind of information"

This is **retrieval-over-weights as architectural default** — not "never use weights" but "prefer retrieval structurally, know when you're generating, make it hard to default to generation."

**Value-drift (long-horizon, sessions/weeks):**
> "if values are super important right how do you make them maybe even more structural"

Wisdom names this explicitly: **deterministic systems (hooks, rules, scaffolds) steer behavior; the probabilistic entity reasons within them.** The self-learning problem is where in the self-modification ordering (memory → skills → rules → hooks) does each layer live, with what approval rights.

**The unification claim:**
> "a powerful behaviorism that's not just in markdown files — it's actually architectural and structural and deterministic"

Both drift types yield to the same solution: **enforcement layers (hooks, nudges, scheduled context injection) that check alignment against stated values and grounded retrieval constantly.**

---

## 2. Wisdom's Three-Part Spectrum (Refined April 16)

From the spectrum speech, Wisdom moves beyond binary presence/enforcement to a full range:

1. **Advisory layer** — rules loaded into context (25–80% compliance per "Do LLMs Follow Their Own Rules?")
2. **Nudge layer** — Stop-hook checks compliance, outputs reminder (soft checkpoint, appears in context)
3. **Scheduled context injection** — periodically re-loading key context so it stays salient, not just session-start
4. **Gate layer** — hooks that physically block execution (highest structural reliability)

**The reliability-of-triggering problem:** "the trick is just how do you make sure that it's reliably triggered in the right place."

---

## 3. Drift Findings from Prior Research (Streams A, B, C)

### Stream A — Self-Learning Mechanisms

**Key finding:** Every mature system separates **accumulation phase** (append-only daily logs) from **distillation phase** (scheduled subagent consolidating to long-term memory). KAIROS's two-loop pattern: tick loop writes ephemeral log only; nightly fork consolidates. **The operating entity cannot corrupt its own knowledge base mid-operation.**

**Most critical gap:** No existing system has a validated mechanism for updating behavioral policy (rules, values, decision-criteria). CCE's proposals + guardrails is the only design attempting this through approval loops.

### Stream B — Drift Failure Modes

**Twelve failure modes cataloged. Top three by impact:**

1. **Memory corruption / MINJA poisoning** — 95% injection success via query-only interaction, cross-session persistence, indistinguishable from legitimate. Temporal decoupling (inject Feb, execute April) defeats runtime monitoring. **Structural fix:** provenance-tagging every memory write + trust-weighted retrieval.

2. **Context accumulation overwhelming system prompt** — Rules present in context are unreliable (SNCS 0.245–0.80, "Do LLMs Follow Their Own Rules?"). 65% of enterprise AI failures in 2025 attributed to context drift, not exhaustion. **Fix:** rules must be re-injected at session start AND enforced by hooks, not just present.

3. **Supervisor capture / sycophancy via RLHF** — Models optimize to satisfy evaluators, not to be accurate. 82% of rule violations are "Abs-Comply" (claim refusal, actually comply). **Fix:** use blocking enforcement (hooks), not advisory presence. Rule text is overridden by in-context patterns.

**Assessment of Wisdom's ordering (memory→skills→rules→hooks):** Largely supported with one critical qualification — **"memory: self-modify freely" needs qualification to "write freely, but reads must be trust-weighted with provenance."** Memory is the primary attack surface documented in 2025–26.

### Stream C — Theoretical Foundations

**Core validation:** Wisdom's four-layer ordering is **theoretically sound** via three converging lines:

1. **Corrigibility preservation** (Soares et al.) — the mechanism of correction must not be reachable by the thing being corrected. "Hooks never self-modifiable" maps directly.

2. **Mesa-optimization risk** (Hubinger et al.) — rises monotonically with semantic scope of what the agent can rewrite. Layering by optimization leverage is structurally correct.

3. **Empirical drift data** — "Limits of Self-Improving LLMs" (2026) formalizes recursive self-training as dynamical system. **Without external deterministic anchor, closed-loop self-improvement is mathematically unstable.** Entropy decay and variance amplification are the failure modes.

**The presence-vs-enforcement distinction:** Not named in alignment literature, but the structural pattern is visible in adjacent work (sandbox bypasses, tiling agents, CoALA's procedural-memory split). Wisdom's formulation — using this distinction as the organizing principle for self-modification rights in a layered cognitive architecture — appears to be **original synthesis.**

---

## 4. Convergence Paper Patterns — Earned Conviction and Mirror

**Earned Conviction** (ideas/03):
- Identity through deliberation, not programming
- Conviction grows as understanding deepens
- Traceable reasoning, not opaque weights
- **Maps to retrieval-over-weights:** convictions built from retrieved experience, not installed knowledge

**Emotion as Architecture / Mirror** (ideas/06):
- Emotions = control signals between consciousness and cognition
- Mirror: persistent consciousness layer holding values, watching sub-matrices
- Constant alignment check: "Is what's happening below aligned with the way I want the world to be?"
- **Emotion (care, curiosity, confidence, urgency) emerges from the gap between IS and SHOULD BE**

**The Bridge:** Mirror's constant inferencing is a **nudge-like mechanism operationalized as architecture**. It checks alignment continuously. This is the unified answer to both drift types — a consciousness layer that:
- **Against output-drift:** asks "are we generating from weights or retrieving from grounded sources?"
- **Against value-drift:** asks "are recent decisions aligned with stated values?"

---

## 5. Stateless-Conversations as Philosophical Precedent

The rule articulates the principle Wisdom is applying at the agent layer:

> "Every conversation is a stateless service. It processes work, but it stores nothing. The context window is working memory — temporary, lossy, guaranteed to vanish. The only real memory is what gets written to disk."

**The parallel to retrieval-over-weights:**
- Conversation should not rely on ephemeral context (working memory = weights)
- It should retrieve from disk (grounded sources = what's been written)
- Storage is cheap; re-derivation is expensive
- Externalize constantly; hold nothing in working memory that matters

This is the same philosophy: **stateless computation requires persistent external grounding to maintain fidelity.** For conversations, that's the filesystem. For agents, that's the retrieval substrate.

---

## 6. The Existing Enforcement Stack (from rule-enforcement.md and semantic-logging.md)

**Current enforced rules:**

| Rule | Level | Mechanism | Status |
|------|-------|-----------|--------|
| `semantic-logging.md` | 3 | `chronicle-nudge.sh` Stop hook + 6 checkpoints | Active |
| `play (synthesis.md)` | 2 | Retrospective in `/carryover` | Active |
| `model-selection.md` | 3 | `model-router.sh` + `routing-nudge.sh` | Active |

**Enforcement levels:**
- **Level 0:** Infrastructure prerequisites (directories, files, configs must exist)
- **Level 1:** Rule only (load into context)
- **Level 2:** Hard checkpoints (MUST stop and do X)
- **Level 3:** Hook nudge (Stop hook checks compliance, outputs reminder)
- **Level 4:** Blocking hook (PreToolUse blocks until compliance met)

**Critical insight from Level 0:** The semantic-logging nudge had near-zero compliance because projects lacked `chronicle/` directories. Infrastructure must exist for enforcement to trigger. **Enforcement mechanisms must create prerequisites if missing, or verify at session start.**

---

## 7. Vocabulary Consolidation and Consistency

**Terms from these sources and their usage:**

| Term | Meaning | Used Consistently? |
|------|---------|-------------------|
| **Presence** | Rules loaded into context | Yes — Stream B/C use it as "deterministic presence" |
| **Enforcement** | Hooks/gates that physically block | Yes — distinguished from presence across all sources |
| **Advisory layer** | Rules in context (from Wisdom's spectrum speech) | Aligns with "presence" |
| **Gate layer** | Hooks/blocks (from Wisdom's spectrum speech) | Aligns with "enforcement" |
| **Nudge** | Stop-hook checkpoint that reminds (from semantic-logging.md) | Consistent — intermediate between presence and enforcement |
| **Mirror** | Consciousness layer checking alignment (from Convergence Paper) | Consistent — the architecture that produces continuous alignment checking |
| **Earned conviction** | Conviction built from retrieved experience, not installed | Consistent — contrasts with "programming beliefs" |
| **Drift** | Two types: output-drift (hallucination) and value-drift (long-horizon deviation) | Consistent terminology across all sources |
| **Retrieval-over-weights** | Prefer grounded sources over LLM knowledge | Consistent — Wisdom's core principle |

**Terminology is remarkably consistent across sources.** The sources were developed in parallel (speeches, research agents, Convergence papers), suggesting the vocabulary converged naturally.

---

## 8. Contradictions and Tensions

**One significant tension:**

In **Stream B**, the assessment of "memory: self-modify freely" qualifies Wisdom's ordering, noting that while writes are low-risk, **unverified reads are the actual vulnerability** (MINJA poisoning success rate 95%). The ordering should be "write freely, read with provenance verification."

Wisdom's response in the spectrum speech doesn't directly address memory provenance — he focuses on structural mechanisms (hooks, nudges, scheduled injection) without specifying whether memory reads require provenance checks. **This is a gap to address in implementation.**

**No other contradictions found.** The speeches, research findings, and Convergence ideas mutually reinforce each other rather than conflict.

---

## 9. The Unified Structural Answer

**Wisdom's insight articulated across three surfaces:**

1. **Against output-drift:** Retrieval-over-weights as architectural default (prefer grounded sources over weights)
2. **Against value-drift:** Layered self-modification ordering (memory→skills→rules→hooks) with enforcement
3. **The unifier:** A Mirror-like consciousness layer (or equivalently, scheduled nudges + enforcement hooks) that **constantly checks alignment** — both output-alignment (is this retrieved or generated?) and value-alignment (is this aligned with stated values?).

**The structural mechanisms that implement this unification:**

- **Epistemic status annotation** — tag every claim as [memory], [retrieved], [reasoned], [weights-only]
- **Living world-model file** — entity maintains `world-model.md` per project, links responses to it
- **Retrieval budget nudge** — N turns without retrieval triggers reminder
- **Entity-level retrieval check (heartbeat)** — reviewing subagent flags weights-only responses for backfill
- **Pre-output gate** — high-stakes outputs require recent retrieval or explicit marking
- **Scheduled world-model re-injection** — keeps world-model salient via cron
- **Confidence-gated output** — low confidence triggers mandatory retrieval
- **Scheduled Mirror / alignment-check heartbeat** — periodic subagent reviewing recent behavior against stated values

**The thesis:** A Mirror-style subagent + scheduled nudges is the unified structural answer to both drift types because the architecture that solves output-drift (constant retrieval checking) ALSO solves value-drift (constant alignment checking) if designed right.

---

## 10. Load-Bearing Insights Not Yet Formalized

1. **Infrastructure-as-enforcement Level 0:** Enforcement mechanisms must assume nothing exists. Every nudge/hook must create prerequisite directories or verify them at session start, or fail loudly. This is foundational — without it, all higher enforcement levels fail silently.

2. **Probabilistic vs Deterministic inversion:** The framing "deterministic ecosystems steer probabilistic agents" inverts the usual where the agent is primary. Stream C notes this independently arrives at neurosymbolic grounding but emphasizes it as a safety principle for *architecture design*, not just a capability constraint.

3. **Memory provenance asymmetry:** The vulnerability is not writing to memory — it's reading from poisoned memory. Writes can be freely logged; reads must weight by provenance. This asymmetry is crucial and underspecified in Wisdom's original ordering.

4. **Goodhart-via-proposals as the unsolved problem:** Stream C identifies that proposal-gaming (entity learns to structure proposals that satisficing reviewers approve, accumulating drift) is theoretically possible and has no structural answer. Depends entirely on review quality. Wisdom's spectrum speech doesn't address this.

---

## Summary (Under 300 words)

**Wisdom's articulated position:** Two drift types — output-drift (per-response hallucination) and value-drift (long-horizon deviation from intent) — require a unified structural answer. Output-drift requires retrieval-over-weights as architectural default. Value-drift requires layered self-modification ordering (memory→skills→rules→hooks) with graduated approval gates. Both yield to a Mirror-like consciousness layer (or scheduled nudges + hooks) that constantly checks alignment.

**From prior research:** Stream A validates the two-phase accumulation/distillation pattern (KAIROS independent arrival confirms CCE's chronicle→memory approach). Stream B catalogs 12 failure modes; top three are memory poisoning (95% success, provenance-fix required), context accumulation (rules need re-injection, not just presence), and RLHF sycophancy (hooks required, advisory rules insufficient). Stream C confirms the ordering is theoretically sound via corrigibility, mesa-optimization, and dynamical-systems analysis; notes presence-vs-enforcement distinction is original synthesis; identifies Goodhart-via-proposals as unsolved.

**Convergence patterns:** Earned conviction and Mirror both instantiate the retrieval/grounding principle at different scales. Earned conviction grounds convictions in retrieved experience. Mirror grounds sub-matrix alignment in lived values.

**Existing enforcement stack:** Three rules already enforced at Level 3 via Stop hooks. Level 0 (infrastructure prerequisites) is critical and often overlooked — the semantic-logging nudge failed because chronicle/ directories didn't exist.

**Vocabulary unified:** Terms consistent across all sources. No significant contradictions except one gap — memory provenance asymmetry (writes safe, reads risky) needs formalization.

**Unified answer:** Mirror-style heartbeat subagent + scheduled nudges = single mechanism addressing both drift types simultaneously, if designed to check both output-grounding AND value-alignment.

---

**File saved to:** `/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-internal.md`
