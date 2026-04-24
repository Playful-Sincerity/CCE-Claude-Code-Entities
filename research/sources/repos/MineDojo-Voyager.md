---
source_url: https://github.com/MineDojo/Voyager
fetched_at: 2026-04-16 14:00
fetched_by: think-deep-github
project: Claude Code Entities
---

# MineDojo/Voyager

**Stars:** ~20K+ | **Language:** Python + JS | **License:** MIT

## What It Implements (Relevant to Drift/Retrieval)

- **Skill library as living world-model**: ever-growing Chroma vector DB of executable skills, embedded by description
- **Retrieval gate**: before generating new skill, retrieves top-k similar existing skills from vector DB
- **Task-based filter** (weak gate): skill retrieval for deposit tasks explicitly blocked — `if info['task'].startswith('Deposit useless items...'): return`
- **Propose-then-verify via execution**: new skills are proposed, executed in environment, refined iteratively based on execution errors. Verification is empirical (does it run?) not semantic (is it true?)
- **Consistency check post-add**: `assert self.vectordb._collection.count() == len(self.skills)` — ensures sync but not correctness

## Gap

No provenance tagging on stored skills. No retrieval gate that prevents weights-only answers — the gate is about efficiency (don't re-derive known skills), not epistemic safety (don't hallucinate). Propose-then-review is partial: propose → execute → fix (not propose → review for truth → store).

## Verdict

**Adapt (concept).** Voyager's skill library is the strongest working example of a world-model file that grounds outputs — but it verifies via execution (can this code run?), not via retrieval-grounding (is this claim sourced?). The pattern of "retrieve similar skills before generating" is directly adaptable to "retrieve relevant knowledge before generating claims."
