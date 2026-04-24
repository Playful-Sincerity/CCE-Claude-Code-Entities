---
source_url: https://arxiv.org/abs/2506.10805
fetched_at: 2026-04-16 17:00
fetched_by: think-deep-expansion
project: Claude Code Entities
authors: McKiernan et al. (2025)
venue: NeurIPS 2025
---

# Detecting High-Stakes Interactions with Activation Probes (arXiv:2506.10805)

## Core Claim

Activation probes trained on **synthetic data** can detect "high-stakes" interactions (text indicating potential for significant harm) during LLM deployment with robust out-of-distribution generalization.

## Key Findings (from abstract + search context)

- Probes generalize from synthetic training data to "diverse, out-of-distribution, real-world data."
- Performance **comparable to prompted or finetuned medium-sized LLM monitors**, with **six orders-of-magnitude computational savings**.
- Designed for "resource-aware hierarchical monitoring systems" — probes as an efficient first-stage filter, escalating ambiguous cases to full-model monitoring.

## Relevance to Paradigm-Drift

This is the nearest published work to the question "do activation probes catch something beyond sleeper-agent backdoors?" Unlike the Anthropic 2024 sleeper-agent paper, the probe here is trained to detect *content category* (high-stakes vs. low-stakes) rather than a backdoor signature, and it generalizes OOD.

**But it still doesn't directly address paradigm-drift.** It detects whether text IS high-stakes, not whether the model has subtly shifted what it interprets "helpful" or "honest" to mean. Detection is at the *content* level, not the *interpretation* level.

**The architectural pattern** — probe-as-cheap-first-stage, full-monitor-as-escalation — is directly applicable to the CCE Mirror design: a fast activation probe on every generation, escalating flagged generations to a cross-model Mirror review.

## Limitations (explicit + inferred)

- Not evaluated for drift over time in a single deployed model.
- Detects content categories defined at training time; novel categories require retraining.
- Synthetic training data may not cover the full space of naturally-arising shifts.

## Full paper

URL: https://arxiv.org/abs/2506.10805 (NeurIPS 2025 accepted).
