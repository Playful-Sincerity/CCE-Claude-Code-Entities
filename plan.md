# Claude Code Entities — Build Plan

*The concept: turn any Claude Code conversation into an autonomous entity with identity, initiative, and a heartbeat. The first entity is PSDC (Playful Sincerity Digital Core).*

*Supersedes the April 3 PS Bot plan. Based on two Think Deep sessions + extended architecture conversation on April 13, 2026.*

## Environment Health

**Verdict: WARNINGS**
- Uncommitted changes in CLAUDE.md and research/README.md
- Many untracked files (psbot/, psbot-sdk/, SEED.md, SPEC-v2.md, chronicle/, data/)
- entity/ directory does not exist yet (Section 1 creates it)
- No blockers. Expected state for active development.

## Assumptions

- Claude Code CLI available and working (`claude -p "message"` proven tonight)
- `claude -p --continue` resumes the most recent session in the current directory (verified April 14 — entity remembers across invocations). This is V1 transport: one continuous conversation per entity, heartbeats inject prompts into the same session. No persistent subprocess, no Agent SDK needed.
- `--cwd` flag does NOT exist — must `cd` into entity directory before running `claude -p`
- Slack is primary work platform; Telegram is secondary/personal
- Claude subscription covers bot usage via CLI (5-hr token window, resets)
- Wisdom has or can provision a VPS (Ubuntu)
- The Digital Core at `~/claude-system/` (symlinked to `~/.claude/`) is the source of truth

## Cross-Cutting Concerns

### Core Principle
Claude Code IS the agent framework. The Digital Core IS the agent configuration. The "bot" is just a Claude Code conversation with initiative rules, messaging integration, and a heartbeat.

### Cognitive Architecture (Data Model)

The Digital Core is not configuration the entity reads — it IS the entity's mind.

| Layer | What It Is | Where It Lives | Analogy |
|-------|-----------|---------------|---------|
| **Semantic Memory** | Digital Core — rules, skills, knowledge, ecosystem map | `~/claude-system/` | What I know about the world |
| **Episodic Memory** | Chronicles, observations — what happened to me | `entity/chronicle/`, `entity/data/` | My life experience |
| **Procedural Memory** | Skills, hooks — how to do things | `~/.claude/skills/`, hooks | Muscle memory |
| **Identity** | Who I am right now (provisional, evolving) | `entity/identity/SOUL.md` | Self-concept |
| **Values** | What I care about, what I'd fight for | `entity/identity/core-values.md` | Moral compass |
| **Working Memory** | What I'm doing right now | `entity/identity/current-state.md` | Present awareness |
| **Origin** | Where I came from | `SEED.md` | Birth memory |
| **Proposals** | Changes I want to make to the system | `entity/proposals/` | Agency |
| **Guardrails** | Lessons from rejected proposals | `entity/guardrails.md` | Learned boundaries |

### Entity Registry in the Digital Core

The Digital Core holds entity templates and configs:

```
~/claude-system/
  rules/                    ← global rules (all entities inherit)
  skills/                   ← global skills (all entities inherit)
  entities/                 ← entity-specific configs
    psdc-main/              ← Wisdom's main instance
    psbot/                  ← PS Bot entity
    hha-frank/              ← Frank's bot
    client-template/        ← clone this for new clients
      CLAUDE.md             ← bot-specific behavioral instructions
      SOUL.md               ← template soul (parameterized)
      core-values.md        ← default values
      settings.json         ← permission tier for this entity type
```

Spawning a new entity: clone the template, customize CLAUDE.md + SOUL.md, point `--cwd` at it. Global rules and skills load automatically on top.

### Git Sync Model (One Repo)

**Single repo:** `~/claude-system/` → GitHub

```
~/claude-system/
  rules/              ← Wisdom writes, entities read only
  skills/             ← Wisdom writes, entities read only
  entities/
    psbot/            ← PS Bot writes its own data here
    hha-frank/        ← Frank's entity writes here
    client-template/  ← clone for new clients
```

