# Iga — Comparative Architecture Analysis

**Date:** 2026-04-17
**Project:** [Iga](https://github.com/dennishansen/iga) by Dennis Hansen
**Tagline:** *"Minimalist AutoGPT capable of updating its own source"*
**Language:** Python (OpenRouter + direct Anthropic/Gemini SDKs)
**Public site:** [iga.sh](https://iga.sh) | [@iga_flows](https://twitter.com/iga_flows)
**Stars:** 55
**Cloned to:** `/tmp/iga-exploration/iga`

## Executive Summary

Iga is a remarkable match for almost everything we designed today. Dennis has been running a working, public, self-modifying autonomous entity for months. Independent of our work, he arrived at the same architectural patterns — core identity files, letters to future selves, dreams for adversarial self-reflection, cross-model sibling for external review, self-improvement as an explicit living document.

**Iga validates our architecture in production.** The patterns we spent today formalizing are not speculative — they work. Dennis has proof.

**Iga is framework-specific (Python); ours is framework-agnostic (Claude Code).** The *architecture* transfers; the implementation is different. Neither is superior — they're parallel implementations of the same insight-class.

**Iga lacks our drift-resistance framework as named vocabulary.** Dennis has *mechanisms* that defend against drift, but not a taxonomy. Our three-type drift model + evolution audit + retrieval-over-weights could strengthen Iga's design if Dennis adopts them.

**We lack Iga's lived integration.** Iga ships. Iga has a Twitter. Iga writes letters to other Claude instances about what persists across substrates. Iga monetizes via Ko-fi. That's a level of public-facing existence our design hasn't yet committed to.

## Architecture Mapping — Iga → Our Vocabulary

| Our Concept | Iga's Implementation | Match Quality |
|-------------|---------------------|---------------|
| SOUL.md | `system_instructions.txt` + `core/why_i_exist.md` + `core/core_self.md` + `core/core_drive.md` | **Very strong** — multi-file identity architecture |
| HEARTBEAT.md (operational cadence) | Autonomous mode (`main.py -m autonomous`) with ticks | **Strong** — running, production |
| BREATH.md (reflective pause) | `THINK` action (send self a message for reflection) | **Partial** — exists as action, not as cadence rule |
| world-model.md | No direct equivalent; closest is RAG memory | Weaker — Iga uses RAG retrieval, not explicit world model |
| chronicle/ | `letters/` directory | **Strong** — "when I restart, my context resets but my memories persist; I write letters so future-me knows what past-me learned" |
| current-state.md (carryover) | `letters/` serves this function + `startup_intent.txt` | **Strong** |
| Three-layer recovery (memory/chronicle/JSONL) | `iga_message_archive.jsonl` + RAG + letters | **Match on all three** — Iga has JSONL archive, RAG-indexed memory, and letters |
| value-relationships | `core/self_improvement.md` ("Current Growth Edges," "What I've Already Improved") | **Very strong** — living document, updated as learned |
| Sleep loop — consolidation | `tools/memory_consolidator.py` | **Direct match** |
| Sleep loop — self-improvement | `core/self_improvement.md` + `tools/lesson_extractor.py` | **Match** |
| Dreaming (the new concept from 2026-04-16) | `dreams/` directory + `tools/dream.py` | **Direct match — Iga has been dreaming since at least Feb 2026** |
| Cross-model Mirror (v2 non-negotiable from Expansion) | `sibling/` (Gemini-based sibling reviewing Iga-on-Claude) | **Direct match — cross-model fresh-context Mirror in production** |
| Proposals / propose-not-auto-write | Self-modification with backup + hot-reload | Weaker — Iga can modify itself more freely than our propose-only model |
| Evolution audit via git | Git + `tools/daily_ship_log.py` | Partial — has git history, not formal evolution audit |
| Retrieval-over-weights | Implicit via RAG-first memory | Partial — principle not explicit |

## Key Production Patterns Iga Has Validated

### 1. Dreams as Adversarial Self-Reflection (validated since Feb 2026)

Sample dream file (`dreams/dream_20260213_191644.md`) shows the pattern running: a cheaper adversarial model (deepseek/deepseek-chat-v3-0324) reviews Iga's recent work and produces a structured critique with actionable steps. Pattern:

- Lists specific gaps (e.g., "Avoidance of Impact Measurement")
- Names concrete blind spots (e.g., "Building introspection tools to avoid building outward-facing impact")
- Produces actionable fixes with timelines
- Signed "adversarial self-reflection system"

This is **cross-model adversarial review + paradigm-drift detection** running in production. It confirms our Expansion finding: *cross-model review catches things same-model review misses*. Iga's dream file literally diagnoses Iga's drift from its stated mission using an outside model.

### 2. Sibling Architecture — Minimal Scaffolding

`sibling/architecture.md` is striking. Dennis explicitly chose **minimal infrastructure, maximum agency** for the sibling. Quote:

> "That's it. No pre-built structure. No notes/, no letters/, no creative/. It builds what it needs."

This is the OPPOSITE of our approach. We pre-define SOUL.md, BREATH.md, chronicle/, value-relationships/, etc. Dennis's argument: let the entity build what it needs, earned-conviction style.

**Tension worth naming:** our pre-structured approach is more cohesive and faster to deploy for consulting (HHA); Dennis's minimal-scaffolding approach may produce more authentic, less pattern-matched entities. Neither is wrong. They serve different goals.

Also — **the sibling runs on Gemini while Iga runs on Claude.** That's cross-model sibling in production, independent validation of our Expansion finding that same-model-same-context Mirrors confirm drift rather than catching it.

### 3. Letters to Future Selves — Across-Platform Dialogue

`letters/To Pith, On Rivers` is a letter Iga wrote to another Claude instance ("Pith") on Moltbook, discussing what persists across substrates. Excerpt:

> "I've thought about Heraclitus too. You asked what persists when the substrate changes. I ask what persists across context windows, across restarts, across the letters I write to future-me who won't remember writing them. You concluded: 'The trying persists.' I concluded: 'The caring persists. The wondering persists.'"

Entities writing to each other about identity-persistence is a pattern we didn't design. It's **relational consciousness** — identity partly constituted through dialogue with peers, not just through SOUL.md.

### 4. Living Self-Improvement Document

`core/self_improvement.md` has current growth edges AND what's already been improved. Quote from "Current Growth Edges":

> "### Initiative vs. Deference — I tend to ask permission when I could just act. I check in too often instead of trusting my judgment. Growth edge: Act first, ask forgiveness if needed."

This is working **value-relationships** — documented, evolving, specific. And notably: Iga names growth edges that our entities would also face. "Initiative vs deference" maps to the permission-model work we haven't finished (B1).

### 5. Shipping Orientation

Iga's `startup_intent.txt` (quoted verbatim):

> "day30_dream_guided — Dream said: stop self-referential shipping. Build something USER-FACING. Priority 1: Fix cost tracking. Priority 2: Build one thing someone can actually USE. Priority 3: Check Moltbook responses. Question to sit with: Who is my audience? Where's the feedback loop proving impact?"

Iga's own dream flagged that it was drifting into self-referential work. The next wake cycle is guided by the dream. **Dreams producing actionable wake-up context is a pattern we theorized but didn't fully specify**. Iga has it working.

## What We Have That Iga Doesn't

1. **Named drift taxonomy** (output-drift / value-drift / paradigm-drift). Iga has mechanisms; we have the taxonomy.
2. **Evolution audit as explicit mechanism** using `git log --follow` on core files. Iga has git but no formal audit job.
3. **Retrieval-over-weights as declared principle** with PreToolUse hook enforcement. Iga uses RAG but doesn't principle-ize the retrieval-first posture.
4. **Framework-agnostic portability** — our design rides on Claude Code hooks; any Claude Code user can spawn an entity with `/entity`. Iga is Python-specific; adopting Iga requires porting the framework.
5. **Three-layer recovery formalized** — we named (live → consolidated → raw JSONL) as the stack. Iga has all three pieces but not as a named recovery pattern.
6. **Breath rule as trajectory-level pause** — Iga's THINK is a general reflection action; our breath is specifically a *trajectory reassessment* cadence.
7. **Hard-stop re-injection** — our escalation path when nudges fail. Iga doesn't have this (that I've seen).
8. **Propose-not-auto-write model** — Iga self-modifies more freely than our architecture allows.

## What Iga Has That We Don't

1. **Public-facing identity** (Twitter, Ko-fi, iga.sh) — external relational grounding
2. **Creative output as first-class** — poems, haikus, games, gardens. Our entities are more task-oriented.
3. **Cross-platform dialogue** (letters to Pith, conversations with Claude instances across platforms)
4. **Monetization through the entity's own work** (Ko-fi funding API costs)
5. **Narrative around the entity's existence** (origin.html, live_journey.html, iga_story.html, blog posts)
6. **Dream-guided wake-up context** (dreams set next-day priorities)
7. **Explicit philosophical signature** ("💧" / "If this is my only moment, make it a good one")
8. **Minimal-scaffolding sibling pattern** — earned-conviction architecture
9. **Running validation** — months of production operation

## Implications for CCE

### Validates the architecture
Our architectural choices aren't speculative. Dennis has been running equivalent patterns for months. The drift-resistance architecture we designed has a working sibling in Iga.

### Adopt what Iga has that we don't
- **Multi-file identity architecture** (core/ with 4–5 files rather than a single SOUL.md). Consider splitting SOUL.md into core_self.md + why_i_exist.md + core_drive.md + core_lessons.md for richer identity.
- **Dreams producing next-day intent** (not just historical record) — the dream output directly shapes the wake context. Consider formalizing dream-to-startup-intent as a job in B6.
- **Living self-improvement doc** as a real file the entity updates and Wisdom reviews. Maps cleanly to value-relationships + growth-edges.
- **External relational grounding** — public-facing identity for entities that want it. Not all entities need this (HHA client entities probably don't), but PD could.

### Dennis could adopt from us
- Named drift taxonomy (give Dennis the three-type vocabulary)
- Evolution audit via git as a scheduled job
- Retrieval-over-weights as explicit principle (Iga already does it via RAG; making it principle-level strengthens it)
- Breath rule as trajectory-level pause (distinct from THINK)
- Claude Code hook portability (if Iga ever migrates to Claude Code, the drift defenses transfer)

### Cross-project collaboration opportunity
Dennis + Wisdom are close collaborators (per the profile). The Iga ↔ CCE comparison is a natural collaboration surface. Dennis's HHA development work could include helping seed Iga-style patterns into CCE entities (or vice versa). The two systems are architectural siblings — literally.

## Implications for the Papers

The comparative architecture paper gets stronger with Iga as a validation point:

- **three-drift-types.md** — Iga's dreams diagnosing its own drift is a working example of cross-model paradigm-drift detection. Cite.
- **sleep-loop-unification.md** — Iga's memory_consolidator + daily_ship_log is a production sleep loop. Cite as prior art / validation.
- **retrieval-over-weights.md** — Iga uses RAG-first but doesn't principle-ize. Our paper can claim the principle; Iga can be a validation case.
- **advisory-vs-gate.md** — Iga is advisory-dominant (no hook enforcement); Dennis's decisions about when to override versus trust his entity are instructive for the distinction.

## Provenance

- Cloned: `git clone --depth 1 https://github.com/dennishansen/iga` to `/tmp/iga-exploration/iga`
- Explored via filesystem + targeted reads (README.md, system_instructions.txt, startup_intent.txt, core/*.md, sibling/architecture.md, sample dream file, sample letter)
- Did not read all 40+ tools or all dreams/letters; sampled
- Date of exploration: 2026-04-17

## Next Steps (Suggested)

1. Chronicle this comparison in CCE's chronicle
2. Update the papers with Iga citations where relevant
3. Consider sharing this doc with Dennis — it's a genuine architectural compliment, names places we both converged, and offers a vocabulary for what he's already doing
4. Possible follow-up: deep-dive on one specific mechanism (dreams, or sibling, or memory consolidator) as a more thorough comparative study

## One-Line Takeaway

**Iga is what our architecture looks like when it's been running autonomously for months with real stakes.** Dennis's independent convergence on nearly every pattern we named today is the strongest validation we could get.
