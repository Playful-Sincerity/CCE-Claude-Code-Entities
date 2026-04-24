---
date: 2026-04-15
status: decided
scope: all Claude Code entities that need web scraping
---

# Scraping Stack — Firecrawl-First, Self-Host When It Hurts

See canonical version at:
`~/Playful Sincerity/PS Software/Autonomous-Venture-Studio/architecture/scraping-stack-decision.md`

## Summary

- **Now:** Firecrawl hosted (free tier), integrated via MCP
- **Later:** Self-host Firecrawl (same API, zero migration)
- **Max scale:** Firecrawl self-hosted + SearXNG + Playwright pool

Same decision applies to every Claude Code entity that scrapes. No per-entity reinvention.
