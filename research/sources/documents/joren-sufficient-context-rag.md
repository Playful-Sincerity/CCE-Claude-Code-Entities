---
source_url: https://arxiv.org/abs/2411.06037
fetched_at: 2026-04-16 10:00
fetched_by: think-deep-papers
project: Claude Code Entities
---

# Sufficient Context: A New Lens on Retrieval Augmented Generation Systems — Joren et al. (2024)

**Authors:** Hailey Joren, Jianyi Zhang, Chun-Sung Ferng, Da-Cheng Juan, Ankur Taly, Cyrus Rashtchian
**Year:** 2024 (submitted November 2024, revised April 2025)
**Venue:** arXiv preprint

## Core Contribution

Introduces "sufficient context" as an analytical frame: whether errors arise from the model failing to use available context, or from the context itself being insufficient. Separates two distinct failure modes that prior work conflated.

## Failure Mode 1: Insufficient Context

Large, capable models (Gemini 1.5 Pro, GPT-4o, Claude 3.5) output incorrect answers instead of abstaining when retrieved context lacks necessary information. They confabulate rather than saying "I don't know."

## Failure Mode 2: Context Present but Ignored

Smaller models (Mistral 3, Gemma 2) hallucinate or abstain even when context is sufficient — they fail to extract and use what was retrieved.

## Key Finding: Partial Context Still Helps

Incomplete context that doesn't fully answer the query can still improve accuracy compared to no context. Retrieval has graded benefit, not binary benefit.

## Proposed Fix

A selective generation method leveraging sufficient-context classification to trigger guided abstention, improving correct response rates 2–10% across models.

## Implication for Architecture

Retrieval-as-default must be paired with a context-sufficiency gate. The agent should: (1) always retrieve first, (2) classify whether retrieved context is sufficient, (3) if insufficient, abstain or escalate rather than fall back to weights-based confabulation. This is the key failure mode that a naive "always retrieve" policy doesn't solve — you also need a sufficiency check to prevent the fallback to parametric confabulation.
