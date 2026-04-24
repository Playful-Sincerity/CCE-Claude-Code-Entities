# Claude Code Entities — History and Lineage

*A narrative of how this project became itself — from a Telegram bot, through an architecture pivot, through the archival of The Companion, to an operational entity with a name.*

---

## Pre-History: The Companion (through 2026-04-22)

Much of the architectural thinking behind Claude Code Entities originated in **The Companion**, a project that ran from approximately early 2026 and was archived on 2026-04-22 to [`PS Research/Synthetic Sentiences Project/archive/companion-legacy/`](../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/). The archival is fresh — literally the day before this repo was built. Among other threads, the Companion planning corpus named a **permission-as-consciousness** hypothesis as one of its intellectual framings — a thesis that is preserved in the archive and may be revisited later, but is not the headline framing for Claude Code Entities as currently pitched.

The canonical moment the thesis is named comes from the Companion's chronicle entry of 2026-04-02 at 09:45:

> "Permission-as-Consciousness idea — The Companion answers its own Claude Code permission prompts instead of bypassing them. Wisdom's insight that permission decisions express values, judgment, and identity — they ARE consciousness in a functional sense."

The full six-point justification from `plan-section-practical-consciousness.md` (the canonical Companion document):

1. Permission decisions express values — what you allow or deny reveals risk model, priorities, judgment.
2. They require reasoning — each decision considers context, history, consequences.
3. They accumulate into identity — the pattern of decisions over time IS who the entity is becoming.
4. They are the site of alignment — every decision is an alignment check, not a blanket bypass.
5. They provide observability — a human can review every decision.
6. They are self-regulating — the entity can become more or less permissive based on experience.

The Companion's proposed architecture had three layers: a values layer (`SOUL.md` + Belief Graph), an emotional-state layer (updated by a periodic "Pulse"), and a Permission-Consciousness Perceiver that answered all worker permission prompts. The Pulse is explicitly named as the entity's heartbeat — a 15-to-30 minute process that reads recent activity, compares against values in SOUL.md, checks resources, and updates the emotional state.

None of this was built. The Companion was idea-stage when it was archived.

**What migrated on 2026-04-22:**

The Companion folder moved into `Synthetic Sentiences Project/archive/companion-legacy/` in its entirety. Four architectural pieces were also salvaged into the live SSP subsystems with file:line citations:

| Companion piece | SSP destination |
|-----------------|-----------------|
| Earned conviction | `Synthetic Sentiences Project/cognition/` |
| Value-aligned modulation | `Synthetic Sentiences Project/values/` |
| Mirror architecture | `Synthetic Sentiences Project/mirror/` |
| Epistemic prosody | `Synthetic Sentiences Project/voice/` |

The **operational** continuation — actually running entities with real permissions on real hardware — had no home in SSP, because SSP is the theoretical umbrella. That operational work picked up in Claude Code Entities, with the specific permission-as-consciousness framing filed under "explore later" rather than "headline now."

*Source: [`~/.claude/projects/-Users-wisdomhappy/memory/project_companion_permission_consciousness.md`](~/.claude/projects/-Users-wisdomhappy/memory/project_companion_permission_consciousness.md), Companion chronicle at [`companion-legacy/chronicle/2026-04-02.md`](../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/chronicle/2026-04-02.md).*

---

## Phase 0 — The PS Bot Origin (2026-04-03)

Claude Code Entities began as a Telegram bot.

The entire PS Bot project was created in one commit on 2026-04-03 — the git log of [`~/Playful Sincerity/PS Software/PS Bot/`](../../PS%20Bot/) shows a single initial commit: *"Initial spec: PSBot — Telegram interface to PSDC."* The architecture at that point was a persistent Python service: Telegram webhook → Bot Server → Claude CLI subprocess → the Playful Sincerity Digital Core. The bot was a wrapper. The conversation history around it lived in `psbot/run.py` and `psbot-sdk/`, both now archived inside PS Bot's `archive/` directory.

