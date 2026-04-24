---
source_url: https://arxiv.org/abs/2410.05162
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# Deciphering the Interplay of Parametric and Non-parametric Memory in RAG Language Models — Farahani & Johansson (EMNLP 2024)

**Authors:** Mehrdad Farahani, Richard Johansson
**Year:** 2024
**Venue:** EMNLP 2024

## Core Contribution

Uses causal mediation analysis to disentangle the independent contributions of parametric (weights-encoded) knowledge and non-parametric (retrieved context) knowledge in RAG models. Goes beyond surface performance metrics to understand internal mechanisms.

## Key Finding 1: Context Preference

When both information types are available, models rely more on retrieved context than parametric knowledge. This is a natural bias — but it is conditional on the model "deciding" that retrieved context is relevant.

## Key Finding 2: Two Distinct Mechanisms

The researchers identify two internal computational processes:
1. A relevance evaluation: "is the retrieved context relevant to this query?"
2. An encoder mechanism: generating representations that support copying from context when relevant

## Key Finding 3: Strength-Conditional Override

The Atlas RAG model prefers retrieved context in cases where parametric memorization is weakest — it dynamically falls back to weights when retrieval signal is weak. This is not a safe fallback: it's exactly the condition under which hallucination risk is highest.

## Scaling Insight

Beyond ~10^23 training FLOPs, diverting additional compute from model depth to datastore size and retrieval steps improves factual accuracy more steeply. Retrieval becomes the dominant accuracy driver at scale.

## Implication for Architecture

The "decision" to use retrieved context vs. weights is an internal model operation — it can be overridden by retrieval signal quality. The architecture must prevent weights-fallback when context is absent or weak: this is where confabulation enters. The structural answer is not to let the model decide between parametric and non-parametric — enforce non-parametric by default with an explicit override gate.
