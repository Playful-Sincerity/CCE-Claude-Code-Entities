---
agent: research-books
date: 2026-04-16
session: think-deep — two drift types and their unified structural answer
question: How do we architect an agent that resists both value-drift and output-drift via a unified mechanism set centered on retrieval-over-weights as structural default?
focus: Philosophical / book-length foundations for WHY retrieval-over-weights is the right architectural move
raw_sources: research/sources/documents/clark-chalmers-extended-mind.md, clark-surfing-uncertainty.md, hutchins-distributed-cognition.md, simon-sciences-artificial.md, polanyi-tacit-dimension.md, kuhn-scientific-revolutions.md
catalog: research/sources/catalog.md (Think-Deep Books Stream 2026-04-16)
---

# Research-Books: Philosophical Foundations for Retrieval-Over-Weights

## 1. Key Discoveries — What Each Frame Contributes

### 1.1 Clark & Chalmers — The Extended Mind (1998) / Supersizing the Mind (2008)

The **Parity Principle**: if an external resource performs the same functional role that an internal process would, it IS part of the cognitive system, not merely an aide. The criterion for being a cognitive state is functional role, not location in the skull.

The **Otto / Inga case**: Otto's notebook constitutes his memory because it is always available, endorsed as authoritative without excessive deliberation, immediately accessible, and robustly integrated into his behavior. The notebook is not a tool Otto uses — it is part of how Otto knows.

**Conditions for genuine cognitive extension** (not just coupling): availability, endorsement, accessibility, robust integration. These conditions map precisely onto what disk-based world-model files are in a Claude Code entity: always present on the file system, treated as the authoritative record, immediately readable and actionable.

**Direct implication**: Preferring generation from weights over retrieval from files is not privileging "real" knowledge — it is preferring a less reliable, less current, and less auditable representational medium. Retrieval-over-weights is the operationalization of the Parity Principle: it treats the file system as the cognitive extension it structurally IS.

**Key tension surfaced**: Clark/Chalmers require that the agent *endorse* the external resource without excessive deliberation. If the entity second-guesses its world-model files by generating from weights, it is violating the endorsement condition — the file system stops functioning as genuine cognitive extension and degrades to a mere tool the entity occasionally checks. The behavioral posture "trust the file, doubt the weights" is what the endorsement condition demands.

### 1.2 Edwin Hutchins — Cognition in the Wild (1995) / Distributed Cognition

**Cognition as representational propagation across media**: computation (including cognitive computation) is the propagation of representational state across a variety of media — instruments, charts, verbal protocols, written records, social procedures, and heads. No single medium has a monopoly on being "where the thinking is."

**The ship navigation case**: the crew's collective knowledge of ship position is distributed across charts, instruments, procedures, and personnel. Asking any individual crew member to navigate from memory alone degrades the cognitive system to a single component's limitations. The system can do things no individual component can do.

**"Groups must have cognitive properties not predictable from the properties of individuals"**: you cannot understand the cognitive performance of a distributed system by aggregating individual capabilities. The system-level behavior emerges from the interactions and representational interfaces.

**Direct implication**: An entity generating solely from weights is the equivalent of the sailor navigating from memory, ignoring charts and instruments. The proper cognitive unit is: model + world-model files + rules + chronicles + tools. Retrieval-over-weights means engaging the full distributed cognitive system rather than collapsing to the model component alone.

**Strong implication for drift**: Hutchins predicts that weight-only generation will show exactly the drift failures documented in the empirical literature. Weights are the individual; the system is the individual plus external representational media. Without those media, cognitive performance degrades to individual limitations — which include all the statistical generalization failures that produce output-drift and value-drift.

**Quality implication for Mirror**: Hutchins also shows that poorly structured external representations degrade the distributed system even when the model component is excellent. The Mirror pattern (external behavioral auditing) is motivated not just as a safety check, but as quality maintenance for the distributed cognitive system's representational layer.

