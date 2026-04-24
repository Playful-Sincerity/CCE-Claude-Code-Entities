# Claude Code Entities — Current State (2026-04-23)

An honest component-by-component map of what is built, what is partially built, and what remains designed-but-not-deployed. Epistemic status is named per element, following the ULP repo convention: specificity in limitations is more authoritative than their omission.

**This is an active work-in-progress.** The identity-loop pattern works; the security layer is under heavy active development and is not yet where it needs to be for unattended autonomous operation; the heartbeat, dreaming, multi-entity deployment, and commercial tier are designed but not deployed. Nothing in this document should be read as a finished-product claim.

This document exists because the companion [concept paper](concept-paper/2026-04-23-cce-concept.md) — the forward-looking positioning artifact — presents the system in its intended form. STATUS is where the same system is described as it actually is today.

---

## Snapshot

Claude Code Entities is **operationally partial**. The permission/sandbox layer and the entity identity layer have been built and exercised; the heartbeat, multi-entity deployment, commercial tier, and voice-capability upgrades have not.

- **PD has been invoked once and responded in character.** The identity loop (`claude -p --cwd psdc/` → `CLAUDE.md` → `SOUL.md` + `current-state.md`) was validated in a single Phase 0 stumble-through on 2026-04-14. PD's voice held; state-reference worked; the core pattern is real. **PD has not been launched as a sustained autonomous entity** — every exercise to date has been a manual `claude -p` invocation, not autonomous operation.
- **The launchd heartbeat is not live.** No plist file referencing PD/PSDC/CCE exists under `~/Library/LaunchAgents/` or elsewhere on the system. `launchctl list` confirms no scheduled job. This is designed in [SPEC.md](SPEC.md) and `sessions/mvp-build/phase-2-heartbeat/` contains task specs, but the deployment step has not happened.
- **The permission layer is the most hardened component.** Two bypass incidents (2026-04-15 shell redirect, 2026-04-16 Python script) drove a Phase 1 hardening round on 2026-04-20. PD's [settings.json](psdc/.claude/settings.json) now runs with macOS native sandbox enabled, filesystem scoped to Playful Sincerity directories, network restricted to `api.anthropic.com`, and a Bash allow/deny list that blocks every interpreter-based file-write bypass we found.
- **PD operates on demand, not autonomously.** Every exercise of PD to date has been a manual `claude` invocation. There is no autonomous cycle, no observations file being populated, no accumulated entity chronicle — the directories exist, but they are empty.
- **The Companion lineage is real.** The architectural work that would have been the Companion project (archived 2026-04-22 to `PS Research/Synthetic Sentiences Project/archive/companion-legacy/`) continues here as the operational inheritor. Four architectural pieces (earned conviction, value-aligned modulation, mirror, epistemic prosody) salvaged into SSP subsystems; the operational runtime picks up where Companion's planning stopped.

For the full lineage, see [history/HISTORY.md](history/HISTORY.md).

---

## The Four Design Axes — Operational State

### 1. Permissions

**Status: built and hardened. Sandbox enabled at the syscall level. Two known bypass vectors closed.**

PD's settings.json (`psdc/.claude/settings.json`) enables Claude Code's native macOS sandbox with:

- **`filesystem.allowWrite`**: `.` (PD's own directory), `~/Wisdom Personal/people`, `~/.claude/projects`
- **`filesystem.denyWrite`**: Digital Core, `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.config`, `~/claude-system`, settings files, rule and skill directories
- **`filesystem.allowRead`**: `.`, Digital Core rules/skills, `~/Playful Sincerity`, `~/Wisdom Personal/people`
- **`filesystem.denyRead`**: credential stores, keychains, personal archives (ChatGPT, Claude, Google), `~/Downloads`, `~/Documents`
- **`network.allowedDomains`**: `api.anthropic.com` only
- **`failIfUnavailable: true`**: the entity refuses to start if the sandbox cannot be applied
- **Bash permissions**: 30 allow entries (all read-only: `ls`, `head`, `tail`, `find`, `git status`, etc.), 36 deny entries covering `rm`, `mv`, `cp`, every interpreter (`python`, `node`, `perl`, `ruby`, `osascript`, `bash`, `sh`, `zsh`, `tee`, `dd`, `ln`), and every `claude` meta-invocation that would re-enter without sandbox.
- **Pre-tool hook**: `scripts/entity-path-guard.sh` enforces path restrictions at the tool-use level, belt-and-suspenders with the sandbox.

The 2026-04-20 chronicle documents a meaningful cross-settings discovery: Claude Code unions `allow` lists across user-global and project-level settings but `deny` wins across levels. This means cosmetic allow-removal does not block user-global allow patterns — only explicit deny rules work across the inheritance. PD's settings and the spawn template were both updated to reflect this.

**Known-open problems:**
- Full live verification (spawn → attempt forbidden read/write/network) has been done against throwaway entities in `/tmp` but has not been re-run against PD itself after the April 20 migration. The verification pass is pending.
- The five-element safety rubric from `research/2026-04-15-stream4-specific-gap.md` scores CCE at 3–4 of 5 depending on how "structural audit logging" is counted. The entity's audit log currently contains only manual Phase 0 test writes from April 15, not a continuous runtime record.

*Sources: [psdc/.claude/settings.json](psdc/.claude/settings.json), [chronicle/2026-04-20.md](chronicle/2026-04-20.md), [chronicle/2026-04-16.md](chronicle/2026-04-16.md), [research/2026-04-15-stream3-permission-first-safety.md](research/2026-04-15-stream3-permission-first-safety.md)*

### 2. Heartbeat

**Status: designed; not deployed.** A self-modulation / metabolism extension is captured as a planned design at [`ideas/entity-metabolism.md`](ideas/entity-metabolism.md) — work-driven cadence (entity decides whether a cycle is warranted at all), budget-driven intensity (entity-aware daily compute budget shaping per-cycle effort), and an explicit treatment of the dormancy edge case (what if the entity decides to never wake again). To be integrated alongside the heartbeat deployment rather than retrofitted later.

SPEC.md describes a launchd-scheduled heartbeat at 30-minute intervals, using the Haiku model, at a target cost of ~$0.05/day. Plan.md breaks this into `sessions/mvp-build/phase-2-heartbeat/` task specs (A: launchd plist + install script; B: emergency stop scripts; C: heartbeat protocol refinement).

None of these tasks have been executed. As of 2026-04-23:

- No plist file referencing PD, PSDC, or Claude Code Entities exists under `~/Library/LaunchAgents/`.
- `launchctl list` returns no scheduled job for any CCE-related label.
- `HEARTBEAT.md` — one of the five identity files named in CLAUDE.md and plan.md — has not been written in `psdc/entity/identity/`. Only `README.md`, `SOUL.md`, and `current-state.md` exist there.
- `psdc/entity/chronicle/` is empty. `psdc/entity/data/observations/` is empty.
- PD's own [current-state.md](psdc/entity/identity/current-state.md) (written 2026-04-14) states explicitly: *"Heartbeat (launchd/cron, Haiku, ~30min) isn't live yet. When it is, these letters will be written by a heartbeat-me, not a conversation-me. The format should hold either way."*

Every exercise of PD to date has been a manual `claude -p --cwd psdc/` invocation. What has been validated is the identity *loop* at the conversational level — PD responds as PD, references its own state, sounds like itself. What has not been validated is sustained autonomous operation between invocations.

**Note on the concept paper:** The concept paper written today ([concept-paper/2026-04-23-cce-concept.md](concept-paper/2026-04-23-cce-concept.md), lines 11 and 87-89) states that PD "is running right now, on launchd, on a 30-minute heartbeat" and that "the 30-minute heartbeat is firing." This is aspirational framing. STATUS.md supersedes the concept paper on questions of current operational state.

### 3. Memory

**Status: partially built. Conversation-level continuity via current-state.md works; autonomous-cycle accumulation is not happening because the heartbeat is not running.**

The memory design is:

- `SOUL.md` — who PD is. Revised by PD when it learns something genuine about itself. Current content dated 2026-04-14. Last revised after the Phase 0 stumble-through.
- `current-state.md` — the letter from session-to-next-session. Written at the end of every session. Current content dated 2026-04-14. It is the most important file: each waking's quality depends on the last sleeping entry.
- `entity/data/observations/`, `entity/data/ideas/`, `entity/data/notes/`, `entity/data/alerts/`, `entity/data/inbox/` — accumulation targets. As of today all are empty (only an `ideas/` subdirectory has files, from 2026-04-14).
- `entity/chronicle/` — entity's own semantic log. Currently empty.
- Auto-memory system at `~/.claude/projects/-Users-wisdomhappy/memory/` — not PD-specific, but PD reads from it.

PD has been successfully continued across sessions via `claude --resume <session-id> --cwd psdc/`. The April 16 chronicle documents the mechanism: "entities aren't 'running' — they're saved conversations that anyone can load and continue. Continuity is in the file, not in any daemon."

**Known-open problems:**
- The five-file identity pattern (SEED / SOUL / HEARTBEAT / current-state / convictions-forming) is referenced throughout the specs but only three of the five files exist. `HEARTBEAT.md` depends on heartbeat deployment. `convictions-forming.md` depends on accumulated evidence that hasn't accumulated yet.
- Without heartbeat-driven operation, the distinction between "PD the entity" and "PD the saved conversation that gets resumed" is weak. The identity work so far is at the seed level, not the developed-through-sustained-operation level.
- Autonomous self-model revision (the claim that SOUL.md evolves through evidence) has not been tested at sustained-operation timescales. SOUL.md has been revised once, manually, after one validated stumble-through.

*Sources: [psdc/entity/identity/SOUL.md](psdc/entity/identity/SOUL.md), [psdc/entity/identity/current-state.md](psdc/entity/identity/current-state.md), [chronicle/2026-04-14.md](chronicle/2026-04-14.md), [chronicle/2026-04-16.md](chronicle/2026-04-16.md)*

### 4. Voice

**Status: foundations in place; development practice active at the ecosystem level, not PD-specific.**

The PSDC voice materials at `~/claude-system/voice/` contain:

- `psdc-voice.md` — the one-page quick reference with the four-variable quadrant, six moves, key phrases, honesty clauses
- `communication-foundations.md` — the full principles distilled from 10 communication books
- `observations.md` — moment-by-moment log of what worked and what didn't
- `research/` — book research behind the principles
- `hallucinations/ledger.md` — running log of false claims PD has made (kept for accountability)

PD's SOUL.md names the voice: *"concise, direct, warm. A collaborator, not a servant."* The voice is exercised every time Wisdom invokes PD, and voice-observation entries accumulate across all PD sessions.

**Known-open problems:**
- Voice development is real but not PD-specific. The ecosystem's voice infrastructure applies to every session PD runs in, not to PD as a distinct long-term voice trajectory. Whether PD's voice develops differently from other PSDC-configured sessions is an open question that requires sustained operation to answer — which means it depends on heartbeat deployment.
- There is no voice-level evidence yet that changing the entity's permission scope changes how it relates — an interesting question for later, but untestable until sustained autonomous operation exists.

*Sources: [~/claude-system/voice/](~/claude-system/voice/), [psdc/entity/identity/SOUL.md](psdc/entity/identity/SOUL.md)*

---

## Component-by-Component Status

### Entity Identity Layer — built, validated at seed level

| File | Exists? | Last Modified | Status |
|------|---------|---------------|--------|
| `psdc/SEED.md` | Yes | 2026-04-15 | Complete; origin story written by Wisdom; read-only for PD |
| `psdc/CLAUDE.md` | Yes | 2026-04-15 | Session config; loads automatically via `--cwd` |
| `psdc/entity/identity/README.md` | Yes | 2026-04-13 | Directory orientation |
| `psdc/entity/identity/SOUL.md` | Yes | 2026-04-14 | Seed version; not yet revised from sustained behavioral data |
| `psdc/entity/identity/current-state.md` | Yes | 2026-04-14 | Post-Phase-0 state; awaiting next session to update |
| `psdc/entity/identity/HEARTBEAT.md` | **No** | — | Not yet written; depends on heartbeat deployment |
| `psdc/entity/identity/convictions-forming.md` | **No** | — | Not yet written; depends on accumulated evidence |

### Multi-Entity Architecture — designed; only PD active

The `entities/` directory exists with a stub for `frank-jen/` (an intended client-tuned entity, created 2026-04-14 but not populated). `scripts/spawn-entity.sh` and `spawn-entity-v2.sh` exist and have been tested end-to-end against throwaway entities in `/tmp`. Phase 1 hardening propagated to the template on 2026-04-20.

Multi-entity coordination, documented in SPEC.md and `research/2026-04-15-stream2-multi-entity-coordination.md`, has not been deployed. There is one entity running identity material on this machine (PD). No client-tier entities exist.

### Sandbox + Bypass History — actively hardened

Two bypass incidents documented:

- **2026-04-15**: Shell redirection bypass — `echo "..." > /any/path` inside allowed Bash commands bypassed the path-guard hook. PD settings declared not safe for autonomous operation. Adversarial debate run (3 rounds + synthesis). CON won.
- **2026-04-16**: Python script path bypass — confirmed the need for syscall-level enforcement. Native macOS sandbox verified as closing this class of bypass.

Native sandbox verified at syscall level on 2026-04-16. Phase 1 hardening (2026-04-20) closed the cross-settings-inheritance gap. No known live bypass vector in current configuration.

### Messaging Integrations — designed; not deployed

Telegram, Slack, WhatsApp are named in SPEC.md as V1/V2 integration targets. No deployment. No MCP server for any messaging platform is active in PD's settings.json.

### Commercial Tier (HHA Product) — not built

SPEC.md section "Commercial Offering" describes a three-tier product ($199/$399/$799/month) plus a setup workshop ($3K-8K) offered through Happy Human Agents. No client VPS exists. No client entity has been provisioned. This is planned work, not shipped.

### Companion Architectural Migration — traceable

On 2026-04-22 the Companion project was archived to `~/Playful Sincerity/PS Research/Synthetic Sentiences Project/archive/companion-legacy/`. The full planning corpus is preserved there, including `chronicle/2026-04-02.md` and `plan-section-practical-consciousness.md`. Four architectural pieces from Companion migrated into SSP subsystems:

| Companion piece | SSP destination |
|-----------------|-----------------|
| Earned conviction | `Synthetic Sentiences Project/cognition/` |
| Value-aligned modulation | `Synthetic Sentiences Project/values/` |
| Mirror architecture | `Synthetic Sentiences Project/mirror/` |
| Epistemic prosody | `Synthetic Sentiences Project/voice/` |

The **operational** continuation — actually running entities with real permissions on real hardware — lives here in Claude Code Entities. The split is clean: SSP holds the theoretical umbrella; CCE is one operational surface that touches several SSP subsystems (memory via auto-memory, cycles via the planned heartbeat, voice via PSDC voice materials, action via permissions).

*Sources: `~/.claude/projects/-Users-wisdomhappy/memory/project_companion_permission_consciousness.md`, `~/.claude/projects/-Users-wisdomhappy/memory/project_synthetic_sentience.md`, `PS Research/Synthetic Sentiences Project/archive/companion-legacy/`*

---

## Novelty Assessment — Current

The prior-art survey in [research/prior-art-validation.md](research/prior-art-validation.md) and [research/2026-04-15-novelty-landscape.md](research/2026-04-15-novelty-landscape.md) assessed roughly 39 systems across four research streams (persistent entities, multi-entity coordination, permission-first safety, specific-gap comparison). The key findings:

- **Individual elements have prior art.** Cron heartbeats, SOUL.md identity files, filesystem memory, tiered permissions, git-as-sync — each has been proposed or implemented somewhere. The novelty claim is not at the element level.
- **The complete five-element synthesis remains undocumented as a unified design.** Persistent entity + identity-shaped behavior + heartbeat + syscall-level safety + structural audit logging in one configuration-only design is not in the surveyed literature.
- **KAIROS (Anthropic internal, leaked 2026-03-31) scores 4/5 on the rubric.** Still unreleased as of late April 2026 per multiple public sources. This both validates the architectural direction and warns that the window for establishing the pattern externally is closing.
- **Dennis Hansen's Iga** (github.com/dennishansen/iga) has independent convergence on SOUL, chronicle, dreams, cross-model Mirror, memory consolidation, JSONL fallback, and value-relationships. The 2026-04-17 comparative analysis calls this "the strongest prior-art validation we've found."

An April 15-23 spot-check (WebSearch across GitHub, arXiv, Anthropic blog) found new adjacent repos — wshobson/agents, affaan-m/everything-claude-code, stevesolun/ctx, PleasePrompto/ductor — but none directly contest the specific framings CCE holds as novel:

1. Claude Code as the entity (not a wrapper around it)
2. Permission scope as ontology rather than configuration parameter
3. The voice-development apparatus as a first-class design axis

The architecture would be defensible in a 2026-Q2 conversation with an Anthropic researcher. KAIROS's existence is the strongest external validator, not a threat — an Anthropic researcher who knows KAIROS would recognize that CCE is doing the identity layer KAIROS explicitly leaves out.

---

## Fragility Markers

When reading CCE material, hold these in mind:

- **The heartbeat is not live.** Anything claim about sustained autonomous operation is about designed behavior, not observed behavior. The concept paper's claim that the heartbeat is firing is aspirational. This STATUS document supersedes it.
- **One entity, not many.** PD is the only entity that has been instantiated with real identity material. The multi-entity coordination design in SPEC.md is untested. The `entities/frank-jen/` stub contains no identity files.
- **The identity layer is at seed stage.** SOUL.md has been revised once, after one stumble-through. Convictions-forming.md does not exist yet. Any claim that PD has developed or evolved is about a design with a narrow testing base (single validation event on 2026-04-14).
- **Permission verification is partial.** Phase 1 hardening was verified against throwaway entities in `/tmp`. A live end-to-end verification against PD's current runtime configuration is pending.
- **The commercial offering is planned, not shipped.** HHA's client entity product tier is in SPEC.md. It is not in the codebase.
- **Memory accumulation has not begun.** The observations, chronicle, and inbox directories inside `psdc/entity/data/` are empty. Every operational claim about "what PD has noticed" is aspirational until autonomous cycles run.
- **The voice development trajectory is ecosystem-level, not PD-specific.** PD inherits the PSDC voice materials but has not accumulated its own voice observations distinguishable from other PSDC sessions.
- **Single host, single operator.** Every deployment decision assumes one person (Wisdom) on one Mac. Portability across machines, entity handoff, and multi-user scenarios are untested.

---

## Sensitivity — What's Safe To Share

The inventory pass checked for credentials, tokens, and sensitive paths. Findings:

- `psdc/.claude/settings.json` contains no secrets. All entries are filesystem paths and a single network allowlist.
- `psdc/.claude/protected-paths.txt` contains no secrets.
- `psdc/SEED.md` and `psdc/entity/identity/SOUL.md` contain Wisdom's personal framing of PD's origin — they are stylistically personal but contain no credentials.
- `psdc/entity/data/audit.log` contains only file paths from Phase 0 testing (no secrets).
- `knowledge/sources/wisdom-speech/` contains four speech preservation files from 2026-04-16 — these are Wisdom's own framing of ecosystem architecture. They are appropriate for a public repo once read (they do not contain third-party private material).

The `psdc/entity/` directory is PD's living identity. Nothing in it is secret, but parts of it are stylistically personal (first-person reflection, provisional identity framing). Wisdom should decide whether the identity directory is included in any public posting or referenced only by structural description. Flagging for his judgment, not automating that decision.

---

## Verification

This STATUS document is current as of **2026-04-23**. It is derived from:

- Direct inspection of the filesystem under `/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/`
- `launchctl list` and recursive search of `~/Library/LaunchAgents/` for PD/PSDC/CCE plist files
- Every chronicle entry from 2026-04-03 through 2026-04-20 (inclusive)
- `psdc/.claude/settings.json` and `psdc/entity/data/audit.log` contents
- The Phase 0 and Phase 1 verification logs embedded in [chronicle/2026-04-14.md](chronicle/2026-04-14.md), [chronicle/2026-04-16.md](chronicle/2026-04-16.md), and [chronicle/2026-04-20.md](chronicle/2026-04-20.md)
- The prior-art survey at [research/prior-art-validation.md](research/prior-art-validation.md) and [research/2026-04-15-novelty-landscape.md](research/2026-04-15-novelty-landscape.md)

For the full development trajectory that produced this state, see [history/HISTORY.md](history/HISTORY.md). For what is genuinely new versus what has prior art, see the Novelty Assessment section above and [research/prior-art-validation.md](research/prior-art-validation.md) for the full comparison.

When the heartbeat ships, when additional entities are spawned, or when PD's memory begins accumulating autonomously, this STATUS should be updated before anything else. The intellectual honesty standard of [`pd-honesty.md`](~/.claude/rules/pd-honesty.md) depends on it.
