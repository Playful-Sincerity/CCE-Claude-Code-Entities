---
source_url: https://arxiv.org/abs/2506.02918
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# World Modelling Improves Language Model Agents — Guo et al. (2025)

**Authors:** Shangmin Guo, Omar Darwiche Domingues, Raphaël Avalos, Aaron Courville, Florian Strub
**Year:** 2025 (June 2025, revised September 2025)
**Venue:** arXiv preprint

## Core Idea

DyMo (Dynamics Modelling): augments LLMs with a state prediction capability alongside function calling during post-training. The model learns to predict future states of its actions through an internal environment model, enabling self-verification before committing to tool calls.

## Key Results

- Improved success rates on Berkeley Function Calling Leaderboard V2
- Significantly reduced hallucinations
- Self-verification sampling (SVS) substantially improves pass-rate-over-trials and allows the model to refuse unreliable outputs

## Two-Phase Separation

Implicit in DyMo is a two-phase operation: (1) predict state consequences of an action before executing, (2) verify predicted state against desired goal, then decide whether to commit. This is the "observe before commit" principle made architectural.

## Implication for Architecture

This is the world-model component of a drift-resistant system. Instead of executing actions and observing consequences, the agent maintains an internal predictive model that it consults before acting. This prevents output-drift through forward simulation: if the predicted output doesn't match the expected state, the agent can withhold or re-plan.

The key insight: a world model transforms output-drift from a post-hoc detection problem to a pre-hoc prediction problem. The agent doesn't hallucinate an action result; it predicts it and checks before committing.
