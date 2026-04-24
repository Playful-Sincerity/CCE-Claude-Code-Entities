---
source_url: https://arxiv.org/abs/2301.04104
fetched_at: 2026-04-16
fetched_by: ai-dreaming-research-agent
project: Claude Code Entities — /dream skill
---

# DreamerV3: Mastering Diverse Domains through World Models (Hafner et al., 2023)

## Core Architecture

DreamerV3 is a model-based RL agent that learns behaviors by imagining rollouts inside a learned world model rather than by interacting with the environment. Three modules trained jointly: (1) world model (RSSM — Recurrent State Space Model), (2) actor, (3) critic.

The RSSM encodes sensory inputs into categorical latent representations combining stochastic (z_t: 32 categorical distributions × 32 classes) and deterministic components. The world model predicts: next latent state, reward, episode termination — all from the latent representation and chosen action.

## What "Imagination" Means Technically

"Imagination" = rollout through the learned world model from a given latent state. The actor is trained entirely on these synthetic rollouts — it never sees real environment transitions during policy optimization. The world model plays the role of a differentiable simulator.

Key distinction: imagination happens in latent space, not pixel space. The world model learns a compressed representation, then imagines forward from that representation. This is computationally efficient (no rendering required) and generalization-capable (latent space is smoother than raw observations).

## Training Process

1. World model learns from real interaction data (encoder + RSSM + decoders)
2. Policy optimization happens entirely in imagination — the actor generates actions, the world model predicts consequences, the critic evaluates outcomes
3. Policy gradient through imagined trajectories updates the actor

## Robustness Techniques

- Symlog predictions: handles reward scale across diverse domains
- KL balance + free bits: prevents world model from ignoring uncertainty
- Percentile return normalization: stabilizes training across different reward magnitudes
- Block GRU + RMSNorm + SiLU: architecture improvements for capacity

## Results

- First algorithm to obtain diamonds in Minecraft without human data or curricula (later surpassed by Dreamer 4 in offline setting)
- Achieves competitive or SOTA results across 150+ diverse tasks with single hyperparameter set
- Demonstrates that larger world models improve both performance and data efficiency

## Limitations

- Imagination errors accumulate over long rollouts
- Relies on environment interaction for world model training (not purely offline)
- Quality of imagined rollouts bounded by world model accuracy

## Year: January 2023 — Foundational paper, not superseded but extended by Dreamer 4 (Sept 2025)
