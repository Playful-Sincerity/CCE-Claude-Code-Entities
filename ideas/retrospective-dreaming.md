---
date: 2026-04-17
category: architectural-principle / skill-extension
related:
  - ideas/dreaming.md (the parent concept — prospective)
  - sessions/v1-build/phase-1-foundation/06-sleep-loop-PARALLEL-no-deps.md (sleep distinct from dreams)
  - research/2026-04-17-iga-dennis-hansen.md (Iga's adversarial dream is partially retrospective)
status: articulated; candidate for /dream v2 or a sibling skill
source_conversation: 2026-04-17 — Wisdom named the third function while working through /dream's debate recommendations
---

# Retrospective Dreaming — Replay the Past Under Distortion

## The three-function distinction (clean version)

Current `/dream` and CCE architecture have been collapsing two functions. They're distinct:

| Function | What it processes | Current status |
|----------|-------------------|----------------|
| **Sleep** | What actually happened — consolidation, review, compaction prep | Being built in CCE Phase 1 (sleep loop) |
| **Prospective dreaming** | What hasn't happened yet — rehearse future scenarios | `/dream` v1 (shipped 2026-04-17) |
| **Retrospective dreaming** | What happened under distortion — replay past to find better patterns | **Not yet built** — this file |

Retrospective dreaming is what Wisdom named in conversation: take something from the past that went okay-but-not-great, generate pattern-similar but distorted variants, walk through each to find what would have made it go better. It's learning from experience via imagination, not by faithful memory.

## Why this matters

Prospective dreaming prepares for unknown futures. But most growth signal comes from past events where the gap between intention and outcome is visible. Biology agrees — Schacter's constructive episodic simulation research showed that roughly half of dream content uses past episodic material recombined, not invented. The brain is extracting learning signal from experience by dreaming variants of it, not by replaying it.

The "what I would do differently" reflex is low-bandwidth in humans; dreams amplify it by:
1. Distorting the situation (so the lesson generalizes across superficial variation)
2. Running it to conclusion (not just identifying what went wrong, but rehearsing a better response)
3. Completing the emotional arc (the cross-cultural research on adaptive dreaming says resolution matters — nightmare disorder is unresolved rehearsal)

Iga's dream module (see `research/2026-04-17-iga-dennis-hansen.md`) is partially doing this already — its dream loop is aimed at finding "gaps between intention and reality" and "patterns of avoidance." That's retrospective by nature. But Iga's framing is adversarial self-audit, not pattern-distortion-based rehearsal. Different cut of the same territory.

## What retrospective dreaming needs

The non-trivial work is **scanning for events worth redreaming.** Not everything is worth dreaming about. The marking function needs to detect:

- **Outcome mismatches** — what was attempted ≠ what landed. The user asked for X and got Y but said "thanks" anyway; the assistant claimed success but the diff tells another story.
- **Positive feedback masking disappointment** — Wisdom flagged this explicitly: *"it gets a lot of positive feedback from a human that's negative or something like that."* The surface-level "sounds good!" that actually means "this isn't what I wanted but I'm moving on." Hard to detect from text alone — probably needs a conversational marker (*"you know what I really meant was..."*, *"actually, instead..."*, topic restart within same session).
- **Failed-to-achieve signals** — entity tried to do X, couldn't, moved on. The chronicle should log these but often doesn't ("actually that didn't work, let me try..." is a sign).
- **Longer-than-expected friction** — a task took 4× the reasonable time. The signal is in the session duration or the number of retries, not in any explicit log.
- **Explicit Wisdom corrections** — "no, not that," "stop doing X," "actually let's do..." — easiest signal to mark.

A good retrospective-dream pass would:
1. Scan the last N chronicles for these markers
2. Cluster similar-pattern events (several sessions where Claude over-explained; several where an outreach note got rewritten; several where a proposal was too speculative)
3. Pick 1-3 events worth redreaming based on recency × severity × pattern-frequency
4. For each: generate 2-3 pattern-similar but distorted scenarios (different stakes, different party, different timing, same underlying structure)
5. Run each to resolution with the lesson loaded
6. File the retrospective dream with explicit "what the original missed" and "what the improved response looks like"

## Architecture options (from today's conversation)

**Option A — widen `/dream counterfactual` mode**: the current counterfactual mode requires Wisdom to name the event. Widen to auto-scan. Lighter touch but muddies the mode semantics — "counterfactual" is about a specific alternative, "retrospective" is broader.

**Option B — `/dream retrospective` as a distinct mode in the existing skill**: keeps infrastructure unified. The scan-for-events step is the new work; the rest reuses `/dream`'s scenario generation + resolution pipeline.

**Option C — separate skill (`/learn-from` or `/redream`)**: retrospective dreaming has genuinely different input semantics (scan vs. point-at) and triggers. Could share the dream-output format but have its own invocation flow. Cleaner if the scan logic gets complex.

My lean (as of this filing, per today's conversation): **Option B first, Option C if the scan logic grows into a distinct capability.** Worth a `/debate` before committing — the skill's debate (2026-04-17) recommended *narrowing* `/dream`, so re-expanding its scope is a deliberate choice.

## Tension with the debate verdict

The debate (2026-04-17-value-of-dream-skill) concluded: restrict `/dream` to high-stakes relational prep, not project-scale default use. Retrospective dreaming widens scope again — it argues for *regular* invocation (weekly? after any sub-optimal interaction?). This is a genuine conflict. Possible resolutions:

1. Retrospective dreaming is valuable enough to justify re-widening.
2. Retrospective dreaming is a distinct skill from prospective dreaming; the debate verdict still stands for prospective.
3. Retrospective dreaming becomes a sleep-loop sub-job — the nightly sleep subagent scans for redream-worthy events and schedules them rather than running on every invocation.

Option 3 is architecturally interesting: it puts retrospective dreaming inside the consolidation flow, which matches biology (dreams happen during sleep). The sleep loop already has access to chronicles. Adding "check for redream-worthy events, queue them" as a sleep job is natural.

## Open questions

- How does the "marker" detection work in practice? Heuristic first (explicit corrections, session-length, retry patterns), ML later?
- Should retrospective dreams be shared with the human? If Claude dreams about a session where it misread Wisdom, does Wisdom benefit from reading the dream, or is it just for the next Claude session?
- Does retrospective dreaming risk being self-critical to a pathological degree? (The debate raised the performative-dream risk; retrospective dreams might trigger a different failure mode: anxious rumination.)
- Integration with the entity's `value-relationships/` directory — do retrospective dreams update value interpretations when they surface a clear "I misinterpreted X"?

## Next step

Not ready for implementation. Candidates for the next move:
- `/debate` whether Option 2 or Option 3 (retrospective inside sleep vs. inside dream) is the right architecture
- Build the marker-detection scanner as a separate experiment first (can run without the dream integration)
- Run one manual retrospective dream pass on a real recent event (like the Spatial Workspace reset moment, or the Dennis first-share hesitation) to see if the output quality justifies the infrastructure

Wisdom's request on 2026-04-17: *"let's store that idea for sure."* Stored.
