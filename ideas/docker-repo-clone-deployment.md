---
timestamp: "2026-04-14 09:45"
category: idea
related_project: Claude Code Entities
---

# Docker + Repo Clone Deployment Model

Instead of raw VPS + tmux, run entities in Docker containers with repo clones.

## Architecture

```
Docker Container (per entity)
├── Clone of Digital Core repo (read-only mount or git pull)
├── Entity's own data volume (persistent, writable)
│   └── entity/ (identity, chronicles, observations, proposals)
├── Claude Code CLI installed
├── Heartbeat cron running inside container
├── MCP connections (Slack, Calendar, etc.)
└── Settings.json with entity-specific permissions
```

## Sync Model

- **Digital Core updates:** Container pulls from GitHub on schedule (or webhook trigger)
- **Entity data:** Writes to its own volume. Optionally pushes entity/ folder to a separate branch or folder in the repo via GitHub as intermediary.
- **No direct push to main** — GitHub acts as the permission boundary. Entity creates a PR or pushes to its own branch. Wisdom reviews and merges.

## Advantages over raw VPS + tmux

- **Isolation** — each entity is fully contained, can't affect others
- **Reproducibility** — Dockerfile defines exact setup, spin up new entities in minutes
- **Easy teardown** — `docker stop && docker rm`, no VPS cleanup
- **Portability** — same container runs on any Docker host
- **Scaling** — multiple entities on one VPS, each in their own container
- **Health checks** — Docker's built-in restart policies + health checks

## Considerations

- Docker adds a layer of complexity for initial setup
- Need to handle Claude Code auth (API key or subscription login) inside container
- GPU passthrough needed if running local Gemma for voice (V2+)
- Storage for entity data volumes needs backup strategy

## When to explore

V1.5 — after the Mac-local entity is proven. Docker deployment replaces the raw tmux approach for client VPSes.
