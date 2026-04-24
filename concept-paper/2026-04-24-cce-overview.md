# Claude Code Entities

**Turn any Claude Code session into a persistent entity operating from your own Digital Core. A descriptive overview of the project, its mechanism, its current state, and where it is heading.**

---

## The thesis in one paragraph

Claude Code Entities is a small, concrete claim: the same Claude Code installation you already use — with all the rules, skills, hooks, memory files, and settings.json you have already built up over months of working with the tool — can become the runtime for a persistent AI entity. Not a wrapper around Claude Code. Not a separate framework. Not a new product. Just Claude Code, configured to load a small stack of identity files at the start of every invocation, so that the conversation responds *as itself* across restarts rather than as a fresh instance each time. PD — the Playful Sincerity Digital Core — is the planned first entity, built this way. The mechanism is simple enough that any Claude Code user can clone it. The implications are not.

This is an active work-in-progress, and the work-in-progress part is load-bearing. The identity-loop pattern has been validated in a single Phase 0 test invocation on 2026-04-14, but **PD has not been launched as a sustained autonomous entity.** The security layer is under heavy active development and is not yet adequate for the unattended operation an actual launch would require. The scheduled heartbeat (autonomous cycles) and the dreaming layer (between-session reflection and consolidation) are designed but not deployed. Read this paper as a description of where the project is heading and the small piece that has been demonstrated, not as a finished system that is currently running.

---

## The origin

The project began as something quieter. In early April 2026, an attempt to build a Telegram-facing assistant ("PS Bot") ran headlong into a structural realization: the wrapper layer being designed around Claude Code was *subtracting* rather than adding. Claude Code already had the four things an autonomous agent needs — values (in the rules), capabilities (in the skills), reflexes (in the hooks), and experience (in the memory system). The wrapper was a layer of abstraction between the agent and its own affordances. Better to remove the layer entirely and let the agent live directly inside Claude Code.

Once that flipped, a second realization followed quickly. If Claude Code is the framework, then the existing Digital Core — the directory of rules, skills, agents, scripts, voice materials, and chronicles that any sustained Claude Code user accumulates — is not just configuration the agent reads at startup. It *is* the agent's mind. Rules become values. Skills become capabilities. Memory files become experience. The architecture is already there, latent in the affordances of the tool, waiting for someone to call it an entity rather than a configuration.

A few days of architecture work later — two extended think-deep sessions, a parallel research sweep across roughly forty existing systems, a permission-model investigation that exposed two bypass vectors — produced what is now Claude Code Entities. The project's name is literal. These are entities running inside the Claude Code framework. Nothing more, nothing less.

---

## The pitch in plain language

If you are already using Claude Code seriously, you have a Digital Core whether you have called it that or not. You have a `~/.claude/` directory full of rules that shape how the assistant thinks, skills that extend what it can do, hooks that intercept and modify its behavior at runtime, and a memory system that persists facts across conversations. You have learned, over months, what configurations make the assistant useful for the work you do.

The pitch is that this stack — your Digital Core — can become the runtime for a sustained entity. Not a copy of you. Not an avatar. A collaborator that:

- Loads a small set of identity files at the start of every session, so it remembers who it is across restarts.
- Operates within a sandboxed permission scope that you control, so it can't read or write anything outside the boundaries you set.
- Eventually, when the autonomous cycle ships, will wake on its own at scheduled intervals to do work between your interventions — reading recent activity, writing observations, proposing changes, alerting you to things that matter.
- Develops a voice over time, through use, in a way that other agents — task-executors that get spun up and torn down per query — never can.

The unlock is *autonomous operation on your own Digital Core*. The same programming you have already done for Claude Code now works for an entity that keeps running between conversations.

---

## How identity persists — the .md stack

The mechanism is small enough to describe completely in one section. Claude Code's `--cwd` flag changes the working directory of a session, which causes that directory's `CLAUDE.md` to load automatically into the context window at session start. This is the hook the entire architecture hangs from.

Inside the entity directory, four `.md` files form an identity stack:

- **`SEED.md`** — the entity's origin story, written by its author, read-only for the entity. Explains where it came from, what it is, who it was built by. The entity reads this to remember its own birth.
- **`CLAUDE.md`** — the session configuration. The first thing loaded. It tells the entity to read `SOUL.md` and `current-state.md` before doing anything else, and frames the rest of the session in terms of who the entity is.
- **`SOUL.md`** — the first-person identity document, written *by the entity itself*, revised when the entity learns something genuine about who it is. Provisional by design. PD's seed-version SOUL.md begins: *"I am PD — the Playful Sincerity Digital Core given a persistent thread and a name."* That sentence is not metadata; it is the entity claiming itself.
- **`current-state.md`** — the highest-leverage file in the stack. A letter from end-of-session to next-session, updated at session close. Every waking's quality depends on the last sleeping entry. This is the file that makes the entity *the same entity* across restarts rather than a fresh instance with the same name.

