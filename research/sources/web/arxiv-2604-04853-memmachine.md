---
source_url: https://arxiv.org/pdf/2604.04853
fetched_at: 2026-04-16
fetched_by: think-deep-web
project: Claude Code Entities
---

# MemMachine: A Ground-Truth-Preserving Memory System for Personalized AI Agents (2026)

## Core Thesis

Memory systems drift from factual accuracy over time. MemMachine implements structural guarantees to preserve ground truth through a multi-layered architecture that separates storage, retrieval, and generation mechanisms.

## Key Mechanisms

### Episodic-Semantic Separation

Following cognitive science foundations, MemMachine distinguishes:
- Episodic memories (specific events with timestamps and context)
- Semantic memories (extracted facts and patterns)

This dual-track approach prevents contamination where generative outputs become fed back as "memories," causing progressive hallucination.

### Immutable Core Layer

Append-only storage of raw observations and user interactions. This creates an audit trail and prevents retroactive memory corruption — structural safeguard, not procedural.

### Retrieval-Generation Decoupling

Three phases:
1. **Retrieval phase**: Extract relevant episodic/semantic records matching query context
2. **Generation phase**: Use retrieved facts as grounding references WITHOUT modifying them
3. **Validation layer**: Verify generated outputs align with source episodic data

This asymmetry prevents the common failure mode where model outputs become new "facts" in memory.

## Structural Guarantees

Probabilistic rather than absolute: memory decay occurs through intentional forgetting policies, not uncontrolled drift. Updates require explicit user confirmation or clear triggering events — rejecting continuous implicit update patterns that cause hallucination accumulation.

## Storage Infrastructure

PostgreSQL (with pgvector for vector search), SQLite, and Neo4j (graph-structured long-term memory).

## Relevance to Claude Code Entities

MemMachine is the closest production analog to Wisdom's "retrieval-over-weights as default." The retrieval-generation decoupling and immutable core layer are the structural patterns to borrow.
