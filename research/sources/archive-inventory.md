# Research Archive Inventory — Claude Code Entities

Companion to [`catalog.md`](catalog.md). Where `catalog.md` indexes the raw web/repo/document sources pulled during research rounds, this document inventories the cross-AI, cross-project archives that fed the project's intellectual context.

The purpose is traceability: every claim in [`../../README.md`](../../README.md), [`../../STATUS.md`](../../STATUS.md), and [`../../history/HISTORY.md`](../../history/HISTORY.md) should be traceable to one of these source pools.

---

## Archive Pool A: Project Research (`research/` directory)

**Total:** 95 files, ~1.2 MB, organized in 8 subdirectories.

- **Root** — 10 dated research files plus prior-art validation. Covers: persistent entity systems (ClaudeClaw v2, KAIROS), tool-limits investigation, Iga comparative, novelty landscape synthesis, four research streams from 2026-04-15.
- **[`think-deep/`](../think-deep/)** — 3 architecture think-deeps (2026-04-13 architecture decision, 2026-04-13 autonomous entity, 2026-04-16 two drift types). Plus `best-practices.md` from the architecture think-deep.
- **[`plan-deep/`](../plan-deep/)** — 3 files covering plan-deep runs for GH Scout deployment, scout-components, and the play phase.
- **[`round-comparative-agents/`](../round-comparative-agents/)** — 5 files (streams A/B/C on self-learning mechanisms, drift modes, theoretical foundations; plus Iga comparative and README).
- **[`dream-skill-research/`](../dream-skill-research/)** — 2 synthesis files on AI dreaming and dreaming-science.
- **[`sources/`](../sources/)** — this directory. Holds the raw source catalog and inventory.

**Catalog status:** [`catalog.md`](catalog.md) indexes 53 sources across the April 16 comparative-agents research round and the think-deep GitHub research. Note: the `round-comparative-agents` round used a `researcher` subagent that was blocked from Write, so raw web/document content for that round was not persisted locally. URLs are cataloged in `catalog.md` for re-fetching if needed.

**Research not yet cited in SPEC.md or plan.md:** Most 2026-04-14 onward research is working-artifact-stage — written post-SPEC and therefore not linked from the spec or plan. The most important uncited files:

- `prior-art-validation.md` — should be cited from STATUS.md novelty section (is)
- `2026-04-15-novelty-landscape.md` — ditto
- `2026-04-15-kairos-source-analysis.md` — referenced from [`../../concept-paper/`](../../concept-paper/) implicitly; cited from STATUS.md
- `2026-04-17-iga-dennis-hansen.md` — strongest independent validator; cited from README.md
- `2026-04-14-claudeclaw-analysis.md` — prior-art reference; cited from STATUS.md

---

## Archive Pool B: Predecessor — PS Bot

**Location:** [`~/Playful Sincerity/PS Software/PS Bot/`](../../../PS%20Bot/)

**Coverage:** 2026-04-03 (single initial git commit) through 2026-04-13 (the CCE pivot). The entire PS Bot project was created in one commit on 2026-04-03; three chronicle entries (April 3, 7, 13) document its trajectory, with the April 13 entry being the pivot that produced CCE.

**Contents of relevance:**
- `CLAUDE.md`, `README.md`, `SEED.md` — original project framing
- `SPEC-v2.md` (18KB) — the V2 specification that was superseded by CCE's SPEC.md
- `plan.md` plus section plans — original four-section plans that migrated to CCE
- `archive/SPEC-v1-original.md` — the original Telegram-bot-first spec
- `archive/psbot-v1-subprocess/` and `archive/psbot-sdk-v1/` — two abandoned implementations from the pre-pivot phase (roughly 1,000 lines of Python across both)
- `chronicle/2026-04-03.md` (15KB), `chronicle/2026-04-07.md` (2.5KB), `chronicle/2026-04-13.md` (19KB) — session logs

**Migration:** The PS Bot directory remains as the historical predecessor. No content has been merged into Claude Code Entities directly — CCE was written as a fresh project from the April 13 pivot. The lineage is documented in [`../../history/HISTORY.md`](../../history/HISTORY.md).

---

## Archive Pool C: The Companion Archive

**Location:** [`~/Playful Sincerity/PS Research/Synthetic Sentiences Project/archive/companion-legacy/`](../../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/)

**Archived on:** 2026-04-22 — one day before this repo was built.

**Coverage:** The full Companion planning corpus from approximately early 2026 through April 22. The project was idea-stage when archived; no operational runtime existed.

