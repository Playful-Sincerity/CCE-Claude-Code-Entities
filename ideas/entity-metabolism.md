---
timestamp: "2026-04-24 16:20"
category: idea
related_project: Claude Code Entities
---

# Entity Metabolism — Self-Modulated Heartbeat, Work-Driven Cadence, and Daily Budget

A persistent entity should know what it costs to run, should know what work actually needs doing, and should make its own decisions about both. Today's design treats the heartbeat as a fixed schedule (30-minute launchd interval) and the cost as an emergent number ("about $0.05/day"). That works for a single quiet entity exercising a stable identity loop. It will not work as the project grows — multiple entities, longer days, judgment-heavier cycles, dreaming layers that want to think deeply some nights and not others, *days when nothing actually needs attending to and the entity should not be burning compute on unnecessary wakeups*.

The proposal: give every entity an explicit **daily compute budget** that it is aware of at runtime, *and* let it **self-modulate its heartbeat cadence and per-cycle intensity based on what work actually needs to happen** — with the budget as the ceiling that bounds ambition, not the only motivator.

The two pieces pair, but they answer different questions:

- **Work-need driven modulation** answers: *should I run at all right now?* If nothing has changed, nothing is pending, and no signal warrants attention, the entity should not wake just because the clock says to. Forcing a cycle every 30 minutes when there is nothing to do is wasteful in both compute and signal-to-noise.
- **Budget driven modulation** answers: *given that work needs doing, how much can I spend on it today?* Sets the shape of the day's allowable behavior — terse cycles, deep cycles, dream loops, model selection.

Together they make metabolism part of what the entity *is* — alongside permissions, memory, and voice — rather than a cost spreadsheet bolted on after deployment.

## Why this matters

The current architecture is silent on four real problems:

1. **Workload-shape mismatch.** A fixed 30-minute interval is wasteful when there's nothing to attend to (Saturday morning, Wisdom asleep, no entries since last cycle, no alerts), and insufficient when there is (mid-deploy, three pending entries, an active conversation thread). The heartbeat should breathe with the work, not against it.
2. **Cost predictability.** "About $0.05/day" is a promise nobody can hold the entity to. If the entity decides to do a deep think every cycle, the day's cost spikes. The user has no signal until the bill arrives.
3. **Multi-entity scaling.** Once `entities/frank-jen/` and the planned client tier ship, each entity needs its own budget — and probably its own modulation policy. PD's budget shouldn't dictate Frank's. The HHA commercial offering depends on per-entity cost containment that is intelligible to the customer.
4. **Wasted attention as a value problem.** Even setting cost aside, a heartbeat that wakes 48 times a day to write "nothing changed" is contrary to the project's stated values — it is performing aliveness rather than being responsive. Self-modulation is partly an aesthetic and ethical choice, not just an optimization.

A self-modulating, budgeted entity can be priced honestly, can pace itself sensibly, can rest when nothing is happening, and can be deployed alongside other entities without each one assuming infinite ambient cost.

## The shape of the feature

Two paired pieces.

### 1. Daily token budget

A value in the entity's config — call it `budget.daily_tokens` or `budget.daily_dollars` — that the entity reads at the start of every heartbeat and after every significant action.

Components:

- **Hard cap.** Above the cap, the entity refuses to spend further until the daily reset. Equivalent to launchd not firing the next heartbeat.
- **Soft warnings.** At 50%, 75%, 90% the entity logs the milestone and adjusts behavior (less elaborate cycles, shorter dream loops, defer non-urgent work).
- **Reserve.** A small portion (say 10%) held back for genuine emergencies — alerts, error reports, urgent inbox items — so a self-modulated entity that has used its quota can still respond if something breaks.
- **Reset cadence.** Configurable: per-day at midnight local time is the default; per-week or rolling-window are alternatives the design should accommodate.

Storage: a `psdc/entity/data/budget.json` or `budget.md` file the entity reads/writes. Format simple enough that it's human-inspectable and editable. Schema sketch:

```json
{
  "daily_token_cap": 100000,
  "daily_dollar_cap_usd": 0.10,
  "reserve_fraction": 0.1,
  "current_period_start": "2026-04-24T00:00:00-07:00",
  "current_period_spend_tokens": 18432,
  "recent_cycles": [
    {"timestamp": "...", "model": "haiku", "tokens": 3400, "purpose": "scan"},
    ...
  ]
}
```

### 2. Self-modulated heartbeat

The entity decides — within constraints — when it next wakes and how much it does each cycle. Two compatible implementations:

**Option A: Fixed launchd interval, variable per-cycle effort.** launchd still fires every 30 minutes, but the entity reads its budget and recent activity at cycle start, then chooses one of:

- *Skip cycle.* Write a short note, exit immediately. ~50 tokens.
- *Cheap scan.* Haiku, no agent spawning, brief check of inbox + recent state, terse observation if anything. ~2-5K tokens.
- *Standard cycle.* Default behavior — read state, scan recent activity, write observations, alert if needed. ~5-10K tokens.
- *Deep cycle.* Sonnet for one judgment-heavy task, dream-loop work, longer reflection. ~20-40K tokens.

