---
timestamp: "2026-04-14 16:00"
category: idea
related_project: Claude Code Entities
source: ClaudeClaw v2 analysis
---

# Message Queue — Prevent Race Conditions

ClaudeClaw uses a FIFO queue per chat to prevent two messages from processing simultaneously. Without this, a heartbeat firing while a user message is active causes silent failures.

Simple pattern: Map<chatId, Task[]>. Each chat processes one message at a time. Different chats run in parallel.

Priority: V1 — needed before heartbeat goes live.