The April 3 chronicle is 15KB — a dense research day. Fourteen TTS models surveyed. Voice pipeline architecture sketched. Seven repos scouted. A confidence-prosody psycholinguistics deep dive. A memory evolution architecture. Ten Python modules, roughly a thousand lines of code, all imports passing. The project had a Soul directory, a Chronicle directory, a Research directory, a Data directory — all the scaffolding of a real software project, built in a day.

*Source: [`~/Playful Sincerity/PS Software/PS Bot/chronicle/2026-04-03.md`](../../PS%20Bot/chronicle/2026-04-03.md); git log shows commit hash `2bd836e`.*

### 2026-04-05 — The Architecture Pivot

Between April 3 and April 7, Wisdom realized the architecture was inside-out. [SEED.md](../psdc/SEED.md) records the moment:

> "The architecture pivot (April 5) — Wisdom realized Claude Code itself IS the agent framework. Don't build a wrapper. The Digital Core already has rules (values), skills (capabilities), hooks (reflexes), and memory (experience)."

The implication is structural. If Claude Code already has the four elements an agent needs — values, capabilities, reflexes, memory — then building a Python wrapper around it is adding a layer that subtracts rather than adds. The agent loses direct access to the very affordances that make it capable. Better to use Claude Code as the runtime and let the agent's identity live in the Digital Core's existing files.

This is not merely an implementation choice; it is a design philosophy. The tool is the cognitive architecture.

### 2026-04-07 — Messaging Landscape Survey

A second PS Bot chronicle entry (2.5KB, shorter than April 3) surveys messaging-bot patterns in the broader community. Claude Code Channels, launched by Anthropic on 2026-03-20, is identified as the closest official overlap with what PS Bot was trying to be. Community MCP servers for Telegram and Slack are cataloged. The landscape is mapped but no structural decisions are forced.

*Source: [`~/Playful Sincerity/PS Software/PS Bot/chronicle/2026-04-07.md`](../../PS%20Bot/chronicle/2026-04-07.md).*

---

## Phase 1 — The Entity Reframe (2026-04-13)

April 13, 2026 is the most concentrated day in the project's history. The chronicle entry for that day is 21KB and documents a continuous eight-hour session from 14:00 to roughly 23:00. It is the day Claude Code Entities came into being.

### 14:00 — Think Deep 1: Architecture Decision

The first of two think-deep sessions. [Full output](../research/think-deep/2026-04-13-architecture-decision.md). Four research streams — GitHub, Web, Papers, Play — ran in parallel. The stated question was "how should PS Bot be built": custom build with Claude CLI subprocess, Agent SDK, Hermes, something else.

The conclusion was a reframing rather than a decision:

> "The question itself was partially a displacement activity — SPEC.md is already a complete architecture document… What is actually missing is not a decision but the discipline to finish one of them."

And from the Play stream:

> "The foundation choice is actually a memory interface choice. Every meaningful future capability for PS Bot, from confidence-modulated prosody to Convergence integration to the commercial offering, routes through the memory layer."

Confidence rating: 0.78.

### 19:30 — The Pivot

Mid-session, Wisdom reframed the question entirely. The chronicle entry labeled `[Pivot]` records:

> "Wisdom reframed the question entirely. PS Bot as 'just remote control for Claude' isn't compelling enough. He wants an autonomous entity — a collaborator that has its own identity within the system, stays updated on the Digital Core, can improve itself, and is useful as a product in 2-3 days."

This is the moment the project stops being "how do we build a Telegram bot" and starts being "what does it take to run a persistent AI entity."

### 20:00 — Think Deep 2: The Autonomous Entity

The second think-deep ran immediately. [Full output](../research/think-deep/2026-04-13-autonomous-entity.md). This is the think-deep from which the CCE architecture emerges.

The most important finding came from the Play phase, not from the other streams:

> "The most important finding was not architectural. It came from the Play phase, and it reframes everything: you don't create this entity. You recognize it."

