---
debate: "value of /dream skill"
mode: adversarial
rounds: 3
date: 2026-04-17
verdict: "CON wins the default case; PRO wins a narrow high-stakes use case. Keep the skill, restrict its triggers, and add a drift-comparison mechanism — otherwise it over-engineers a function the profile already serves."
---

# Synthesis — Value of the /dream Skill

## 1. Proposition restated

The debate tested whether the /dream skill — as built today and demonstrated by the four Spatial Workspace dreams (dennis-disagrees-with-dark, organic-layout-vs-first-share, settings-panel-metastasizes, talk-to-claude-feature-creep) — produces genuine value whose output is operationally distinct from alternatives (/play, mental rehearsal, conversation with Wisdom) and whose token/maintenance cost is justified.

## 2. Key points of genuine disagreement

Four real cruxes emerged. The sides diverged on facts and values, not just rhetoric.

**Crux 1 — Paraphrase vs. derivation.** PRO argued the dream's Value Interpretation sections produce operational formulations the profile doesn't contain ("dials are diagnostic," "withholding is a small deception by omission," "phase discipline is not rigidity"). CON argued these are three-word compressions of sentences already in wisdom-happy.md lines 154-157, which PRO reads as *preferences* and CON reads as *already-refined operational entries written by Claude in prior sessions by the same mechanism dreams claim*. This is the debate's deepest factual disagreement: what is the profile actually storing?

**Crux 2 — /play symmetry.** Both sides agreed the skills load similar context and generate structured reasoning. They disagreed on whether /play's paradox-holder can reliably reach decisive resolutions. PRO leaned on SKILL.md's structural requirement that dreams "run each to resolution." CON argued /play's paradox-holder "frequently is the resolution criterion" when asked pointedly. This crux matters because it determines whether /dream justifies its existence as a distinct skill.

**Crux 3 — Fresh-context prohibition and compounding value.** The skill prohibits the dream agent from reading past dreams. CON called this a design flaw that blocks the compounding-fingerprint mechanism. PRO countered that comparison happens in the *reader* (Wisdom or a future session), not in the dream agent, and the prohibition exists to prevent recursive self-feeding. Both positions are internally coherent; the real question is whether cross-dream comparison actually happens in practice.

**Crux 4 — Rehearsal transfer.** PRO framed dreams as mental rehearsal that pre-loads responses for foreseeable situations. CON argued rehearsal presumes a fixed script — real situations arrive with different details that can *activate* the rehearsed pattern in the wrong context, substituting rehearsed responses for fresh reasoning. This was the debate's most serious structural attack and went largely unanswered by PRO in R3.

## 3. Strongest argument from each side

**PRO's strongest:** Dream 4's role-boundary formulation. The counterfactual-organic-layout scenario produces the sentence *"my job is to make sure he has the full picture when he makes it"* — which CON conceded is not traceable to any profile line and functions as a genuine behavioral constraint, not a value summary. The reasoning chain reaches it only by constructing a specific information-asymmetry scenario (assistant knows about a planned reset; Wisdom knows Dennis) that ordinary reflection would not spontaneously build. This is the clearest evidence the skill does something the profile and a 5-minute conversation would not reliably produce — a novel role-boundary specification arrived at through constructed pressure.

**CON's strongest:** The infrastructure-vs-yield argument in R3. The skill spawns a fresh-context orchestrator, loads context across multiple files, mandates 3-5 scenarios per pass, and writes/indexes files. CON's estimate: ~40-60K tokens per invocation, yielding roughly one genuinely novel formulation. Meanwhile, Dream 1 ("dials are diagnostic") is a three-word compression of a sentence already at wisdom-happy.md line 156. Dream 3 ("talk-to-claude") resolves to "capture to build queue and propose a zero-dependency bridge" — which is *exactly what the build-queue rule already mandates*. Two of four dreams produce rule-shaped outputs, not value-interpretation outputs. The difficulty test failed to filter them out, meaning the skill's own design constraint isn't reliably enforced. This isn't an attack on the mechanism — it's evidence the mechanism isn't consistently firing.

## 4. Where the weight of evidence falls

