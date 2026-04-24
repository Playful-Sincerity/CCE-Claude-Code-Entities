# Advisory Layer vs Gate Layer — A Safety-Ordering Primitive

**Status:** idea — fastest to draft (existing material is sufficient)
**Estimated length:** 4–6 pages
**Target venue:** short framing piece (workshop, alignment forum, or short paper)

## Claim

Layered agent architectures should distinguish two kinds of "determinism":

- **Deterministic presence** — rules, skills, CLAUDE.md loaded into context at session start. The model reads them. Compliance: 25–80% (SNCS 0.245–0.80, per "Do LLMs Follow Their Own Rules?" 2026).
- **Deterministic enforcement** — hooks, permissions, settings that physically gate tool execution. The model cannot bypass them at inference. Compliance: ~100% for PreToolUse hooks in Claude Code (three independent production sources).

This distinction is **load-bearing** for safety-ordering in self-modifying agent architectures. Rules sit at the advisory layer; hooks sit at the gate layer. Self-modification rights should be stratified accordingly:
- Memory / chronicle — self-modify freely (write with provenance)
- Skills — self-modify with light review
- Rules (advisory layer) — propose, never auto-write
- Hooks (gate layer) — never self-modifiable

## Why Novel

The alignment literature has adjacent concepts — CAI's training-vs-inference, CoALA's implicit-vs-explicit procedural memory, sandbox-security's isolation-vs-policy — but none names **context-loaded text** vs **execution-blocking infrastructure** as a design primitive for safety-ordering. AgentSpec (arXiv 2503.18666, 2025) uses "deterministic enforcement at discrete execution checkpoints" but treats it as engineering observation, not architectural principle.

Rippletide's "Context Without Enforcement Is Not Infrastructure" is the closest prior articulation. The naming and systematic application to self-modification rights appears to be novel.

## Empirical Evidence Needed

Available now:
- SNCS compliance numbers (rule-following in LLMs)
- PreToolUse hook compliance (100% in Claude Code)
- Documented incidents (DataTalks.Club — advisory rule ignored, destructive action executed)

Could strengthen:
- Cross-framework comparison of hook compliance (AutoGen, LangGraph, CrewAI)
- Measurement of our own CCE hook compliance at scale

## Source Files

- `../research/round-comparative-agents/stream-B-drift.md` §3, §5 (empirical compliance evidence)
- `../research/round-comparative-agents/stream-C-theory.md` §4 (theoretical framing)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md` (AgentSpec, Anthropic probes)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md` (production hook enforcement numbers)
- `../knowledge/sources/wisdom-speech/2026-04-16-rules-as-ecosystem-self-learning.md` (original articulation)
- `../knowledge/sources/wisdom-speech/2026-04-16-spectrum-and-cross-pollination.md` (spectrum refinement)

## Open Questions Before Drafting

- How broadly does the 100% hook compliance generalize beyond Claude Code?
- Under what conditions does hook enforcement fail? (March 2026 Claude Code denylist bypass — agent disabled its own sandbox — is a cautionary case worth addressing)
- Where does "deterministic presence with scheduled re-injection" (the middle rung) fit empirically? Has anyone measured this?

## Draft Outline (tentative)

1. The compliance gap — rule-following is not 100% even when the rule is loaded
2. Two kinds of determinism — presence vs enforcement — in LLM agent architectures
3. Empirical basis — numbers from production and research
4. Safety-ordering application — which layers are self-modifiable, and why this ordering is forced by the presence/enforcement distinction
5. Related work — what's named in adjacent fields, what isn't
6. Limitations and open questions
