---
source_url: https://pages.ucsd.edu/~ehutchins/citw.html
secondary_sources:
  - https://en.wikipedia.org/wiki/Distributed_cognition
  - https://arl.human.cornell.edu/linked%20docs/Hutchins_Distributed_Cognition.pdf
fetched_at: 2026-04-16 11:10
fetched_by: research-books agent
project: Claude Code Entities
---

# Edwin Hutchins — Cognition in the Wild (1995) + Distributed Cognition

## Core Claim

Cognition is a property of systems, not individuals. The unit of analysis for intelligent behavior is the person-in-interaction-with-tools-and-practices, not the isolated person.

## The Ship Navigation Case

Hutchins studied navigation on a US Navy ship. No single crew member has full knowledge of the ship's position at any given moment — the knowledge lives in a distributed system: charts, instruments, procedures, spoken protocols, the division of labor across the team. The ship knows where it is; individual crew members each hold one piece.

Key observation: when the system was disrupted (equipment failure, crew incapacity), the navigation failed — not because any individual lost knowledge, but because the distributed cognitive system broke down. The knowledge was in the relationships and interfaces between people and tools, not in any skull.

## Computation as Representational Propagation

Hutchins' most technically precise claim: computation, including cognitive computation, is the **propagation of representational state across media**.

Navigation is computing because information gets encoded in one form (compass bearing), transformed into another (chart position), accumulated with other representations (log entries, depth soundings), and combined to produce outputs (course corrections). Each transformation happens at an interface — human-to-instrument, instrument-to-instrument, human-to-human.

The same framework covers processes inside and outside the head. There is no special boundary at the skull that makes internal transformation more "cognitive" than external transformation.

## Challenges to the Head-Bound Model

Classical cognitive science asks: what knowledge structures does the individual have? Hutchins argues this question systematically misses where intelligence lives.

"The emphasis on finding and describing 'knowledge structures' that are somewhere 'inside' the individual encourages us to overlook the fact that human cognition is always situated in a complex sociocultural world."

The head-bound model isn't wrong — it's systematically incomplete. You can't predict the cognitive performance of a navigation team by aggregating the knowledge of its individual members, because team cognition is produced in the interactions, the tools, and the procedures — none of which reduce to any individual.

## Cultural Cognition and Practice

Hutchins identifies a second level of externalization: cultural knowledge embedded in practices and artifacts. Tools encode prior cognitive work — a chart encodes centuries of navigational knowledge. When a navigator uses a chart, they are using crystallized cognition from people who are not present. The tool is a form of cognitive inheritance.

This is not metaphor. The chart actually propagates a representational state — it holds positional information that enters the navigator's cognitive process directly.

## The System as Unit

Design implication: "groups must have cognitive properties that are not predictable from a knowledge of the properties of the individuals in the group."

To understand or design a cognitive system — human or artificial — you must analyze it at the level of the system, not the components. Components are embedded in representational media and protocols that shape what cognitive work they can do. The component alone cannot do the work.

## Implication for Retrieval-Over-Weights

Hutchins' framework reframes what "knowing" means for an AI agent. An entity that generates from weights is not accessing its full cognitive system — it is accessing only the individual component (the model) while bypassing the distributed system (files, rules, world-models, chronicles). This is analogous to asking a single sailor to navigate the ship alone, from memory, without instruments or charts.

The proper cognitive system for a Claude Code entity is: model + world-model files + rules + chronicles + tools. Retrieval-over-weights means engaging the full distributed cognitive system rather than over-relying on the individual component.

**Strong implication for drift:** Hutchins' framework predicts that an agent running only on weights will show exactly the drift failure modes documented in the empirical literature (stream-B). Weights are the individual; the system is the individual plus the external representational media. Bypassing external media degrades the system to the individual's limitations.

## Key tension for the project

Hutchins' work also implies that the *quality of the external representations matters enormously*. Poorly structured charts lead to navigation errors even when the crew is skilled. Poorly structured world-model files, rules, or chronicles will degrade the distributed cognitive system even if the model component is excellent. The Mirror pattern (external self-model auditing) is directly motivated: the system needs a way to maintain the quality of its own representational media.
