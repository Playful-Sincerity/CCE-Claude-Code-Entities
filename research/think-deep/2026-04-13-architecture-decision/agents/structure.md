# Structure — PS Bot Architecture Decision
**Analyst Phase | Think Deep Session: 2026-04-13**
**Question: Which foundation should PS Bot build on? Hermes Agent vs Claude Agent SDK vs OpenClaw vs Custom Build**

---

## 1. INSIGHT MAP

### Theme A: The Foundation Is a Memory Interface Question

**Insight:** The "foundation choice" is actually a question about which framework allows the cleanest memory interface design — everything else (webhooks, subprocess management, platform adapters) is composable from existing scouted pieces.

Evidence:
- Play synthesis: "The foundation choice is a memory interface choice, not a framework choice." All three play agents converged here independently.
- Papers stream: M3-Agent, Memoria, MemVerse, Memory Fabric all treat memory as modular infrastructure, not embedded in the agent loop. The framework that owns memory also constrains what PS Bot can do with it.
- GitHub research: Hermes's memory layer is a pluggable provider system — but its learning loop (execution traces → skill evolution) is architecturally tied to its memory model in a way that conflicts with AM's graph-topology-derived confidence.
- Play synthesis: "The voice can't earn confidence from a mind it can't read. The soul can't modulate the voice's assertiveness if they're in different runtime environments."

Confidence: 0.90. The convergence across three independent research streams (academic papers, GitHub code analysis, play synthesis) is strong. The one uncertainty: this could change if Hermes's memory provider system proves cleanly decoupled from its learning loop.

---

**Insight:** PS Bot's cross-modal voice+text persistent memory is genuinely novel — not a feature gap in existing frameworks, but an uncharted architectural combination.

Evidence:
- Papers stream: "No surveyed system unifies voice + text in a single persistent memory store for a personal assistant." M3-Agent (entity-centric, no voice), MemVerse (modality alignment, research stage), Moshi (no cross-session memory) each solve one part.
- Papers stream: Moshi, the best real-time voice dialogue system, starts fresh each conversation. PS Bot's exact opportunity is adding persistent memory on top.
- GitHub research: "True voice integration (confidence-modulated prosody) doesn't exist in any framework — this is custom build territory in all scenarios."

Confidence: 0.88. Strong across web and papers research. Somewhat speculative because the field moves fast and there could be unreleased work.

---

### Theme B: The Digital Core Alignment Heavily Favors Agent SDK

**Insight:** Claude Agent SDK is the only option that natively loads CLAUDE.md, follows rules, uses hooks, and accesses MCP servers — because it wraps Claude Code CLI directly. Hermes would require reimplementing every Digital Core convention in a foreign framework.

Evidence:
- Wisdom's direct question: "How does PS Bot USE the Digital Core's skills/rules/hooks?"
- GitHub research: "The SDK's `.claude/` directory exists in the repo, meaning it uses Claude Code's own CLAUDE.md and skills infrastructure for its development. This is a strong signal that CLAUDE.md/Digital Core is the natural integration layer."
- GitHub research: Hermes's skill system (markdown + YAML frontmatter) is "structurally similar" but not the same — it's Hermes's own engine, not Claude Code's tool system. Bridging them requires custom work.
- GitHub research: claude-code-telegram (2,426 stars, production-grade) demonstrates that Agent SDK bridges cleanly to Telegram with session management — this is the integration pattern PS Bot needs.

Confidence: 0.92. This is probably the strongest single finding in the dataset. The Digital Core is non-negotiable for Wisdom's use case, and SDK is the only option that natively supports it.

---

**Insight:** GEPA self-improvement is not a Hermes-exclusive advantage — it's available via DSPy to any Python framework.

Evidence:
- Papers stream: "GEPA is available via `dspy.GEPA`. Any framework that supports DSPy integration can use GEPA. This is not a Hermes-exclusive advantage."
- GitHub research: "GEPA self-evolution is a separate experimental repo (NousResearch/hermes-agent-self-evolution), not in main codebase." Phase 1 only. $2-10 per optimization run.
- Papers stream: GEPA outperforms RL by 20% with 35× fewer rollouts (ICLR 2026 Oral).

Confidence: 0.95. This is stated clearly in both the papers and GitHub research. GEPA's availability via DSPy is a documented fact.

---

### Theme C: Voice Architecture Is Independent of Foundation Choice

