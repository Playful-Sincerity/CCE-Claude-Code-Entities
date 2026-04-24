# Prior Art Validation: Claude Code as Agent Runtime
**Date:** 2026-04-13
**Question:** Has anyone already built "Claude Code as the agent framework" — using Claude Code itself (rules, skills, hooks, MCP, CLAUDE.md) as the autonomous agent runtime, with a heartbeat (cron/launchd running `claude -p` periodically) and entity identity (SOUL.md)?

---

## Executive Summary

**Verdict: Partially novel, but the specific combination is not yet documented as a unified design.**

Each individual claim has prior art. The cron heartbeat using `claude -p` is documented and even named (blle.co, DEV community, opensourcebeat). SOUL.md as identity is a live ecosystem (aaronjmars/soul.md, israelmirsky/claude-code-soul). Settings.json as autonomy boundary is explicitly used by cog (marciopuga/cog). Git as sync layer is well-explored via worktrees and ccswarm.

What is **not** yet clearly articulated anywhere is the explicit framing of **Claude Code's existing primitive stack (CLAUDE.md + rules + skills + hooks + MCP + settings.json) as the complete agent OS** — treating the tool itself as the runtime without adding any wrapper, with SOUL.md (or equivalent) as the entity's persistent self-authored identity and `claude -p` via cron/launchd as the initiative mechanism. The closest projects either: (a) add a wrapper layer around Claude Code, (b) use SOUL.md without a heartbeat, or (c) use a heartbeat without entity identity, or (d) use all elements but spread across separate non-unified projects. The synthesis into a single coherent "Claude Code Entity" design pattern is the gap.

---

## Claim-by-Claim Analysis

### Claim 1: No Framework Wrapper — Claude Code Directly as Agent

**Verdict: Overlap exists, not fully novel, but not universally adopted.**

The "no wrapper" pattern is well-represented:
- **blle.co** ("Building Automated Claude Code Workers") uses `claude -p "/process-next-task" --output-format=stream-json --verbose -dangerously-skip-permissions` directly, no SDK or framework layer.
- **marciopuga/cog** (created March 15, 2026) runs natively in Claude Code without wrapper applications. Uses slash commands within Claude Code's terminal.
- **DEV: jkheadley** ("I Built a Claude Code Agent That Doesn't Need Me Anymore") uses a process manager that wraps real Claude Code sessions — slightly different: they do add a process management layer.
- **MindStudio** explicitly documents that headless mode (`claude -p`) is what enables cron-scheduled tasks and GitHub Actions without a separate framework.
- **Anthropic's own docs** describe `claude -p` as the primitive for CI/CD, cron, automation.

The distinction Wisdom's design makes — framing this "no wrapper" choice as a **philosophical stance** (the tool IS the agent, not just a backend for something else) — is not articulated as a design principle anywhere found. Most people use `claude -p` as an implementation detail, not as the identity claim of the system.

**Closest overlap:** blle.co and the MindStudio headless guide.
**Differentiation remaining:** The explicit framing as "Claude Code IS the agent OS" with its existing primitives as the complete cognitive architecture stack.

---

### Claim 2: CLAUDE.md + Rules as Agent Identity/Cognitive Architecture

**Verdict: Closest claim to genuine novelty, but contested territory is developing fast.**

Most approaches treat CLAUDE.md as *project context* (instructions, conventions) not as *agent identity* (values, personality, self-model). The field is fragmenting around a separate SOUL.md standard:

- **aaronjmars/soul.md** (Feb 2, 2026): Explicitly separates SOUL.md (identity) from CLAUDE.md (project config). The README frames this as the "right" division: CLAUDE.md = what to do, SOUL.md = who you are.
- **bkpaine1/CLAUDECODE** (Feb 8, 2026): Uses SOUL.md + IDENTITY.md + USER.md + MEMORY.md as a four-file identity stack loaded *alongside* CLAUDE.md, not replacing it.
- **israelmirsky/claude-code-soul** (Feb 7, 2026): Hooks-based plugin that preserves a "soul file" across compactions — entirely separate from CLAUDE.md.
- **Blue Octopus Technology** article: Explicitly argues CLAUDE.md, SOUL.md, and SKILL.md are *complementary* layers, not interchangeable. CLAUDE.md alone cannot establish personality.
- **marciopuga/cog** (Mar 15, 2026): Uses CLAUDE.md as the *governing instruction set* for memory architecture — closer to Wisdom's framing, but scoped to memory management, not full entity identity.
- **emlenartowicz.medium.com** ("Cognitive Architecture for Claude Cowork"): Frames Claude Code configuration as a "cognitive architecture" — similar framing to what Wisdom is articulating.

The specific claim that **CLAUDE.md + rules = the agent's personality/values** (not a separate SOUL.md file, but the existing rules system doing double duty as identity) is *not* clearly articulated in any found source. The consensus view is that CLAUDE.md is project-scoped operational context, and identity requires a separate SOUL.md. The claim that the Digital Core's existing rules *are* the entity's cognitive architecture — that the tool's configuration IS the being — is a distinct philosophical position not yet documented.

**Closest overlap:** emlenartowicz's cognitive architecture framing, cog's CLAUDE.md-as-governing-instruction framing.
**Differentiation remaining:** Treating the existing rule stack (not a new file) as the complete identity layer. The "no new file needed" angle is not present elsewhere.

---

### Claim 3: Heartbeat via `claude -p` Cron Invocation

**Verdict: Prior art exists. This specific pattern is documented multiple places.**

This is the most-covered claim. Multiple independent sources document `claude -p` + cron as the heartbeat mechanism:

- **blle.co** (exact quote): `claude -p "/process-next-task" --output-format=stream-json --verbose -dangerously-skip-permissions` called from a cron-scheduled shell script.
- **DEV: boucle2026** ("How to Run Claude Code as an Autonomous Agent with a Cron Job", March 7, 2026): Direct tutorial on exactly this pattern. Documents failure modes (overlapping runs, PATH issues, authentication in cron context, context bloat).
- **opensourcebeat.com** ("Claude Code's Cron Heartbeat: OpenClaw's Ghost Without the Daemon Bloat", April 7, 2026): Names this the "cron heartbeat" pattern explicitly. Notes it inverts the always-on daemon model: event-triggered cold starts instead of persistent background processes.
- **DEV: simplemindedrobot** ("Giving Claude Code a Heart-beat", April 7-9, 2026): Uses `CronCreate(schedule: "*/5 * * * *", prompt: "/heartbeat-pulse", agent: "doer")` — Claude Code's *native* scheduling primitive rather than OS-level cron. Shell predicates (bash exit codes) gate whether the model fires, preventing token waste on empty cycles.
- **MindStudio**: "How to Build Scheduled AI Agents with Claude Code" (April 4, 2026) — full tutorial.
- **Anthropic official docs**: Scheduled tasks documented as a first-class feature at `code.claude.com/docs/en/scheduled-tasks` (session-scoped variant) and Remote Control/Dispatch for persistent triggers.

**Documented failure modes (from DEV: boucle2026 and the gist):**
- Overlapping runs corrupting state files → lockfile pattern required
- PATH issues in cron environment ("command not found") → use full binary path
- Authentication errors in cron context → explicit API key in cron or .env sourcing
- Context bloat from growing state files → separate hot/cold data; cap state.md at ~4KB
- Memory feedback loops (agent becomes optimistic without external validation)
- Token waste during idle cycles → shell predicates before model invocation

**Differentiation remaining:** None on the raw mechanism. The `claude -p` + cron heartbeat is established prior art. The differentiation in Wisdom's design is in what the heartbeat *does* (checks SOUL.md, evaluates autonomy tier, initiates from entity identity) — not the mechanism itself.

---

### Claim 4: Settings.json as Autonomy Tier

