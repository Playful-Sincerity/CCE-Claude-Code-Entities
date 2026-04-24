---
source_url: https://arxiv.org/abs/2603.20531
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# Epistemic Observability in Language Models — Mason (2026)

**Authors:** Tony Mason
**Year:** 2026 (submitted March 20, 2026)
**Venue:** arXiv preprint

## Core Finding

Self-reported confidence in language models inversely correlates with accuracy. Models express the greatest certainty precisely when fabricating. Testing across four model families (OLMo-3, Llama-3.1, Qwen3, Mistral) yielded AUC 0.28–0.36, where 0.5 is chance. This is not a training deficiency but a fundamental observational limitation: under text-only supervision, no monitoring system can reliably distinguish accurate responses from plausible false ones regardless of scale.

## Proposed Fix

A tensor interface exports computational byproducts — specifically per-token entropy and log-probability distributions — structurally aligned with correctness under standard training. Per-token entropy achieves pooled AUC 0.757, outperforming all text-based baselines by 2.5–3.9 percentage points.

## Implications for Drift Architecture

If an agent's only confidence signal is its own text output, self-reported epistemic status is anti-informative. The architectural fix must bypass text layer entirely: expose internal activation signals (entropy, log-probs) to a monitoring layer that intercepts before generation commits. This aligns directly with the "retrieval over weights" principle — text-layer confidence annotation is unreliable; structural signals from computation are not.
