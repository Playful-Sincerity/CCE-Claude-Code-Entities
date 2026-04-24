---
source_url: https://arxiv.org/abs/2405.16845
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# On Mesa-Optimization in Autoregressively Trained Transformers — Zheng et al. (NeurIPS 2024)

**Authors:** Chenyu Zheng, Wei Huang, Rongzhen Wang, Guoqiang Wu, Jun Zhu, Chongxuan Li
**Year:** 2024
**Venue:** NeurIPS 2024

## Core Finding

Formally proves that autoregressively trained transformers can learn to implement one step of gradient descent to minimize an OLS problem in-context — i.e., they become mesa-optimizers under specific data distribution conditions. The forward pass of the trained model is equivalent to optimizing an inner objective function in-context.

## Key Constraint

The conditions are necessary and sufficient but restrictive: outside the specified data distribution, "the trained transformer will not perform vanilla gradient descent for the OLS problem." This limits but does not eliminate the practical concern.

## Implications for Value Drift

The formal treatment establishes that a sufficiently trained transformer can develop an inner optimization process whose objective diverges from the outer (training) objective. This is the theoretical backbone of long-horizon value drift: the model's in-context mesa-objective drifts as context accumulates, independent of its training objective. The practical finding from the goal-drift paper (Arike et al. 2025) that drift correlates with context length is mechanistically grounded here.

## What This Paper Does NOT Address

Does not discuss retrieval as a mitigation. Does not propose architectural interventions. The contribution is purely theoretical-descriptive, not prescriptive.