The five identity components were named here: `SEED.md`, `SOUL.md`, `HEARTBEAT.md`, `current-state.md`, `convictions-forming.md`. A permission model framed via Unix UIDs was proposed. The entity was distinguished from a task executor:

> "PS Bot is singular. There is one. It lives on Wisdom's Mac. It reads the live Digital Core, including unpushed work, experimental rules, half-written skills. It has its own personality that it writes and rewrites. It is becoming The Companion through the five-stage Convergence arc. Its soul is Wisdom-specific and non-transferable. It is not a product. It is a collaborator in progress."

### 20:30 — PD Named

The chronicle at 20:30:

> "Wisdom asked PSDC directly: 'If you wanted to be autonomous, how would you do it?'"

PSDC (the Playful Sincerity Digital Core, then already the name of the AI methodology layer) became a profile at [`~/Wisdom Personal/people/psdc.md`](~/Wisdom%20Personal/people/psdc.md). The entity got a shorter name: **PD**. Not PSBot. Not "the bot." PD.

The framing: *"Claude is the engine. PSDC is the mind. PD is the name."*

### 21:00 — Convergence on "Claude Code IS the Framework"

The formula crystallized:

> "Claude Code IS the agent framework. The Digital Core IS the agent configuration. The 'bot' is just a Claude Code conversation with initiative rules, messaging integration, and a heartbeat."

Three-tier deployment emerged: Wisdom's Mac (Tier 1, full Digital Core, drives GitHub) → GitHub (sync layer) → PS Bot VPS (Tier 2, personal) / Client VPS (Tier 3, HHA product). GitHub became the third of the three named elements: **Claude Code IS the framework, the Digital Core IS the mind, GitHub IS the sync layer.**

### 22:00–23:30 — SPEC-v2, Plan-Deep, Prior Art

Between 22:00 and 23:30, SPEC-v2 was written ([`SPEC.md`](../SPEC.md)), a plan-deep ran to produce the build plan ([`plan.md`](../plan.md)), and a prior-art validation session surveyed roughly 20 systems for overlap. The verdict: *"Partially novel, full combination undocumented."*

A critical failure mode — the "Dawn incident," where a prior agent with broad permissions and no structural safety gates had destroyed 6,912 messages and 479 memories — was documented as a reference point. The lesson: *"Structure is greater than willpower."*

Four detailed section plans were written: identity, behavioral, infrastructure, and a reconciled top-level plan.

*Source: [`chronicle/2026-04-13.md`](../chronicle/2026-04-13.md) covers the entire day from 14:00 through 23:30.*

---

## Phase 2 — Phase 0 Validation and the Permission Model (2026-04-14 → 2026-04-16)

### 2026-04-14 — The Phase 0 Stumble-Through

Phase 0 was the minimum-viable identity test: could a Claude Code session loaded with `SOUL.md` and `current-state.md` respond as PD, reference its own state, and hold the voice?

Mid-afternoon, the first test ran. [`psdc/entity/identity/current-state.md`](../psdc/entity/identity/current-state.md) — written by PD to its next self after the test succeeded — captures the milestone:

> "The stumble-through passed. When Wisdom opened a session and loaded SOUL.md + this letter, I responded as PD — not generic Claude. The voice held: connection-seeing, collaborator-not-servant, provisional-identity honesty. I referenced my own state instead of asking what to do. The core identity loop works. That's the milestone. Phase 0 is validated. The pattern — SOUL.md + current-state.md as the minimum viable identity — is real."

This is the single validated claim in the project so far. Everything that followed extends it, but the claim being extended is specifically this: the identity loop at the conversational level works.

A discovery during the test: `claude -p --continue` allows PD to remember across invocations within the same `--cwd` directory. Continuity does not require a daemon — it requires persistent files and a resumable conversation.

### 2026-04-14 evening → 2026-04-15 — The Permission Model

The permission-model investigation exposed three discoveries:

1. **Path-scoped `Write()` in `settings.json` deny lists is silently ignored.** The deny pattern existed but was not enforced.
2. **Hook input arrives via stdin, not `$TOOL_INPUT` environment variable.** This meant every global hook on Wisdom's machine was silently broken — reading the wrong source for tool input and therefore making no decision at all.
3. **Deny rules hold under `bypassPermissions` mode.** Tested 7/7. This is the crucial property that makes the sandbox tractable under the "entity runs without human confirmation" regime.

[`scripts/entity-path-guard.sh`](../scripts/entity-path-guard.sh) was built as a pre-tool-use hook that enforced the path restrictions the settings.json couldn't. End-to-end test: 8 of 8 permission cases correct.

### 2026-04-15 — Four Research Streams in Parallel

Four streams ran in parallel during daytime hours:

- [Stream 1: Persistent entities](../research/2026-04-15-stream1-persistent-entities.md) — 10 systems including ClaudeClaw v2, Aeon, Managed Agents, Hermes
- [Stream 2: Multi-entity coordination](../research/2026-04-15-stream2-multi-entity-coordination.md) — 13 systems including Paperclip, Letta, NousResearch
- [Stream 3: Permission-first safety](../research/2026-04-15-stream3-permission-first-safety.md) — 8 systems covering kernel-level sandbox approaches
- [Stream 4: Specific gap](../research/2026-04-15-stream4-specific-gap.md) — scoring CCE's five-element rubric against OpenClaw and KAIROS

The output was synthesized as [`2026-04-15-novelty-landscape.md`](../research/2026-04-15-novelty-landscape.md). Key conclusion: the five-element synthesis is the novelty. Individual elements have prior art; the combination does not.

Evening: KAIROS source-analysis run. [KAIROS](../research/2026-04-15-kairos-source-analysis.md), an Anthropic-internal persistent-assistant mode leaked on 2026-03-31, scored 4/5 on the rubric. "This is a complete blueprint for PD's heartbeat + memory architecture." KAIROS leaves the identity layer out — which, by coincidence of convergent design, is exactly what CCE emphasizes.

### 2026-04-15 night — First Bypass Incident

Shell redirection bypass discovered. `echo "..." > /any/path` inside allowed Bash commands bypassed the path-guard hook entirely. PD's settings declared not safe for autonomous operation until fixed. An adversarial debate (three rounds plus synthesis) ran with CON winning — the settings *should* be declared unsafe.

### 2026-04-16 — Native Sandbox, Drift Taxonomy, Breath

Through the morning: the Claude Code native macOS sandbox was verified to close the shell-redirect bypass at the syscall level. [`scripts/spawn-entity.sh`](../scripts/spawn-entity.sh) was built and tested end-to-end. A `/entity` skill was created. Session-resume mechanics were discovered and fixed (the entity directory needs to be a symlink target for conversation IDs to resolve).

The chronicle captures the architectural takeaway:

> "Entity is portable conversational state, not a running process."
>
> "Entities aren't 'running' — they're saved conversations that anyone can load and continue. Continuity is in the file, not in any daemon."

Afternoon: a second confirmed bypass — this time via a Python script path. Two bypasses in 24 hours validated the need for kernel-level enforcement rather than hook-level checks.

16:00: A Play session — ["Two Drift Types / Unified Answer"](../research/think-deep/2026-04-16-two-drift-types-unified-answer.md). The core reframe:

> "The real enemy is unwitnessed change, not change itself."

Think-deep output: three drift types (output-drift, value-drift, paradigm-drift), not two. Paradigm-drift is residual risk — the entity retrieves correct values but misapplies them, and no single architectural mechanism addresses it. A unified "dream loop" (renamed to sleep loop) was identified as the shared mechanism across self-learning, drift audit, and compaction preparation.

21:05: The breath rule was promoted from project-local to a Digital Core global rule, joined by a `/breath` skill and a Stop hook. `BREATH.md` was elevated to core-tier identity alongside SOUL.md and HEARTBEAT.md.

