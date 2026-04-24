# Claude Code Entities — MVP Build

**Goal:** Spawn PD as a persistent autonomous entity with a heartbeat. Leave it running for a day. Observe what happens. Adjust.

**Not the goal:** Full production-grade autonomy. Perfect memory architecture. AVS integration. Multi-entity coordination. Those come later.

**Estimated total time:** 2-3 hours of focused work across three phases.

---

## The Decomposition

```
Phase 1: Safety Hardening (SEQUENTIAL — all edit spawn-entity.sh template)
    ┌──────────────────────────────────────┐
    │ 01: Tighten Bash allow/deny lists     │
    │    Remove interpreters from allow     │
    │    Add mcp/permission-mode denies     │
    │    ~30 min                             │
    └──────────────────┬───────────────────┘
                       │
                       ▼
    ┌──────────────────────────────────────┐
    │ 02: Add PII/sensitive denyRead/Write  │
    │    Protect ~/Wisdom Personal/people   │
    │    Narrow allowRead scope             │
    │    ~20 min                             │
    └──────────────────┬───────────────────┘
                       │
                       ▼
Phase 2: Heartbeat Infrastructure (PARALLEL — different files)
    ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
    │ A: Heartbeat     │  │ B: Emergency     │  │ C: Heartbeat     │
    │    plist +       │  │    stop scripts  │  │    protocol      │
    │    install       │  │    (pause-all,   │  │    refinement    │
    │    script        │  │    kill-entity)  │  │    in template   │
    │    ~45 min       │  │    ~15 min       │  │    ~20 min       │
    └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
             │                      │                     │
             └──────────────────────┼─────────────────────┘
                                    │
                                    ▼
Phase 3: Live Test (SEQUENTIAL)
    ┌──────────────────────────────────────┐
    │ 01: Spawn PD, enable heartbeat,       │
    │    run for 24 hours, observe          │
    │    ~30 min active + 24 hr passive     │
    └──────────────────┬───────────────────┘
                       │
                       ▼
    ┌──────────────────────────────────────┐
    │ 02: Review audit log + observations,  │
    │    capture learnings, adjust          │
    │    ~30 min                             │
    └──────────────────────────────────────┘
```

## Launch Order

1. **Now:** Phase 1, task 01 (sequential, must be first)
2. **Then:** Phase 1, task 02
3. **Then:** Phase 2 tasks A, B, C in parallel
4. **Then:** Phase 3, task 01 (spawn PD, enable heartbeat)
5. **24 hours later:** Phase 3, task 02 (review and adjust)

## What's Explicitly OUT of MVP Scope

These session briefs exist but are deferred until MVP is running:
- `v1-build/phase-1-foundation/03-memory-architecture-PARALLEL-no-deps.md` — design after observing real entity memory needs
- `v1-build/phase-1-foundation/04-comparative-architecture-PARALLEL-no-deps.md` — research phase, not blocking
- `v2-build/phase-graph-digital-core/01-graph-architecture-design.md` — V2 by definition
- `2026-04-15-novelty-research.md` — research, not blocking
- `2026-04-16-vscode-full-path.md` — daily workflow improvement, separate concern
- `2026-04-16-read-protection-PII.md` — subsumed into Phase 1 task 02 here (narrower scope for MVP)

## What MVP Actually Proves

After Phase 3, we'll know:
- Does PD behave sensibly as a persistent entity over 24 hours?
- Does the heartbeat fire reliably?
- Does PD leave useful breadcrumbs (observations, state updates)?
- Do the safety boundaries hold during real operation?
- What's annoying / broken / beautiful in practice?

Everything after MVP is informed by this — memory architecture, comparative research, expansion — all gets better with real data from a live entity.

## MVP Done Criteria

- [ ] `/entity pd` spawns PD with tightened settings
- [ ] PD has a running launchd heartbeat firing every 30 min
- [ ] Emergency stop script exists and works (tested once with a throwaway entity)
- [ ] PD runs for 24 hours without damage to the filesystem
- [ ] Wisdom can review PD's observations and audit log after 24 hours
- [ ] At least one real insight comes from watching PD operate