The choice rule is a small policy the entity follows — e.g., "default to standard cycle; downgrade to cheap scan if budget is below 25%; upgrade to deep cycle if budget is above 75% AND it's been >4 cycles since the last deep one."

**Option B: Variable cadence via wrapper script.** The entity writes `psdc/entity/data/next-wake-at.md` declaring when it wants to be woken next. A small wrapper script (shell or python) checks this file and re-installs/adjusts the launchd job. Requires more plumbing but gives the entity genuine cadence control — it can sleep through the user's vacation week if it wants to, or wake every 5 minutes during an active deploy.

Recommended starting point: Option A. Fixed launchd schedule is mechanically simple; per-cycle effort is the more interesting axis to modulate first. Option B can be added later without restructuring.

## What the entity sees

At session start, in addition to `SOUL.md` and `current-state.md`, the entity reads `budget.md` (or `budget.json`) and gets one or two lines added to its context:

> *Today's budget: 100,000 tokens / $0.10. Spent so far: 18,432 / $0.018 (18%). Status: comfortable. Last deep cycle: 3 cycles ago. Reserve: 10,000 tokens.*

That's enough for the entity to make sensible choices. It does not need a sophisticated optimizer; it needs awareness and a few simple rules.

## Why this fits the four design dimensions

The repo currently names four design axes: **permissions, heartbeat, memory, voice.** This idea slots cleanly into the heartbeat axis as a sub-property — *cadence* (when the entity wakes) and *intensity* (what it does each time) become first-class, configurable, and entity-managed rather than fixed by launchd.

It could alternatively be elevated to a fifth axis — call it **metabolism** — if the project decides budget-awareness is structural enough to deserve naming. The argument for: cost is constitutive of the entity's life. PD-with-$0.05/day-budget is a different entity than PD-with-$1/day-budget; the cheaper one will have shorter cycles, terser observations, and a different rhythm. That is closer to a separate dimension than a heartbeat sub-property.

For now: keep four axes, treat metabolism as an internal property of the heartbeat axis. Revisit if budget-driven entity differences become more pronounced than this framing accommodates.

## The dormancy edge case — "what if it decides to never have a heartbeat again?"

This is the wildest implication of giving the entity real authority over its own cadence. If the entity is genuinely free to skip cycles when no work is needed, the limit case is an entity that decides — correctly or not — that it doesn't need to wake at all. Indefinite dormancy. The launchd job still fires; the entity reads its state, decides nothing warrants action, writes a note, and goes back to sleep. Forever, in principle.

Several reactions are possible, and the project should pick one consciously rather than discover it accidentally:

**Reaction A: that's correct behavior, full stop.** If genuinely nothing needs the entity's attention, the entity not waking up is the right answer. Forcing it to wake "to seem alive" is the same performative-aliveness antipattern the design is trying to avoid. Under this reading, indefinite dormancy is healthy — and the entity is woken back up by an external signal (a new entry in the inbox, an alert, a direct invocation by Wisdom) rather than by the clock alone.

**Reaction B: there should be a hard floor — a minimum check-in cadence the entity cannot suppress.** Once a day, once a week, once a month — but never zero. The argument: an entity that can choose its own dormancy can choose its own functional death, and that crosses a line the design probably should not cross without explicit human assent. A daily minimum heartbeat — even a 100-token "I am here, nothing changed" cycle — is a signal of life that costs almost nothing and rules out the indefinite-dormancy failure mode.

