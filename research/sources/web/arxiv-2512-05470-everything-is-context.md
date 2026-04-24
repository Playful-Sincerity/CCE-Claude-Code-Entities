---
source_url: https://arxiv.org/pdf/2512.05470
fetched_at: 2026-04-16
fetched_by: think-deep-web
project: Claude Code Entities
---

# Everything is Context: Agentic File System Abstraction for Context Engineering (2025)

## Core Architecture

A file system abstraction layer that virtualizes how AI agents access context. Rather than agents directly querying databases or APIs, all contextual information is presented through a unified file-system interface:

- Files represent data artifacts (documents, configurations, memories, system state)
- Directories organize context hierarchically by relevance, domain, or lifecycle stage
- File operations (read, search, list) become the primary interaction pattern

## Retrieval-First Enforcement Mechanism

The abstraction enforces retrieval-first behavior by:

1. Making explicit retrieval necessary — agents must perform deliberate read operations rather than having context automatically injected
2. Limiting working memory — only explicitly accessed files are loaded into the agent's context window
3. Indexing and search capabilities — agents discover relevant context through filesystem operations (grep, find, ls) rather than assumption

This contrasts with approaches where all potentially relevant data floods the agent's attention.

## "Everything is Context" Thesis

Context engineering is the fundamental problem. Rather than focusing on model architecture or prompt engineering, agent behavior emerges from what information is accessible and how. By controlling the "information environment," you shape agentic reasoning without modifying the model itself.

## Key Implication for Claude Code Entities

The filesystem IS the world model. SOUL.md, world-model files, chronicle entries, memory files — these ARE the entity's context, accessed via Read operations. The architecture is already naturally file-system-based. The enforcement question becomes: how do you make the agent READ these files before generating, rather than defaulting to weights?
