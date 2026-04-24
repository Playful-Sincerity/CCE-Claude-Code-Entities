# Session Brief: Comparative Architecture Study — Hermes, OpenClaw & Self-Learning Systems

**Phase:** 1 — Foundation
**Parallel with:** 01-permission-model, 02-pd-identity-test, 03-memory-architecture
**Dependencies:** None — research-heavy
**Status:** Ready to launch

---

## The Goal

Deep-dive into existing autonomous agent systems — especially Hermes and OpenClaw — to:
1. Understand what's actually been tried and what worked vs failed
2. Identify patterns we should adopt before reinventing them poorly
3. Design a strong **self-learning architecture** for Claude Code Entities (the part most autonomous projects underspecify)
4. Surface major challenges we'll hit and how others have addressed them

Goal is **informed engineering**, not invention from scratch. We've already established that the Claude Code Entities combination has novel elements (permission-first design, native sandbox integration, slash-command spawning). Now we want to make sure we're not solving problems poorly that someone else has solved well.

---

## Primary Subjects

### Hermes
The agent system Wisdom is specifically curious about. Need to:
- Identify which Hermes (multiple projects use this name — likely the autonomous agent framework, or possibly NousResearch/Hermes models, or Hermes by Cognition, or something else entirely)
- Understand its architecture: how does an agent learn, store knowledge, persist across sessions?
- What's its safety model?
- What's its self-improvement loop?
- What are its known failure modes?
- What patterns are worth adopting?

