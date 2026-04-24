# Session Brief: Memory Architecture — Compaction, Breadcrumbs, Hierarchical Recall

**Phase:** 1 — Foundation
**Parallel with:** 01-permission-model, 02-pd-identity-test
**Dependencies:** None — research and design heavy
**Status:** Ready to launch

---

## The Problem

An entity that resumes via `claude --resume` inherits its full conversation history. Over weeks and months, that grows past Claude's context window. Compaction happens — but default compaction is lossy and not designed for entities that need to remember critical learnings, relationships, decisions, and accumulated knowledge.

**Wisdom's vision (verbatim from session):**
- Use the carryover skill (already exists) as the compaction approach, not default compaction
- Storage of "good memories" via an **entity log** — its understanding of what it's done in the world
- Hierarchical structure — main info in primary memory, links to deeper-dive markdown files, which can link to even deeper detail when needed
- The entity asks itself: "will this be necessary for me to remember?" before storing
- Breadcrumbs — knowing context will compact, leave good trails so the entity can re-find critical info later
- Critical learnings get prioritized in the folder hierarchy

**Why this matters:**
> "It's one of the biggest issues with agents — context management, forgetting things. We want something where whenever it comes to a piece of information that feels critical to some process, that's a really big deal. It can prioritize that in the hierarchy."

This isn't just engineering — it's the central unsolved problem in agent persistence. Solving it well distinguishes Claude Code Entities from every existing autonomous agent project.

---

## What Already Exists

Existing assets to build on:

| Asset | Where | What it does |
|---|---|---|
| `/carryover` skill | `~/.claude/skills/carryover/` | Generates prescriptive carryover doc before compaction |
| `chronicle/` pattern | `rules/semantic-logging.md` | Append-only daily semantic log per project |
| `memory/` system | `~/.claude/projects/.../memory/` + MEMORY.md | Cross-conversation persistent facts; index + per-topic files |
| Associative Memory project | `~/Playful Sincerity/PS Research/Associative Memory/` | Wisdom's research on graph-based memory architectures (LLM as engine, graph as mind) |
| The Companion vision | `~/Playful Sincerity/PS Software/The Companion/` | Eventual integration target — AM becomes the memory layer |
| `/digest` skill | `~/.claude/skills/digest/` | Processes large data into searchable knowledge archives |

**Key existing pattern:** the `MEMORY.md` index + per-topic files (`feedback_*.md`, `project_*.md`, `user_*.md`, `reference_*.md`) is already a hierarchical breadcrumb system. Index loads always, individual files load on demand. This is the seed of what entities need.

---

## Research Streams

### Stream 1: Existing Agent Memory Architectures

How do production agent systems handle long-term memory and context management?

- **MemGPT / Letta** — virtual context management, in-context vs out-of-context memory, recall pattern
- **OpenAI's Memory feature** — what's their hierarchical model?
- **Mem0** — open-source memory layer for agents
- **Cognition's Devin** — how does it remember work across sessions?
- **Anthropic's own Managed Agents API** — does it provide memory primitives?
- **LangChain memory modules** — types: ConversationBuffer, Summary, Entity, KG
- **Sleep-time compute** (DeepMind/Anthropic research) — offline consolidation between sessions
- **Context engineering papers** — recent research on what to keep, what to compress, what to recall

For each: how do they decide what to store, how do they retrieve, what fails?

### Stream 2: The Hierarchical Breadcrumb Pattern

The structure Wisdom described: main memory file → links to deeper file → links to even deeper detail.

- How does Obsidian's link graph work as a memory model?
- How does Roam Research's block-level transclusion work?
- How does the human brain do this (cued recall, spreading activation)?
- What's the right depth before too-deep becomes inefficient?
- How does the entity decide "this needs its own file" vs "this fits in the parent file"?

### Stream 3: Criticality Assessment

How does the entity know what's worth remembering?

- Heuristics: surprise, frequency, emotional salience, recency, novelty
- Self-asking pattern: "will this be necessary for me to remember in 3 months?"
- Cost of forgetting vs cost of storing
- How to avoid both pack-rat behavior (storing everything) and amnesia (storing nothing)
- The Associative Memory project's "navigational graph" insight is directly relevant here

### Stream 4: Compaction Strategy

When the conversation has to compact, what happens?

- Default compaction loses semantic context
- `/carryover` already produces prescriptive recovery docs — extend this for entities
- Summarize-then-discard vs index-then-archive vs distill-then-graph
- Should compaction generate a "memory" entry automatically?
- Should entities be able to refuse compaction of certain critical recent context?

### Stream 5: Memory Promotion / Demotion

Memory hierarchy isn't static — important things become less important, mundane things become critical retrospectively.

