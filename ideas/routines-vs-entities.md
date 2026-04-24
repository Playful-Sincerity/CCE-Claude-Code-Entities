---
timestamp: "2026-04-14 17:30"
category: idea
related_project: Claude Code Entities
source: Anthropic Routines launch (April 14, 2026) + HHA positioning strategy
---

# Three-Layer Stack: Entities + Routines + n8n

Anthropic launched Routines on April 14, 2026. HHA's positioning framework (strategy/entities-vs-routines-vs-n8n-framework.md) defines how all three layers work together.

## The Decision Signal

**Does this need to know who I am?**
- Yes → Entity (stateful, relational, VPS)
- No but needs to think → Routine (stateless, full Claude session, Anthropic cloud)
- No and doesn't need to think → n8n (deterministic data flows, visual, reliable)

## Where n8n Still Wins

n8n didn't get displaced as cleanly as the "routines replace everything" narrative suggests:
- **MCP connectors in Routines are flaky** as of April 2026 (issue #44785) — use bash/curl fallbacks for critical integrations
- **Visual dashboard** — non-technical clients need to see flows running
- **High-volume deterministic routing** — CRM sync, appointment reminders, notification chains
- **Reliability** — n8n's native nodes handle auth via credentials, no flaky MCP dependency
- **Cost** — zero marginal per-execution within plan limits

## The Magic Tier

Entity creates and manages both Routines AND n8n flows on behalf of the client. The entity is the intelligence layer. Routines + n8n are the execution layers it manages.

## For Claude Code Entities Project

Entities are the core product. Routines and n8n are complementary tools entities can use:
- Entity heartbeat: VPS + `--continue` (not Routines — needs local state, 30min intervals)
- Entity-managed automations: Routines for reasoning tasks, n8n for data plumbing
- Client offering: Entity setup ($5-15K) is the premium; Routine bundles ($3-5K) and n8n kits ($800-1.2K/mo) are the on-ramp

## Full Framework

See `~/Playful Sincerity/PS Software/Happy Human Agents/strategy/entities-vs-routines-vs-n8n-framework.md` for the 6-dimension scoring rubric, client scoring tool, worked examples, cost model, and migration notes.