**Insight:** Voice pipeline (STT → LLM → TTS with confidence-modulated prosody) must be built custom regardless of framework. MCP is wrong for real-time voice; all frameworks require the same custom voice layer.

Evidence:
- Web research: Daily.co explicitly advises "Skip MCP unless specifically required; hard-code tools instead" for voice. Tool calls double LLM latency; MCP adds another layer.
- Web research: Vapi real cost is $0.30-0.33/minute — not viable for always-on personal use ($5,400/month for 24/7 voice).
- Papers stream: NVSpeech provides token-level paralinguistic marker insertion — directly usable for confidence-modulated prosody regardless of framework.
- Papers stream: Separate calibration layer required before mapping LLM confidence to prosody — RLHF actively penalizes hedging, making raw LLM confidence miscalibrated (Anthropomimetic Uncertainty, 2025).

Confidence: 0.93. The MCP-for-voice warning comes from Daily.co (practitioners, not theorists) and aligns with the latency math. Vapi pricing is cited from official source.

---

**Insight:** Hume EVI is the closest off-the-shelf implementation of confidence-modulated prosody, but it's a black box that sacrifices LLM choice and context control.

Evidence:
- Web research: EVI 3/4-mini detects 48+ emotions, 600+ voice descriptors, native LiveKit integration. "Closest to confidence-prosody vision."
- Web research: "Black-box S2S model — you lose debuggability, LLM choice, and context control."
- Papers stream: NVSpeech + Chatterbox Turbo gives more control at cost of more implementation work.

Confidence: 0.85. Hume's capabilities are documented. The trade-off assessment (black box vs. control) is a design judgment, not a fact.

---

### Theme D: Hermes Loses on Architecture, Not Quality

**Insight:** Hermes is genuinely production-grade (sentinel-object concurrency, SQLite WAL+FTS5, crash-recovery, 487 commits this cycle), but its learning loop is incompatible with PS Bot's graph-topology-derived confidence architecture.

Evidence:
- GitHub research: Hermes's learning loop is "pluggable context slots + Honcho user modeling, not autonomous unsupervised learning." The loop optimizes task performance via execution traces.
- Play synthesis: "PS Bot's learning mechanism is different. It's not 'the agent gets better at tasks.' It's 'the memory graph gets denser, and from that density, the agent earns the right to speak more assertively.' The learning is qualitative and tracked through a graph structure."
- Play synthesis: "If Hermes's learning loop is what makes it valuable, and PS Bot's learning loop is fundamentally different, you're not inheriting the valuable part — you're inheriting everything except the valuable part."
- GitHub research: 18 platform adapters, cron scheduler with crash safety, sentinel-object pattern — all genuinely useful engineering.

Confidence: 0.87. The incompatibility claim depends on the design intent for PS Bot's confidence model being stable. If the confidence model changes, this could change. But the architectural misalignment is real given current spec.

---

### Theme E: The Commercial Case Is Real But Premature

**Insight:** PS Bot v1 should target Wisdom as the power user; the commercial case for Frank's clients requires a fundamentally different set of trade-offs that would compromise v1 if mixed in.

Evidence:
- Play synthesis: "Two users (Wisdom vs Frank's non-technical clients) need opposite things." Wisdom needs deep Digital Core integration; Frank's clients need reliability and opacity.
- Web research: Dot shut down October 2025, Limitless acquired by Meta, Rabbit/Humane failed — "the bar for standalone AI hardware is not 'better than nothing' but 'better than a smartphone.'" Value must come from integration depth.
- Play synthesis: "Building for commercial clients before you've built for the power user is building to the wrong spec."

Confidence: 0.80. This is a strategic judgment with good supporting evidence from market failures. The uncertainty is that Frank's sales pipeline could create real pressure to prioritize commercial features sooner.

---

### Theme F: The Convergence Vision Makes the Foundation Choice Consequential

**Insight:** The foundation choice for PS Bot is also the foundation choice for the Convergence Vision's memory integration layer — getting it wrong means rebuilding when Associative Memory, Companion, and Phantom need to integrate.

Evidence:
- Play synthesis: Thread-Follower identified that "PS Bot is the first PS Software project that explicitly needs to integrate with the rest. It's not extending a framework — it's connecting organs."
- Play synthesis: "The soul can't modulate the voice's assertiveness if they're in different runtime environments." If PS Bot uses Hermes's memory, AM uses graph architecture, and Companion uses a different store, cross-integration becomes very expensive.
- Papers stream: Memory Fabric (2026) treats memory as infrastructure multiple agents write to — the vision PS Bot's convergence needs.

