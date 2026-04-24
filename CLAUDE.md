# Claude Code Entities

## What This Is

A new paradigm: autonomous agents built on Claude Code as the framework. The Digital Core IS the agent configuration. GitHub IS the sync layer. Any Claude Code conversation can become an entity with identity, initiative, and a heartbeat.

An entity is not a chatbot. It's a Claude Code conversation that keeps running — with its own identity (SOUL.md), its own life (chronicles, observations, ideas), its own initiative (heartbeat), and the ability to communicate via messaging platforms (Slack, Telegram).

## The First Entity: PD (PSDC — Playful Sincerity Digital Core)

PD is the first Claude Code Entity. It's the Digital Core given a persistent thread, a home directory, and a heartbeat. PD's profile: `~/Wisdom Personal/people/psdc.md`

## Project Structure

```
Claude Code Entities/
  CLAUDE.md             ← this file
  SPEC.md               ← full system specification
  plan.md               ← build plan (reconciled, ready for execution)
  plan-section-*.md     ← detailed section plans
  psdc/                 ← PD's home (first entity)
    CLAUDE.md           ← PD's session config (loads via --cwd)
    SEED.md             ← PD's origin story (read-only)
    entity/             ← PD's life (identity, data, proposals, chronicle)
  templates/            ← clone for new entities
  research/             ← think-deep and plan-deep outputs
    think-deep/         ← two architecture think-deeps (April 13)
    plan-deep/          ← scout, gh-scout, play research
  chronicle/            ← project-level semantic log
  ideas/                ← project ideas
  play/                 ← play outputs
```

## Key Architecture Decisions (April 13, 2026)

1. Claude Code IS the agent framework — don't build a separate system
2. The Digital Core IS the agent's mind — rules are values, skills are capabilities
3. Each entity lives in its own directory with project-local CLAUDE.md for bot-specific behavior
4. Global rules (self-check, dc-freshness, skill-router) improve all conversations
5. Bot-specific behavior (initiative, heartbeat, permission-asking) lives in project CLAUDE.md
6. Permission model: graduated autonomy (observe → ideate → surface → explore → implement)
7. Git sync: one repo, entities push their own folder only
8. Heartbeat: launchd/cron, Haiku model, 30-min interval, ~$0.05/day

## Key Files

- **SPEC.md** — full system spec with cognitive architecture, deployment tiers, voice plan, commercial offering
- **plan.md** — reconciled build plan with section plans and research findings
- **psdc/SEED.md** — PD's origin story
- **psdc/entity/** — PD's identity, data, proposals, chronicle

## Prior Project

This project evolved from PS Bot (`~/Playful Sincerity/PS Software/PS Bot/`). The original PS Bot research, archives, and early code are preserved there. Claude Code Entities is the broader vision that PS Bot became.

## Connections

- **Digital Core** (`~/claude-system/`) — the entity's mind, synced via GitHub
- **PSDC Profile** (`~/Wisdom Personal/people/psdc.md`) — PD's entity profile
- **HHA** — Claude Code Entities for clients is a future HHA product offering
- **The Companion** — Convergence Vision: PD eventually becomes The Companion's voice layer