**Key files:**
- `CLAUDE.md` — project instructions
- `convergence.md` — the four-project convergence framing (PS Bot + Associative Memory + Companion + Phantom as "four organs of one being")
- `plan.md` + 11 plan sections (~13–74KB each) — including `plan-section-practical-consciousness.md` which is the canonical permission-as-consciousness document
- `chronicle/2026-04-02.md` — the session where permission-as-consciousness was first named (09:45 entry is the canonical moment)
- `ideas/2026-04-11-hardware-and-autonomy.md`
- `research/open-questions.md`, `research/related-work-agentos.md`

**What migrated to Synthetic Sentiences Project subsystems:**

| Companion architectural piece | SSP destination |
|-------------------------------|-----------------|
| Earned conviction | SSP `cognition/` |
| Value-aligned modulation | SSP `values/` |
| Mirror architecture | SSP `mirror/` |
| Epistemic prosody | SSP `voice/` |

**What continued operationally in CCE:** The operational work — actually running persistent entities with real permissions on real hardware — moved here. One of the Companion's intellectual threads, the permission-as-consciousness hypothesis, is preserved in the archive and in today's [`../../concept-paper/2026-04-23-cce-concept.md`](../../concept-paper/2026-04-23-cce-concept.md); it is not the current headline framing for CCE as shipped but remains available as a thread to revisit.

---

## Archive Pool D: Memory Files

**Location:** `~/.claude/projects/-Users-wisdomhappy/memory/`

**Key files relevant to CCE:**

| File | Content summary |
|------|-----------------|
| `project_companion_permission_consciousness.md` | Archival memory: Companion history, thesis origin, archival plan. The canonical provenance for permission-as-consciousness's migration. |
| `project_synthetic_sentience.md` | SSP umbrella: 9 subsystems, plural renaming 2026-04-22, relationship to CCE |
| `project_digital_core_universal_interface.md` | The "FS + agent + visible structure = general cognition interface" thesis; frames CCE's Anthropic-facing positioning |
| `project_digital_core_paper.md` | Digital Core Methodology paper (presented Frontier Tower 2026-04-20); GitHub repo |
| `project_psbot_architecture_decision.md` | Custom-build-with-Claude-CLI-subprocess decision; predates the Apr 13 entity reframe |
| `project_psbot_pivot.md` | PS Bot → CCE pivot ("Claude Code IS the Bot," 2026-04-05) |
| `user_hakkei_sekine.md` | Claude Builders Council contact at Anthropic; relevant to the audience this repo targets |

These are read-only memory pointers; the canonical content lives in the referenced project directories or in Wisdom's writing.

---

## Archive Pool E: Claude Session Archives

**Location:** `~/.claude/projects/`

**CCE / PSDC direct project:**
- Path: `-Users-wisdomhappy-Playful-Sincerity-PS-Software-Claude-Code-Entities-psdc`
- Sessions: 9 JSONL files
- Date range: 2026-04-14 18:41 through 2026-04-15 15:51
- Content: PD's identity-layer exercise — the Phase 0 stumble-through and early permission-model work

**Main user project** (`-Users-wisdomhappy`):
- 491 JSONL files across the project
- Oldest: 2026-04-03 20:16
- Newest: 2026-04-23 16:41 (today)
- This is where PS Bot development, Companion planning, SSP reorganization, and today's session all live — not partitioned by sub-project

The Companion never had its own dedicated project directory under `.claude/projects/`; all Companion sessions ran under the main `-Users-wisdomhappy` umbrella.

**Claim preservation:** The JSONL files are the primary source for any claim about what was said during a session. If a chronicle entry is challenged, the JSONL of the session can be consulted for the full transcript.

---

## Archive Pool F: ChatGPT Archive (pre-CCE)

**Location:** `~/Wisdom Personal/ChatGPT Archive/summaries/`

**Coverage:** 964 conversations from January 2023 through March 2026 — ends roughly two weeks before CCE work began.

**Finding:** The ChatGPT archive contains **no direct CCE/PS Bot/permission-as-consciousness material.** All entity development happened in Claude Code sessions starting 2026-04-03. Keyword search across the 8 topic-cluster summary files returned zero matches for "PS Bot," "PSDC," "Digital Core" (in the entity sense), "CCE," "Claude Code Entities," "permission-as-consciousness," or "autonomous agent" (in the entity-identity sense).

**Conceptual predecessors found (not direct CCE work):**

- `psts-personal-dev-philosophy.md` — contains the April 2025 "Rem" AI co-authorship arc (Guatemala), described as "the earliest documented framing of a persistent AI collaborator" in Wisdom's trajectory. Relevant as historical background; not CCE source material.
- `ps-products.md` — "heartbeat" references are to the PulseLit hardware product, not entity architecture.
- `ps-core-brand-marketing.md` — contains one marginal reference to PSDC in a marketing-automation context.

