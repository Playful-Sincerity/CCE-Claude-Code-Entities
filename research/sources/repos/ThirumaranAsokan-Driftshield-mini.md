---
source_url: https://github.com/ThirumaranAsokan/Driftshield-mini
fetched_at: 2026-04-16 14:10
fetched_by: think-deep-github
project: Claude Code Entities
---

# ThirumaranAsokan/Driftshield-mini

**Stars:** 2 | **Language:** Python 3.10+ | **Version:** v0.1.1 (Feb 2026) | **License:** MIT | **Commits:** 9

## What It Implements

Real-time behavioural drift detection wrapping LangChain and CrewAI agents.

- **Calibration phase**: first 30 runs (configurable) quietly observe to build baseline
- **Goal drift**: local CPU embeddings compare output to stated `goal_description` (value-drift coverage)
- **Loop detection**: identifies repetitive tool-calling patterns (output-drift)
- **Resource spikes**: token/duration anomalies vs learned statistical baseline
- **Integration**: `agent = monitor.wrap(existing_agent)` — non-intrusive wrapper
- **Alerts**: Slack/Discord webhooks with structured payload (detector type, severity, context)

## Coverage

Covers both value-drift (semantic alignment to goal) and output-drift (similarity/pattern). Post-execution analysis, not pre-generation gating.

## Gap

Self-described "not production-hardened yet." 2 stars, single contributor. No retrieval gating. No provenance tagging. Drift detection is reactive (after generation), not structural prevention.

## Verdict

**Adapt (concept, not code).** The goal_description + embedding similarity approach for value-drift detection is the right direction. The wrap() pattern for non-intrusive integration is clean. Too early-stage to adopt directly. The three-detector structure (goal, loop, resource) maps well to what Claude Code Entities need to monitor.
