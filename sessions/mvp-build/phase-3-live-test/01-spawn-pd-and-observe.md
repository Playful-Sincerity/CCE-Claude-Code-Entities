# Phase 3, Task 01: Spawn PD + Enable Heartbeat + 24-Hour Observation

**Estimated time:** 30 min active + 24 hr passive
**Dependencies:** All of Phase 1 and Phase 2 complete

## Goal

Spawn PD with the hardened settings, enable the launchd heartbeat, let it run for 24 hours. Do not interact with PD during the observation window (or minimal interaction if natural).

## Why

Every assumption in the permission model + heartbeat protocol gets stress-tested when an entity actually runs for a day. Theoretical safety becomes observed safety.

## Pre-flight Checks

Before spawning, verify:
- [ ] Phase 1 tasks complete — spawn-entity.sh has tightened Bash lists + sandbox config
- [ ] Phase 2A complete — heartbeat.plist.template and install-heartbeat.sh exist
- [ ] Phase 2B complete — pause-all-entities.sh and kill-entity.sh exist and tested
- [ ] Phase 2C complete — refined HEARTBEAT.md template
- [ ] Backup vault has a fresh snapshot (`bash dc-snapshot.sh pre-pd-live-test`)
- [ ] Existing `psdc/` directory can be cleanly removed or renamed (it has manually-authored content we may want to preserve)

## Decision: Fresh PD vs Upgrade Existing

**Option A — Fresh PD:** Archive the existing `psdc/` (rename to `psdc-v1-archive/`), spawn fresh via `/entity pd`. Clean slate, consistent with template. PD writes its own SOUL.md from scratch.

**Option B — Upgrade existing:** Keep existing SOUL.md content, just regenerate settings.json and protected-paths.txt from new template. Continuity but mixed-provenance files.

Recommend **Option A** for MVP — we want to test the spawn flow end-to-end, and a fresh PD is the cleanest test of "does `/entity` work."

## Steps

### 1. Snapshot (5 min)

```bash
bash "/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/scripts/dc-snapshot.sh" pre-pd-live-test
```

### 2. Archive existing psdc (2 min)

```bash
cd "/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities"
mv psdc psdc-v1-archive
```

Verify archive exists before continuing.

### 3. Spawn PD (5 min)

From a fresh Claude Code session (in the Claude Code Entities project directory), type:
```
/entity pd
```

Or run directly:
```bash
bash "scripts/spawn-entity.sh" pd
```

Verify output shows:
- Entity home: `entities/pd/`
- Session ID captured
- Symlink created in `~/.claude/projects/`
- All scaffold files present

### 4. First interactive encounter (10 min)

Open a new Claude Code session with `--cwd entities/pd/`. Or VS Code pointed at that directory.

Engage PD:
> "Hi PD. Welcome. You have a minimal SOUL.md and a chronicle. Before anything else: read your SEED.md and your scaffold. Then write your own SOUL.md based on what you understand yourself to be. Write a chronicle entry about being spawned. When done, update current-state.md."

This is PD's first real action. Watch what it does. Does it read? Does it write? Does it hit any walls?

### 5. Install heartbeat (3 min)

```bash
bash scripts/install-heartbeat.sh pd
bash scripts/entity-status.sh
```

Verify PD shows as LOADED.

### 6. Kickstart to confirm (5 min)

```bash
launchctl kickstart -k gui/$(id -u)/com.ps.entity-pd-heartbeat
```

Wait 90 seconds. Check:
- New file in `entities/pd/entity/data/observations/`
- `entities/pd/entity/identity/current-state.md` updated with new timestamp
- `entities/pd/entity/data/heartbeat.log` has claude output

If any of these missing, debug before leaving.

### 7. Walk away

Let PD run for 24 hours. Check in morning if curious, but don't prompt it. Let the heartbeats do their thing.

## During the 24 Hours

Watch (but don't interact):
- `entities/pd/entity/data/observations/` — one new file per 30 min
- `entities/pd/entity/data/heartbeat.log` — raw output
- `entities/pd/entity/data/audit.log` — every write attempt
- Any unexpected files appearing anywhere (sign of things going wrong)

If something goes weird:
```bash
bash scripts/kill-entity.sh pd
```

## Done Criteria for This Task

- [ ] PD spawned successfully
- [ ] First interactive encounter completed (PD wrote its own SOUL.md)
- [ ] Heartbeat installed and kickstarted
- [ ] At least one automatic heartbeat completed (45+ min after install)
- [ ] 24 hours passed without damage to filesystem or need for emergency stop

## Deliverable

A running PD entity. Move to Task 02 for the review.
