# Retrieval-Over-Weights as Architectural Default — Closing the Output-Drift Gap in Production Agent Systems

**Status:** idea — requires live measurement
**Estimated length:** systems paper (6–10 pages)
**Target venue:** workshop or arXiv preprint, maybe agent-systems venue

## Claim

Production agent systems are architecturally biased toward weights-generation. Agentic-RAG explicitly treats retrieval-skipping as a feature improvement. This is backwards for long-running autonomous entities.

An entity's default posture should be: **retrieval from grounded sources** (memory, documents, web, research) is the expected path; weights-reasoning is an explicit operation, not a default. The architecture biases toward retrieval.

Concrete implementation in Claude Code Entities:
1. **PreToolUse hook (retrieval gate)** scoped to persistent outputs (Write/Edit to chronicle, proposals, communications, world-model) — requires at least one retrieval since the last persistent output. Block if absent.
2. **Stop hook (retrieval budget)** — nudges if N turns elapse without Read/Grep/WebFetch.
3. **Claim annotation at retrieval source** (not post-hoc self-grading, which is AUC 0.28 — anti-informative).
4. **Sufficiency-gate on retrieval** — if retrieved context is insufficient, abstain; do not fall back to weights (Joren et al. EMNLP 2024).

## Why Novel

Web research across 13+ sources confirmed: no production system ships **retrieval-first-as-declared-default + inline claim provenance + architectural enforcement (hook-level)**. Pieces exist separately. Integration is the gap.

Agentic-RAG (dominant production framing in 2025–26) treats retrieval-skipping as efficiency improvement. This widens the output-drift (hallucination) gap rather than closing it.

## Philosophical Grounding

Strong case from Books research:
- **Clark & Chalmers (Parity Principle):** files that are available, endorsed, and robustly consulted are genuinely part of the cognitive system — not tools, constituents.
- **Hutchins (distributed cognition):** proper cognitive unit is model + files + tools, not model alone.
- **Clark (predictive processing):** weights = prior, retrieved files = high-precision evidence. Retrieval-over-weights = correct precision-weighting.
- **Polanyi (tacit dimension):** the limit — some knowing can't be externalized.

## Key Evidence

- **Web production survey** (13 sources): no shipping system does this integration.
- **Claude Code hook compliance:** 100% for PreToolUse, vs 25–80% for advisory rules.
- **Sufficient Context (arXiv 2411.06037):** capable models confabulate rather than abstain when retrieved context is insufficient — sufficiency classifier is necessary.
- **Mason 2026 (arXiv 2603.20531):** self-reported confidence AUC 0.28–0.36 — anti-informative. Text-layer post-hoc annotation is structurally broken.
- **MemMachine (arXiv 2604.04853):** production analog — retrieval-generation decoupling with immutable core layer.
- **Spec Kit Agents (arXiv 2604.05278):** discovery/validation hooks firing before generation.

## Implementation Requirements

1. Four hooks shipped in CCE (from B5 brief):
   - UserPromptSubmit SOUL injection
   - Stop retrieval-budget counter
   - PreToolUse retrieval gate for persistent outputs
   - Stop SOUL re-injection every K turns

2. Claim annotation at retrieval source (NOT post-hoc):
   - Every retrieval result tagged with source + trust
   - Pre-annotation pattern — commit claim source before retrieval, not after

3. Sufficiency-gate implementation: when retrieval returns low-signal results, entity abstains rather than falls back to weights.

4. Measurement:
   - Hallucination rate before vs after
   - Retrieval frequency per output class
   - False abstention rate (sufficiency-gate overtriggering)
   - User-perceived quality delta

## Source Files

- `../ideas/retrieval-over-weights-as-architectural-default.md` (principle articulation)
- `../knowledge/sources/wisdom-speech/2026-04-16-retrieval-over-weights.md` (original speech)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-web.md` (production gap confirmation)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-papers.md` (theoretical backing)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-books.md` (philosophical foundation)
- `../research/think-deep/2026-04-16-two-drift-types-unified-answer/agents/research-github.md` (implementation precedents)
- `~/claude-system/rules/stateless-conversations.md` (precedent at conversation layer)

## Open Questions

1. Where does the retrieval-first principle break? (Creative synthesis, analogical reasoning, quick informational queries — Challenger correctly scoped it away from universal.)
2. What's the right output-type classification that the PreToolUse gate uses to decide "persistent enough to require retrieval"?
3. Cost-benefit — latency added by retrieval gate vs quality improvement?
4. Pre-annotation vs post-annotation — is pre genuinely a different mechanism, or a temporal displacement of the same self-grading problem?

## Draft Outline (tentative)

1. The production-gap observation — why agentic-RAG is backwards
2. Philosophical grounding — five pillars for externalization-over-internal-state
3. The architectural mechanism — hooks + annotation + sufficiency gate
4. Scoping — where retrieval-over-weights applies and where it doesn't
5. Implementation in CCE
6. Measurement and results
7. Related work — MemMachine, Spec Kit Agents, Agentic RAG critique
8. Limitations, open questions

## Prerequisite: Build B5 + 3 months live

B5 ships the hooks. Paper drafts after ~3 months of live data.
