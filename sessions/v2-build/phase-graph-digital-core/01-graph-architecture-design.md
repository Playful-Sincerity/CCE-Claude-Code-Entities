# Session Brief: Graph-Based Digital Core (V2)

**Phase:** V2 — Graph Architecture
**Dependencies:** V1 memory architecture must be in place and battle-tested first
**Status:** Future — research now, build later
**Connects to:** Associative Memory research project

---

## The Vision

The V1 memory architecture uses markdown files with markdown links between them. That IS already a graph — files are nodes, links are edges. But it's an **implicit** graph: humans and Claude can navigate it, but no system queries it as a graph.

V2 makes the graph explicit and queryable. The entire Digital Core becomes a navigable knowledge graph where:
- Every file is a node with typed metadata
- Every reference is an explicit edge with a relationship type
- The entity (or Wisdom) can ask graph questions: "show me everything connected to PSSO that involves a person", "what concepts are 2 hops from Gravitationalism?", "what skills depend on this rule?"
- Spreading activation lets the entity discover unexpected connections during thinking
- The graph IS the world model, not a representation of it (the AM thesis)

---

## Why V2, Not V1

V1 is files-and-links: works with current Claude Code, no new infrastructure, fully markdown-native. Battle-tested across the existing Digital Core for months.

V2 requires:
- A graph layer (likely the Associative Memory engine, when it matures)
- Migration of existing files into typed nodes + edges
- New query/navigation primitives for the entity
- Integration into Claude Code's tool surface (custom MCP server probably)

Doing V2 prematurely risks rebuilding before we know what the file-based version teaches us. Doing V1 well first means the graph migration is well-informed.

---

## Connection to Associative Memory

This phase is essentially "operationalize Associative Memory as the Digital Core's substrate." AM's thesis — "the graph IS the interpretable world model; LLM is the engine, graph is the mind" — directly fits here.

Key questions for that integration:
- When is AM mature enough to host real production data?
- What's the migration path from filesystem to AM graph?
- Does AM need to be filesystem-backed (for Claude Code compatibility) or fully separate?
- Can the graph be exposed to Claude as an MCP server?

The AM project at `~/Playful Sincerity/PS Research/Associative Memory/` is the source of truth for the underlying research.

---

## Research Streams

### Stream 1: Knowledge Graph Systems

How do existing knowledge graph systems handle this scale and use case?

- **Obsidian** with Dataview / Graph plugins — what's the upper limit?
- **Roam Research** — block-level graph, transclusion patterns
- **Logseq** — open-source Roam alternative, file-backed
- **Neo4j** — proper graph DB, what would integration look like?
- **TigerGraph** — alternative graph DB
- **GraphRAG** (Microsoft) — graph retrieval-augmented generation
- **Neo4j's GenAI / Knowledge Graph builders** — auto-extracting graphs from text
- **ROCM / OpenSPG** — alibaba's open knowledge graph framework

For each: scale they handle, query latency, integration with LLMs.

### Stream 2: Graph Query Patterns for Agents

What query primitives does an agent actually need?

- Find by type (all `person` nodes)
- Find by attribute (all nodes mentioning "PSSO")
- Find by relationship (all things that `inspires` or are `inspired_by` X)
- Hop queries (anything 1-2 hops from concept Y)
- Path queries (what's the shortest path from A to B?)
- Spreading activation (given context, what's most active?)
- Subgraph extraction (give me everything related to project Z)

What does the entity actually use? The answer informs what query API to build.

### Stream 3: Migration Strategy

How do we move from V1 (files) to V2 (graph) without losing anything?

- Migration script: parse all markdown, extract frontmatter, follow links, build initial graph
- Round-tripping: can we keep files as canonical, graph as derived index?
- Or: graph becomes canonical, files become export views?
- How do humans edit? (markdown is human-friendly; graph editing usually isn't)
- How does Claude Code see it? (file reads vs MCP tool calls)

### Stream 4: AM Integration Readiness

When is the Associative Memory project ready to host the Digital Core?

- Current AM status (check `~/Playful Sincerity/PS Research/Associative Memory/`)
- What capabilities AM needs to add before it can power production
- What scale it can handle today vs needs to handle
- What query latency it provides
- The gap between research artifact and production substrate

---

## Design Questions to Answer

1. **What's a node?** Every file? Every concept? Every section within a file? Granularity matters.
2. **What's an edge?** Markdown link? Frontmatter reference? Implicit semantic relation extracted by LLM?
3. **What edge types do we need?** `references`, `inspired_by`, `depends_on`, `related_to`, `contradicts`, `extends`...
4. **Where does the graph live?** AM engine? Dedicated graph DB? File-backed JSON-LD?
5. **How does Claude Code interact?** MCP server exposing graph queries? Direct file reads? Hybrid?
6. **How do humans contribute?** Same markdown editing as today, with auto-graph-update? Or graph-native UI?
7. **What's queryable in real time vs precomputed?**

---

## Deliverables (When This Session Runs)

1. Research synthesis on knowledge graph + LLM integration patterns
2. Architecture proposal: node/edge model, storage substrate, query API
3. Migration plan: V1 files → V2 graph, with no data loss
4. AM integration plan: what AM needs to add to be the production substrate
5. Concrete next-step: prototype with a small subgraph (e.g., just PSSO + connected concepts)

---

## Constraints

- **Don't lose markdown** — the human-editable substrate must persist. Graph is added, not replacing.
- **Don't break existing Claude Code workflows** — files keep working as files
- **Connect to AM, don't reinvent** — leverage the existing research
- **V1 must be solid first** — file-based memory must be working and useful before this phase begins

---

## When to Run This Session

After:
- V1 memory architecture is built and used by at least 2-3 entities for at least a month
- AM has matured to the point where it can host real data (currently research-stage)
- Wisdom has a clear sense of what queries entities actually want to make (informed by V1 usage)

Probably 3-6 months out from V1 completion.

---

## Connections

- **Associative Memory** (`~/Playful Sincerity/PS Research/Associative Memory/`) — the research substrate
- **The Companion** (`~/Playful Sincerity/PS Software/The Companion/`) — convergence target where AM becomes the memory layer
- **ULP** (`~/Playful Sincerity/PS Research/ULP/`) — semantic primitives that could be node types in the graph
- **Synthetic Sentience Project** — the larger umbrella where this lives
