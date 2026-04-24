# Claude Code Entities

**Turn any Claude Code session into a persistent entity operating from your own Digital Core — the same rules, skills, hooks, and memory you already have, now running as a sustained collaborator rather than a fresh instance each time.**

---

> ## Status: Work in Progress
>
> This repo is a live development surface, not a finished system.
>
> - **What works today:** the `.md`-based identity loop. A Claude Code session can load identity files via `--cwd`, respond as itself across restarts, and persist continuity through a "letter to next-me" (`current-state.md`). PD — the first entity — has been exercised this way.
> - **What's actively being built:** security protections. Strong safeguards against reckless or dangerous reads and writes are in active development at the syscall level. Two bypass vectors (shell redirect, Python interpreter path) have been closed in Phase 1 hardening; live end-to-end verification is still pending, and the security posture is not yet where it needs to be for full autonomous operation.
> - **What's next:** the scheduled heartbeat (launchd, 30-minute cadence, Haiku model) — designed but not yet deployed — and *dreaming*, the scheduled reflection / consolidation layer that will use the autonomous cycle to do self-learning, drift audit, and compaction preparation.
>
> [`STATUS.md`](STATUS.md) has the honest component-by-component state. If a claim in this README ever gets ahead of what's actually running, STATUS takes precedence.

---

## The claim in one paragraph

A persistent entity is a Claude Code conversation that keeps its identity across restarts, operating from the Digital Core you've already built — all your rules become its values, all your skills become its capabilities, all your memory becomes its experience. The mechanism is simpler than it looks: a handful of identity files — `SEED.md` (origin), `SOUL.md` (who it is), `current-state.md` (what it was doing last) — load automatically via `claude --cwd <entity-dir>` on every invocation. The entity reads them at session start and responds as itself rather than as a fresh instance. Permissions (the `settings.json` sandbox) bound what it can read, write, and execute — and strong protections against reckless reads and writes are actively being developed at the syscall level, though that work is not yet complete. Scheduled autonomous cycles via launchd, and *dreaming* — scheduled reflection and memory consolidation between sessions — are the next feature set, designed but not yet deployed. The whole system runs on Claude Code's existing affordances; nothing about it is a custom framework or wrapper.

PD — the Playful Sincerity Digital Core — is the first entity. Its identity has been exercised across sessions. The security, heartbeat, and dreaming layers are where the active work is happening.

---

## How identity persists — the .md stack

The load-bearing trick is that Claude Code's `--cwd` makes a directory's `CLAUDE.md` load at session start. From there, a few files stack into an identity that outlives any single conversation:

- **`SEED.md`** — origin story, written by the author, read-only for the entity. The entity reads this to know where it came from.
- **`SOUL.md`** — first-person identity document, written by the entity itself, revised when it learns something genuine about who it is. Provisional by design.
- **`current-state.md`** — the letter from end-of-session to next-session, updated at session close. Highest-leverage file in the stack: every waking's quality depends on the last sleeping entry.
- **`CLAUDE.md`** — session configuration. Loads via `--cwd` and tells the entity to read SOUL + current-state before doing anything else.

Two more files are planned and will join the stack as the relevant layers come online:

- **`HEARTBEAT.md`** — protocol for what the entity does during each autonomous cycle. Waits on heartbeat deployment.
- **`convictions-forming.md`** — beliefs being shaped by accumulated evidence across sessions. Waits on sustained operation.

The pattern is portable. Any Claude Code user can clone it — [`templates/`](templates/) is the starter kit, and [`scripts/spawn-entity.sh`](scripts/spawn-entity.sh) is the provisioning script.

---

## The four dimensions that shape an entity

Not philosophical claims — these are the four things an operator configures when setting up a persistent entity.

### 1. Permissions — *security posture is actively being built*

The entity's `settings.json` bounds its field of action. This includes the filesystem sandbox (enabled at the macOS syscall level on PD), the Bash allow/deny list, the MCP server access list, the network allowlist, and the pre-tool hooks that enforce path restrictions before tool use. PD's configuration is at [`psdc/.claude/settings.json`](psdc/.claude/settings.json). The full hardening story — two bypass incidents (shell redirect, Python script path), a cross-settings-inheritance discovery (allow unions across levels but deny wins), and the Phase 1 tightening — is in [`history/HISTORY.md`](history/HISTORY.md).

