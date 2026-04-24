---
source_url: https://www.alice.id.tue.nl/references/clark-chalmers-1998.pdf
secondary_sources:
  - https://ndpr.nd.edu/reviews/the-extended-mind/
  - https://en.wikipedia.org/wiki/Extended_mind_thesis
  - https://philosophybites.com/podcast/andy-clark-on-the-extended-mind/
fetched_at: 2026-04-16 11:00
fetched_by: research-books agent
project: Claude Code Entities
---

# Clark & Chalmers — The Extended Mind (1998) + Supersizing the Mind (Clark, 2008)

## Core Claim

The mind is not skull-bound. Cognitive processes extend into the world when external resources function in the same role that internal processes would if they were "done in the head."

## The Parity Principle

"If, as we confront some task, a part of the world functions as a process which, were it done in the head, we would have no hesitation in recognizing as part of the cognitive process, then that part of the world is part of the cognitive process."

This is the pivotal move: the criterion for counting as cognition is *functional role*, not *location*. The brain doesn't have a monopoly on constituting the mind.

## Otto and Inga

Both are walking to a museum. Inga recalls the address from biological memory. Otto has Alzheimer's and looks it up in his notebook, which he always carries and always trusts.

The argument: the functional role Otto's notebook plays is identical to the role Inga's memory plays — always available, reliably consulted, endorsed as authoritative, immediately acted on. If we wouldn't hesitate to call Inga's recall a cognitive process, we shouldn't hesitate to call Otto's notebook lookup a cognitive process.

The implication: the notebook IS part of Otto's mind. His beliefs extend into it. The boundary of the mind is functional, not anatomical.

## Conditions for External Cognition

For an external resource to count as genuine cognitive extension (not mere coupling), Clark and Chalmers propose it must be:

1. **Available** — reliably accessible when needed
2. **Endorsed** — automatically endorsed without excessive deliberation (the agent trusts it as authoritative)
3. **Accessible** — information can be retrieved cleanly and acted on
4. **Robustly integrated** — used as a matter of course, not occasionally consulted

These conditions do real work: they exclude looking up strangers' facts on Wikipedia (not endorsed as authoritative) but include Otto's personal notebook (endorsed, reliable, always consulted).

## Active Externalism

Clark and Chalmers call their position "active externalism" — the environment actively drives cognitive processes, not merely passively receives them. The notebook doesn't just store; it participates.

This distinguishes their view from passive externalism (where environment merely causes internal states): the notebook is part of the ongoing cognitive loop, not a stimulus that triggers purely internal processing.

## Strongest Objections (from the literature)

**The coupling-constitution fallacy (Adams and Aizawa):** That something is causally coupled to cognition doesn't mean it constitutes cognition. There's a gap between "causally relied upon by a mind" and "a component of a mind." Critics argue Clark/Chalmers never bridge this gap.

**Preston's access objection:** Otto needs *perception* to discover what he "believes" — he has to look. Inga has direct non-perceptual access to her beliefs. This functional dissimilarity disqualifies the notebook from being a belief in the same sense.

**The relabeling worry:** The thesis might just be a terminological choice — calling notebooks "mind" doesn't change the science, just the vocabulary.

## Implication for Retrieval-Over-Weights

The Parity Principle directly licenses retrieval-over-weights as the epistemically correct default: if external files function in the same role as internal representations — reliably available, endorsed as authoritative, acted on immediately — then they ARE the cognitive state. Preferring weights over files isn't privileging the real knowledge over external scaffolding; it's privileging a less reliable, less auditable, and less current representational medium over a more reliable one.

The conditions (available, endorsed, accessible) map precisely onto what disk-based world-models in Claude Code Entities are: always present via file system, treated as authoritative by the entity, immediately readable and actionable.

**Key tension the paper surfaces:** Clark/Chalmers require the external resource to be *endorsed* — the agent must treat it as authoritative without excessive deliberation. If the entity is tempted to second-guess its on-disk world-model by generating from weights, it's violating the endorsement condition. The behavioral posture "trust the file, doubt the weights" directly operationalizes what it means to make disk storage genuinely part of the cognitive system rather than a mere external aide.