CON's R3 closer — *"PRO won the right use case. CON wins the default use case"* — is substantively accurate and I endorse it, with one sharpening.

PRO did not successfully rebut the circularity attack. The profile entries dated "self-stated 2026-04-16" were themselves written by Claude during live sessions by the same mechanism dreams claim exclusively. PRO's temporal-direction reframe in R3 ("profile captures surfaced values; dreams surface not-yet-tested values") is elegant but glosses the fact that three of the four dreams landed on values that *had* been tested, on the same day, in the chronicle the dream agent loaded. Under these conditions — maximally fresh profile, maximally salient tensions — the skill's output is hard to distinguish from competent paraphrase.

PRO also conceded substantially more than CON. By R3, PRO had narrowed to: one novel formulation per invocation (Dream 4), cost is low enough that the paraphrase dreams are acceptable overhead, and the compounding-value claim is "architecturally plausible" rather than demonstrated. That's a defensible but narrow position.

CON's rehearsal-transfer attack (R3) went unanswered. PRO's R3 pivoted to "the file exists and can be read later" without engaging CON's point that rehearsed patterns can activate under subtly different real-world triggers and substitute for fresh reasoning. This matters because it undermines PRO's "prevents live mistakes" cost denominator.

**But CON also did not win everything.** Dream 4 is real. The role-boundary insight — *"my job is to make sure he has the full picture when he makes it"* — is a genuine artifact the profile does not contain. CON conceded this explicitly in R2 and maintained the concession in R3. For genuinely novel relational territory where the scenario architecture constructs pressure a conversation wouldn't, the skill does something distinctive.

The honest accounting: the four-dream test demonstrates the mechanism *can* work (Dream 4) but does not demonstrate it *reliably* works (two of four produced rule-shaped outputs the difficulty test should have filtered). At the skill's current yield rate and token cost, the default-use case is not justified. The high-stakes-relational-territory case is.

## 5. Recommendation

Keep the skill, but modify and restrict it.

**Modify (three concrete changes):**

1. **Tighten the difficulty test enforcement.** Dreams 1 and 3 of the Spatial Workspace batch produced rule-shaped outputs (reiterating build-queue and "dials as diagnostic") that the difficulty test in SKILL.md was supposed to filter. The test is currently a suggestion to the orchestrator, not an enforced gate. Add an explicit pre-generation check: for each proposed scenario, the orchestrator must name which two values pull in opposite directions *and* confirm the profile does not already resolve them. Scenarios that fail this check get discarded or sharpened before reasoning begins.

2. **Add a drift-comparison skill or flag.** CON's fresh-context attack has real force only because no mechanism actually compares dreams over time. Either (a) create a companion skill (`/dream-drift <value>`) that reads past dream files on a named value and surfaces interpretation shifts, or (b) add a `--compare` flag to /dream that loads the most recent same-target dream as a reference (not as input to reasoning, but as a post-hoc divergence check). Without this, the compounding-value argument remains a promissory note.

3. **Reduce default scenario count from 3-5 to 1-3.** The four-dream test produced one clearly novel formulation. Running fewer scenarios per invocation, each more carefully difficulty-tested, would improve the signal-to-noise ratio and roughly halve the per-invocation cost.

**Restrict (when to invoke):**

Warranted:
- Before a significant first contact with a new collaborator whose relational territory is genuinely novel (Dream 4's use case)
- Before an irreversible decision that will be observed by a high-taste external party
- After a value has been tested in a real scenario — to crystallize what was learned

Not warranted:
- Routine project work where the profile is fresh and tensions are explicit (most of the Spatial Workspace case)
- Scenarios already covered by a specific rule (build-queue handles Dream 3's territory)
- Default "every few days" cadence — the yield rate doesn't support it

**Do not retire the skill.** Dream 4 demonstrates a capability neither /play nor conversation reliably reproduces: a role-boundary specification arrived at through constructed information-asymmetry pressure. Retiring the skill loses that capability. But running it on every project at project-scale, as was implied by today's batch, is over-engineering.

The one-line verdict in the frontmatter captures the operational takeaway: keep it, restrict it, fix the drift-comparison gap.