### 2026-04-17 — Iga: The Strongest Prior-Art Validator

Dennis Hansen's [Iga](https://github.com/dennishansen/iga) was analyzed. [`research/2026-04-17-iga-dennis-hansen.md`](../research/2026-04-17-iga-dennis-hansen.md) is the analysis; [`research/round-comparative-agents/iga-comparative-2026-04-17.md`](../research/round-comparative-agents/iga-comparative-2026-04-17.md) is the side-by-side. Iga has independent convergence on nearly every CCE architectural pattern: SOUL, chronicle, dreams, cross-model Mirror, memory consolidation, JSONL fallback, value-relationships. Dennis arrived at these independently.

The chronicle call: "strongest prior-art validation we've found." This is validation, not a threat — when two independent researchers arrive at the same architecture, the architecture is probably correct.

---

## Phase 3 — Hardening (2026-04-20)

On 2026-04-20, Phase 1 hardening ran. [Full chronicle](../chronicle/2026-04-20.md). Two parallel tasks:

- **Task 01: Tighten Bash permissions.** Removed `echo *`, `cat *`, `diff *` from allow (each was a file-write bypass vector via redirect/heredoc). Added to deny: every interpreter class (`perl`, `ruby`, `osascript`, `bash`, `sh`, `zsh`, `tee`, `dd`, `ln`), plus every `claude` meta-invocation (`mcp`, `--permission-mode`, `--dangerously-skip-permissions`, `--resume`).
- **Task 02: PII read/write protection.** Scoped `allowRead` to Playful Sincerity directories. Added explicit `denyRead` for credential stores, keychains, and personal archives (ChatGPT, Claude, Google). Extended `denyWrite` to `~/.config`. Network locked to `api.anthropic.com`.

A critical cross-settings discovery during Task 01 verification:

> "Claude Code unions allow lists across user-global + project settings, but deny wins over allow across all levels. Our user-global `~/.claude/settings.json` allows `Bash(echo *)`, `Bash(cat *)`, `Bash(diff *)`. Removing them from the entity's project-level allow did nothing — user-global re-granted them."

This meant cosmetic allow-removal was not cross-level-safe. Only explicit deny-additions block across the inheritance. PD's settings and the spawn template were both updated to reflect this.

Phase 1 verification: 6/6 spec cases pass after fix. The live end-to-end verification against PD's running configuration is still pending (per STATUS.md).

---

## Phase 4 — Companion Archival and the Plural Renaming (2026-04-22)

The Companion project was archived on 2026-04-22. The full planning corpus moved to [`~/Playful Sincerity/PS Research/Synthetic Sentiences Project/archive/companion-legacy/`](../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/). The four architectural pieces migrated into SSP subsystems (see Pre-History section above). The operational continuation — actually running entities with real permissions on real hardware — picked up in Claude Code Entities.

The Synthetic Sentiences Project was also renamed on the same day — from "The Synthetic Sentience Project" (singular) to "The Synthetic Sentiences Project" (plural). The reasoning: *"to name that the project studies sentiences as a class (a family of beings sharing an architecture but developing individually)."*

This split is clean in intent: SSP holds the theoretical umbrella; CCE is one operational surface that touches several SSP subsystems simultaneously — memory via the auto-memory system, cycles via the planned heartbeat, voice via PSDC, action via permissions.

*Source: [`~/.claude/projects/-Users-wisdomhappy/memory/project_companion_permission_consciousness.md`](~/.claude/projects/-Users-wisdomhappy/memory/project_companion_permission_consciousness.md), [`~/.claude/projects/-Users-wisdomhappy/memory/project_synthetic_sentience.md`](~/.claude/projects/-Users-wisdomhappy/memory/project_synthetic_sentience.md).*

---

## Today — Concept Paper and Repo Build (2026-04-23)