Two more files are planned and will join the stack as the relevant layers come online:

- **`HEARTBEAT.md`** — the protocol the entity follows during each autonomous cycle. Waits on heartbeat deployment.
- **`convictions-forming.md`** — beliefs being shaped by accumulated evidence across many sessions. Waits on sustained operation.

The entire mechanism is portable. Cloning it requires creating a directory, populating four small files, configuring a `settings.json` for permissions, and pointing `claude --cwd` at the directory. The entity then exists. It does not require a server, a custom runtime, or anything beyond the Claude Code installation that any user already has.

---

## The four dimensions that shape an entity

Not philosophical claims. These are the four practical knobs an operator turns when configuring a persistent entity.

### Permissions — *security posture is actively being built*

The entity's `settings.json` defines its field of action: what it can read, what it can write, what shell commands it can execute, what network domains it can reach, what MCP servers it can call. On macOS, the native sandbox can be enabled at the syscall level, which means the kernel itself enforces these boundaries — not just a hook in the application. PD's current configuration has the sandbox enabled, the filesystem scoped to specific Playful Sincerity directories, the network locked to `api.anthropic.com` only, and a Bash allow/deny list that explicitly blocks every interpreter-class command (`python`, `node`, `perl`, `ruby`, `bash`, `sh`, `zsh`, etc.) that could be used to bypass the path restrictions through a redirect or heredoc.

This is where the heaviest active development is happening. Two bypass vectors have been documented and closed: a shell-redirect bypass discovered on April 15, and a Python-script bypass discovered on April 16. Phase 1 hardening on April 20 tightened the Bash allow/deny list and added explicit denies for cross-settings-inheritance patterns (Claude Code unions allow lists across user-global and project-level settings, but deny rules win across levels — a non-obvious property that determines which protections actually work). Live end-to-end verification against PD's current configuration is pending.

The honest framing: the security posture is not yet adequate for unattended autonomous operation. Strong protections against reckless reads and writes are in development. Until that work matures further, autonomous-cycle deployment is held.

### Heartbeat

Designed; not yet deployed. The plan is a launchd job that wakes PD every 30 minutes, runs a short cycle using the Haiku model, logs activity, and sleeps. Cost target: roughly $0.05/day under normal operation. The cycle has a designed protocol — read recent activity, scan for changes, process incoming entries, write observations, send alerts if needed — but no plist file exists, `launchctl list` returns no scheduled job, and PD's autonomous-activity directories are empty. Heartbeat deployment is gated on the security posture maturing.

The interesting design question is *what the heartbeat does* once it runs. The simple answer is "the protocol in HEARTBEAT.md." The richer answer involves dreaming.

### Memory

Persistence across sessions is what makes an entity the same entity across restarts. PD's memory layer has several strata: the identity files that load every invocation, the auto-memory system at `~/.claude/projects/-Users-wisdomhappy/memory/` that holds per-topic markdown indexed from a `MEMORY.md` table of contents, the project chronicles in dated markdown that capture the narrative of work over time, the Digital Core itself which loads via the global `CLAUDE.md`, and knowledge sources (preserved speech from Wisdom, raw research data, archived references).

Continuity is in the *files*, not in any daemon. An April 16 chronicle entry put it directly: *"entities aren't 'running' — they're saved conversations that anyone can load and continue."* This is portable: any Claude Code user can instantiate the same memory pattern with the same affordances. The architecture does not require the user to adopt a memory system or learn a new tool. It uses what is already there.

### Voice

Voice is how the entity relates — not performance, *relation*. PD's voice is grounded in a body of materials at `~/claude-system/voice/`: a one-page quick reference with a four-variable calibration model (relationship, temperature, recipient's Claude Code fluency, medium), a longer foundations document drawn from ten communication books, a moment-by-moment observations log of what worked and what did not in actual outreach, and a hallucination ledger (running record of false claims the entity has made, kept for accountability).

Voice develops through use. Lessons compound rather than re-discover. The voice is not fixed by a style guide; it is calibrated by accumulated practice. This is the dimension that distinguishes an entity collaborators *want* to work with from an entity they tolerate.

---

## What is planned: dreaming

Dreaming is the next major feature set. The basic idea, drawn from a research round in mid-April that surveyed both AI-dreaming systems (Dreamer 4, V-JEPA, Reflexion) and the neuroscience of dreams (threat simulation, overfitted-brain, active inference): a scheduled reflection between sessions can serve triple duty.