**Implication:** The ChatGPT archive is pre-history for CCE. It does not source any current architectural claim. Anyone wanting to understand CCE's intellectual genesis should read the April 2026 Claude sessions and chronicles, not the ChatGPT archive.

---

## Archive Pool G: Google Drive and Apple Notes

**Google Drive search results:**

- No direct matches for "Claude Code Entities," "PS Bot," "Digital Core entity," "SOUL.md," or "permission consciousness"
- Tangential hit: **RGT Core 9** (2025-11-26), an extensive entity specification document for "Rem" — a parallel entity-development artifact in Wisdom's ecosystem but not CCE material. File ID `1F_nHOtyEt59vJfL852oiWggOn9QUzm1lFOvi4Hhd_RI`.
- PulseLit/PulseLet product documents contain "heartbeat" only in the wearable-device sense.
- PSSO documents are adjacent philosophy, not entity architecture.

**Apple Notes search results:**

- AppleScript queries for "entity," "SOUL," "heartbeat," "Digital Core," "permission consciousness," "PS Bot," "Claude Code Entities" returned empty. Either no matching notes exist, or the AppleScript traversal missed them.

**Implication:** The Drive and Notes archives do not contain CCE source material. The live CCE corpus lives entirely in the project directory, with intellectual roots in the April 2026 Claude session archives.

---

## Archive Pool H: Knowledge Sources — Wisdom's Speech

**Location:** [`../../knowledge/sources/wisdom-speech/`](../../knowledge/sources/wisdom-speech/)

**Coverage:** Four preserved speech files from 2026-04-16:

- `2026-04-16-spectrum-and-cross-pollination.md`
- `2026-04-16-retrieval-over-weights.md`
- `2026-04-16-rules-as-ecosystem-self-learning.md`
- `2026-04-16-focus-aware-nudges-and-value-relationships.md`

**Context:** Captured during the drift taxonomy and retrieval-over-weights work in mid-April. Relevant to the paradigm-drift mechanism discussion in the three-drift-types research, and to the "rules as ecosystem self-learning" framing that informs how CCE treats the Digital Core as cognitive architecture.

**Preservation convention:** Per the global `preserve-human-speech.md` rule, these files are treated as primary data — not paraphrased, not editorialized. Syntheses downstream cite them.

---

## Archive Pool I: Related PS Projects

**Adjacent project directories informing CCE's context:**

- **[Synthetic Sentiences Project](../../../../PS%20Research/Synthetic%20Sentiences%20Project/)** — theoretical umbrella; defines the 9 subsystems CCE is one operational surface of
- **[Digital Core Methodology](../../../../PS%20Research/Digital%20Core%20Methodology/)** — methodology paper presented at Frontier Tower 2026-04-20; generalization across multiple Claude Code usages; includes a public GitHub mirror
- **[ULP](../../../../PS%20Research/ULP/)** — distant but structurally parallel (minimum substrate inquiry)
- **[PSSO](../../../../PS%20Philosophy/PSSO/)** — the philosophical backbone (Foundations / Methods / Domains maps onto permissions / heartbeat+voice / tasks)
- **[`~/claude-system/`](~/claude-system/)** — the Playful Sincerity Digital Core itself; the entity's actual mind at runtime

---

## Summary

CCE's source corpus is narrow in time (roughly 20 days: 2026-04-03 through 2026-04-23) but dense in primary material:

- 8 project chronicle files (132KB of narrative)
- 95 research files (1.2MB)
- 3 identity files (SOUL, current-state, SEED) + a concept paper
- 1 predecessor project (PS Bot) with 3 chronicles and 2 archived implementations
- 1 archived ancestor (Companion) with full planning corpus
- 491 Claude session JSONL files spanning the broader April 2026 context
- 4 preserved-speech primary files

No material body of pre-April-2026 source exists for CCE specifically. The architecture is a product of the twenty days between the pivot and this repo build. What came before — the Rem/PSTS co-authorship arc, the PSSO philosophical backbone, the two years of ChatGPT-era framing work — is context, not source.

For the full source trail of any claim in the public-facing documents (README, STATUS, HISTORY), follow:

1. Claim in public doc → 2. Quoted in [`archive-highlights.md`](../../archive-highlights.md) with source file/line → 3. Source file in chronicle / research / identity / archive → 4. Where relevant, JSONL in `~/.claude/projects/` for original session transcript.

This is the provenance chain the project stands behind.