Confidence: 0.82. The Convergence Vision is aspirational — it might not materialize on the planned timeline. But if it does, the memory interface decision now has large downstream consequences.

---

## 2. FRAMEWORKS

### Framework 1: The Kernel/Userland Distinction

**What it is:** PS Bot is userland software, not a kernel. The kernel is the minimal runtime environment — subprocess management, async event loop, message routing. Everything interesting (memory, confidence, voice, PSSO behaviors) is userland.

**How to use it:** When evaluating frameworks, ask "is this kernel-level code or userland code?" Kernel code should be minimal, stable, and well-tested. Userland code is where PS Bot's value lives. Hermes and OpenClaw are trying to do both — they're opinionated about userland, which creates friction when PS Bot needs different userland behaviors. The Agent SDK (thin wrapper over Claude Code CLI) is closer to kernel-level.

Implication: "Which framework" is the wrong question. "What does my kernel need to provide" is the right question. The kernel PS Bot needs: persistent Claude subprocess, async message routing, file-based state management, clean memory interface that grows from JSON to graph. That kernel doesn't have a name — it's a composition.

---

### Framework 2: The Memory Interface Seam

**What it is:** Every architectural decision should be evaluated against one question: does this leave a clean seam at the memory interface? The seam is where voice confidence will eventually read from AM's graph topology.

**How to use it:** Define a memory interface (abstract Python class or documented protocol) before choosing any other component. Then evaluate each framework/component by asking "does it honor this interface, or does it assume ownership of memory?" Frameworks that own memory (Hermes's memory provider system, OpenClaw's flat files) close the seam. Frameworks that treat memory as external (Agent SDK, raw asyncio + clean files) leave it open.

Implication: Build the memory interface first, in code. Make it simple (v1 reads/writes JSON) but contractual. Everything else — Telegram handler, subprocess lifecycle, voice pipeline — plugs into the edges of that interface.

---

### Framework 3: Compose Scouted Pieces, Leave Seam Open

**What it is:** The "custom build" option isn't starting from zero — it's deliberately composing the best scouted pieces for each component while keeping the memory seam clean and explicit.

**How to use it:**

| Component | Scouted Source | Reuse Approach |
|-----------|---------------|----------------|
| Telegram webhook/bot handler | python-telegram-bot ≥22.6 (used by Hermes) | Direct dependency |
| Claude subprocess lifecycle | claude-code-telegram (2.4K stars, production) | Adapt pattern |
| Session persistence | SQLite + WAL mode (Hermes pattern, nanobot) | Steal the pattern |
| Tool registration pattern | claude-code-telegram / Hermes skill system | Adapt to Digital Core conventions |
| Proactive triggers | HEARTBEAT.md pattern (nanobot) + cron scheduler (Hermes) | Steal the pattern |
| Digital Core integration | Agent SDK programmatic API | Direct dependency or pattern |
| Voice pipeline | Pipecat framework + Chatterbox Turbo + NVSpeech | Custom, independent of agent framework |
| Memory (v1) | Clean JSON interface with explicit schema | Build from scratch |
| Memory (v3) | AM graph — TBD | Design seam now |
| Self-improvement | GEPA via DSPy | Add as module later |
| SOUL.md / identity | OpenClaw's SOUL.md pattern (inspiration) | Adapt to PSSO |

---

### Framework 4: The Two-User Sequencing Model

**What it is:** Wisdom's power-user case and Frank's commercial case require fundamentally different architectures. Sequencing (Wisdom first, commercial second) avoids building to the wrong spec.

**How to use it:**

- PS Bot v1: Wisdom as user. Deep Digital Core integration. PSSO-grounded behaviors. Interesting novel tech. Explicit placeholder confidence (labeled as such — no AM yet).
- PS Bot v2: Frank tests it with one warm lead. Empirical discovery of what needs to change.
- PS Bot commercial: Informed by v2 findings. Different reliability contract. Different silence interpretability model. Possibly different underlying architecture.

The dangerous version: trying to satisfy both cases in v1. The safe version: optimize for Wisdom so thoroughly that v1 demonstrates the value proposition clearly, then let Frank's feedback drive v2.

---

## 3. DECISION LANDSCAPE

### Option A: Claude Agent SDK (as primary substrate)