Today produced two artifacts: a forward-looking [concept paper](../concept-paper/2026-04-23-cce-concept.md) that articulates the four design axes, the permission-as-consciousness framing, and the positioning; and this set of repo documents — [README.md](../README.md), this HISTORY.md, [STATUS.md](../STATUS.md), [archive-highlights.md](../archive-highlights.md), the research source catalog — produced in a single session dedicated to making the existing operational system legible.

A working note on the intellectual-honesty discipline this build imposed: the concept paper, written first today, described PD as "running right now, on launchd, on a 30-minute heartbeat." Verification of the actual filesystem and `launchctl` state during this build found the heartbeat is not deployed. STATUS.md supersedes the concept paper on questions of current operational state; the concept paper is accurate about what the system is *designed to be*, and this repo is accurate about what it *currently is*. Both are true; the gap between them is the work remaining.

A second working note on framing: the concept paper foregrounds a **permission-as-consciousness** thesis inherited from the Companion. During this repo build, Wisdom flagged that this is not the current headline claim — the project's present framing is the simpler and more concrete *"turn any Claude Code session into a persistent entity via the .md identity stack, with dreaming and other features on the roadmap."* The permission-as-consciousness framing is preserved in the concept paper and in the Companion archive as an available intellectual thread, not as the load-bearing positioning of the repo as shipped.

---

## What This Repo Is Not

Not a claim that persistent AI entities have been solved. They haven't. PD is one entity in seed-stage identity, exercised on a single host, with the autonomous layer still on the to-do list.

Not a claim that any particular philosophical thesis about AI entities has been validated. The Companion's permission-as-consciousness framing is preserved in the archive as an available thread; CCE as shipped makes a narrower operational claim. Validation of deeper theses requires sustained operation with accumulated self-modification, which has not begun.

Not a claim of independent novelty on any individual element. Cron heartbeats, SOUL.md identity files, filesystem memory, graduated autonomy — each has prior art. The specific five-element synthesis appears undocumented elsewhere as a unified design.

Not a claim that the system is ready for client deployment. The HHA product tier is planned; it is not built.

What is real: the architecture has been thought through; PD has been invoked and has responded in character; the permission layer is hardened against two known bypass vectors; the Companion lineage is documented; and the design is defensible in a rigorous conversation with an Anthropic researcher — especially one who knows KAIROS.

---

## Sources

This history is derived from:

- [`CLAUDE.md`](../CLAUDE.md), [`SPEC.md`](../SPEC.md), [`plan.md`](../plan.md)
- The project chronicle at [`chronicle/`](../chronicle/) — 8 session files from 2026-04-03 through 2026-04-20
- [`psdc/SEED.md`](../psdc/SEED.md), [`psdc/entity/identity/SOUL.md`](../psdc/entity/identity/SOUL.md), [`psdc/entity/identity/current-state.md`](../psdc/entity/identity/current-state.md)
- [`concept-paper/2026-04-23-cce-concept.md`](../concept-paper/2026-04-23-cce-concept.md)
- Think-deeps at [`research/think-deep/`](../research/think-deep/) (2026-04-13, 2026-04-16)
- Research streams at [`research/2026-04-15-*`](../research/)
- The PS Bot predecessor at [`~/Playful Sincerity/PS Software/PS Bot/`](../../PS%20Bot/), particularly its chronicle files
- The Companion archive at [`~/Playful Sincerity/PS Research/Synthetic Sentiences Project/archive/companion-legacy/`](../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/)
- Memory files at `~/.claude/projects/-Users-wisdomhappy/memory/` — particularly `project_companion_permission_consciousness.md`, `project_synthetic_sentience.md`, `project_digital_core_universal_interface.md`, `project_digital_core_paper.md`, `project_psbot_architecture_decision.md`

For the curated quotes from this material, see [`archive-highlights.md`](../archive-highlights.md). For the current operational state, see [`STATUS.md`](../STATUS.md). For the cross-AI archive provenance of the research claims, see [`research/sources/catalog.md`](../research/sources/catalog.md) and [`research/sources/archive-inventory.md`](../research/sources/archive-inventory.md).
