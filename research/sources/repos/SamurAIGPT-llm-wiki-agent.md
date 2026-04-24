---
source_url: https://github.com/SamurAIGPT/llm-wiki-agent
fetched_at: 2026-04-16 14:15
fetched_by: think-deep-github
project: Claude Code Entities
---

# SamurAIGPT/llm-wiki-agent

**Stars:** 2,000 | **Forks:** 217 | **License:** MIT

## What It Implements

LLM-maintained persistent wiki as world-model. Based on Karpathy's April 2026 LLM-wiki pattern (16M+ views on X, Gist hit 5K+ stars).

- **World-model as wiki**: structured markdown pages, entity pages, concept pages, synthesis pages
- **EXTRACTED vs INFERRED edge tagging**: graph edges tagged `EXTRACTED` (from wikilinks) vs `INFERRED` (agent-inferred, with confidence score) vs `AMBIGUOUS`. This IS claim annotation.
- **YAML frontmatter** per page: `type: source`, enabling Dataview-style queries to distinguish content types
- **Retrieval gate**: `/wiki-query` reads index.md → retrieves relevant pages → generates answer with `[[wikilinks]]` citations
- **Append-only log**: `wiki/log.md` tracks every change made
- **Ingest cycle**: new source → extract knowledge → update 10-15 related pages → append to log

## Key Pattern

The EXTRACTED / INFERRED / AMBIGUOUS tagging on graph edges is the closest implementation found to explicit claim-provenance annotation. Not retrieved/reasoned/weights-only exactly, but maps directly: EXTRACTED = retrieved, INFERRED = reasoned.

## Gap

The annotation is on graph edges, not inline in prose outputs. A human reading the wiki output won't see `[INFERRED]` in the text — it's in the knowledge graph metadata only. For claim-level annotation in generated responses, an additional rendering step would be needed.

## Verdict

**Adopt (pattern + code).** The EXTRACTED/INFERRED distinction is the most concrete claim annotation found. The wiki-as-world-model is directly applicable to Claude Code Entities' world-model.md concept. The mandatory read-first pattern is a working retrieval gate.
