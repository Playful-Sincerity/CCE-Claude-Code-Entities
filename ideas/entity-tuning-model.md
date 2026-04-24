---
timestamp: "2026-04-14 09:45"
category: idea
related_project: Claude Code Entities
---

# Tune Per User — Entity Configuration Model

Same architecture, different tuning. Every Claude Code Entity has the same infrastructure (SOUL.md, heartbeat, permissions, graduated autonomy). What changes per user is the configuration.

## Tuning Dimensions

| Dimension | Wisdom (PD) | Frank/Jen (Client) |
|-----------|-------------|-------------------|
| **Autonomy level** | High — propose ideas, explore on own, earned conviction | Low — suggest and wait, no unsupervised exploration |
| **Thinking partner vs on-call** | Thinking partner — surfaces connections, challenges assumptions, plays with ideas | On-call — responds when asked, proactive only for reminders/scheduling |
| **Self-modification** | Can propose rule changes, update own SOUL.md, form convictions | Fixed rules, HHA maintains, $250 for custom additions |
| **Skills available** | All 20+ (think-deep, play, debate, plan-deep, research) | Curated subset (calendar, journal, reminders, basic research) |
| **Heartbeat behavior** | Scan for ideas, check Digital Core changes, propose improvements | Check calendar, surface reminders, morning practice prompts |
| **Identity depth** | Full SOUL.md with earned conviction, values, self-reflection | Lighter identity — professional assistant with learned preferences |
| **Morning practice** | PSSO-based priming (5 centers, philosophical) | Journal prompts, day planning, energy check-in |
| **Voice** | Eventually confidence-modulated prosody | Simple voice I/O (talk to calendar, record journal) |

## How to Implement

The tuning lives in three places:
1. **SOUL.md** — who the entity is, what it cares about, how it communicates
2. **CLAUDE.md** — what behaviors are active (initiative level, permission patterns)
3. **settings.json** — what tools are available, what's denied

Spinning up a new tuning: clone template, adjust these three files, deploy.