- When does a chronicle entry get promoted to a memory file?
- When does a memory file get archived (demoted)?
- How does the entity rebalance its hierarchy over time?
- Who reviews this — the entity itself, periodically? Or a separate "librarian" process?

---

## Design Questions to Answer

1. **What's the entity's memory file layout?**
   - Recommendation: extend the existing pattern. `entity/memory/MEMORY.md` (index, always loaded) + `entity/memory/<topic>.md` (loaded on demand, can link to deeper files).

2. **How does the entity decide what becomes a memory?**
   - At natural pauses (end of conversation, before compaction)
   - Self-asking: "Was anything in this exchange load-bearing for future me?"
   - Auto-extraction of decisions, learnings, relationship updates

3. **What's the link/breadcrumb format?**
   - Markdown links between memory files
   - Each memory file has frontmatter (date, topic, depth, parent, children)
   - Index references: "see [topic-x] for deeper detail"

4. **How does compaction interact with memory?**
   - `/carryover` generates the carryover doc
   - Carryover doc identifies what should be promoted to memory
   - Then compact — knowing critical info is now durable in `entity/memory/`

5. **How does the entity recall on resume?**
   - On resume, read MEMORY.md index
   - Index summarizes available memory files
   - Entity navigates to specific files when relevant questions arise
   - Pattern: "I remember there was something about X — let me check `entity/memory/x.md`"

6. **What about the `entity log` Wisdom mentioned?**
   - This is a journal of what the entity has done (decisions, actions, outcomes)
   - Distinct from chronicle (which is project-level semantic log) and memory (cross-conversation persistent facts)
   - Probably: `entity/log/YYYY-MM.md` — monthly action log
   - Each entry: timestamp, what I did, what happened, what I learned
   - Loaded on demand or by date range

---

## Deliverables

1. **Research synthesis:** `research/2026-04-XX-memory-architecture-survey.md` — what existing systems do, with attribution
2. **Architecture proposal:** `architecture/memory-system.md` — the proposed entity memory model with file layouts, naming conventions, promotion rules
3. **Updated `/carryover` skill:** if needed, extend it to support memory promotion (writing distilled memory entries, not just carryover docs)
4. **Update spawn-entity.sh:** add `entity/memory/` and `entity/log/` to the scaffold
5. **Update entity CLAUDE.md template:** add instructions for "before responding, check MEMORY.md index" and "before session ends, write any critical memories"

---

## Constraints

- **Build on existing patterns** — MEMORY.md + per-topic files already exists in `~/.claude/projects/.../memory/`. Use it as the model.
- **Don't reinvent Associative Memory** — that's its own research project. This session designs the file-based starter that AM could later replace or augment.
- **Markdown-only** — no databases, no embeddings, no vector stores in V1. Just files Claude can read.
- **Entity-readable** — the entity itself must be able to navigate its own memory. No magic — just files with predictable names.
- **Backwards compatible** — existing chronicle/, observations/, notes/ patterns continue to work. Memory is an addition, not a replacement.

---

## Open Questions for Wisdom

1. **Should memory writes go through the carryover skill, or be continuous?** Continuous (the entity writes memory as it learns) vs gated (only at compaction time, via carryover). Hybrid possible.
2. **Should the entity's MEMORY.md auto-truncate?** The global one is capped at 200 lines. What's the right size for an entity's index?
3. **Cross-entity memory sharing?** Should multiple entities share a memory store (`AVS/knowledge/memory/`) in addition to their own (`entities/<name>/memory/`)?
4. **AM integration timing?** When does the file-based starter get replaced/augmented by Associative Memory? Probably after AM matures past its current state.

---

## Why This Phase Placement

Phase 1 because:
- Foundational — every entity needs this from the start
- Independent — doesn't depend on permissions or identity work being done first
- Research-heavy — can run in parallel with the empirical permission and identity work
- Output feeds Phase 2 — Frank/Jen entity build will use the memory model designed here

Could be deferred to Phase 4, but then Frank/Jen would need to be retrofit. Better to design once, scaffold correctly from the start.

---

## Reference: Wisdom's Direct Quotes

> "We need to design the compaction system... we should make a phase within the build for this to focus on that."

> "We want to be researching memory structures. I know that's one of the biggest issues with agents is their context management and also forgetting things."

> "We want something that's essentially like whenever it comes to a piece of information, a piece of learning that feels critical to some process, that's a really big deal. It can prioritize that in the hierarchy of the folders."

> "It will always be asking — 'will this be necessary for me to remember?' It knows it's not going to necessarily remember everything in every context because the context is always compacting, so it needs to make sure to leave good breadcrumbs to get to the right information in the right circumstances."

> "That's a fundamental architecture that we need to design that we need to improve on because it seems like that's not really fully developed for these things right now."
