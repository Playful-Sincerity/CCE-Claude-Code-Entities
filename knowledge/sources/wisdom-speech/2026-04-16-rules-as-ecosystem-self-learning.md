---
source: Wisdom's original speech
captured_at: 2026-04-16
session: Claude Code Entities — comparative architecture kickoff
context: Framing the self-learning research direction and articulating a theory of deterministic ecosystems as drift mitigation
---

# Wisdom's Speech — Rules as Ecosystem, Self-Learning Focus (2026-04-16)

> Oh I haven't looked into any of the specific Hermes I really don't know too much about them all I feel like the self learning component is the thing I really am interested in self improvement how can you structure things where is that drift coming from we should do a kind of a pretty comprehensive understanding piece there yeah we should definitely look at all the research we've done already that's great okay yeah we want to be saving agent transcripts and stuff yeah I think this is an example of something really interesting

> Which is you just talked about the raw data preservation scaffold. That is something that we built as a global rule, right? Global rules are really important ways to help make sure. We've got some enforcement mechanisms in our own system. We've got these different things like that's one way that's good that can actually make sure that people that these agents these entities are steering behavior rather they have independent rules um deterministic systems right you want to be you want to be creating powerful deterministic systems that act as good essentially ecosystems rather than to operate by then right

> yeah interesting i'm curious what you think here let's uh yeah you can go ahead and create the scaffold that's good and um yeah i'm excited to see what you get up to here i don't think you're gonna need fire crawl at all so we shouldn't need that we should just do normal web fetch stuff and we want to do you know everything we have available to us get repos and if you feel like you need to look at some youtube videos or something you could but ideally this can kind of run on its own here so

## Key Decision Monologues

### Research focus: self-learning, not comparative breadth

Wisdom explicitly deprioritized Hermes/OpenClaw deep-dives in favor of the self-learning problem. "I feel like the self learning component is the thing I really am interested in — self improvement, how can you structure things, where is that drift coming from." Direction: comprehensive understanding piece on self-learning architecture and drift sources.

### Rules as deterministic ecosystems — the core insight

The speech articulates a theory of agent steering: **global rules are deterministic systems that act as ecosystems, and those ecosystems steer behavior rather than relying on the agent/entity to decide well.** The raw-data-preservation rule is given as the example — Claude mentioned it as a scaffold to build, and Wisdom recognized that this mention is itself evidence the rule works.

> "you want to be creating powerful deterministic systems that act as good essentially ecosystems"

The contrast he's drawing: probabilistic agent reasoning vs deterministic structural constraints. The rule file didn't have to "decide" to apply — it loaded deterministically, and that loading shaped Claude's behavior. Rules + hooks + enforced scaffolds = ecosystem.

## Pattern Observations

This is the first articulation I've heard Wisdom give of a principle that's been implicit in the Digital Core design for a while: **drift-resistance comes from the deterministic layers, not the probabilistic ones.** The entity reasons probabilistically, but the environment it reasons within is hard-structured. Self-learning must respect this asymmetry — which layers can an entity modify about itself, and which must stay fixed for drift-resistance to hold?

This directly seeds the Stream 1 research: the self-learning architecture question becomes "where in the deterministic/probabilistic stack does self-modification live, and why?"