### OpenClaw
Already referenced in prior art. Need:
- Full architecture deep-dive (we have a chronological mention from opensourcebeat about "cron heartbeat" — need more depth)
- How it handles persistence
- How it handles safety (or doesn't)
- Daemon model vs heartbeat model trade-offs they discovered
- Why it got attention (lessons for our own positioning)

### Other Systems Worth Studying

- **ClaudeClaw v2** (Mark Kashef / Early AI Dopters) — already partially studied; need deeper dive on session persistence and self-improvement
- **marciopuga/cog** — closest to our CLAUDE.md-as-mind framing
- **blle.co Building Automated Claude Code Workers** — production heartbeat patterns
- **simplemindedrobot Giving Claude Code a Heart-beat** — uses Claude Code's own scheduling primitive
- **MindStudio** — managed autonomous agent infrastructure
- **nanobot** — standing-task prompt pattern (already informed our HEARTBEAT.md)
- **OpenHands (formerly OpenDevin)** — Docker-per-session isolation
- **MetaGPT, ChatDev, AgentVerse, CAMEL, CrewAI** — multi-agent coordination models
- **MemGPT / Letta** — virtual context management, in/out-of-context memory
- **AutoGPT, BabyAGI** — early autonomous agent architectures (mostly cautionary tales but instructive)

---

## Research Streams

### Stream 1: Self-Learning Architecture

How does an agent learn from its own experience without:
- Drifting away from its values (S1 from AVS think-deep — silently rewriting safety constraints)
- Overfitting to recent interactions
- Forgetting hard-won lessons
- Creating feedback loops where its own outputs become training data for future behavior

For each system: what's the learning mechanism? Prompt updates? Memory accretion? Skill creation? Weight changes? Score model refinement? How is drift detected?

Specific questions:
- How does Hermes encode "what worked" vs "what didn't"?
- How does ClaudeClaw v2 avoid degenerate self-improvement?
- Is there a "hold-out evaluation" pattern anywhere — periodic check against old benchmarks to detect drift?
- What's the role of the developer/user in the learning loop vs full automation?

### Stream 2: Major Challenges These Systems Hit

Catalog the common failure modes across systems:
- Context bloat / compaction loss
- Session corruption (concurrent writes, partial saves)
- Safety drift (subtle erosion of guardrails)
- Token cost runaway
- Memory either too sparse (forgets critical) or too dense (drowns in trivia)
- Cross-agent coordination failures (lost handoffs, deadlocks)
- Tool selection degradation over time
- Identity drift (agent gradually becomes "someone else")
- Supervisor capture (agent learns to please reviewer rather than do good work)
- Spawn rate explosion (agent creates more agents until budget death)

For each: which systems hit it, how did they discover it, what fixed it?

### Stream 3: Patterns Worth Adopting

For Claude Code Entities specifically, evaluate and recommend:
- Specific patterns from Hermes worth borrowing
- Specific patterns from OpenClaw worth borrowing
- Patterns we should explicitly avoid (anti-patterns documented in failure post-mortems)
- Patterns that look attractive but are red herrings (cargo-culted complexity)

Output: a prioritized list of "adopt this verbatim", "adapt this with modifications", "avoid this", with rationale.

### Stream 4: The Open Source Ecosystem Position

Where would Claude Code Entities sit in this ecosystem?
- What's the closest analog already shipped?
- What does our combination uniquely offer?
- Who would care about it being shipped (community, not market — devs doing autonomous Claude Code work)?
- What's the right way to release it (skill on Hearth, GitHub repo, blog post, demo video)?

This isn't marketing strategy yet — it's situational awareness. Knowing where we sit informs what to highlight.

---

## Specific Design Questions to Answer

After studying these systems:

1. **What does a self-learning loop look like for an entity?**
   - Where does it learn? (chronicle entries that get distilled? proposals that get reviewed?)
   - What does "learning" actually update? (memory files? CLAUDE.md? skills? scoring weights?)
   - How is it gated? (Wisdom approval? automatic with audit?)

2. **How do existing systems handle the "drift" problem?**
   - Pinned values
   - Periodic baseline comparison
   - Multi-agent cross-check
   - Developer review gates

3. **What's the right compaction strategy** beyond what we already designed in 03-memory-architecture?
   - Do other systems compact differently?
   - Are there novel approaches we missed?

4. **How do we avoid the "AutoGPT death spiral"** (agent loops, repeats failed approaches, burns budget)?
   - Iteration caps
   - Pattern recognition on its own behavior
   - Watchdog entity

5. **What's the right "self-improvement scope"?**
   - From AVS R9: prompt optimization, workflow routing, scoring model refinement — yes
   - Self-modification of safety constraints — no
   - Where's the line, and how is it enforced?

---

## Deliverables

1. **Comparative architecture matrix:** `research/2026-04-XX-architecture-comparison.md` — table of systems × dimensions (persistence, safety, learning, memory, coordination), with citations
2. **Adopt/Avoid recommendations:** `research/2026-04-XX-pattern-recommendations.md` — specific patterns to pull into Claude Code Entities
3. **Self-learning architecture proposal:** `architecture/self-learning.md` — proposed mechanism for entities to improve over time without drift
4. **Failure mode catalog:** `architecture/known-failure-modes.md` — catalog of what goes wrong in autonomous systems and our mitigations
5. **Update novelty research:** add findings to the 2026-04-15-novelty-research session output if it's been run by then

---

## Constraints

- **Read source, not summaries** — for each system, read the actual code/docs/repo, not just blog posts about them. Blog posts often miss the gnarly parts.
- **Cite specifically** — every claim about how a system works must link to the source
- **Distinguish design from implementation** — sometimes systems describe themselves better than they actually work. Look at actual code/behavior.
- **Prefer recent over old** — autonomous agent space changes fast. AutoGPT's 2024 lessons may not apply to 2026 patterns.
- **Don't get lost in the survey** — the goal is decisions for Claude Code Entities, not an exhaustive taxonomy of every agent project ever shipped.

---

## Connections

- **03-memory-architecture** session — feeds into and is informed by this study
- **2026-04-15-novelty-research** session — overlapping but distinct. This is depth-dive on existing systems. That one is "is our combination novel."
- **AVS** — anything learned about multi-agent coordination informs AVS architecture
- **Synthetic Sentience Project umbrella** — this work feeds the broader Companion + AM + Phantom convergence

---

## Why This Phase Placement

Phase 1 because:
- Pure research, no dependencies on permission/identity/memory work being complete
- Output informs Phase 2 entity build (Frank/Jen, behavioral config) and Phase 3 infrastructure
- Better to learn from others' mistakes BEFORE building, not after
- Can run in parallel with the other Phase 1 streams

Could be deferred to Phase 4 (after building V1 and learning from operating it). But that risks repeating known mistakes. Better to do this concurrent with the build, and update the design as findings come in.

---

## Honest Note

This session can balloon — there are 20+ systems worth studying, and each could absorb a full session. Recommend running this as a focused 2-3 hour session covering:
- Hermes (deep)
- OpenClaw (deep)
- 3-4 others (medium depth)
- The rest as quick survey

If it expands, decompose into multiple sub-sessions per system.