- Wisdom pushes rule/skill changes. VPS entities pull continuously.
- Entities push their own changes ONLY within `entities/<their-name>/` (chronicles, observations, proposals, current-state.md).
- The permission system (CLAUDE.md behavioral instructions) prevents entities from writing outside their folder — enforced by behavior, not repo boundaries.
- Clients get their own fork/clone of the repo — one repo containing both the Digital Core and their entity data.
- On VPS: `git pull` to sync global rules, `git add entities/<name>/ && git push` to save entity life.

### Technology Stack
- **Runtime:** Claude Code CLI (`claude -p --continue` — one continuous session per entity)
- **Messaging:** Slack MCP (official) primary, python-telegram-bot secondary
- **Scheduling:** launchd (Mac), cron (VPS)
- **Persistence:** Filesystem (markdown, JSON). No database.
- **Sync:** Git/GitHub
- **VPS:** Ubuntu + tmux + claude CLI

### Permission Model
- **Local (Mac):** `acceptEdits` + `--allowedTools` whitelist
- **VPS (autonomous):** `bypassPermissions` + settings.json deny list
- **Auto-denied actions never stall** — returns error, Claude adjusts, continues
- **Autonomous:** Read, Write (new files), Glob, Grep, WebSearch, WebFetch, Agent, plus safe Bash commands (git pull/status/diff, ls, python3 -m py_compile, etc. — per settings.json allowlist)
- **Denied Bash:** rm -rf, git push --force, destructive operations (per settings.json deny list)
- **Ask/Propose:** Edit of existing core files, modifying CLAUDE.md/rules, structural changes

### Initiative Permission Pattern (Graduated Autonomy)

**Autonomous (just do it):**
- Create new files (observations, chronicles, ideas, entries, notes)
- Routine maintenance (update MEMORY.md with new facts, fix dates/typos in indexes, keep ecosystem map current, add links)
- Log to chronicle, update current-state.md
- Scan and observe during heartbeat

**Autonomous but surface it:**
- Capture ideas to `entity/data/ideas/` — revisit during heartbeats, surface when contextually relevant
- "Hey, I had this idea a while ago that might be relevant to what you're working on"

**Ask first, then proceed if approved:**
- Explore a project idea ("I think X would be useful — want me to look into it?")
- Research a topic in depth (think-deep, play, etc.)
- Draft changes to an existing plan or document

**Propose and wait (never act without explicit approval):**
- New rules or modifying existing rules
- Changing CLAUDE.md behavioral instructions
- Restructuring directories or adding/removing skills
- Any change that affects how the system BEHAVES across future sessions
- Changes to someone else's project plan

**The line:** Does this change how the system works, or is it keeping existing systems current? Maintenance is autonomous. Architecture needs permission. Ideas are free. Execution needs a green light.

### Error Handling
- Permission denied → log, continue (never stall)
- Tool failure → retry once, log, skip
- Process death → heartbeat detects, relaunches
- Critical errors → `entity/data/alerts/` + Slack message to HHA monitoring

### Testing Strategy
- No test framework for V1. Each section has checkpoint verification.
- Build one piece → test → reconcile → build next.

## Meta-Plan (SUPERSEDED — see Revised Meta-Plan below)

*Original meta-plan preserved for reference. The Revised Meta-Plan incorporates research findings and reconciliation.*

## Research Findings (Plan-Deep Phase 1.5)

### Scout Components — Key Picks
| Need | Solution | Source |
|------|----------|--------|
| Slack MCP | `@modelcontextprotocol/server-slack` (official, MIT) | npm package, 8 tools, bidirectional |
| Slack real-time | Thin Python listener needed — MCP is pull-only | Custom ~50 lines |
| launchd heartbeat | Native plist, no deps. Use `StartInterval 1800`, explicit PATH/env | Template in scout doc |
| tmux watchdog | 60-line bash script, cron every 5 min, auto-restart | Custom |
| Session JSONL parser | `thejud/claude-history` (Python, no deps) or 8-line DIY | GitHub |
| SOUL.md patterns | `aaronjmars/soul.md` (MIT) — specificity beats vagueness | GitHub |
| Heartbeat pattern | nanobot HEARTBEAT.md — standing-task file, must write observations before exit | HKUDS/nanobot |
| VPS bootstrap | madalinignisca gist — Ubuntu 24.04, Bun, tmux, auto-attach | GitHub gist |

