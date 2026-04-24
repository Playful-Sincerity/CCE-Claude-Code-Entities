# Round: Self-Learning & Drift — Agent Outputs

**Started:** 2026-04-16
**Focus:** Self-learning architecture and drift mechanics. Deprioritized: comparative breadth.
**Status:** Complete — three agents finished.

## Research Question

How do autonomous agent systems implement self-learning, and where does value/capability/identity drift originate? What structural answers (not model-behavior answers) make self-improvement compatible with stable identity?

Seed insight from Wisdom (see `../../knowledge/sources/wisdom-speech/2026-04-16-rules-as-ecosystem-self-learning.md`): **deterministic ecosystems (rules, hooks, enforced scaffolds) do the steering; the probabilistic agent reasons within them.** Self-learning must respect this asymmetry.

Working hypothesis pressure-tested across all three streams — the **safety ordering**:
- Memory / chronicle — self-modify freely (experience)
- Skills — self-modify with light review (capability)
- Rules / CLAUDE.md — propose, never auto-write (values)
- Hooks / permissions — never self-modifiable (enforcement)

Plus a distinction: **deterministic presence** (rules loaded into context, interpretable) vs **deterministic enforcement** (hooks, bash scripts that physically block execution).

## Agent Streams

| Stream | File | Focus | Model | Status |
|--------|------|-------|-------|--------|
| A | [stream-A-mechanisms.md](stream-A-mechanisms.md) | How existing systems implement self-learning | Sonnet | Summary only — full report not recovered |
| B | [stream-B-drift.md](stream-B-drift.md) | Documented drift failure modes × originating layer | Sonnet | Full report recovered |
| C | [stream-C-theory.md](stream-C-theory.md) | Corrigibility, mesa-opt, CAI, Goodhart theoretical frame | Opus | Full report recovered |

## Permission Gotcha (preserve for next round)

All three subagents hit a **Write tool denied** state — the `researcher` subagent type appears to be configured to deliver findings inline rather than write .md files to disk. This meant:
- Reports were delivered as text in the agent's final message and had to be reconstructed in the main session
- Raw-source files (the `../sources/web/`, `../sources/documents/` scaffold) were NOT populated — agents could not save the raw pages/papers they fetched
- Stream A's full body was lost (only summary came back); Streams B and C delivered full reports inline which were fully salvaged

**Fix for next round:** use `general-purpose` subagent type instead of `researcher`, or manually unblock Write for the target paths in the subagent's session.

## Key Cross-Stream Findings

1. **The ordering is empirically supported** across drift evidence (Stream B) and alignment theory (Stream C) — with one caveat and one gap.

2. **Caveat (Stream B):** "memory: self-modify freely" needs qualification to "write freely, but reads must be trust-weighted with provenance." Memory is the primary attack surface in 2025–26 (MINJA: 95% injection success rate).

3. **Gap (Stream C):** Goodhart-via-drafts / mesa-optimization-through-proposals is the one failure mode the ordering has no structural defense against. Needs trend analysis, A/B behavior diffing, or multi-reviewer rotation.

4. **The presence-vs-enforcement distinction** is not named in the alignment literature surveyed. Adjacent concepts exist (AgentSpec's "deterministic enforcement," rippletide's "context without enforcement is not infrastructure," CoALA's implicit-vs-explicit split) but naming it as an **architectural safety-ordering primitive** appears to be original. Publishable as a short framing piece.

5. **Field gap CCE uniquely addresses (Stream A):** no other system has a validated mechanism for updating *behavioral policy* (rules, values, decision criteria). CCE's `proposals/` + `guardrails.md` architecture with human approval is the only design attempting this.

6. **Two-phase learning loop is independently validated (Stream A):** mature systems separate accumulation from distillation. CCE's chronicle → memory pattern matches this. Concrete recommendation: consolidation should run in a restricted subagent, not inline in the main entity.

## Next Steps

- **Synthesis doc:** `../2026-04-16-self-learning-and-drift.md` pulling the three streams into a unified architectural recommendation
- **Decisions needed:** Is Wisdom open to the qualification on "memory: self-modify freely"? Does CCE want to address Goodhart-via-drafts now or defer?
- **Possible follow-up:** resume Stream A via SendMessage to recover the full ~4K-word mechanisms report