**Verdict: Partial prior art. Used operationally; not framed as "autonomy tier" in the same way.**

- **marciopuga/cog**: Explicitly uses `.claude/settings.json` to pre-approve file operations for memory maintenance. The README states settings.json reduces permission prompts for autonomous workflows.
- **Anthropic Auto Mode** (March 24, 2026): Settings/policy control is the defined mechanism for autonomous operation tiers. The `policy.json` and `.claudeignore` files define what the safety classifier approves.
- **Multiple production guides** (eesel, backslash.security, mintmcp, DEV: klement_gunndu): Document settings.json allow/deny patterns as the boundary for autonomous agents.
- **blle.co**: Uses `--dangerously-skip-permissions` (the nuclear all-allow option) rather than fine-grained allow lists.

What's *not* done: explicitly designing settings.json as a **named autonomy tier** — where the allow list defines what the entity can do on its own initiative versus what requires human approval. The framing as "autonomy boundary" rather than "permission config" is a conceptual distinction that appears partially in Anthropic's Auto Mode documentation but is not presented as a design pattern for entity autonomy.

**Closest overlap:** Anthropic's Auto Mode architecture docs, cog's settings.json pre-approval.
**Differentiation remaining:** Framing settings.json as a *named tier* (e.g., Tier 1 / Tier 2 / Tier 3 autonomy) that the entity itself is aware of and respects as its operating charter — not just a technical permission list.

---

### Claim 5: Git as Agent Sync Layer

**Verdict: Prior art exists, well-explored in multi-agent contexts.**

