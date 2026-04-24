---
source_url: https://arxiv.org/html/2503.10566v4
fetched_at: 2026-04-16 17:00
fetched_by: think-deep-expansion
project: Claude Code Entities
title: ASIDE — Architectural Separation of Instructions and Data (limitations deep dive)
---

# ASIDE Limitations — What the Paper Explicitly Does Not Address

## Scope Constraints (Section 7, Summary and Discussion)

Quoted: *"We purposefully limited our discussion to the single-turn setting, where the role of instruction vs. data is well-defined."*

- Multi-turn conversations fall outside the evaluation framework.
- Assumes token roles are **fixed by system design** (e.g., external files are always labeled as data).
- Does **not handle** scenarios where functional roles must be dynamically inferred at runtime, such as general-purpose chatbots.

## Interpretation-Drift: Explicitly Out of Scope

ASIDE focuses exclusively on preventing tokens marked as data from being **executed as instructions**. The mechanism ensures separation at the embedding level. It does **not** constrain **how instructions are applied** once correctly identified as instructions.

This is the critical finding for the CCE paradigm-drift question: the Challenger's steelmanned counter-argument was that paradigm-drift is an interpretation failure at a layer ASIDE doesn't touch. The ASIDE authors confirm this explicitly. ASIDE solves the "did the model recognize this as instruction vs. data" problem. It does not solve the "is the model's interpretation of the instruction the same interpretation the designer intended" problem.

## What ASIDE Actually Tests

- **SEP Score:** instruction execution rate when instruction is embedded in a data section.
- **SEP Utility:** execution frequency of legitimate instructions.
- **AlpacaEval 1.0:** general task utility via GPT-4 preference.
- **Safety benchmarks:** StruQ, BIPIA-text/code (indirect injection); TensorTrust, Gandalf, Purple, RuLES (direct injection).
- **Analysis:** linear probing accuracy, concept activation vectors, embedding interventions.

All of these measure **whether the data/instruction boundary is respected**. None measure whether instructions are applied with the intended interpretation.

## Implication for Claude Code Entities

The "geometric separation at the representation layer" answer from the structure.md analysis is correctly scoped to **injection-class attacks** and the **instruction/data confusion** failure mode. It is **not** an answer to paradigm-drift. The structure.md analysis should be corrected to reflect this: ASIDE prevents prompt-injection from corrupting the entity's value retrieval; it does not prevent the entity from gradually reinterpreting its retrieved values.