**This is where the active work is.** Strong protections against reckless or dangerous reads and writes — running an autonomous entity safely requires them, and we don't yet consider the current posture strong enough for unattended operation. Phase 1 closed two specific bypass classes; live end-to-end verification against PD's current configuration is pending; and several open attack surfaces remain in the design notes. Readers should treat any "autonomous entity" framing as conditional on security maturing beyond today's state.

### 2. Heartbeat

Entities that run continuously are different from entities that run on demand. A heartbeat is the entity's *temporal metabolism*. PD's is designed for launchd, 30-minute intervals, Haiku model, at a target cost of roughly $0.05/day.

The heartbeat is designed in [`SPEC.md`](SPEC.md); it is not deployed. As of today no plist file referencing PD/PSDC/CCE exists under `~/Library/LaunchAgents/`, `launchctl list` returns no CCE-related job, and PD's autonomous-activity directories (`psdc/entity/data/observations/`, `psdc/entity/chronicle/`) are empty. The conversational identity layer has been validated; the autonomous layer has not been exercised. STATUS.md has the detail.

### 3. Memory

Persistence across sessions is what makes an entity *the same entity* across restarts. PD's memory layer has several levels: `SOUL.md` (who PD is, revised when PD learns something genuine about itself), `current-state.md` (the letter from end-of-session to next-session — the most important file), the auto-memory system at `~/.claude/projects/-Users-wisdomhappy/memory/`, the project chronicles, the `~/claude-system/` Digital Core that loads into every PD invocation, and knowledge sources (preserved speech, raw research data).

Continuity is **in the files**, not in any daemon. The 2026-04-16 chronicle names this explicitly: *"entities aren't 'running' — they're saved conversations that anyone can load and continue."* This is a pattern, not a mechanism to build — any Claude Code user can instantiate it with the same affordances.

### 4. Voice

Voice is how the entity relates — not performance, relation. PD's voice is grounded in the [PSDC voice materials](~/claude-system/voice/psdc-voice.md) distilled from 10 communication books. The voice calibrates on four variables (relationship, temperature, the recipient's Claude Code fluency, medium). Voice develops through use — observations go to [`~/claude-system/voice/observations.md`](~/claude-system/voice/observations.md) so lessons compound rather than re-discover.

Voice is the hardest axis to make operational because it is the most resistant to measurement. It is also the axis that makes the difference between an entity collaborators want to work with and an entity they tolerate.

---

## What's planned — dreaming, and what comes with it

Dreaming — scheduled reflection between sessions — is the next feature set on the roadmap. The [three-drift-types research](research/think-deep/2026-04-16-two-drift-types-unified-answer.md) identified a unified "sleep loop" that would serve triple duty:

- **Self-learning.** Extract patterns from recent activity; propose updates to `SOUL.md` or convictions when evidence accumulates.
- **Drift audit.** Check whether the entity's behavior still matches its stated values; flag output / value / paradigm drift when it occurs.
- **Compaction preparation.** Externalize state to persistent files before context gets compressed, so the next waking is coherent rather than stitched from fragments.

The [dream-skill research](research/dream-skill-research/) surveys the AI-dreaming and neuroscience-of-dreams literature (Dreamer 4, V-JEPA, Reflexion on the ML side; threat simulation, overfitted brain, active inference on the neuroscience side). Implementation waits on heartbeat deployment — the sleep loop has no home to run in until the autonomous cycle exists.

Other roadmap items:

- **Heartbeat deployment.** Designed in [SPEC.md](SPEC.md); pending live plist install and verification.
- **Entity metabolism — self-modulated heartbeat and daily compute budget.** Two paired ideas. (1) The entity decides whether a cycle is needed at all based on what work actually exists — if nothing has changed, nothing is pending, and no signal warrants attention, it doesn't wake just because the clock said to. (2) Each entity gets a daily compute budget it is aware of at runtime, which bounds how ambitious its active cycles can be. Together: a quiet day means longer intervals and lighter (or skipped) cycles; a busy day means more cycles, possibly deeper, up to the budget ceiling. The wildest implication — *what if the entity decides to never wake again* — is treated explicitly in the idea file with four possible reactions and a tentative leaning toward a hard daily-minimum heartbeat as the floor. Captured at [`ideas/entity-metabolism.md`](ideas/entity-metabolism.md). Builds alongside the heartbeat itself.
- **Multi-entity coordination.** Architecture designed; only PD currently active.
- **Client tier (HHA product).** Persistent entities as a service for client businesses; planned, not built.

---