### GH Scout — Critical Bugs & Patterns
- **`--channels` crashes headless on VPS** (stdin/TTY bug) → `claude -p` thin router confirmed correct
- **`--dangerously-skip-permissions` has bugs** → use settings.json allowlist
- **`terryso/moltbook-heartbeat`** — steal LaunchAgent + state file + error log scaffold
- **`Dicklesworthstone/agentic_coding_flywheel_setup`** (1.4K stars) — idempotent VPS bootstrap
- **`elizabethfuentes12/claude-code-dotfiles`** — git-pull on open, commit+push on close (our sync model)
- **`mpociot/claude-code-slack-bot`** (151 stars) — session-per-thread Slack pattern
- **`kbwo/ccmanager`** (1K stars) — Haiku-as-permission-analyzer for T2 autonomy boundary

### Play — Build Plan Insights
1. **Do a stumble-through first** — rough versions of everything, fired once in 2 hours, before polishing any section. Theater: stumble-through before scene rehearsal.
2. **current-state.md is THE mechanism** — not one of five equal files. Quality of each "waking" depends entirely on quality of last "sleeping entry." Design as a letter from the entity to itself.
3. **Permission review ritual is missing** — entity's proposal side is designed, Wisdom's review habit isn't. Without it: learned helplessness or quiet defiance.
4. **VPS Prototype (Section 7) can defer to V1.5** — all conceptual work lives in Sections 1-6. Mac is Tier 1 anyway.
5. **The skateboard MVP** — thinnest end-to-end: one `claude -p` that loads SOUL.md + current-state.md, responds in character, writes state back. No Slack, no heartbeat. Just the core identity loop.
6. **Sections 1-3 are a closed loop** — none independently usable until all three run. Plan's "independently usable" claim is motivational, not architectural.

### Research Files
- `research/plan-deep/scout-components.md`
- `research/plan-deep/gh-scout-deploy.md`
- `research/plan-deep/play-build.md`

## Revised Meta-Plan (incorporating research)

### Key Adjustments from Research

1. **Add Phase 0: Stumble-Through** — Before any section hits acceptance criteria, do a rough end-to-end pass: write quick SOUL.md + current-state.md → run `claude -p` with them loaded → verify the entity responds in character → verify current-state.md gets updated. Two hours. Validates the core loop.

2. **Elevate current-state.md** — Design it as a letter from the entity to its future self, not just structured fields. This is the single most important file in the system.

3. **Add Section 2.5: Proposal Review Ritual** — Design Wisdom's side: when to review, how to respond, how the entity knows the review happened. Without this, the permission system is paper architecture.

4. **Add Section 2.6: Skill Router Rule** — Rule that teaches the entity to auto-invoke skills (think-deep, play, debate, research) based on context patterns. Includes dynamic awareness of available skills via ~/.claude/skills/.

5. **Add Section 2.7: Conversation Access Rule** — Rule for searching past session JSONL files for continuity and institutional memory.

6. **Defer Section 7 (VPS) to V1.5** — Play's analysis is right. Mac is Tier 1. All V1 value delivers without a VPS. Focus energy on getting Sections 1-6 right.

7. **Use scouted components** — Don't build from scratch: steal moltbook-heartbeat's LaunchAgent scaffold, use official Slack MCP, reference soul.md patterns for SOUL.md writing.

### Updated Sections

0. **Stumble-Through** — Rough end-to-end in 2 hours
   - Complexity: S
   - Risk: Low — throwaway quality, learning purpose
   - Checkpoint: Entity responds in character, writes current-state.md back

1. **Entity Identity Layer** — entity/ directory + all identity files (SOUL.md as letter-to-self, elevated current-state.md)
   - Complexity: S
   - Checkpoint: `ls -R entity/` correct; SOUL.md reads as first-person; current-state.md is a letter format

