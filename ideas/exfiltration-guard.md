---
timestamp: "2026-04-14 16:00"
category: idea
related_project: Claude Code Entities
source: ClaudeClaw v2 analysis
---

# Exfiltration Guard — Scan Outbound Messages

We have web-content-safety.md for inbound (prompt injection detection). ClaudeClaw has a 15+ regex pattern scanner for outbound messages — catches leaked API keys, tokens, credentials in entity responses before they reach Telegram/Slack.

For autonomous entities, this is critical. A hallucinating entity could dump env vars or config files containing secrets.

Patterns to scan: sk-, AKIA, xoxb-, ghp_, Bearer tokens, hex strings 32+, base64-encoded secrets, URL-encoded secrets.

Could be a PreToolUse hook on Write or a PostMessage hook.

Priority: V1.5 — needed before entities go autonomous.