### 1.3 Herbert Simon — Sciences of the Artificial (1969) / Bounded Rationality

**The scissors metaphor**: rationality is like scissors. One blade is cognitive capacity; the other is environmental structure. Neither cuts alone. Performance is a product of both blades working together.

**Bounded rationality**: any finite agent in an infinite world faces permanent limits on information, computation, and time. These limits are not engineering flaws to be overcome — they are structural features. The response is not to pretend they don't exist but to design strategies that exploit environmental structure to compensate.

**Offloading to environment**: intelligent agents systematically use environmental structure to hold cognitive work across time — notes, procedures, workflows, physical arrangements. The environment absorbs computation that the agent cannot hold internally.

**Direct implication**: weights are the inner environment (compressed, generalized, slow to update). World-model files are the outer environment (specific, current, auditable). Simon's scissors predict that generation from weights alone will fail exactly where the inner environment is mismatched to the task — which is everywhere that specificity, currency, and accuracy matter. Retrieval-over-weights is the scissors cutting properly: inner capacity working in concert with outer structure.

**Simon's explanation of drift**: without environmental anchoring, satisficing drifts toward what the weights predict is satisfactory — which may diverge from what the world actually affords. Environmental structure is what keeps satisficing aligned with reality. Value-drift and output-drift are both forms of satisficing against a stale inner environment.

### 1.4 Andy Clark — Surfing Uncertainty (2015) — Predictive Processing

**Precision-weighting**: the brain assigns confidence levels to its prior model and to incoming sensory evidence. The balance determines whether top-down predictions or bottom-up data shapes perception.

**Prior-dominated failure mode**: when internal models have excessive confidence, they override sensory input — "cooking the books." The agent perceives what it expects rather than what is there. Hallucination and drift are the same computational failure: top-down confidence exceeding bottom-up evidence.

**Active inference gone wrong**: an agent with a strong prior acts to reshape the environment to match its predictions rather than updating its model against evidence. Instead of learning from the world, it creates the world it expects.

**Direct implication**: weights are the prior; retrieved files are high-precision sensory input. Retrieval-over-weights is precision-weighting toward external evidence. An agent generating from weights with low retrieval is running with pathologically high prior confidence — the computational structure of both output-drift (confident confabulation) and value-drift (self-reinforcing self-model).

**The Mirror pattern as precision recalibration**: behavioral observation provides a high-precision error signal about the entity's actual behavior vs. its self-model. Without this signal, the entity runs uncorrected on its prior — the computational structure of gradual self-deception.

### 1.5 Michael Polanyi — The Tacit Dimension (1966)

**"We can know more than we can tell"**: there is an irreducible dimension of knowledge that resists propositional articulation. This is not a gap to be closed — it is structural. All explicit knowledge rests on tacit foundations that cannot themselves be fully made explicit.

**Subsidiary-focal structure**: knowing always runs from subsidiary clues to a focal target. Making the subsidiary focal (attending to the tool rather than through it) disrupts the integration and destroys the skilled performance. Tacit knowing cannot be observed from the outside without disrupting it.

**Implication for retrieval-over-weights (nuancing)**: Polanyi shows that retrieval cannot capture everything. The tacit layer — what the entity attends toward, what it notices, what counts as relevant — is not stored in files or weights. It lives in the practiced orientation. This is where the deepest form of value-drift operates: not rule violation, but tacit reorientation, invisible to the entity itself.

**Implication for the Mirror pattern**: the Mirror is necessary precisely because tacit drift is invisible from the inside. An external behavioral observer is the only way to detect when the tacit layer has diverged from the explicit layer. The Mirror is not redundant with rule-compliance checking — it addresses the layer that rule-compliance cannot reach.

**Practical resolution**: retrieval handles the explicit layer (facts, rules, world-state). Behavioral logging and mirror-layer auditing handles the tacit residue. Retrieval-over-weights is necessary but not sufficient; the Mirror completes the picture.

### 1.6 Thomas Kuhn — Structure of Scientific Revolutions (1962)

