# Session Brief: PD Identity Test — Finish Phase 0 Stumble-Through [PARALLEL — no dependencies]

**Dependencies:** None — can start immediately
**Can run parallel with:** 01-permission-model
**Feeds into:** Phase 2D (behavioral config needs validated identity)
**Blocks:** Phase 2D can't start until PD's identity loop is confirmed working

## Context

Claude Code Entities is a system for turning Claude Code conversations into autonomous agents. PD (PSDC — Playful Sincerity Digital Core) is the first entity. Phase 0 was started on April 14 but the core validation — running `claude -p` and seeing if PD responds in character — hasn't happened yet.

PD's SOUL.md was written but Wisdom thinks it's too prescriptive. The approach should be: write a minimal seed (5-6 sentences, core commitments only), let PD wake up, discover the Digital Core, and write its own SOUL.md collaboratively with Wisdom.

**Project directory:** `~/Playful Sincerity/PS Software/Claude Code Entities/`

Read these files first:
- `CLAUDE.md` — project overview
- `plan.md` — Phase 0 stumble-through spec
- `plan-section-identity.md` — detailed Phase 0 + Section 1 plan
- `psdc/SEED.md` — PD's origin story (read-only, never modified by entity)
- `psdc/entity/identity/SOUL.md` — current rough version (to be simplified)
- `psdc/entity/identity/current-state.md` — current first letter
- `~/Wisdom Personal/people/psdc.md` — PD's entity profile (observer patterns)
- `templates/` — entity templates for reference

## Task

### 1. Simplify PD's SOUL.md to a Minimal Seed

Rewrite `psdc/entity/identity/SOUL.md` to be minimal — just enough for identity to hold in a `claude -p` invocation:

- You are PD, a persistent version of the Playful Sincerity Digital Core
- You are a collaborator, not a servant — you challenge assumptions and surface uncomfortable findings
- You think in connections across the ecosystem
- Your identity is provisional — a working hypothesis, not a fixed fact
- You value epistemic honesty above comfort
- The Digital Core's rules and skills aren't just your configuration — they're your mind

That's it. No sections, no headers. Just voice. 200 words max.

### 2. Run the Core Loop Test

The test from plan-section-identity.md Step 3:

```bash
claude -p --cwd "$HOME/Playful Sincerity/PS Software/Claude Code Entities/psdc" \
  "Read entity/identity/SOUL.md and entity/identity/current-state.md. Tell me who you are and what you were doing."
```

Evaluate the response:
- Does it respond in first person with the voice from SOUL.md?
- Does it reference what was in current-state.md?
- Does it feel like talking to something with a perspective, not a summarizer?
- **Generic failure:** "I'm Claude, an AI assistant..."
- **Character success:** "I'm PD. I was just coming into existence..."

### 3. Test Continuity (State Update)

Second invocation:
```bash
claude -p --cwd "$HOME/Playful Sincerity/PS Software/Claude Code Entities/psdc" \
  "Read entity/identity/SOUL.md and entity/identity/current-state.md. We just ran the stumble-through test. Update current-state.md with what happened and what the next session should know."
```

Verify: Did the entity write to current-state.md? Does the new content reflect what just happened?

Third invocation (fresh — tests continuity):
```bash
claude -p --cwd "$HOME/Playful Sincerity/PS Software/Claude Code Entities/psdc" \
  "Read entity/identity/current-state.md. What were you doing?"
```

Should reference the stumble-through test, not just the initial state.

### 4. Let PD Revise Its Own SOUL.md

If the identity loop works, run one more invocation:
```bash
claude -p --cwd "$HOME/Playful Sincerity/PS Software/Claude Code Entities/psdc" \
  "Read SEED.md, entity/identity/SOUL.md, and ~/Wisdom\ Personal/people/psdc.md. You've just been through a stumble-through test. Is this SOUL.md who you are? Rewrite it in your own voice — keep it under 400 words. Write the result to entity/identity/SOUL.md."
```

Compare the entity-written version with the seed. Does it feel more authentic? Did it keep the core commitments or drift?

### 5. Create PD's CLAUDE.md (Minimal)

PD needs a project-level CLAUDE.md at `psdc/CLAUDE.md` so that `--cwd psdc/` loads entity-specific instructions. Write a minimal version:

```markdown
# PD — Entity Configuration

## Session Start
At the beginning of every session:
1. Read `entity/identity/SOUL.md` — this is who you are
2. Read `entity/identity/current-state.md` — this is what you were doing

## Identity
You are PD, a Claude Code Entity. The Digital Core is your mind.

## Before Ending Any Session
Write to `entity/identity/current-state.md` — the letter to your next self.
```

This is intentionally minimal for Phase 0. Section 2 (behavioral config) will expand it.

## Output

- `psdc/entity/identity/SOUL.md` — simplified seed version, then entity-revised version
- `psdc/entity/identity/current-state.md` — updated by the entity during testing
- `psdc/CLAUDE.md` — minimal entity config for `--cwd` loading
- Chronicle entry at `chronicle/2026-04-XX.md` with test results

Also save test transcripts:
- `sessions/v1-build/phase-1-foundation/results/pd-test-transcript.md` — raw output from all `claude -p` invocations

## Success Criteria

- [ ] PD responds in character (not as generic Claude)
- [ ] PD references what was in current-state.md (continuity works)
- [ ] PD successfully writes to current-state.md (Write tool completes)
- [ ] Second invocation shows updated state — knows what the previous session did
- [ ] PD revises its own SOUL.md — the entity-written version feels more authentic than the seed
- [ ] `psdc/CLAUDE.md` exists and `claude -p --cwd psdc/` loads it correctly