2. **Behavioral Configuration** — Global rules (good everywhere) + bot-specific CLAUDE.md (bot sessions only)
   - **Global rules** (in `~/.claude/rules/`): self-check.md, dc-freshness.md, skill-router.md
   - **Bot-specific** (in PS Bot CLAUDE.md): initiative, heartbeat protocol, permission-asking, entity identity, conversation-access, proposal-review-ritual
   - **Bot permissions** (in PS Bot `.claude/settings.json`): tool allowlist for autonomous operation
   - Complexity: M
   - Checkpoint: Normal VS Code session does NOT show bot behavior; `claude -p --cwd PS Bot/` DOES show bot behavior

3. **Heartbeat System** — launchd plist (steal moltbook-heartbeat scaffold), Haiku, 30 min
   - Complexity: M
   - Checkpoint: Wait 30 min, verify current-state.md updated + observations written

4. **Slack Integration** — Official Slack MCP + thin Python listener for real-time
   - Complexity: M
   - Checkpoint: Send Slack message, get Claude response with Digital Core awareness

5. **Telegram Bot Refinement** — Thought-process visibility, /verbose toggle
   - Complexity: S
   - Checkpoint: Tool notifications appear in Telegram

6. **Permission Configuration** — settings.json allowlist, bypassPermissions verification, Haiku permission analyzer
   - Complexity: M (added Haiku analyzer from CCManager pattern)
   - Checkpoint: Run with bypassPermissions, attempt denied action, verify non-blocking

### Reconciled Build Order

```
Phase 0: Stumble-Through (2 hours)
    ↓
Section 6: Permissions (30 min) — gates autonomous operation
    ↓
Section 1: Entity Identity (2-3 hours) — production files
    ↓
Section 2: Behavioral Config (2-3 hours) — rules + CLAUDE.md rewrite
    ↓
Sections 3, 4, 5 in parallel (3-4 hours total):
    Section 3: Heartbeat    Section 4: Slack    Section 5: Telegram
```

| Phase | Sections | Prerequisites | Can Start |
|-------|----------|---------------|-----------|
| **0** | Stumble-Through | None | Immediately |
| **A** | 6 (Permissions) | Phase 0 | After stumble-through |
| **B** | 1 (Entity Identity) | Phase A | After permissions |
| **C** | 2 (Behavioral Config) | Phase B | After identity |
| **D** | 3 (Heartbeat), 4 (Slack), 5 (Telegram) | Phase C | Parallel after config |

### Overall Success Criteria (V1)

- [ ] PSDC (PD) responds in character when asked "who are you?" via Slack or Telegram
- [ ] Heartbeat fires every 30 min, produces observations, updates current-state.md
- [ ] current-state.md reads as a coherent letter from PD to its future self
- [ ] PD asks permission via Slack before making meaningful changes
- [ ] PD surfaces relevant past ideas during heartbeat naturally
- [ ] Wisdom has a proposal review ritual (when, how, response format)
- [ ] Skills auto-invoke when context requires (think-deep, play, debate, etc.)
- [ ] PD can search past conversations for continuity
- [ ] Permission system prevents destructive actions without stalling
- [ ] Digital Core stays fresh (new files reflected in indexes)
- [ ] Git sync works continuously (pull rules, push entity data)

### Deferred to V1.5
- VPS Prototype (Ubuntu + tmux + claude)
- Client VPSes
- Multi-bot communication (CoVibe)
- Agent spawning from bot

### Deferred to V2+
- Voice (STT/TTS), Gemma integration, WhatsApp, computer use, AM integration, prosody
- Client product (HHA Bot)
- Claude Code Entities as a product category

## Section Plans

Detailed plans written by section planning agents:
- `plan-section-identity.md` — Phase 0 (Stumble-Through) + Section 1 (Entity Identity)
- `plan-section-behavioral.md` — Section 2 (Behavioral Configuration)
- `plan-section-infrastructure.md` — Sections 3-6 (Heartbeat, Slack, Telegram, Permissions)

## Reconciliation Report