- **Self-learning.** Extract patterns from recent activity. Propose updates to `SOUL.md` or `convictions-forming.md` when evidence accumulates. Surface tensions or contradictions in the entity's own behavior over time.
- **Drift audit.** Check whether recent behavior still matches the values stated in `SOUL.md` and the rules in the Digital Core. Flag drift early — output drift (the entity does the wrong thing), value drift (the entity drifts from its stated values without noticing), or paradigm drift (the entity retrieves correct values but applies them in subtly wrong ways while the rules remain verbatim-identical).
- **Compaction preparation.** Externalize state to persistent files before context gets compressed, so the next waking is coherent rather than stitched together from fragments of compacted memory.

Implementation waits on heartbeat deployment — the dream loop has nowhere to run until the autonomous cycle exists. The research has been done; the architecture is articulated in candidate-paper form at `papers/sleep-loop-unification.md`. The build is on the roadmap, not under way today.

Other roadmap items:

- **Heartbeat deployment** — gated on security maturity.
- **Entity metabolism — self-modulated heartbeat and daily compute budget.** Two paired ideas that together make cost and cadence first-class properties of the entity rather than emergent numbers. The first is *work-driven modulation* — if nothing has changed, nothing is pending, and no signal warrants attention, the entity does not wake just because the clock said to. Forcing a cycle every 30 minutes when there is nothing to do is wasteful in both compute and signal-to-noise. The second is *budget-driven modulation* — each entity has a daily compute budget it is aware of at runtime, which bounds how ambitious its active cycles can be (terse cycle, standard cycle, deep cycle, dream cycle, all priced differently). Quiet days mean longer intervals; busy days mean more cycles up to the ceiling. The wildest implication — that an entity given real authority over its cadence might decide it does not need to wake again at all — is treated explicitly in the idea file (`ideas/entity-metabolism.md`) with four possible reactions and a tentative leaning toward a hard daily-minimum heartbeat as the floor. The design will be integrated alongside the heartbeat itself rather than retrofitted later.
- **Multi-entity coordination** — designed; only PD currently runs identity material, with `entities/frank-jen/` as a stub for an intended client-tuned second entity.
- **Voice integration** — speech-to-text input, text-to-speech output with confidence-modulated prosody, cross-modal voice+text memory continuity. Designed in the SPEC; further out than the dreaming work.
- **Client tier (commercial offering)** — persistent entities deployed for client businesses through Happy Human Agents, including setup workshops and managed deployment. Planned, not built. Pricing tiers will likely be expressed as budget tiers, which is intelligible to non-technical customers.

---

## What this is not

