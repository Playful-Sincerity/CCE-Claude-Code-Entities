---
source_url: https://github.com/Nubaeon/empirica
fetched_at: 2026-04-16 14:00
fetched_by: think-deep-github
project: Claude Code Entities
---

# Nubaeon/empirica

**Stars:** 207 | **Language:** Python | **Version:** 1.8.4 (released Apr 15, 2026) | **License:** MIT

## What It Claims

Epistemic measurement, Noetic RAG, Sentinel gating, and grounded calibration for Claude Code and beyond. Three-vector model: self_assessed, observed (deterministic checks), and AI-reasoned grounded state.

## What's Actually Implemented

- `.empirica/` SQLite database for epistemic state
- `.git/refs/notes/empirica/*` — epistemic checkpoints
- `MEMORY.md` — auto-curated hot cache ranked by epistemic confidence
- CLI with 150+ commands
- MCP server integration for Cursor/Cline
- Sentinel gate: blocks code edits until understanding is demonstrated via domain-aware thresholds `(work_type, domain, criticality)`
- Deterministic check runners: pytest, ruff, git status as subprocess operations

## What's Missing / Gap

No code-level examples of hook interceptors. Epistemic annotation mechanics (retrieved/reasoned/weights-only tagging) not detailed. World-model file structure not exposed in README. The three-vector model appears to measure task-readiness, not claim provenance. This is closer to pre-execution gating than retrieval-as-structural-default.

## Verdict

**Adopt (partially).** The Sentinel pre-action gate pattern is directly relevant. The three-vector approach (self_assessed + observed + grounded) maps to the epistemic status annotation need. However the actual provenance tagging (retrieved vs weights-only) is not shipped — would need to be built on top.