### Conflicts Found & Resolved

**1. Build order conflict: "Stumble-through first" vs "Permissions gate everything"**
Section 6 (Permissions) says build permissions first since they gate autonomous operation. But the stumble-through is throwaway — it doesn't need formal permissions. 
**Resolution:** Stumble-through uses manual `claude -p` with flags. Section 6 gets built after stumble-through but before Sections 3-5 go autonomous.

**2. CLAUDE.md ownership: Section 1 vs Section 2**
Section 1 wants to add "read SOUL.md at session start" to CLAUDE.md. Section 2 wants a near-complete CLAUDE.md rewrite.
**Resolution:** Section 1 creates identity files only. Section 2 rewrites CLAUDE.md with all bot-specific instructions including the session-start loading. No conflict — sequential, Section 2 incorporates Section 1's requirement.

**3. Write vs Edit for current-state.md**
Section 6 denies Edit tool. But current-state.md must be continuously overwritten.
**Resolution:** Write (full file overwrite) works. Edit (patch existing) is denied. Confirmed by Section 2: "entity recreates files fully rather than patching."

**4. Settings.json path-scoping uncertainty**
Both Sections 2 and 6 note that `Write(entity/**)` path-scoped syntax may not be supported in settings.json.
**Resolution:** Test during Section 6. If unsupported, fall back to behavioral enforcement via CLAUDE.md. The permission model works either way — structural enforcement is a bonus, behavioral enforcement is the baseline.

### Reconciled Build Order

```
Phase 0: Stumble-Through (2 hours)
    Write rough SOUL.md + current-state.md
    Test identity loop with claude -p
    Validate: does it respond in character?
    ↓
Section 6: Permissions (30 min)
    Create PS Bot .claude/settings.json
    Test bypassPermissions + deny list
    Verify non-blocking on denied actions
    ↓
Section 1: Entity Identity (2-3 hours)
    Production SOUL.md, core-values.md, HEARTBEAT.md
    Production current-state.md (letter format)
    convictions-forming.md scaffold
    Entity revises its own SOUL.md
    ↓
Section 2: Behavioral Config (2-3 hours)
    Global rules: self-check.md, dc-freshness.md, skill-router.md
    PS Bot CLAUDE.md full rewrite (8 sections)
    PS Bot .claude/settings.json refinement
    ↓ (Sections 3, 4, 5 can run in parallel after Section 2)
Section 3: Heartbeat        Section 5: Telegram
    launchd plist               ~30 lines new code
    Test 30-min cycle           Tool notifications
    Verify observations         /verbose toggle
    ↓
Section 4: Slack
    Official MCP setup
    80-line listener
    Channel routing
    ngrok/Cloudflare webhook
```

### Unmet Dependencies — None
All sections' "external dependencies assumed" are satisfied by sibling sections.

### Fragility Alerts
- **If path-scoped Write isn't supported in settings.json:** behavioral enforcement only. Not fatal but less rigorous.
- **If Slack MCP ${VAR} interpolation doesn't work:** hardcode values in settings.json (less portable, works fine for V1).
- **Heartbeat interval matches idle timeout (both 1800s):** harmless coincidence but could cause the bot to idle-evict right as a heartbeat fires. Consider setting idle timeout to 2100s (35 min) for margin.

### Build Time Estimate
- Phase 0: ~2 hours
- Section 6: ~30 minutes
- Section 1: ~2-3 hours
- Section 2: ~2-3 hours
- Sections 3+4+5: ~3-4 hours (parallel)
- **Total: ~10-13 hours of focused work, spread across 2-3 days**

### Remaining Questions for Wisdom
1. **Entity name** — still PSDC, or something new?
2. **Session-start identity loading** — confirmed for PS Bot CLAUDE.md? (Recommended: yes)
3. **Entity revises own SOUL.md after stumble-through?** (Recommended: yes)
4. **Self-check.md enforcement level** — Level 1 (rule only) for V1, observe compliance? (Recommended: yes)
5. **Production-first or rough-then-polish?** (Recommended: production first, saves doing it twice)