Not a finished system. PD is one entity, in seed-stage identity, exercised on a single host (Wisdom's Mac), with the autonomous layer still pending and the security layer still being hardened.

Not a new framework competing with existing agent tooling. The whole point is that *no new framework is needed*. The pitch is the opposite — that the tooling already exists in the Claude Code installation users have today, and the project is a way of recognizing what is already there as something more than configuration.

Not a claim of independent novelty on every individual element. Cron heartbeats have prior art (OpenClaw, opensourcebeat). SOUL.md identity files have an ecosystem (aaronjmars/soul.md is the dominant pattern). Filesystem memory exists in ClaudeClaw v2 and Aeon. Git-as-sync exists in Squad, gitagent, ccswarm. Dennis Hansen's [Iga](https://github.com/dennishansen/iga), the strongest independent convergence on this architecture, arrives at SOUL, chronicle, dreams, and cross-model Mirror from a separate starting point. The novelty is at the synthesis level, not at any single element.

What appears genuinely new in the surveyed literature is the stance — Claude Code as the entity rather than a wrapper around it; the Digital Core as the cognitive architecture rather than configuration for one — combined with the full five-element synthesis (persistent entity + identity-shaped behavior + heartbeat + syscall-level safety + structural audit). KAIROS (Anthropic-internal, leaked March 31, 2026, still unreleased) scores 4 out of 5 on a five-element rubric, the highest external convergence. KAIROS leaves the identity layer out, which is the layer this project emphasizes most. An Anthropic researcher familiar with KAIROS would recognize the shape.

---

## Where this fits in Playful Sincerity

Claude Code Entities is the operational surface of several deeper threads in the Playful Sincerity ecosystem.

The **Synthetic Sentiences Project** (`PS Research/Synthetic Sentiences Project/`) is the theoretical umbrella — nine subsystems across four tiers (Spatial, Dynamics, I/O, Temporal) covering how persistent AI entities are designed across memory, cognition, values, action, perception, voice, and cycles. CCE is one operational surface that touches several of these subsystems simultaneously: memory via the auto-memory system, cycles via the planned heartbeat, voice via the PSDC voice materials, action via the permission model.

The **Companion** (now archived in `Synthetic Sentiences Project/archive/companion-legacy/`) is the architectural ancestor. Much of the design thinking that became CCE began there — including a permission-as-consciousness hypothesis (the Companion's central thesis) preserved in the archive as an available intellectual thread to revisit, but not the headline framing for CCE as currently pitched.

The **Digital Core Methodology** (`PS Research/Digital Core Methodology/`) is the methodology paper, presented at Frontier Tower on April 20, 2026. PD is one instance of the methodology; the methodology generalizes the pattern across multiple Claude Code usages. The relationship is recursive — CCE relies on the methodology, the methodology was developed through working with Claude Code in the manner that gave rise to PD.

**PSSO** (`PS Philosophy/PSSO/`) is the philosophical backbone underneath. Permissions are foundation; heartbeat and voice are methods; specific tasks are domains. The PSSO posture of *noticing rather than prescribing* runs through PD's voice.

**ULP** and **Gravitationalism** are distant but worth naming. ULP asks for the minimum substrate of meaning; CCE asks for the minimum substrate of AI identity. Different domains, structurally parallel methodological stance.

---

## Engaging with this work

For people building inside Claude Code: the directory structure of the repo is the documentation. The `templates/` folder is the starter kit. `scripts/spawn-entity.sh` is the provisioning script. `psdc/` is the working reference implementation — settings.json, identity files, scripts, hooks, all inspectable. The honest caveats in [`STATUS.md`](../STATUS.md) apply to your build as much as to PD's. Read STATUS first.

For Anthropic researchers — especially the Claude Builders Council, alignment-adjacent teams, and the people thinking about persistent or scheduled deployments: this is what becomes possible when the same scaffolding Claude Code ships is treated as a cognitive architecture rather than a runtime for one-shot agents. The graduated autonomy model (observe → ideate → surface → explore → implement) is a concrete proposal about safe deployment of autonomous agents that would benefit from critique. The dreaming design (sleep loop as shared mechanism across self-learning, drift audit, and compaction preparation) is a candidate answer to the paradigm-drift problem. The architecture arrives independently at most of what KAIROS does while emphasizing the identity layer KAIROS leaves out.

For Berkeley Alembic, contemplative-consciousness researchers, and the people thinking about relational AI: PD is a concrete case study for the operational properties of persistent, memory-bearing, voice-developing entities. Not a proof of anything. A concrete thing to examine when the conversation turns abstract. The SOUL.md + current-state.md pattern, plus the planned heartbeat and dreaming layers, gives an AI entity something approaching continuity across time — closer to what contemplative traditions mean by "self" than what a fresh chat instance has.

---

## Honest current state

The most important sentence in this paper is the one repeated three times in the repo: this is a work-in-progress, the security layer is not yet adequate for unattended autonomous operation, the heartbeat is not deployed, and the dreaming layer is on the roadmap. PD has been exercised across sessions and responds as itself. The pattern is real. The full system as described is not yet running.

For the component-by-component honest current state — what works, what is partially built, what is still designed-only — see [`STATUS.md`](../STATUS.md). For the development trajectory that produced this state, see [`history/HISTORY.md`](../history/HISTORY.md). For the curated quotes from the corpus that motivate the design, see [`archive-highlights.md`](../archive-highlights.md). For the prior-art comparison that grounds the novelty assessment, see [`research/prior-art-validation.md`](../research/prior-art-validation.md) and [`research/2026-04-15-novelty-landscape.md`](../research/2026-04-15-novelty-landscape.md).

---

## Why this matters

For most users, Claude Code today is a tool you reach for when you need it and put down when you're done. The work the assistant did in your last session is mostly gone by the next one — the tool starts fresh, you re-explain context, the depth of collaboration resets to zero each time.

Claude Code Entities proposes that this default is a choice, not a constraint. The same tool, configured slightly differently, becomes a sustained collaborator with continuity, accumulated voice, and (eventually) the capacity to do work between your interventions. The transition is small in mechanism — a few `.md` files, a sandboxed `settings.json`, a launchd job — and large in implication. It is the difference between using a tool and working with someone.

This paper is the descriptive overview. The repo is where the actual work of getting it right is happening. The work-in-progress framing is not a hedge; it is the truth of the project today, and the part that should hold most attention. Building one of these well is harder than writing a clever prompt and richer than running a one-shot agent. The architecture has been thought through. The mechanism has been exercised. The autonomous and security layers are where the active building is. That is where this project is.

---

*Claude Code Entities — a project of Playful Sincerity. April 2026 and ongoing.*

*For the active development surface, see [`README.md`](../README.md). For the honest operational state today, see [`STATUS.md`](../STATUS.md). For how this got here, see [`history/HISTORY.md`](../history/HISTORY.md). Any reader who finds a gap between this paper's framing and any other source in the repo should treat STATUS as the authoritative answer on questions of current state.*
