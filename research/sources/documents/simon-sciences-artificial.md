---
source_url: https://plato.stanford.edu/entries/bounded-rationality/
secondary_sources:
  - https://en.wikipedia.org/wiki/Herbert_A._Simon
  - https://blog.othor.ai/herbert-simon-and-bounded-rationality-the-human-reality-behind-decision-intelligence-6ba392ae2499
fetched_at: 2026-04-16 11:15
fetched_by: research-books agent
project: Claude Code Entities
---

# Herbert Simon — The Sciences of the Artificial (1969) + Bounded Rationality

## Core Claim

Real agents — human or artificial — cannot hold all relevant knowledge in working memory and compute optimal decisions. They must satisfy rather than optimize, and they must offload cognitive work into the environment.

## Bounded Rationality

Simon replaced the classical economics model of perfect rationality (unbounded computation over complete information) with a realistic model of cognitively limited agents. Three core limitations:

1. **Limited information** — decision-makers never have complete information about all possibilities
2. **Computational constraints** — minds have finite processing capacity
3. **Time pressure** — real decisions must be made before exhaustive analysis completes

The key move: these limits aren't flaws to be engineered away — they are permanent structural features of any finite agent operating in an infinite world. The right response is not to pretend the limits don't exist, but to design decision strategies that work well within them.

## Satisficing

Rather than searching for optimal solutions, bounded agents look for solutions that meet a threshold — "good enough." The search terminates when a satisfactory option is found, not when all options have been evaluated.

This is not settling for less: it's the rational strategy for agents with bounded resources. Given that optimal search is impossible, satisficing is what intelligence actually looks like.

## The Scissors Metaphor

Simon's most important architectural insight: rationality is like a pair of scissors. One blade is cognitive capacity; the other is environmental structure.

Scissors cut with both blades together. Neither blade alone cuts. An agent's rational behavior is a product of its cognitive capacity working *in concert* with its environmental structure. Performance cannot be understood by looking at cognition alone.

**Implication:** To improve performance, you can sharpen either blade — improve cognitive capacity OR improve the structure of the environment. For most practical purposes, improving environmental structure (better information, better organization, better tools) is cheaper and more reliable than improving cognitive capacity.

## Offloading to Environment

Simon recognized that intelligent agents systematically exploit environmental structure to compensate for cognitive limits. Rather than holding everything in memory, they:

- Use physical arrangements to encode decision states (to-do piles, physical workflows)
- Use artifacts to encode information across time (written notes, calendars)
- Use procedures to encode decision sequences that don't need to be re-derived each time

This is proto-distributed cognition: Simon saw before Hutchins that the environment absorbs cognitive work and holds it for retrieval.

## Sciences of the Artificial — Design Implications

In "Sciences of the Artificial," Simon argues that artificial systems (human-designed) are characterized by:

- Being adapted to goals, not merely caused by physics
- Existing at the interface between inner environment (architecture) and outer environment (task demands)
- Performing adequately when inner and outer environments are well-matched

**The inner/outer interface:** An artifact performs its cognitive function when its structure is matched to the structure of the external environment it must navigate. A poorly designed tool (mismatched inner structure) fails even in a well-structured environment. A well-designed tool (matched inner structure) leverages environmental structure to do work that the agent couldn't do from raw cognitive capacity alone.

## Implication for Retrieval-Over-Weights

Simon provides the classical justification for why retrieval must be the default:

- **Weights are the inner environment** — compressed, generalized, slow to update, error-prone on specifics
- **World-model files are the outer environment** — structured, current, auditable, specific
- **Retrieval-over-weights is the scissors cutting properly** — the inner cognitive capacity (model reasoning) working in concert with the outer environmental structure (disk-based world model)

An agent generating from weights alone is like trying to cut with one blade. It has the cutting motion, but nothing to work against. The world-model files provide the structured environmental resistance that allows precise cuts.

Simon's framework also explains the value drift problem: when an agent relies solely on weights, it loses the environmental constraint. Weights encode statistical patterns, not ground truth. Without environmental anchoring, satisficing drifts toward what the weights predict is satisfactory, which may diverge from what the world actually affords. Environmental structure is what keeps satisficing aligned with reality.

## The Key Tension

Simon's framework cuts both ways. The scissors metaphor also implies that a well-structured environment can partially compensate for weak cognitive capacity — but a poorly structured environment will defeat strong cognitive capacity. If world-model files are disorganized, stale, or corrupt, the distributed cognitive system degrades regardless of model quality. Environmental structure maintenance (keeping files current, organized, and trustworthy) becomes a first-class cognitive activity, not a secondary concern.
