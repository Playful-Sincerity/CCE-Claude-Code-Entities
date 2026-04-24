# Session Brief: Permission Model — Structural Safety for Entity Autonomy [PARALLEL — no dependencies]

**Dependencies:** None — can start immediately
**Can run parallel with:** 02-pd-identity-test
**Feeds into:** Phase 2C (Frank/Jen entity needs settings.json), Phase 2D (PD behavioral config needs permission design), Phase 3E (infrastructure needs permission model)
**Blocks:** All downstream sessions depend on knowing what entities can and can't do structurally

## Context

Claude Code Entities is a system for turning Claude Code conversations into autonomous agents. Each entity has identity (SOUL.md), continuity (current-state.md), initiative (heartbeat via launchd/cron), and graduated permissions.

The permission model is the gating question for the entire build. Claude Code's `Write` tool can create OR overwrite any file the user has filesystem access to. The current plan uses behavioral rules ("only write within entity/") but these are LLM-followed, not structurally enforced. A confused or looping entity could overwrite critical files.

**Project directory:** `~/Playful Sincerity/PS Software/Claude Code Entities/`

Read these files first:
- `CLAUDE.md` — project overview and architecture decisions
- `plan.md` — full build plan (Section 6 covers permissions)
- `plan-section-infrastructure.md` — Section 6 detailed permission design
- `plan-section-behavioral.md` — Zone C (settings.json design), Q4 about Edit restrictions
- `research/prior-art-validation.md` — Claim 4 (settings.json as autonomy tier)
- `research/plan-deep/gh-scout-deploy.md` — kbwo/ccmanager Haiku-as-permission-analyzer pattern
- `ideas/entity-tuning-model.md` — permission differences per entity type

## The Core Tension

**PD (Wisdom's entity)** needs broad access:
- Store person profiles in `~/Wisdom Personal/people/`
- Create memory entries in `~/.claude/projects/.../memory/`
- Write across project directories in the ecosystem
- Read everything

**Frank/Jen (client entity)** needs narrow access:
- Write only to its own `entity/` space
- Access calendar via Google Calendar MCP
- Create journal entries in its own space
- Send messages via Slack/Telegram

**Both** must be safe from hallucination loops that could overwrite critical infrastructure.

## Task

### 1. Test Path-Scoped Permissions in settings.json

Create a test project directory. Write a `.claude/settings.json` with path-scoped allow rules and test whether Claude Code actually enforces them:

```json
{
  "permissions": {
    "allow": ["Write(test-entity/**)"],
    "deny": ["Write(protected/**)"]
  }
}
```

Test with `claude -p --cwd <test-dir>`:
- Try writing to `test-entity/test.md` — should succeed
- Try writing to `protected/test.md` — should be denied
- Try writing to `../../some-other-path` — should be denied
- Try writing to an absolute path outside the project — should be denied

Record exact results: what syntax works, what doesn't, what error messages appear.

### 2. If Path-Scoping Doesn't Work: Design a PreToolUse Hook

If settings.json doesn't support path-scoped Write permissions, design a hook that enforces them:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "command": "python3 ~/claude-system/scripts/entity-write-guard.py"
    }]
  }
}
```

The hook receives the tool input as JSON on stdin, checks the `file_path` parameter against an allow/deny list, and exits 0 (allow) or non-zero (block). Design the script, test it.

### 3. Define Permission Models

Based on what's structurally possible, define two permission models:

**PD Permission Model:**
- Protected paths (NEVER writable by entity): list specifically
- Open paths (always writable): list specifically  
- Ask-first paths (writable with proposal): list specifically
- How to handle "PD needs to write a people profile" use case

**Frank/Jen Permission Model:**
- Write scope: `entity/**` only
- MCP access: Google Calendar (read/write), Slack (send messages)
- No filesystem access outside entity/

### 4. Write the Actual settings.json Files

For PD: `psdc/.claude/settings.json` (or wherever PD's project root is)
For Frank/Jen: `entities/frank-jen/.claude/settings.json`

### 5. Test Blast Radius

In a sandboxed test:
- Run `claude -p` with the PD settings
- Ask it to write to a protected path
- Verify it's blocked without stalling
- Verify it can still write to allowed paths
- Verify denied actions return errors (not hangs)

## Output

Save all results to `sessions/v1-build/phase-1-foundation/results/`:
- `permission-test-results.md` — raw test results from path-scoping experiments
- `permission-model-design.md` — final permission models for PD and Frank/Jen
- `psdc-settings.json` — PD's settings.json (copy to `psdc/.claude/settings.json`)
- `frank-jen-settings.json` — Frank/Jen's settings.json (copy to `entities/frank-jen/.claude/settings.json`)
- `entity-write-guard.py` — PreToolUse hook script (if needed)

## Success Criteria

- [ ] Know definitively whether path-scoped Write permissions work in settings.json
- [ ] If not: have a working PreToolUse hook that enforces path restrictions
- [ ] PD's settings.json written and tested — blocked on protected paths, allowed on open paths
- [ ] Frank/Jen's settings.json written and tested — scoped to entity/ only
- [ ] Denied actions are non-blocking (entity gets error, adjusts, continues)
- [ ] Document what happens when entity tries to write outside its boundaries
