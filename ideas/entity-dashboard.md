---
timestamp: "2026-04-14 16:00"
category: idea
related_project: Claude Code Entities
source: ClaudeClaw v2 analysis
---

# Entity Dashboard — Web UI for Monitoring

ClaudeClaw has a 3,200+ line embedded HTML dashboard (Hono on port 3141):
- Memory timeline with search
- Token usage graphs (Chart.js)
- Agent status cards
- Mission task queue viewer
- Hive mind activity log
- Audit trail browser
- War Room management
- SSE for real-time updates
- Privacy blur toggle
- No React, no build step — just embedded HTML/CSS/JS

For HHA clients, this would be a real differentiator. Frank/Jen could see their entity's memory, upcoming tasks, cost, and heartbeat status from a browser.

Could serve via Cloudflare Tunnel for mobile access.

Priority: V2 — after core entity system is working.
