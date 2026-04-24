# Stream A — Self-Learning Mechanisms

**Date:** 2026-04-16
**Agent:** researcher (Sonnet)
**Agent ID:** acd90a4c86ef8930f
**Note:** Agent was blocked from Write — agent returned a summary but its full ~4000-word report was not recovered. This file holds the summary and can be expanded by resuming the agent via SendMessage if needed.

---

## Summary (agent-provided, verbatim)

### Dominant mechanism pattern

The field has converged on a **two-phase Observe–Extract–Retrieve loop.** During operation, agents accumulate raw observations into an append-only log (daily logs, SQLite, session archive). A cheaper secondary process — scheduled separately, not inline — consolidates that raw accumulation into structured long-term knowledge (MEMORY.md, skill files, vector DB entries).

Every mature system studied (KAIROS, ClaudeClaw, Letta, Hermes Agent, OpenClaw) separates the accumulation phase from the distillation phase. Systems that skip Phase 1 and write directly to long-term memory (early MemGPT, basic Claude Code auto-memory) degrade in quality over time.

### Most novel mechanism

**KAIROS's two-loop separation.** The tick loop (operational mode) never writes to long-term memory — it appends to an ephemeral daily log only. A nightly forked subagent with restricted tools (read-only Bash, write-only to `memdir/`) runs the "dream" consolidation. This means **the entity can never corrupt its own knowledge base mid-operation.**

Paired with terminal-focus-awareness that modulates autonomy based on whether the user's window is focused — the only hardware-signal-to-behavior mechanism found in any system.

### What's most missing across the field

**No system has a validated mechanism for updating *behavioral policy* — how the agent decides and acts.** Every update lands in memory (facts) or skill files (procedures). The rules, values, and decision-criteria layers are always static. The field has not addressed this gap.

Claude Code Entities' `proposals/` + `guardrails.md` architecture is the only design found anywhere that even attempts behavioral policy learning through an approval loop.

### Which Hermes is relevant

**NousResearch Hermes Agent** (github.com/nousresearch/hermes-agent, launched early 2025). Uses Hermes model weights but is a full agent framework with:
- Skill creation thresholds: 5-tool-call / error-recovery / user-correction
- agentskills.io-compatible SKILL.md files
- 1-session memory delay
- Lineage-preserving compression

The SPEC.md's "Platform Adapter from Hermes (V2+)" refers specifically to this project's 18-adapter platform gateway pattern. There is no separate "Hermes by Cognition" or other competing Hermes agent framework in autonomous-agent land.

---

## CCE Implications (extracted from summary)

1. **Two-phase loop validates CCE's chronicle → memory pattern.** The chronicle/ directory maps to KAIROS's ephemeral log. A future consolidation pass (weekly, via subagent) maps to the dream loop. This is the KAIROS pattern, independently arrived at.

2. **Consolidation should run in a restricted subagent, not in the main entity session.** This is a concrete design recommendation: don't let the operating entity write to its own long-term memory inline. Fork a subagent with write-only-to-memdir permissions.

3. **The gap the field hasn't closed — behavioral policy updates — is exactly what Wisdom's ordering addresses.** The `proposals/ + guardrails.md + rules/` pattern with human approval is the structural answer to the question no one else has answered.

4. **Hermes Agent is worth a dedicated read pass** — the 18-adapter platform gateway pattern is directly relevant to CCE's messaging-platform plans.

---

## Recovery

If the full ~4K-word report is needed: resume the agent via SendMessage to `acd90a4c86ef8930f` with a prompt like "Please output the full five-section report (executive summary, system-by-system breakdown, cross-cutting patterns, gaps, implications) in-line. Write is blocked — deliver as text only."

## Citations (to verify)

Agent did not surface specific URLs in the summary returned. The repos and systems named:

- NousResearch Hermes Agent: github.com/nousresearch/hermes-agent
- KAIROS: see prior research at `../2026-04-15-kairos-source-analysis.md`
- ClaudeClaw: see prior research at `../2026-04-14-claudeclaw-analysis.md`
- Letta: github.com/letta-ai/letta (MemGPT successor)
- agentskills.io: standard for SKILL.md

Recovering the agent's full citations list would require SendMessage resume.
