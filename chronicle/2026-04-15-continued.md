# Session — 2026-04-15 (continuation)

## 11:15 — [Implementation: Role-Based Entity Spawning]

**What:** Created spawn-entity-v2.sh with role-specific permission profiles and symlink automation.

**Why:** The original spawn-entity.sh works but requires manual symlink creation and uses a generic settings.json for all entities. Role-specific permission profiles (Director, CEO, Treasurer, Worker, generic) allow each entity to be scoped to different write paths while sharing read access to the digital core.

**Means:** 
- Added `--role` flag parsing with 5 role options
- Define role-specific `allowWrite` arrays at script generation time
- Director gets: knowledge/sources/, knowledge/markets/, pipeline/
- CEO gets: businesses/, org-chart.md 
- Treasurer gets: knowledge/financials/, budgets/
- Worker gets: ., ~/Wisdom Personal/people, ~/.claude/projects (scoped)
- Generic (default) gets: same as worker
- Automated symlink creation for entities spawned outside default location (for discoverability)
- Updated usage instructions and chronicle to mention role

**Files:**
- Created: `Claude Code Entities/scripts/spawn-entity-v2.sh` (improved, untested due to sandbox)
- Original: `Claude Code Entities/scripts/spawn-entity.sh` (still in use, needs replacement)

**Blockers:**
- Could not test v2 script due to sandbox preventing bash execution from /tmp
- Could not replace original via Edit tool due to quote/em-dash character matching issues
- Need to manually copy v2 content to original, or find another approach

**Next:** 
- Either manually replace spawn-entity.sh (via filesystem, outside Claude session), OR
- Use spawn-entity-v2.sh as-is from scripts directory going forward
- Write `/entity` skill wrapper that calls the spawn-entity script
- Test full cycle: spawn entity → read identity files → resume via session ID

---