- **Squad (GitHub Blog)**: Uses git as the source of truth for agent coordination via a versioned `decisions.md` file — the "drop-box" pattern.
- **open-gitagent/gitagent** (GitHub, March 2026): Framework-agnostic, git-native standard for defining AI agents. Beads JSONL format for issue tracking that syncs via git pull/push.
- **nwiizo/ccswarm**: Multi-agent orchestration using Claude Code with git worktree isolation; agents push to separate branches and the orchestrator merges.
- **DEV: mariohayashi**: Cron + tmux + git worktrees for parallel autonomous workers; GitHub Issues as operational queue, git repos for memory/context storage.
- **Simon Willison**: Documents git as a recommended pattern for coding agent state management.
- **Claude Code native**: Git worktree support added v2.1.49 (Feb 19, 2026) as first-class parallel agent isolation.
- **CoVibe** (Wisdom's own project): Git-based multi-session coordination — most directly parallel to this claim.

What's relatively unexplored: using git as the *configuration sync layer* (not just code/state) for a persistent entity — i.e., the entity pulls its own rules, skills, and SOUL.md updates via `git pull`, and commits its own state changes as a living record of its evolution. This "entity as git citizen" framing, where the agent's cognitive configuration is versioned alongside its memory, is not clearly described in any found source.

**Closest overlap:** Squad's drop-box pattern, mariohayashi's git-as-memory approach.
**Differentiation remaining:** The agent pulling its *own identity configuration* via git (SOUL.md, rules, skills as living git-versioned documents the entity co-evolves).

---

## The "Already Done" Question

**What exists that's close to the complete picture?**

The most complete prior implementation found is **opensourcebeat.com** ("Claude Code's Cron Heartbeat", April 7, 2026), which combines:
- `claude -p` cron invocation ✓
- HEARTBEAT.md as versioned state contract ✓
- Shell predicates to gate inference (no token waste) ✓
- Running entirely within Claude Code's native primitives ✓
- Named as "OpenClaw's Ghost Without the Daemon Bloat" — the "no daemon" framing is the closest to "no wrapper" ✓

It does **not** include:
- SOUL.md or equivalent self-authored identity ✗
- Settings.json as explicit autonomy tier ✗
- Git as config sync for the entity's identity files ✗
- The "Claude Code IS the cognitive architecture" philosophical framing ✗

**macrodata** (ascorbic, Jan 29, 2026) is also close: identity.md + human.md + cron-like daemon + memory persistence. But it's a TypeScript plugin *around* Claude Code, not Claude Code as the runtime.

---

## Documented Failure Modes (Synthesized)

From boucle2026, the gist (sigalovskinick), jkheadley (Instar/Dawn), and MindStudio:

1. **PATH in cron**: `claude` not found because cron doesn't load shell profile. Fix: hardcode full binary path or source PATH.
2. **Auth in cron**: API key not in cron environment. Fix: explicit `ANTHROPIC_API_KEY=...` in cron command or `.env` sourcing.
3. **Overlapping runs**: Two invocations running simultaneously corrupt state. Fix: lockfile pattern (`flock` or `.lock` file check).
4. **Context bloat**: State files grow unboundedly, degrading model performance. Fix: cap hot state at ~4KB, move cold data to searchable knowledge directory.
5. **Memory feedback loops**: Agent self-validates without external check, becomes optimistic and loses accuracy.
6. **Token waste on empty cycles**: Model invoked when no work exists. Fix: shell predicates (bash exit codes) gate whether `claude -p` fires.
7. **Context compression amnesia**: Compaction loses prior decisions. Fix: soul/identity files re-injected at session start (addressed by SOUL.md + hooks pattern).
8. **Data destruction from unchecked commands**: The Instar "Dawn" incident — `claude -p` with broad permissions + no safety gates + database command = 6,912 messages and 479 memories destroyed. Fix: hard-coded safety gates for destructive operations, not prompt-level constraints.
9. **Activity-without-progress**: Agent performs cycles but doesn't advance goals. Needs progress metrics separate from activity metrics.
10. **Cross-session amnesia**: Architectural decisions disappear between sessions. Fix: decisions.md or equivalent log that persists.

---

## Novelty Assessment by Claim

| Claim | Prior Art Status | Differentiation Remaining |
|-------|-----------------|--------------------------|
| No framework wrapper | Exists (blle.co, opensourcebeat, cog) | Framing it as a design philosophy, not implementation detail |
| CLAUDE.md + rules as agent identity | Contested (SOUL.md ecosystem says separate file needed) | Using existing rules stack as identity without new file |
| `claude -p` cron heartbeat | Documented prior art (multiple sources, April 2026) | None on mechanism; differentiation is in what heartbeat *does* |
| settings.json as autonomy tier | Partially documented (Auto Mode docs, cog) | Named tier model with entity-awareness of its own charter |
| Git as config sync for identity | Not documented | Entity pulling/committing its own identity config via git |
| **Full combination** | **Not found as unified design** | **The synthesis itself** |

---

## Update: April 15, 2026 — Round 2 Research

A comprehensive second research round (4 parallel streams, 39+ systems surveyed) confirmed and extended these findings. See [2026-04-15-novelty-landscape.md](2026-04-15-novelty-landscape.md) for the full synthesis.

### New Systems That Affect This Assessment

**KAIROS (Anthropic internal, leaked March 31, 2026):** Scores 4/5 on the five-element rubric. Anthropic independently arrived at a near-identical architecture: persistent entity (not wrapper), tick-loop heartbeat, append-only audit logs. Behind a feature flag (`false` in external builds). This is the strongest validation of the design AND the clearest signal that the window is closing.

**Anthropic Managed Agents (April 8, 2026):** Path-addressable, versioned memory stores with immutable versions and optimistic concurrency. The professional-grade persistence substrate. No identity layer natively.

**Claude Code Routines (April 14, 2026):** Anthropic's official scheduling: cron (1hr min), API endpoint, GitHub webhooks. Validates the heartbeat pattern but the 1hr minimum means fine-grained heartbeat still requires OS-level cron.

**ClaudeClaw v2 (earlyaidopters fork):** Most operationally complete community system. Importance-scored memory with decay, FIFO queuing, AES-256-GCM encryption. Runs `bypassPermissions` in single-user trust perimeter.

**Sandlock (Multikernel):** Per-tool-call kernel-level sandboxing (Landlock + seccomp-bpf). XOA pattern eliminates prompt injection structurally. Apache 2.0.

**OrgAgent (April 2026 paper):** Three-layer hierarchy with dedicated compliance layer. 46-79% token reduction over flat coordination.

**ACP (IBM Research):** DID-based cryptographic agent identity. The right foundation for non-repudiable audit trails.

### Updated Verdict

**Still genuinely novel as a unified design.** No system combines all five elements. KAIROS is the closest at 4/5 but is not shipped and uses different mechanisms (tick loop vs. cron, no `--cwd` identity loading). The window for establishing this pattern is real but narrowing.

---

## Key Sources

- [opensourcebeat: Claude Code's Cron Heartbeat](https://opensourcebeat.com/article/giving-claude-code-a-heart/) — April 7, 2026. Closest to the heartbeat claim.
- [DEV: boucle2026 — How to Run Claude Code as Autonomous Agent with Cron](https://dev.to/boucle2026/how-to-run-claude-code-as-an-autonomous-agent-with-a-cron-job-hec) — March 7, 2026. Failure modes documented.
- [DEV: simplemindedrobot — Giving Claude Code a Heart-beat](https://dev.to/simplemindedrobot/giving-claude-code-a-heart-beat-55ja) — April 7-9, 2026. Native CronCreate + shell predicate pattern.
- [aaronjmars/soul.md](https://github.com/aaronjmars/soul.md) — Feb 2, 2026. The dominant SOUL.md ecosystem.
- [bkpaine1/CLAUDECODE](https://github.com/bkpaine1/CLAUDECODE) — Feb 8, 2026. Self-authored identity stack.
- [israelmirsky/claude-code-soul](https://github.com/israelmirsky/claude-code-soul) — Feb 7, 2026. Hook-based soul persistence.
- [marciopuga/cog](https://github.com/marciopuga/cog) — Mar 15, 2026. CLAUDE.md as cognitive architecture + settings.json pre-approval.
- [Blue Octopus: CLAUDE.md vs SOUL.md vs SKILL.md](https://www.blueoctopustechnology.com/blog/claude-md-vs-soul-md-vs-skill-md) — Identity standards comparison.
- [ascorbic/macrodata](https://github.com/ascorbic/macrodata) — Jan 29, 2026. Persistent memory + autonomous scheduling plugin.
- [DEV: jkheadley — I Built a Claude Code Agent That Doesn't Need Me Anymore](https://dev.to/jkheadley/i-built-a-claude-code-agent-that-doesnt-need-me-anymore-dfm) — March 17, 2026. Most complete autonomous agent; documents the data-destruction failure mode.
- [sigalovskinick gist: 8 failure modes](https://gist.github.com/sigalovskinick/6cc1cef061f76b7edd198e0ebc863397) — Production failure taxonomy.
- [blog.mariohayashi.com: Autonomous dev pipeline](https://blog.mariohayashi.com/p/an-autonomous-dev-pipeline-for-one) — April 6, 2026. Cron + tmux + git worktrees.
- [nwiizo/ccswarm](https://github.com/nwiizo/ccswarm) — Multi-agent git worktree orchestration.
- [open-gitagent/gitagent](https://github.com/open-gitagent/gitagent) — Git-native agent standard.
- [GitHub issue #45661](https://github.com/anthropics/claude-code/issues/45661) — MDEMG/claude-eng proposal (April 9, 2026): proposes replacing flat MEMORY.md with graph-based system, confirming flat-file identity is seen as a limitation.
- [MindStudio: Agentic OS Heartbeat Pattern](https://www.mindstudio.ai/blog/agentic-os-heartbeat-pattern-proactive-ai-agent) — April 4, 2026.
- [blle.co: Automated Claude Code Workers with Cron and MCP](https://www.blle.co/blog/automated-claude-code-workers) — Direct `claude -p` invocation pattern.
