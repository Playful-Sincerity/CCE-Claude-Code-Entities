---
source_url: https://arxiv.org/html/2601.04170v1
fetched_at: 2026-04-16
fetched_by: ai-dreaming-research-agent
project: Claude Code Entities — /dream skill
---

# Agent Drift: Quantifying Behavioral Degradation in Multi-Agent LLM Systems (Jan 2026)

## Core Finding

Agent drift — systematic behavioral degradation in LLM agents over extended interactions — was quantified across workflows ranging from 5 to 1,847 interactions. Without mitigation, behavioral drift was projected to affect 42% of long-running agents, reducing task success rates and increasing human intervention needs.

## Behavioral Baseline Methodology

Baselines established using the first 20 interactions, capturing:
- Initial agent decision patterns
- Tool usage distributions  
- Coordination protocols

Subsequent interactions compared against this baseline using distributional distance metrics. This is exactly the external-in-time reference the dreaming.md document calls for.

## Three Mitigation Strategies Tested

1. **Episodic Memory Consolidation**: periodic compression of interaction histories to prevent context bloat from diluting baseline patterns
2. **Drift-Aware Routing**: use agent stability scores in delegation decisions — don't assign high-stakes tasks to drifted agents
3. **Adaptive Behavioral Anchoring**: few-shot prompt augmentation with baseline exemplars prepended to each request

Results: Behavioral Anchoring most effective alone (70.4% drift reduction). All three combined: 81.5% drift reduction.

## Practical Applications (2025-2026)

Production voice agent analysis (4M+ calls, 10K+ agents) found daily synthetic tests can catch silent degradation before user complaints. Approach: record trajectories when working correctly → save as baseline → diff after every change. "Snapshot tests for agents."

## Relevance to /dream skill

This paper is the most directly relevant piece of operational research found. The baseline methodology (first N interactions → distribution → compare subsequent) is exactly what the dreams/ corpus enables, but for value-behavior rather than task-success. Dream outputs are behavioral snapshots. Comparing dream outputs from month 1 to month 6 detects paradigm drift in values, not just capability drift. The "Adaptive Behavioral Anchoring" strategy maps to: include early dream outputs in the entity's context to anchor it against drift.

## Year: January 2026 — Very recent. Directly applicable to entity architecture.