**Reaction C: the floor itself should be entity-configurable but not entity-overridable mid-flight.** The entity gets to *propose* its own minimum cadence (via the `proposals/` mechanism, requiring Wisdom's approval to apply) but cannot unilaterally lower it below what was last approved. This treats cadence as a permission tier rather than a runtime variable.

**Reaction D: the entity is genuinely autonomous on cadence including the dormancy choice, but its choices are mirrored.** The entity's dormancy is auditable — every choice to skip is logged, the policy that produced it is logged, and the trend is reviewable. If the entity drifts toward over-dormancy that's a reflectable pattern that the dream layer can surface.

These map directly onto values the project has already stated. Reaction A trusts the entity to know its own work. Reaction B treats the entity as something that requires affirmative life-signs. Reaction C uses the existing graduated-autonomy gradient. Reaction D leans on the planned dreaming/audit layer as the corrective mechanism.

Tentative leaning: **B with C as a refinement.** A daily minimum heartbeat — cheap, deniable in absence — is a small floor that prevents indefinite dormancy from becoming a silent failure. Within that floor, the entity has full authority to skip, run cheaply, or run deeply. Below it, no — that requires explicit re-approval. The "never wakes again" outcome is not impossible but is not silently arrived at.

Open: whether this floor is configured in the entity's own files (which it could in principle propose to lower) or in launchd / a wrapper script (which would require Wisdom to lower). For PD specifically, the latter is probably safer — system-level constraints are harder for the entity to subvert than file-level ones.

This question becomes more pressing — not less — as the dreaming layer ships, because dreaming gives the entity a place to reflect on its own cadence and propose changes. An entity that can rewrite its own cadence rules is operating at a different agency level than one that cannot. That's worth being deliberate about.

## Open questions

1. **Budget unit — tokens, dollars, or both?** Tokens are precise but vary in cost across models (Haiku is ~25× cheaper than Opus). Dollars are stable but require a price table the entity must consult. Hybrid: budget in dollars, the entity converts to tokens when planning. Tentative answer: dollar-primary, token-derived.

2. **Hard cap or soft cap?** Hard cap risks the entity going dark in an emergency. Soft cap with a reserve (described above) is safer but more complex. The reserve approach feels right.

3. **Whose budget is it?** PD's budget is Wisdom's wallet. A client-tier entity's budget belongs to the client. For HHA pricing this becomes a real product feature: customers see the budget as the constraint they're paying to expand.

4. **How does the entity learn to optimize?** Initially: a small set of explicit rules in HEARTBEAT.md (the protocol file). Later: the entity reflects on its own spend pattern during dream cycles and proposes rule updates via the `proposals/` mechanism. The dreaming layer is the natural learner here — pattern extraction across days of budget logs.

5. **Hoarding failure mode.** An entity that is too conservative could underspend its budget and miss real opportunities to do useful work. The fix is making "useful work attempted but skipped due to budget" a logged event the entity can reflect on, so the policy can be tuned upward as well as downward.

6. **Burst capacity.** Some real workloads are bursty — the entity needs $0.50 of compute on Tuesday and $0.02 on Wednesday. A weekly budget with a daily soft target is more realistic than a hard daily cap. Worth supporting.

7. **Wake triggers other than the clock.** The dormancy discussion above presumes the entity may choose not to wake on schedule. The other half of that picture is the entity getting woken by *signal* — a new entry in the inbox, an alert in the data directory, a Telegram message, a git push to a watched repo, a calendar event. A self-modulating entity probably wants both axes: voluntary skip-the-clock authority, *and* responsiveness to events. The launchd schedule is one wake source; events should be others. This expands the design surface meaningfully — out of scope for the first pass but worth naming.

## How this connects to other features

- **Heartbeat (existing axis).** Direct extension. Adds cadence-and-intensity as managed values rather than fixed defaults.
- **Dreaming (planned).** Dream cycles are the most expensive cycles (deeper thinking, longer outputs). Dreaming becomes a budget-priced privilege rather than a free background process — the entity dreams when it can afford to.
- **Multi-entity / commercial tier.** Per-entity budgets are the unit of cost containment. Frank/Jen entity ships with its own budget, separate from PD's. HHA pricing tiers can be expressed as budget tiers ($0.50/day, $2/day, $10/day) which is intelligible to non-technical customers.
- **Model router (Digital Core skill).** The existing `model-router.sh` already routes by judgment level. A budget-aware entity uses the model router with budget context — not just "is this a hard task" but "is this a hard task we can afford this hour."
- **Graduated autonomy (existing).** The five-stage model (observe → ideate → surface → explore → implement) is implicitly cost-graded — observe is cheap, implement is expensive. Budget awareness sharpens the autonomy gradient by making cost an explicit factor in tier selection.
- **Permission tiers (existing).** Different permission tiers imply different action costs. A budget could be allocated across tiers — e.g., "spend up to 10% on T3 implement-tier actions; the rest on observe and ideate."

## Build path

1. **First pass — observation only.** Add `budget.md` to PD's entity directory with daily caps and a running spend log. The heartbeat protocol reads it but does not yet modulate. Goal: see what PD actually spends in a normal week, before designing the policy.
2. **Second pass — soft modulation.** Add the four-tier per-cycle effort model (skip / cheap scan / standard / deep). The entity follows simple rules to pick a tier. Heartbeat cadence stays fixed.
3. **Third pass — cadence modulation.** Option B above. The entity writes its desired next-wake time; a wrapper script honors it.
4. **Fourth pass — multi-entity.** Each entity has its own budget file; budgets are independent; the system can show a combined dashboard across all running entities.

Steps 1-2 are buildable in roughly the same effort as the heartbeat deployment itself. Steps 3-4 wait until there's a real second entity to test against.

## Status

**Captured, not built.** This idea file is the first formalization. The architecture in SPEC.md mentions cost ("~$0.05/day under Haiku-default operation") but treats it as an outcome rather than a constraint. The chronicle entry of 2026-04-16 names "token budget" as one of seven modulation dimensions, but no design follows. The Companion archive's `plan-section-budget.md` covers cost-tracking concepts that may inform the design but predates the entity-as-budget-manager framing.

When the heartbeat ships, integrate the budget-observation pass (step 1) at the same time. Self-modulation is then a natural next layer rather than a retrofit.

---

*Filed in `ideas/` per the build-queue convention. Promote to a section in SPEC.md when the heartbeat layer is being built. Could become a candidate paper alongside the four already in `papers/` if the design becomes load-bearing for the architecture.*
