---
source_url: https://github.com/Piebald-AI/claude-code-system-prompts/blob/main/system-prompts/agent-prompt-dream-memory-consolidation.md
fetched_at: 2026-04-16 14:15
fetched_by: think-deep-github
project: Claude Code Entities
---

# Piebald-AI/claude-code-system-prompts (dream consolidation prompt)

**Contains:** Extracted Claude Code system prompts including the KAIROS dream memory consolidation agent prompt.

## KAIROS Two-Phase Architecture (extracted)

- **Operating entity**: writes only to append-only daily logs at `logs/YYYY/MM/YYYY-MM-DD.md`. System prompt enforces: "Do not rewrite or reorganize the log — it is append-only."
- **Restriction mechanism**: prompt gating. The operating agent receives append-only permission. The `/dream` restricted subagent alone receives permission to modify MEMORY.md.
- **Dream agent four phases**: Orient (read index) → Gather Signal (prioritize daily logs > contradicted memories > transcript searches) → Consolidate (merge into existing files, delete contradicted facts, convert relative to absolute dates) → Prune and Index (update under line/character limits)
- **Feature flag**: `feature('KAIROS')` gates the daily-log prompt variant
- **Memory loading vs write routing**: MEMORY.md still loaded into context (via claudemd.ts) as distilled index; new writes go to daily log

## What's Missing

No explicit provenance tagging in the consolidation prompt. The dream agent "deletes contradicted facts" but doesn't mark surviving facts with source metadata. The separation is architectural (who can write where) not semantic (what kind of claim is this).

## Verdict

**Adopt (architecture).** The two-phase pattern is the best working implementation found of operating entity → restricted consolidator separation. The append-only log + nightly dream is directly portable to Claude Code Entities. The prompt-gating approach (not code-level enforcement) is the actual mechanism — important to know.
