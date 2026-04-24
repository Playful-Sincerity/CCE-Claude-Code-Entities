---
source_url: https://arxiv.org/html/2604.05278
fetched_at: 2026-04-16
fetched_by: think-deep-web
project: Claude Code Entities
---

# Spec Kit Agents: Context-Grounded Agentic Workflows (2026)

## Core Architecture

Multi-agent spec-driven development pipeline with three components:
1. Orchestrator (state machine)
2. PM Agent (requirements clarification)
3. Developer Agent (artifact and code generation)

Workflow phases: Specify → Plan → Tasks → Implement

## What "Context-Grounded" Solves

"Context blindness" — where agents generate internally coherent but repository-incompatible outputs (hallucinated APIs, non-existent paths, architectural violations).

Grounds decisions in actual repository evidence rather than parametric model weights alone.

## Structural Enforcement Mechanism: Two Hook Types

**Discovery Hooks (pre-phase):** Read-only probing collects repository evidence — relevant files, conventions, dependencies, history — BEFORE each stage begins.

**Validation Hooks (post-phase):** Checks intermediate artifacts (SPEC/PLAN/TASKS) for structural and referential constraints like file-path existence and dependency availability, BEFORE code generation proceeds.

## Prevention Architecture

The system decouples grounding from generation by:
- Operating validation BEFORE implementation (catching errors early)
- Restricting agents to least-privilege tool access
- Making grounding "an explicit workflow primitive" rather than in-prompt behavior
- Using phase-scoped artifact validation against executable signals (tests, linters)

## Key Insight for Claude Code Entities

This is the clearest production example of "grounding as a workflow primitive." Grounding is not in the prompt — it's a hook that fires before the generation phase is allowed to start. The agent cannot skip it because the hook is architecturally prior to generation.