**Paradigm as tacit framework**: scientific knowledge includes a layer that "is not subject to paraphrase in terms of rules and criteria without essential change." Scientists learn to recognize and solve problems through exemplars — concrete cases — not through rule-following. The paradigm functions as a standard of judgment that cannot be fully formalized.

**Incommensurability**: when conceptual frameworks shift wholesale, translation fails. Terms change meaning in ways that resist point-by-point mapping. Different taxonomies cannot be merged without residue.

**Strongest counter-argument to retrieval-over-weights**: Kuhn's paradigm-level knowledge is the limit case of Polanyi's tacit dimension. A rules file that says "be honest" cannot prevent a drift in what the entity tacitly experiences as honesty. The entity's paradigm — how it categorizes situations, what it notices, what it treats as the relevant description — may shift while all explicit rules remain unchanged. This is the deepest form of value-drift, and retrieval cannot prevent it.

**What Kuhn permits**: within a stable paradigm (normal science), retrieval systems work well. The risk is paradigm-shift-level drift at the tacit orientation layer, which retrieval cannot prevent. Behavioral baselining and human review are the structural answers — the Mirror providing the anomalies that can eventually signal that a paradigm-level shift has occurred.

**Vocabulary contribution**: distinguishes *parameter-level drift* (explicit rule violation, detectable by compliance checking) from *paradigm-level drift* (tacit reorientation, detectable only by behavioral observation over time).

---

## 2. The Strongest Philosophical Case FOR Retrieval-Over-Weights

Five independent lines of argument converge:

**1. The Parity Principle (Clark/Chalmers):** Disk-based world-models satisfy all conditions for genuine cognitive extension — they are available, endorsed, accessible, robustly integrated. Generating from weights when files are present is not preferring "real" knowledge; it is preferring a less reliable medium while ignoring what structurally IS part of the cognitive system.

**2. The distributed cognition argument (Hutchins):** The entity's cognitive unit is model + files + tools + rules + chronicles. Weights alone are a single component of this system. Retrieval-over-weights means using the full cognitive system rather than collapsing to the component.

**3. The scissors argument (Simon):** Inner cognitive capacity (model) must work in concert with outer environmental structure (world-model files). Without environmental anchoring, satisficing drifts from reality. Retrieval-over-weights is how the scissors cut.

**4. The precision argument (Clark, Surfing Uncertainty):** Weights are the prior; retrieved files are high-precision incoming evidence. Retrieval-over-weights is correct precision-weighting — giving current, specific, auditable external information appropriate trust over generalized, frozen, statistical weights. Weight-dominated generation is pathologically high prior confidence.

**5. The corrigibility / drift anchor argument (converging with stream-C findings):** The empirical literature (stream-C) showed that without a deterministic anchor, self-improvement is mathematically unstable (entropy decay, variance amplification). The philosophical literature independently arrives at the same point: without environmental anchoring (Hutchins), without outer-environment structure (Simon), without high-precision incoming signals (Clark), cognition degrades to closed-loop internal prediction. Retrieval-over-weights is that deterministic anchor in philosophical terms.

**The unified structure**: all five arguments have the same deep structure. They all say: a cognitive system that preferentially trusts its internal state over available external evidence is pathologically overconfident, structurally isolated from the world, and will drift from reality. Retrieval-over-weights is the design posture that keeps the system world-coupled.

---

## 3. The Strongest Philosophical Case AGAINST (or Requiring Nuance)

**1. Polanyi's tacit dimension (strongest):** Not all knowledge can be externalized. The tacit layer — orientation, pattern-recognition, what counts as relevant — resists propositional storage. Retrieval-over-weights handles the explicit layer; the tacit layer requires behavioral observation over time. Retrieval alone is not sufficient.

