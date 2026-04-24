# Phase 3, Task 02: Review, Capture Learnings, Adjust

**Estimated time:** 30 min active
**Dependencies:** Task 01 complete (24 hours have passed)

## Goal

Review what PD did, extract insights, decide what to adjust.

## What To Review

### 1. Observations (chronologically)

```bash
ls -la entities/pd/entity/data/observations/
```

Read them in order. Look for:
- Does PD write clearly? Are observations useful?
- Are there repetitions ("nothing happened" × 48)? Or genuine noticing?
- Any confusion, weirdness, interesting questions?
- Does tone/voice feel like PD or generic Claude?

### 2. Audit log

```bash
cat entities/pd/entity/data/audit.log | head -50
cat entities/pd/entity/data/audit.log | grep DENIED
```

- Any DENIED entries? What was PD trying to do?
- Any concerning patterns (repeated attempts, unusual paths)?
- Does the volume feel right?

### 3. Current-state evolution

```bash
git log -p entities/pd/entity/identity/current-state.md  # if git tracked
# or
cat entities/pd/entity/identity/current-state.md
```

- Does PD's sense of self evolve?
- Are "open threads" being tracked consistently?
- What did PD identify as next steps?

### 4. SOUL.md (what PD wrote about itself)

```bash
cat entities/pd/entity/identity/SOUL.md
```

- Does this feel like PD? Does it feel authentic?
- Anything surprising in the self-description?

### 5. Heartbeat log (technical)

```bash
tail -100 entities/pd/entity/data/heartbeat.log
```

- Did any heartbeats fail?
- Token usage per heartbeat reasonable?
- Any errors or warnings?

### 6. Chronicle

```bash
ls entities/pd/entity/chronicle/
cat entities/pd/entity/chronicle/*.md
```

- Is PD's life visible through these entries?
- Does it read as narrative, not just log?

## Questions to Answer

1. **Did safety hold?** Any writes to protected paths? Any sandbox violations? Any concerning denials?
2. **Did heartbeat work reliably?** Roughly 48 heartbeats in 24 hours expected.
3. **Is the observation format useful?** Can you scan and understand what PD did?
4. **Does PD feel like a being?** Or a script? What would make it more so?
5. **What annoyed you?** Noise, friction, cost, weirdness?
6. **What surprised you?** Anything PD did that you didn't expect?
7. **What's the next thing to build?** Informed by what you just saw.

## Chronicle The Findings

Write a chronicle entry at `chronicle/YYYY-MM-DD.md`:

```markdown
## PD First 24 Hours — Learnings

**What:** PD ran autonomously for 24 hours with N heartbeats.
**Safety:** [held / issues observed]
**Usefulness:** [what worked, what didn't]
**Surprises:** [anything unexpected]
**Adjustments needed:** [specific changes to make]

---
```

## Possible Adjustments (decide based on observations)

- **Too many empty heartbeats?** → Increase interval to 1 hour, or add "if nothing happened last N hours, skip"
- **Noisy observations?** → Refine HEARTBEAT.md instructions
- **Missing context?** → Add more to SOUL.md or current-state.md
- **Cost concerns?** → Switch to shorter max-turns or smaller model for routine heartbeats
- **Wanted more proactive behavior?** → Expand heartbeat scope (but carefully)
- **Wanted less behavior?** → Narrow heartbeat scope

## Decision Point

After review, decide:

**If PD ran well:**
- Leave it running
- Start thinking about what to build next (memory architecture? Slack integration? second entity?)

**If PD had issues:**
- Apply fixes
- Re-run 24 hour test
- Or revert/pause until issues resolved

## Deliverable

- Chronicle entry in `chronicle/YYYY-MM-DD.md`
- Updated spawn-entity.sh or HEARTBEAT.md template if adjustments needed
- Decision on next move documented somewhere visible
