# Papers — Candidate Ideas

Four candidate papers emerging from the 2026-04-16 drift research round and think-deep session. Ideas stored here until implementation provides empirical grounding to draft from.

## Policy

- **Store now, draft later.** Each file captures the claim, novelty, and source material. Draft when real measurements are available from implementation.
- **Fastest to draft** = advisory-vs-gate (existing material is sufficient).
- **Most implementation-tied** = sleep-loop-unification and retrieval-over-weights (want live data).
- **Biggest contribution** = three-drift-types (taxonomy + defense stack + honest residual-risk framing).

## Files

| File | Claim (one line) | Status |
|------|------------------|--------|
| [advisory-vs-gate.md](advisory-vs-gate.md) | Layered agent architectures should distinguish *deterministic presence* (context-loaded rules) from *deterministic enforcement* (execution-gating hooks) as a safety-ordering primitive | idea — fastest to draft |
| [three-drift-types.md](three-drift-types.md) | Autonomous agents face three architecturally distinct drift types (output / value / paradigm), requiring different mechanisms — paradigm-drift is currently residual risk | idea — largest contribution |
| [sleep-loop-unification.md](sleep-loop-unification.md) | A scheduled restricted-subagent "sleep loop" unifies self-learning, drift audit, and compaction preparation via one architectural mechanism | idea — wants implementation data |
| [retrieval-over-weights.md](retrieval-over-weights.md) | Retrieval-over-weights as architectural default, implemented via PreToolUse hooks scoped to persistent outputs, closes the output-drift gap that production agentic-RAG systems widen | idea — requires live measurement |

## Ecosystem Fit

These papers would live under the **PS Research** umbrella, under the **Synthetic Sentiences Project** theoretical layer. Claude Code Entities is the operational surface where the architectural mechanisms they propose would be tested. Framing: persistent agent entities — how do you create consistent beings, not just functional agents?

## Source Corpus

All four papers draw from:
- `../research/round-comparative-agents/` — Streams A, B, C (drift mechanics, theory)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer.md` — synthesis + 11 supporting agent files
- `../knowledge/sources/wisdom-speech/2026-04-16-*.md` — preserved speech primary sources
- `../ideas/retrieval-over-weights-as-architectural-default.md` — principle articulation
- `~/claude-system/rules/stateless-conversations.md` — precedent at conversation layer

## Related public-facing writing

- **[Digital Core Methodology](../../../PS%20Research/Digital%20Core%20Methodology/)** — the methodology paper presented at Frontier Tower 2026-04-20. Repo: `github.com/Playful-Sincerity/Digital-Core-Methodology`. Written in first-person-AI voice; the closest generalization of the CCE pattern beyond PD specifically. Reference rather than draft-source — these papers extend the methodology, they don't restate it.
- **[`../concept-paper/2026-04-23-cce-concept.md`](../concept-paper/2026-04-23-cce-concept.md)** — today's forward-looking positioning artifact for CCE. Names the four design axes (permissions / heartbeat / memory / voice). The paper ideas here sit downstream of this framing.

## Caveat

All four papers are **idea-stage, not draft-stage**. Each file captures the claim, novelty, and source material. Drafting waits for live implementation data — which, per [`../STATUS.md`](../STATUS.md), is partially available (permission hardening) and partially not (heartbeat-driven operation is still pending deployment). Drafts should be sequenced against what the operational system can actually evidence.
