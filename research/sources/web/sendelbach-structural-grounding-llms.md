---
source_url: http://www.johnsendelbach.com/2026/04/structural-grounding-for-trustworthy.html
fetched_at: 2026-04-16
fetched_by: think-deep-web
project: Claude Code Entities
---

# Structural Grounding for Trustworthy Large Language Models (Sendelbach, April 2026)

## Core Thesis

Existing mitigations like RAG and uncertainty estimation patch symptoms without imposing an "irreversible epistemic structure." The author argues models fundamentally treat all tokens as interchangeable probabilities — RAG doesn't change this, it just provides better input tokens.

## The Artificial Hourglass Mechanism

Rather than retrieving facts BEFORE generation (which still allows the model to ignore them), the proposed architecture imposes commitment friction:

1. **Persistent Irreversible Ledger** — High-confidence outputs are locked into a dedicated layer with timestamp and provenance, preventing silent overwriting

2. **Simulated Friction Budget** — The system accumulates computational "cost" for ungrounded claims, forcing abstention when thresholds are exceeded

3. **Provenance Layering** — The model explicitly tracks which knowledge layer it draws from (pre-training corpus, committed knowledge, or live context), enabling transparent epistemic disclosure

## Structural Directionality

Knowledge moves one-way through an aperture — mirroring human cognition's irreversibility rather than treating all generation as costless probability.

## Critical Assessment

This is a theoretical proposal, not a shipping architecture. But the framing is valuable: it names what RAG doesn't do (change the model's fundamental probability structure) and proposes what would — making ungrounded generation structurally expensive rather than just contextually discouraged.

## Relevance to Claude Code Entities

The "provenance layering" concept maps directly to the Claude Code Entities architecture: entity should know whether it's reasoning from SOUL.md (committed values), world-model files (committed context), or weights (fallback). The distinction should be explicit and logged.