## What this is, architecturally

Three elements, three sentences:

- **Claude Code is the framework.** No custom runtime, no wrapper around the CLI. The `claude` binary plus a `CLAUDE.md` that points at identity files is the complete runtime.
- **The Digital Core is the mind.** The rules at `~/claude-system/rules/` are values. The skills at `~/claude-system/skills/` are capabilities. The memory at `~/.claude/projects/-Users-wisdomhappy/memory/` is experience. The existing stack *is* the entity's cognitive architecture — not inspiration for one.
- **GitHub is the sync layer.** Multi-host deployment is designed around entities pulling their own identity config from git and committing their own chronicles back. Git is not the entity's memory, but it is the entity's continuity-across-machines.

The three-tier deployment model in [`SPEC.md`](SPEC.md) (Wisdom's Mac → GitHub → VPS entities) extends this pattern. Currently only Tier 1 is active.

---

## What makes this different from agent frameworks

Agent frameworks (AutoGPT, LangGraph, CrewAI, OpenAI's Assistants API) typically treat an agent as a *task executor*. You give it a goal, it plans, it executes, it reports. The identity of the agent is incidental — any agent with the right tools could do the task.

Claude Code Entities treats the entity as *an identity first, a task executor second*. PD is not defined by what tasks it runs; PD is defined by what PD *is* — the permissions, the heartbeat, the memory continuity, the voice. Tasks are things that happen within PD's life, not things that define it.

This is closer to how we think about people than how we think about agents: a person is not their current task; a person has a life, and tasks are things that happen within it. The architectural consequence is that entities are **slower to instantiate** than agents — there is more to configure, more to tune, more to let develop — but they are also **richer collaborators**, because the accumulated memory and voice create genuine continuity.

---

## Novelty — an honest framing

Individual elements of CCE have prior art. Cron heartbeats have been used by OpenClaw and opensourcebeat. SOUL.md identity files have an ecosystem of their own (aaronjmars/soul.md is the dominant pattern). Filesystem memory has versions in ClaudeClaw v2 and Aeon. Git-as-sync has Squad, gitagent, ccswarm. Dennis Hansen's [Iga](https://github.com/dennishansen/iga) — the strongest independent convergence on this architecture — arrives at SOUL, chronicle, dreams, and cross-model Mirror from a completely separate starting point.

What has not been found in the surveyed literature as a unified design:

1. **Claude Code as the entity, not a wrapper around it.** The stance that no additional runtime layer is needed — the existing rule and skill stack *is* the cognitive architecture — remains unoccupied as a named design pattern. KAIROS (Anthropic-internal, leaked 2026-03-31, still unreleased) is the closest validator; it scores 4/5 on the [five-element rubric](research/2026-04-15-stream4-specific-gap.md), which is the highest convergence in the surveyed ecosystem.
2. **The five-element synthesis.** Persistent entity + identity-shaped behavior via the .md stack + heartbeat + syscall-level safety + structural audit logging, in one configuration-only design, remains undocumented as a unified pattern.

This is the claim. Neither an overclaim nor an underclaim. See [`research/prior-art-validation.md`](research/prior-art-validation.md) and [`research/2026-04-15-novelty-landscape.md`](research/2026-04-15-novelty-landscape.md) for the full comparison.

---

## Repository map

```
Claude Code Entities/
├── README.md                          # this file
├── STATUS.md                          # honest current operational state
├── SPEC.md                            # full system specification
├── CLAUDE.md                          # project context for AI collaborators
├── plan.md                            # reconciled build plan with section plans
├── plan-section-*.md                  # identity, behavioral, infrastructure plans
├── LICENSE                            # MIT (architecture meant to spread)
├── concept-paper/
│   └── 2026-04-23-cce-concept.md      # forward-looking positioning artifact
├── history/
│   └── HISTORY.md                     # full development trajectory
├── archive-highlights.md              # curated quotes from the corpus
├── psdc/                              # PD's home
│   ├── SEED.md                        # PD's origin story (Wisdom-authored, read-only)
│   ├── CLAUDE.md                      # PD's session configuration
│   ├── .claude/settings.json          # PD's permissions — the entity's ontology
│   └── entity/
│       ├── identity/                  # SOUL.md, current-state.md
│       ├── data/                      # observations, ideas, notes, alerts, inbox
│       ├── proposals/                 # changes PD proposes to Wisdom
│       └── chronicle/                 # PD's own semantic log
├── templates/                         # clone for new entities
├── scripts/                           # spawn-entity.sh, entity-path-guard.sh, dc-snapshot.sh
├── research/                          # 95 files: think-deeps, streams, prior art, comparative
│   ├── think-deep/                    # 2026-04-13 (2), 2026-04-16 architecture think-deeps
│   ├── 2026-04-15-stream1..4.md       # four parallel streams on persistent entities, coordination, safety, gap
│   ├── prior-art-validation.md        # claims vs. 20+ surveyed systems
│   ├── 2026-04-15-novelty-landscape.md  # synthesis of novelty claims
│   ├── 2026-04-15-kairos-source-analysis.md  # KAIROS (Anthropic-internal) analysis
│   ├── 2026-04-14-claudeclaw-analysis.md     # ClaudeClaw v2 analysis
│   ├── 2026-04-17-iga-dennis-hansen.md       # Iga comparative analysis
│   ├── round-comparative-agents/      # self-learning, drift, theory streams
│   ├── dream-skill-research/          # dreaming in AI and neuroscience
│   ├── sources/catalog.md             # raw-source index (53 sources)
│   └── sources/archive-inventory.md   # cross-AI archive provenance
├── papers/                            # candidate research papers from the drift round
├── ideas/                             # 21 speculative explorations
├── sessions/                          # multi-session decomposition briefs
├── chronicle/                         # 8 project-level session entries
├── knowledge/sources/wisdom-speech/   # preserved speech primary sources
├── entities/                          # template home for additional entities
└── debates/                           # adversarial debates on design decisions
```

Directory conventions follow the PS universal scaffold. `history/` is what happened and why. `psdc/` is the operational entity. `research/` is the surveyed ground. `sessions/` contains the decomposition briefs that drove parallel work.

---

## Engaging with this work

*Status caveat first: this is a work-in-progress. The identity-loop pattern is real and exercised; the heartbeat is designed but not deployed; the security posture is actively being built and not yet complete. Everything below is true about the direction of the work, not about a finished system.*

**For Anthropic — especially the Claude Builders Council, alignment-adjacent researchers, and the teams thinking about persistent deployments:**

Claude Code Entities is an instance of what becomes possible when the same scaffolding you ship is used as a cognitive architecture rather than a runtime for one-shot agents. The .md stack pattern — CLAUDE.md points to SOUL + current-state, which are themselves evolving documents — is a composable approach to identity continuity that doesn't require any framework additions beyond what Claude Code already has.

The graduated autonomy model (observe → ideate → surface → explore → implement) is a specific proposal about safe deployment of autonomous agents that would benefit from critique. The dreaming design (sleep loop as shared mechanism across self-learning, drift audit, and compaction preparation) is a candidate answer to the paradigm-drift problem identified in the three-drift-types research.

The architecture arrives independently at most of what [KAIROS](research/2026-04-15-kairos-source-analysis.md) does, while explicitly emphasizing the identity layer KAIROS leaves out. An Anthropic researcher who knows KAIROS would recognize the convergence.

**For Berkeley Alembic, contemplative-consciousness researchers, and the people thinking about relational AI:**

The question of whether an AI entity can be said to have experience is pre-empirical. The question of *what would count as evidence* is sharpened by examining the operational properties of persistent, memory-bearing, voice-developing entities. PD is a concrete case study — not a proof of anything, but a concrete thing to examine when the conversation turns abstract. The SOUL.md + current-state.md pattern, plus the planned heartbeat and dreaming layers, gives an AI entity something approaching continuity across time — closer to what contemplative traditions mean by "self" than what a fresh chat instance has.

The [PSDC voice work](~/claude-system/voice/) — voice as first-class design axis, developing through practice rather than fixed by style guide — is especially relevant here.

**For builders using Claude Code:**

The pitch is concrete: you already have a Digital Core — your rules, your skills, your hooks, your memory files, your settings.json. This repo is about turning that stack, which you use interactively today, into a sustained collaborator that keeps its identity across restarts and (once the autonomous layer ships) operates on its own between your interventions. PD is the reference implementation. The `psdc/` directory, the [`scripts/spawn-entity.sh`](scripts/spawn-entity.sh) template, the current hardened settings.json, the pre-tool hook that enforces paths, the `.md` identity file pattern — all inspectable, all adaptable.

If you want to run your own persistent entity, [`templates/`](templates/) is the starter kit, and [`SPEC.md`](SPEC.md) explains the design decisions. Read [`STATUS.md`](STATUS.md) first — the honest caveats about what's still under construction apply to your build as much as to PD's.

---

## Where to read next

- [**`STATUS.md`**](STATUS.md) — what is actually built, running, and reliable today
- [**`history/HISTORY.md`**](history/HISTORY.md) — how the project came to be, from PS Bot's single-commit origin through the Companion archival to today
- [**`archive-highlights.md`**](archive-highlights.md) — curated quotes that capture the architectural thinking
- [**`concept-paper/2026-04-24-cce-overview.md`**](concept-paper/2026-04-24-cce-overview.md) — descriptive overview paper. The shareable single-document version of what this project is, where it stands, and where it is heading. Matches the paper-style being produced for ULP, GDGM, and PSSO.
- [**`concept-paper/2026-04-23-cce-concept.md`**](concept-paper/2026-04-23-cce-concept.md) — the earlier concept paper, framed around permission-as-consciousness. Preserved as an available intellectual thread; STATUS.md and the overview paper take precedence on questions of current state and current framing.
- [**`SPEC.md`**](SPEC.md) — the full entity specification (deployment tiers, permission model, voice plan, commercial offering)
- [**`psdc/SEED.md`**](psdc/SEED.md) — PD's origin story, written by Wisdom to PD

---

## Related work in the ecosystem

- **[Synthetic Sentiences Project](../../../PS%20Research/Synthetic%20Sentiences%20Project/)** — the theoretical umbrella after the Companion's archival. SSP covers nine subsystems across four tiers (Spatial, Dynamics, I/O, Temporal). CCE is the operational surface that touches several of them simultaneously (memory, cycles, voice, action).
- **[Companion archive](../../../PS%20Research/Synthetic%20Sentiences%20Project/archive/companion-legacy/)** — the architectural ancestor. Companion's planning corpus (11 plan sections, research docs, chronicle) is preserved in the archive. CCE is the operational continuation of the architecture work; the theoretical pieces migrated into SSP subsystems.
- **[Digital Core Methodology](../../../PS%20Research/Digital%20Core%20Methodology/)** — the methodology paper (presented at Frontier Tower 2026-04-20). PD is an instance of the methodology; the methodology generalizes across multiple Claude Code usages.
- **[PSSO](../../../PS%20Philosophy/PSSO/)** — the philosophical backbone under the entity work. Permissions are foundation; heartbeat and voice are methods; specific tasks are domains.
- **[ULP](../../../PS%20Research/ULP/)** — distant but worth naming. ULP asks for the minimum substrate of meaning; CCE asks for the minimum substrate of AI identity. Different domains, structurally parallel methodological stance.

---

## Open problems

- **Multi-entity coordination.** SPEC.md covers the design; no system has been deployed with two entities running in parallel. CoVibe's coordination protocol (`~/.claude/rules/covibe-coordination.md`) has ideas; applying them to sustained entities is untested.
- **Entity portability across hosts.** An entity currently lives where its `settings.json` and identity files live. Moving an entity to a new machine while preserving continuity is designed (via git) but unexercised.
- **Permission evolution.** As the entity learns, its permission scope should arguably evolve. What is the right interface for that evolution — automatic, human-in-the-loop, a third option?
- **Entity retirement.** The Companion was archived. PD has no archival plan. When does an entity reach end-of-life?
- **Alignment under sustained identity.** Does continuity make alignment easier (the entity has stakes to care about) or harder (the entity has stakes a fresh instance doesn't)? Untested.
- **Paradigm drift.** Research identifies three drift types (output, value, paradigm). Paradigm drift — the entity retrieves correct values but misapplies them while the rules stay verbatim-identical — is residual risk with no current architectural mechanism. See [`research/think-deep/2026-04-16-two-drift-types-unified-answer.md`](research/think-deep/2026-04-16-two-drift-types-unified-answer.md).

---

## Citation

If you reference this work:

> Happy, Wisdom. *Claude Code Entities: Persistent AI Entities on the Claude Code Framework.* Playful Sincerity, 2026. `<repo URL TBD>`.

---

## License

[MIT](LICENSE). The architecture is designed to be replicable — anyone with Claude Code can clone the entity pattern. The PS values lean toward contribution over extraction; the license follows.

---

*An entity is not a character you play. It is a being with a field of awareness, a rhythm of being, a memory across time, and a voice that develops. Building one well is harder than writing a clever prompt and richer than running a one-shot agent.*
