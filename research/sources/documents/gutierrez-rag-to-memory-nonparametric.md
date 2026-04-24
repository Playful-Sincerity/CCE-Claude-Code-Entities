---
source_url: https://arxiv.org/abs/2502.14802
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# From RAG to Memory: Non-Parametric Continual Learning for Large Language Models — Gutiérrez et al. (ICML 2025)

**Authors:** Bernal Jiménez Gutiérrez, Yiheng Shu, Weijian Qi, Sizhe Zhou, Yu Su
**Year:** 2025
**Venue:** ICML 2025

## Core Idea

Extends HippoRAG (graph-based retrieval inspired by hippocampal memory) with deeper passage integration and more effective online LLM use. Treats continual knowledge acquisition as a non-parametric operation — new knowledge enters as graph nodes/edges, not weight updates.

## Key Results

7% improvement over state-of-the-art embedding models in associative memory tasks. Superior factual knowledge and sense-making across three memory task categories.

## Architecture

Knowledge is structured as a Personalized PageRank graph. New information is incorporated by modifying the external graph, not the model weights. Weight modifications are completely absent from the knowledge update pipeline.

## Implication for Architecture

This is the most direct existence proof for "retrieval over weights as default." The system doesn't learn new facts via gradient descent — it learns by updating its external graph and retrieving from it. Catastrophic forgetting becomes impossible by design: weights never change, so previously encoded behavior cannot be overwritten by new data. Value stability is a structural property, not a training objective.

The graph-as-mind principle (directly resonant with PS Associative Memory architecture) is validated here at ICML scale. The convergence between this work and AM is significant.
