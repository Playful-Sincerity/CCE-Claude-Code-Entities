# Session Brief: Entity Permission Model — Structural Safety

**Created:** 2026-04-14
**Prior session:** `d25bd887-7168-4707-ad55-dd3c72db3fb9` (Phase 0 stumble-through, VS Code)
**Project:** `~/Playful Sincerity/PS Software/Claude Code Entities/`
**Load first:** CLAUDE.md, plan.md, SPEC.md, plan-section-infrastructure.md (Section 6), research/prior-art-validation.md

---

## The Problem

Claude Code's `Write` tool can create OR overwrite any file the user has filesystem access to. The current entity permission model uses behavioral rules ("only write within entity/") which are LLM-followed, not structurally enforced. A confused or looping entity could overwrite critical files like `~/.claude/CLAUDE.md`, project CLAUDE.md files, or any other file on the system.

The `Edit` tool is denied in settings.json, and `Bash` is denied. But `Write` must be allowed for the entity to function (it writes observations, current-state.md, chronicle entries, proposals). The vulnerability is that Write has no path scoping.

## What We Know

- **settings.json** supports `allow` and `deny` lists by tool name (confirmed working)
- **Path-scoped permissions** like `Write(entity/**)` — unknown whether Claude Code supports this syntax. Needs testing.
- **`--allowedTools`** flag on `claude -p` — whitelist only, no path scoping
- **Git** is a safety net for tracked/committed files, but Wisdom isn't deeply practiced with git recovery yet
- **Prior art:** marciopuga/cog uses settings.json pre-approval; Anthropic Auto Mode uses policy.json; neither documents path-scoped Write restrictions

## The Tension

PD (Wisdom's entity) needs to:
- Store a person's profile in the main Digital Core (`~/Wisdom Personal/people/`)
- Create memory entries in `~/.claude/projects/.../memory/`
- Write to project directories across the ecosystem
- Potentially edit files in projects it's working on

Locking PD to its own `entity/` folder makes it useless for Wisdom's actual use cases. But giving it unrestricted Write access means a hallucination loop could damage critical infrastructure.

## Questions to Investigate

1. **Does Claude Code settings.json support path-scoped permissions?** Test `Write(entity/**)` syntax, `Write(/specific/path)`, glob patterns in allow/deny lists.

2. **Can we use a hook to enforce path restrictions?** A PreToolUse hook that checks the `file_path` parameter of Write calls and blocks writes to protected paths. This would be deterministic enforcement.

3. **Is a git worktree the right model for PD?** PD works in a worktree, writes freely, changes come back as a diff Wisdom reviews. Structurally safe but adds friction.

4. **Should entities get a clone of the Digital Core?** Entity has its own copy, writes freely there. Good changes get pulled into main. Bad changes stay isolated.

5. **Is there a middle ground?** Maybe: allow Write everywhere EXCEPT a deny list of critical paths (`~/.claude/CLAUDE.md`, `~/.claude/rules/*`, `~/claude-system/scripts/*`). Behavioral rules handle the rest.

6. **What's the actual blast radius?** Run a test: in a sandboxed session, ask Claude to write to various paths. See what settings.json actually blocks vs allows. Empirical data > assumptions.

## Wisdom's Use Case That Drove This

"I want to tell PD: hey I just had this conversation with this person. And I want that to go into my main digital core. I want that to be a profile. I want that then to be accessible within GitHub, within the CRM. And then maybe be able to do a deep research on them. None of that's possible if it's just locked away in its own entity folder."

## For Frank/Jen (Simpler Case)

Frank/Jen's entity only needs:
- Write to its own `entity/` space (observations, notes, chronicle, state)
- Read/write calendar via Google Calendar MCP
- Create journal entries in its own space
- Send messages via Slack/Telegram

No need to touch core infrastructure. The simple `Write` + `deny Bash/Edit` model probably works fine here. The permission complexity is PD-specific.

## Reference Files

- `plan-section-infrastructure.md` — Section 6 permission design, settings.json drafts, Haiku analyzer pattern
- `research/prior-art-validation.md` — Claim 4 (settings.json as autonomy tier), documented prior art
- `plan-section-behavioral.md` — Zone C (settings.json), Q4 about Edit being too aggressive
- `ideas/entity-tuning-model.md` — tuning dimensions table showing permission differences per entity
- `research/plan-deep/gh-scout-deploy.md` — kbwo/ccmanager Haiku-as-permission-analyzer pattern
- `research/plan-deep/scout-components.md` — moltbook-heartbeat LaunchAgent scaffold

## What to Do in This Session

1. Test whether path-scoped permissions work in settings.json (empirical)
2. If not: design a PreToolUse hook that enforces path restrictions
3. Define PD's permission model (what paths are protected vs writable)
4. Define Frank/Jen's permission model (simpler, mostly self-contained)
5. Write the actual settings.json files for both entities
6. Test: attempt a write to a protected path, verify it's blocked without stalling
