---
timestamp: "2026-04-14 09:50"
category: idea
related_project: Claude Code Entities
---

# Conversation Clone Routing — Spectrum of Context Inheritance

When spawning a sub-agent or continuation from an existing conversation, route based on how coupled the sub-task is to the parent conversation.

## The Spectrum

| Level | Method | When to Use |
|-------|--------|------------|
| **Light** | Prompt with file links only | Task just needs access to specific files. No conversational context needed. |
| **Medium** | Prompt + extracted context (key decisions, current state, thread summary) | Task needs to understand what was decided and why, but doesn't need the full conversation. |
| **Heavy** | Full conversation clone (read JSONL, rebuild full context) | Task literally needs to continue the same train of thought. The conversational context IS the value. |

## Router Criteria

- How coupled is the sub-task to the parent conversation?
- Does the sub-task need decisions/reasoning, or just files?
- Is the parent conversation's thinking process load-bearing for the sub-task?
- Could you brief a new person on this in 3 sentences (light), a paragraph (medium), or would they need to read the whole transcript (heavy)?

## Most tasks are Light or Medium

Full clone is rare — reserved for continuing deep think-deeps mid-stream, picking up a research thread that built momentum over many turns, or parallel exploration of a decision fork where both branches need the full reasoning context.

## Implementation

This could be a routing decision within a `/clone-conversation` skill, or a pattern documented in a rule that the entity follows when using the Agent tool.