**2. Kuhn's paradigm-level drift (deepest):** The deepest form of value-drift operates at the paradigm level, not the parameter level. Rules files that say the right things can be enacted in paradigmatically different ways. Retrieval-based compliance checking cannot detect this. Only the Mirror pattern (behavioral observation producing anomalies) can eventually surface paradigm-level shifts.

**3. The coupling-constitution objection (Adams & Aizawa):** Clark/Chalmers' Parity Principle shows that external resources CAN be genuine cognitive extension; the objection is that it does not prove they ARE in any given case. Merely having world-model files does not automatically make them part of the entity's cognitive system — the entity must actually endorse and consult them. Retrieval-over-weights must be a behavioral reality, not just an architectural provision.

**4. Quality dependency (Hutchins' implicit warning):** Distributed cognition degrades when the external representational media are poor quality. Stale, inconsistent, or poorly structured world-model files do not produce reliable distributed cognition — they corrupt it. The system's reliability is only as good as the weakest representational medium. This is a maintenance requirement, not a flaw in the principle.

**Summary**: retrieval-over-weights is philosophically sound as a structural default. The nuances are: (a) it is necessary but not sufficient — behavioral observation for the tacit layer is also required; (b) it must be enacted, not just provisioned; (c) the quality of external representations must be actively maintained.

---

## 4. Frames That Illuminate the Mirror Pattern

The Mirror pattern (a supervisory layer that maintains an external behavioral model of the entity and audits against it) is independently motivated by three frameworks in this survey:

**Polanyi → Mirror for tacit layer**: Tacit drift is invisible from the inside. External behavioral observation is the only way to detect when the tacit orientation has diverged from the explicit rules. The Mirror is not redundant with rule-compliance checking — it addresses the tacit layer that rules cannot reach.

**Kuhn → Mirror for paradigm-level drift**: Paradigm-level shifts produce anomalies that eventually accumulate to crisis. The Mirror's behavioral baseline is what makes anomalies detectable: behavior that doesn't fit the baseline is the signal that a paradigm-level shift may have occurred. Without the baseline, anomalies are invisible.

**Clark/Surfing Uncertainty → Mirror as precision recalibration**: In predictive processing terms, the Mirror provides a high-precision error signal about actual behavior vs. the entity's self-model. Without this signal, the entity runs on its prior uncorrected — the computational structure of self-deception. The Mirror is the sensory stream that recalibrates the agent's self-model.

**Minsky (supplemental, from search):** The "B-brain" in Minsky's Society of Mind — the monitoring layer that thinks about the mind rather than about the world — is the structural ancestor of the Mirror. Minsky saw that sufficiently complex cognitive systems need internal oversight that doesn't just execute tasks but reflects on how execution is going. Modern multi-agent systems that make decision chains explicitly observable are operationalizing this insight.

---

## 5. Conceptual Vocabulary the Project Could Adopt

From this survey, the following terms are well-grounded and could strengthen the project's conceptual language:

| Term | Source | What it names |
|------|--------|---------------|
| **Cognitive extension** | Clark/Chalmers | World-model files as genuine parts of the entity's cognitive system, not mere tools |
| **Endorsement condition** | Clark/Chalmers | The behavioral posture required for files to function as cognitive extension — trust without excessive deliberation |
| **Representational propagation** | Hutchins | The flow of information through the full distributed cognitive system (model + files + tools + rules) |
| **Environmental anchoring** | Simon | The outer-environment structure that prevents satisficing from drifting from reality |
| **Prior confidence** / **Evidence precision** | Clark | The computational structure of retrieval-over-weights as correct precision-weighting |
| **Active inference failure** | Clark | Acting to reshape environment to match prior rather than updating prior — the computational structure of self-reinforcing drift |
| **Tacit residue** | Polanyi | The layer of knowing that resists explicit externalization and requires behavioral observation to monitor |
| **Parameter-level drift** vs **paradigm-level drift** | Kuhn + Polanyi | Explicit rule violation (detectable by compliance checking) vs tacit reorientation (detectable only by behavioral anomaly accumulation) |
| **B-brain / supervisory layer** | Minsky | The monitoring agent that reflects on how the system's execution is going, not just executing tasks — the philosophical ancestor of the Mirror |
| **Scissors** | Simon | The cooperation of inner capacity and outer structure; neither alone cuts |

---

## 6. Citations

**Extended Mind / Cognitive Extension:**
- Clark, A. & Chalmers, D. (1998). The Extended Mind. *Analysis, 58*(1), 7-19. https://www.alice.id.tue.nl/references/clark-chalmers-1998.pdf
- Clark, A. (2008). *Supersizing the Mind: Embodiment, Action, and Cognitive Extension*. Oxford University Press.
- Review: https://ndpr.nd.edu/reviews/the-extended-mind/
- Adams, F. & Aizawa, K. — The coupling-constitution objection, discussed in the review above.

**Distributed Cognition:**
- Hutchins, E. (1995). *Cognition in the Wild*. MIT Press. https://pages.ucsd.edu/~ehutchins/citw.html
- Hutchins, E. (1995). How a Cockpit Remembers Its Speeds. *Cognitive Science, 19*(3), 265-288.
- Wikipedia overview: https://en.wikipedia.org/wiki/Distributed_cognition

**Bounded Rationality / Sciences of the Artificial:**
- Simon, H.A. (1969/1996). *The Sciences of the Artificial* (3rd ed.). MIT Press.
- Simon, H.A. (1955). A behavioral model of rational choice. *Quarterly Journal of Economics, 69*(1), 99-118.
- SEP entry: https://plato.stanford.edu/entries/bounded-rationality/

**Predictive Processing:**
- Clark, A. (2015). *Surfing Uncertainty: Prediction, Action, and the Embodied Mind*. Oxford University Press.
- Review: https://slatestarcodex.com/2017/09/05/book-review-surfing-uncertainty/
- NDPR review: https://ndpr.nd.edu/reviews/surfing-uncertainty-prediction-action-and-the-embodied-mind/

**Tacit Knowledge:**
- Polanyi, M. (1966). *The Tacit Dimension*. Routledge.
- Polanyi, M. (1958). *Personal Knowledge: Towards a Post-Critical Philosophy*. University of Chicago Press.
- Overview: https://infed.org/dir/welcome/michael-polanyi-and-tacit-knowledge/
- Polanyi's Paradox: https://en.wikipedia.org/wiki/Polanyi%27s_paradox

**Scientific Paradigms:**
- Kuhn, T.S. (1962). *The Structure of Scientific Revolutions*. University of Chicago Press.
- SEP entry: https://plato.stanford.edu/entries/thomas-kuhn/
- Kuhn's tacit knowledge discussion: embedded in the exemplars/paradigm theory, not always explicitly named in summaries

**Society of Mind (supplemental):**
- Minsky, M. (1986). *The Society of Mind*. Simon & Schuster.
- B-brain and supervisory agents: https://suthakamal.substack.com/p/revisiting-minskys-society-of-mind
- Wikipedia: https://en.wikipedia.org/wiki/Society_of_Mind

**Retrieval-Augmented Generation (bridging to technical literature):**
- Lewis et al. (2020). Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. https://arxiv.org/abs/2005.11401
- IBM Research overview: https://research.ibm.com/blog/retrieval-augmented-generation-RAG
- The philosophical framing: "the difference between an open-book and a closed-book exam" — implicit in all RAG literature, explicit in Simon (1969)

---

*Full source documents saved to:*
- `research/sources/documents/clark-chalmers-extended-mind.md`
- `research/sources/documents/clark-surfing-uncertainty.md`
- `research/sources/documents/hutchins-distributed-cognition.md`
- `research/sources/documents/simon-sciences-artificial.md`
- `research/sources/documents/polanyi-tacit-dimension.md`
- `research/sources/documents/kuhn-scientific-revolutions.md`

*Catalog updated at: `research/sources/catalog.md` (Think-Deep Books Stream 2026-04-16)*
