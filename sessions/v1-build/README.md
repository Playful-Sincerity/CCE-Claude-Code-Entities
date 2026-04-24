# Claude Code Entities — V1 Build

**Project:** `~/Playful Sincerity/PS Software/Claude Code Entities/`
**Plan:** `plan.md` (reconciled build plan from April 13, 2026)
**Started:** April 14, 2026
**Status:** Phase 1 ready to launch

## What We're Building

A system for turning any Claude Code conversation into an autonomous entity with identity (SOUL.md), continuity (current-state.md), initiative (heartbeat), and graduated permissions. First entity: PD (the Digital Core). First client tuning: Frank/Jen (calendar assistant, morning practice, energy-aware scheduling, journaling).

## Phase Map

```
Phase 1: Foundation (PARALLEL — start both now)
    ┌─────────────────────┐   ┌─────────────────────┐
    │ A: Permission Model │   │ B: PD Identity Test  │
    │ (test path-scoping, │   │ (finish Phase 0,     │
    │  design safety)     │   │  claude -p test,     │
    │                     │   │  PD writes own soul) │
    └────────┬────────────┘   └────────┬────────────┘
             │                         │
             ▼                         ▼
Phase 2: Entity Build (after Phase 1)
    ┌─────────────────────┐   ┌─────────────────────┐
    │ C: Frank/Jen Entity │   │ D: Behavioral Config │
    │ (needs A: perms)    │   │ (needs B: identity)  │
    │ SOUL, HEARTBEAT,    │   │ Global rules +       │
    │ CLAUDE.md tuned for │   │ PD's full CLAUDE.md  │
    │ calendar/energy/    │   │ self-check,          │
    │ morning practice    │   │ dc-freshness,        │
    │                     │   │ skill-router         │
    └─────────────────────┘   └────────┬────────────┘
                                       │
                                       ▼
Phase 3: Infrastructure (after Phase 2D)
    ┌──────────────────────────────────────────────┐
    │ E: Heartbeat + Slack + Telegram              │
    │ (needs D: behavioral config)                 │
    │ launchd plist, Slack MCP, Telegram refinement│
    └──────────────────────────────────────────────┘
```

## Launch Order

1. **Now:** Start sessions **A** and **B** in parallel
2. **After A completes:** Start session **C**
3. **After B completes:** Start session **D**
4. **After D completes:** Start session **E**

C and D can run in parallel once their respective prerequisites finish.

## Human Action Required

- **Phase 1A:** Wisdom needs to evaluate test results and make permission design decisions
- **Phase 1B:** Wisdom should be present for the PD identity test (interactive)
- **Phase 2C:** Wisdom + Frank should review Frank/Jen SOUL.md tuning
- **Phase 3E:** Slack app creation requires manual web setup (api.slack.com)

## Prior Work (This Session)

Completed April 14 before decomposition:
- 5 parameterized entity templates in `templates/`
- PD's rough SOUL.md + current-state.md (needs trimming — let PD explore and write its own)
- Frank/Jen directory scaffold (empty, ready for content)
- Permission model session brief (migrated into this build structure)
- Chronicle entry for April 14