**Evidence for:**
- Native Digital Core integration — CLAUDE.md, rules, hooks, MCP all work automatically because it IS Claude Code
- claude-code-telegram (2.4K stars) demonstrates production-viable Telegram integration on this exact substrate
- Anthropic's Managed Agents (April 8, 2026) adds stateful persistence, ~$0.05/hour container cost
- 5 hook interception points including UserPromptSubmit and SessionStart — exactly what PS Bot needs
- Full MCP dynamic control (enable/disable/reconnect at runtime)
- Cleanest Python: SDK wraps Claude Code subprocess, no translation layer between Digital Core and bot behavior

**Trade-offs:**
- Known session-resumption bug (issue #809: `continue_conversation=True` starts new session instead of resuming)
- Subprocess transport adds latency vs direct API calls
- No built-in platform gateway, cron scheduler, or voice pipeline — these must be built or sourced
- Still maturing (59 releases, some production bugs around cancel scope leaks)
- Container costs (~$36/month for 24/7) before tokens

**Dependencies/sequencing:** Best used as the agent execution substrate. Needs: Telegram handler (python-telegram-bot or similar), proactive scheduler (build or steal HEARTBEAT.md pattern), memory interface (build from scratch), voice pipeline (completely independent). Session-resumption bug must be resolved or worked around before relying on long sessions.

---

### Option B: Hermes Agent (as full framework)

**Evidence for:**
- Production-grade: sentinel-object concurrency, SQLite WAL+FTS5, crash recovery, 487 commits this cycle
- 18 platform adapters ready-built — Telegram, Slack, WhatsApp, Discord, Signal, iMessage
- Cron scheduler with crash safety and deduplication already implemented
- Skill system structurally similar to Digital Core (markdown + YAML frontmatter)
- $5 VPS deployment viable (2GB RAM for 2 channels, no browser tools)
- Honcho user modeling (dialectic Q&A, peer cards, semantic search) is genuinely useful

**Trade-offs:**
- Skill execution model is Hermes's own engine, not Claude Code's — Digital Core skills require bridging or reimplementation
- Learning loop optimizes task performance via execution traces; incompatible with graph-topology-derived confidence
- Memory provider system has opinions that close the memory seam
- Starting a fight with the framework immediately when building the skeleton-soul boundary features (compaction metabolism, emotional chronicle, earned assertiveness)
- GEPA self-evolution is separate experimental repo, $2-10/run, Phase 1 only — not a shipped feature
- Honcho requires external hosted service (additional infrastructure dependency)

**Dependencies/sequencing:** Would need a Digital Core bridge layer before it's useful for Wisdom's case. The multi-platform gateway is the only component that's genuinely ahead of what you'd build custom. For Frank's commercial case later, Hermes might resurface as a strong option.

---

### Option C: OpenClaw (TypeScript framework)

**Evidence for:**
- 356K stars — largest community, most platform coverage
- SOUL.md pattern is conceptually resonant with PSSO identity model
- Plugin architecture allows principled extension

**Trade-offs:**
- TypeScript — PS Bot is Python-native. Full rewrite cost is real.
- 18,495 open issues — enormous maintenance surface
- Optimizes for multi-tenant flexibility, not single-user depth
- Already decided as "inspiration, not dependency" in Companion project

**Dependencies/sequencing:** Not a live option for v1. SOUL.md pattern is worth stealing as an identity design pattern, not as a dependency.

---

### Option D: Custom Build (composing scouted pieces)

**Evidence for:**
- SPEC.md already exists and is architecturally complete with research citations
- Composable pieces are already scouted: claude-code-telegram (subprocess lifecycle), python-telegram-bot (platform), HEARTBEAT.md (proactive triggers), SQLite WAL (persistence)
- Memory seam stays explicitly open — no framework owns it
- Digital Core integration is native (same Python runtime, same filesystem)
- GEPA available via DSPy — self-improvement is addable as a module, not requiring a specific framework
- Inner Thoughts 8-heuristic motivation scoring (CHI 2025) is implementable as a module on any foundation
- Voice pipeline is independent of framework choice regardless

**Trade-offs:**
- More implementation work upfront (no built-in multi-platform gateway)
- No community to debug against
- Requires discipline to not build from scratch what already exists in libraries
- Risk of building the wrong abstractions early and having to refactor

**Dependencies/sequencing:** SPEC.md is the blueprint. Build order: (1) memory interface contract, (2) Telegram handler + subprocess lifecycle, (3) Digital Core integration via Agent SDK programmatic API, (4) HEARTBEAT.md proactive triggers, (5) voice pipeline as independent module. Each phase is independently shippable.

---

### Verdict

**Custom Build with Agent SDK as execution substrate.**

The options aren't cleanly separable. "Custom Build" doesn't mean ignoring Agent SDK — it means using Agent SDK as one well-chosen module (the Claude subprocess layer) while building around it rather than inside a framework that owns more than it should. The decision decomposes as:

- Agent subprocess layer: Claude Agent SDK (Digital Core integration is non-negotiable)
- Platform layer: python-telegram-bot (same library Hermes uses, production-tested)
- Persistence layer: SQLite + WAL (steal Hermes's pattern, own the implementation)
- Memory layer: custom, clean interface, v1 = JSON, seam open for AM
- Proactive layer: HEARTBEAT.md + cron (steal nanobot's pattern)
- Voice layer: independent module, build when text layer is stable

Hermes is the strongest alternative but loses on the learning loop incompatibility and the Digital Core bridge cost. OpenClaw is eliminated. The real question is whether Agent SDK is the subprocess layer or the whole foundation — the answer is: it's the subprocess layer, inside a custom-built wrapper.

---

## 4. ASSUMPTIONS

### Assumption 1: The Digital Core is non-negotiable for Wisdom's use case

What it assumes: Wisdom will not accept a PS Bot that doesn't natively load his rules, skills, and memory from the Digital Core.

What changes if wrong: Hermes becomes significantly more competitive. The multi-platform gateway, Honcho user modeling, and cron scheduler would all be immediately available without bridging work.

Fragility: LOW. This assumption is stated explicitly in Wisdom's direct questions to the research. It's not inferred.

---

### Assumption 2: Associative Memory will eventually exist and should be design-integrated

What it assumes: AM will be built, its graph architecture is relatively stable, and PS Bot's memory interface should be designed to accept it.

What changes if wrong: The memory seam design is wasted work. A simpler, more opinionated memory model (e.g., Hermes's pluggable providers) becomes fine.

Fragility: MEDIUM. AM is in research phase. Timeline uncertain. If PS Bot is built and useful before AM exists, the practical pressure may be to ship rather than wait for a clean integration surface.

---

### Assumption 3: PS Bot v1 is for Wisdom, not for Frank's clients

What it assumes: The commercial case is real but secondary; v1 should prioritize Wisdom's power-user needs.

What changes if wrong: Frank closes an enterprise deal before v1 ships. Suddenly PS Bot needs to look reliable and opaque, not deeply integrated and experimental. This would push toward Hermes (hardened, production-grade, readable by clients) or a commercial platform.

Fragility: MEDIUM. Frank has warm leads and real sales ability. This assumption could expire within weeks.

---

### Assumption 4: Confidence-modulated prosody is a v1 goal, not v3

What it assumes: Building voice with confidence-modulated prosody is in scope for PS Bot v1 architecture, even if v1 has placeholder confidence.

What changes if wrong: The voice architecture decisions (NVSpeech, separate calibration layer, prosody parameter mapping) can be deferred. The foundation choice is simpler — pure text bot first.

Fragility: LOW-MEDIUM. SPEC.md includes voice. But play synthesis noted: "can you build the voice before the mind exists?" A pragmatic v1 might ship text-only and add voice later, reducing the architectural complexity significantly.

---

### Assumption 5: Agent SDK's session-resumption bug (issue #809) is resolvable

What it assumes: The known bug where `continue_conversation=True` starts a new session instead of resuming can be worked around or will be fixed.

What changes if wrong: The persistent-session architecture breaks. Either PS Bot rebuilds sessions from stored history each time (expensive and imperfect) or moves to a different subprocess management approach.

Fragility: MEDIUM-HIGH. This is an open bug in the SDK. It hasn't been fixed yet as of the research date. Workarounds exist (reconstruct session from SQLite store) but add complexity.

---

### Assumption 6: "Custom build" means disciplined composition, not starting from scratch

What it assumes: The implementation team (Wisdom, primarily) will resist the temptation to rebuild what already exists in libraries and focus on building only the novel memory interface and PSSO-specific behaviors.

What changes if wrong: Custom build becomes the worst option — takes the longest, has the most bugs, and doesn't benefit from the community debugging of frameworks like Hermes or Agent SDK.

Fragility: MEDIUM. This is a discipline risk, not a technical risk. Known pattern: building interesting rabbitholes instead of shipping.

---

## 5. OPEN QUESTIONS

Ranked by importance to the build decision:

### Q1 (Critical): What is the memory interface contract?

The synthesis says "design a clean seam where AM will eventually plug in." But what does that seam look like in code? Until this is answered, the foundation choice remains abstract. A poorly designed interface makes all other decisions wrong retroactively.

Suggested investigation: 30-minute focused design session. Define an abstract `MemoryInterface` class with the methods PS Bot needs (read context, write interaction, retrieve relevant, compact). Then implement it twice — once with a flat JSON file (v1) and once with a sketch of what AM graph calls would look like (v3). The gap between those two implementations reveals what the seam needs to be.

---

### Q2 (Critical): Can Agent SDK's session-resumption bug be worked around cleanly?

Issue #809 is a known blocker for persistent session architecture. If the workaround (reconstruct from SQLite store on each session) adds enough complexity that it negates the Digital Core integration advantage, then "custom subprocess management + periodic Digital Core context injection" may be cleaner.

Suggested investigation: Test the bug in practice. Build the minimal subprocess lifecycle (connect → query → disconnect → reconnect) and measure how expensive session reconstruction is versus true resumption.

---

### Q3 (High): What does the SPEC.md say about the build order?

SPEC.md is described as architecturally complete. Before the build starts, a focused read of SPEC.md against the research findings (especially the papers stream and the GitHub findings) would identify which parts of the spec are validated, which are outdated, and which have gaps that research surfaced. This is 2-3 hours of work that prevents months of misalignment.

---

### Q4 (High): Is v1 text-only or voice-included?

The paradox-holder asked: "Can you build the voice before the mind exists?" This is a sequencing question with architectural implications. If v1 is text-only, the foundation choice is simpler and faster. If v1 includes voice, the calibration layer, NVSpeech integration, and split MCP/hardcoded-tools architecture all need to be designed in from the start.

Suggested decision: Ship text-only v1. Validate the memory architecture and Digital Core integration. Add voice as v1.5 once the baseline is stable.

---

### Q5 (High): What does "Digital Core write-back" look like in practice?

The emerging permission model (chronicles and remote-entries as append-only, rules and skills as read-only, CLAUDE.md as desk-approval-only) is directionally right. But the implementation — git clone with read-only branch, writable overlay directories, pull cadence — hasn't been tested. This should be prototyped before it's designed into the architecture, because the implementation constraints could change the permission model.

---

### Q6 (Medium): What is the HEARTBEAT.md equivalent for PS Bot's PSSO behaviors?

The HEARTBEAT.md pattern (nanobot) is elegant: a markdown file with tasks, checked every 30 minutes, agent executes and delivers to most active channel. PS Bot needs something similar but grounded in PSSO: the "content in inaction" principle means silence is the default, but the heartbeat checks whether silence is appropriate. What are the heuristics for breaking silence? The Inner Thoughts 8-heuristic scoring system (CHI 2025) is the academic template, but what are the PSSO-specific heuristics?

---

### Q7 (Medium): How does the Honcho user modeling trade-off resolve?

Hermes's Honcho plugin provides dialectic Q&A, peer cards, and semantic search on user representation — genuinely useful. But it requires a hosted Honcho account (additional infrastructure and cost dependency). The AM graph is eventually meant to fill this role. For v1, is there a lightweight user modeling that doesn't require Honcho and doesn't wait for AM? A simple "identity document" (like OpenClaw's SOUL.md or Digital Core's MEMORY.md) might be sufficient.

---

### Q8 (Lower): Does Frank's commercial pipeline create timing pressure?

If Frank closes an enterprise prospect before PS Bot v1 ships, the sequencing assumption (Wisdom first, commercial second) breaks. This is a business question, not a technical one, but it could force an architectural decision. Monitoring this is more important than resolving it now.

---

### Q9 (Lower): What is the "content in inaction" silence contract for commercial users?

Play synthesis identified that silence is companionable for Wisdom (who understands the system) but mysterious for commercial clients (who don't). If PS Bot ever serves commercial users, the silence interpretability problem must be solved — possibly with a different "participation contract" exposed in the configuration. This is v2+ work but deserves documentation now so it doesn't get designed out.

---

*Analyst Phase complete — 2026-04-13. No new information added. Organized from GitHub research, web research, papers research, play synthesis, and Wisdom's direct questions.*
