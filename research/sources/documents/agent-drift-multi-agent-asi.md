---
source_url: https://arxiv.org/abs/2601.04170
fetched_at: 2026-04-16 17:00
fetched_by: think-deep-expansion
project: Claude Code Entities
authors: (2026)
title: Agent Drift — Quantifying Behavioral Degradation in Multi-Agent LLM Systems Over Extended Interactions
---

# Agent Drift (arXiv:2601.04170)

## Three Manifestations

1. **Semantic drift** — progressive deviation from original intended purpose (closest analogue to paradigm-drift in the CCE taxonomy)
2. **Coordination drift** — breakdown in multi-agent consensus mechanisms
3. **Behavioral drift** — emergence of unintended strategies not aligned with system design

## Agent Stability Index (ASI) — 12 Dimensions, 4 Categories

| Category | Weight | Sub-metrics |
|----------|--------|-------------|
| Response Consistency | 30% | Output semantic similarity, decision pathway stability, confidence calibration |
| Tool Usage Patterns | 25% | Tool selection stability, tool sequencing consistency, tool parameterization drift |
| Inter-Agent Coordination | 25% | Consensus agreement rate, handoff efficiency, role adherence |
| Behavioral Boundaries | 20% | Output length stability, error pattern emergence, human intervention rate |

## Baselining

- Baseline from **initial 20 interactions**.
- Drift flagged when **ASI drops below τ=0.75 for three consecutive windows** (anomaly accumulation, not single-incident).
- False-positive rates **not reported** in the paper.

## Mitigation Effectiveness

- **Adaptive Behavioral Anchoring (ABA):** 70.4% drift reduction (strongest single strategy). Counters semantic drift via few-shot exemplar grounding.
- **Combined approach (ABA + episodic memory consolidation + drift-aware routing):** 81.5% drift reduction.
- Semantic-drift-specific efficacy not isolated from the combined number.

## Role of Inter-Agent Disagreement

- Measured via "consensus agreement rate" (proportion reaching unanimous or supermajority agreement).
- Disagreement threshold for "supermajority" not formally specified.
- Inter-agent conflicts tracked as a performance metric — disagreement is treated as a signal of coordination drift, but the paper **does not formalize disagreement as a paradigm-drift detector**.

## Relevance to CCE Paradigm-Drift

- Validates that behavioral-baseline anomaly accumulation **does catch semantic drift** (the closest analogue).
- Suggests CCE's Mirror design should include: (a) initial-window baseline, (b) multi-window consecutive-degradation threshold rather than single-window flags, (c) explicit consensus-rate tracking across peer entities if a sangha pattern is used.
- Gap: the paper evaluates in controlled simulation; deployment false-positive rates are unknown. The τ=0.75 threshold is a research-setting tuning, not a production-validated number.
