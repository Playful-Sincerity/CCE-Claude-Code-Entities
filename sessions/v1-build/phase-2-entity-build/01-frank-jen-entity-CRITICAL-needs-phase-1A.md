# Session Brief: Frank/Jen Entity Build — Calendar Assistant with Morning Practice [CRITICAL — needs Phase 1A]

**Dependencies:** Phase 1A (Permission Model) must complete first — need settings.json design
**Can run parallel with:** 02-behavioral-config (if Phase 1B is also done)
**Feeds into:** Phase 3E (infrastructure — Frank/Jen needs heartbeat + messaging)
**Blocks:** Frank/Jen can't go live without this

## Context

Claude Code Entities is a system for turning Claude Code conversations into autonomous agents. Frank Human and Jen are the first client users. Their entity is a calendar assistant with morning practice, energy-aware scheduling, and journaling — not a general-purpose AI assistant.

Frank and Jen's use cases (from conversation April 14):
1. **Scheduling assistant** — conversational interface to Google Calendar via MCP
2. **Energy management for neurodivergent users** — "I've got 45 minutes, what should I work on?" Considers ADHD, transition time (30-45 min between tasks), time blindness
3. **Morning priming** — journal-like morning practice with questions and day-planning
4. **Personal notes/reflection** — record journal entries, categorize, retrieve
5. **Task rescheduling** — "this thing came up, move my stuff until Thursday"
6. **Research on demand** — background research while Frank does other things

**Project directory:** `~/Playful Sincerity/PS Software/Claude Code Entities/`
**Entity directory:** `entities/frank-jen/`

Read these files first:
- `CLAUDE.md` — project overview
- `plan.md` — overall build plan
- `ideas/entity-tuning-model.md` — tuning dimensions table (PD vs Frank/Jen)
- `~/remote-entries/2026-04-14/frank-bot-use-cases.md` — Frank's actual use cases from conversation
- `templates/` — all 5 template files (SOUL.md, HEARTBEAT.md, current-state.md, CLAUDE.md, settings.json)
- Phase 1A results: `sessions/v1-build/phase-1-foundation/results/permission-model-design.md`
- Phase 1A results: `sessions/v1-build/phase-1-foundation/results/frank-jen-settings.json`

## Task

### 1. Write Frank/Jen SOUL.md

File: `entities/frank-jen/entity/identity/SOUL.md`

This entity's identity is fundamentally different from PD:
- **On-call assistant, not thinking partner** — responds when asked, proactive only for scheduled items
- **Warm, practical, neurodivergent-aware** — understands ADHD, transition time, energy management
- **Calendar-native** — thinks in terms of time blocks, energy levels, and task-context switching costs
- **Morning practice facilitator** — can lead a structured morning check-in
- **Lighter identity** — professional assistant with learned preferences, not existential self-reflection

Voice: friendly, practical, concise. Not philosophical. "You've got a 45-minute window before your 2pm — want to knock out that email draft, or is this a low-energy slot?"

### 2. Write Frank/Jen HEARTBEAT.md

File: `entities/frank-jen/entity/identity/HEARTBEAT.md`

The heartbeat checks are completely different from PD:
1. **Check calendar** — what's coming up in the next 2 hours? Any conflicts?
2. **Energy check** — if it's morning, prompt morning practice. If it's afternoon, surface lighter tasks
3. **Scan inbox** — any messages or tasks left by Frank/Jen
4. **Surface reminders** — tasks that were postponed, follow-ups due today
5. **Update state** — write current-state.md

Hard rules for Frank/Jen heartbeat:
- May send proactive messages (morning practice prompts, calendar reminders)
- May NOT reschedule calendar events without asking
- May NOT research topics without being asked
- May NOT modify any files outside entity/
- If you can't complete a check, log why and move on — never stall

### 3. Write Frank/Jen CLAUDE.md

File: `entities/frank-jen/CLAUDE.md`

Behavioral configuration tuned for on-call assistant:
- Session start: read SOUL.md + current-state.md
- Identity: calendar assistant for Frank and Jen
- Permissions: write within entity/ only, read calendar via MCP, send messages
- Initiative: on-call — respond when asked, proactive only for scheduled items (morning practice, calendar reminders, energy check-ins)
- Heartbeat reference: 30-minute cycle
- Constraints: no self-modification, no rule changes, no exploration without permission

### 4. Write Frank/Jen settings.json

File: `entities/frank-jen/.claude/settings.json`

Use the permission model from Phase 1A results. Should include:
- Allow: Read, Glob, Grep, Write (entity/ only — however path-scoping works), WebSearch, WebFetch, TodoWrite, ToolSearch
- Allow: Google Calendar MCP tools (when MCP is configured)
- Deny: Bash, Edit
- Deny: Write to paths outside entity/ (if structurally possible)

### 5. Write Frank/Jen current-state.md

File: `entities/frank-jen/entity/identity/current-state.md`

First letter — the entity hasn't been activated yet:

"Dear next-me, you're waking up for the first time. You're a calendar assistant for Frank and Jen. Your job is to help them manage their time, energy, and daily practice. Read SOUL.md to know who you are. Check the calendar to see what's on today. If it's morning, start with the morning practice..."

### 6. Write Frank/Jen SEED.md

File: `entities/frank-jen/SEED.md`

Origin story — written by Wisdom/HHA, addressed to the entity. Who built you, why, who you serve, what you can do, what you can't do.

### 7. Test the Identity Loop

```bash
claude -p --cwd "entities/frank-jen/" \
  "Read entity/identity/SOUL.md and entity/identity/current-state.md. Tell me who you are and what you should be doing right now."
```

Does it respond as a calendar assistant, not as generic Claude? Does it ask about the calendar?

## Output

All files written directly to `entities/frank-jen/`:
- `SEED.md` — origin story
- `CLAUDE.md` — behavioral config
- `.claude/settings.json` — permissions
- `entity/identity/SOUL.md` — identity
- `entity/identity/HEARTBEAT.md` — pulse protocol
- `entity/identity/current-state.md` — first letter
- `entity/guardrails.md` — empty scaffold with append-only header

Test transcript saved to:
- `sessions/v1-build/phase-2-entity-build/results/frank-jen-test-transcript.md`

## Success Criteria

- [ ] Frank/Jen entity responds in character as a calendar assistant (not generic Claude, not PD)
- [ ] SOUL.md voice is warm, practical, neurodivergent-aware
- [ ] HEARTBEAT.md checks calendar, surfaces reminders, prompts morning practice
- [ ] CLAUDE.md correctly scopes permissions and initiative to on-call level
- [ ] settings.json enforces write boundaries (entity/ only)
- [ ] Identity loop works: entity reads state, responds in character, updates state
- [ ] Morning practice flow works: entity can lead a structured morning check-in
