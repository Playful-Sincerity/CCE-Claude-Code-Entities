# Play Synthesis — PS Bot Architecture Decision
**2026-04-13 | Think Deep Session**
**Question: Which foundation should PS Bot build on? Hermes Agent vs Claude Agent SDK vs OpenClaw vs Custom Build**

---

What surprised me first wasn't which option is right. It was that the question is almost certainly a trick. The Thread-Follower pulled on that thread hard, and here's where it went.

---

## Thread-Follower: "What if you're already building it?"

The thread that deserves to be followed unreasonably far: **SPEC.md is already a custom build spec, and it's actually good.** Not rough notes — a complete architecture with research citations (CMV, MemGPT, TiMem), a lossless memory model, async subprocess lifecycle management, structured compaction as metabolism rather than a trigger cycle, a voice layer, TOTP auth. Whoever wrote that spec had already done the foundation research.

So following the thread: what does "foundation" even mean for something this specific? The spec isn't missing a framework. It's missing shipping. The foundation question might be displacement — a way of reframing "I haven't built this yet" as "I haven't decided the architecture yet," when actually the architecture is fairly settled and the missing thing is time and execution.

Now follow the Hermes thread further than it deserves. Hermes Agent is 76K stars, self-improving, multi-platform. The phrase "PS Bot is the soul, Hermes is the skeleton" appeared somewhere in the context framing. Follow what "soul" means technically in that metaphor. A soul, in the philosophical sense this ecosystem uses (see PSSO, Companion design), is something that has: continuity of identity over time, values that constrain behavior, a way of developing earned conviction rather than installed beliefs, and presence that isn't dependent on external stimulation.

Technically, that maps to: a persistent memory graph (continuity), rules/prompts that emerge from the graph rather than being hardcoded (values from evidence), confidence that scales with knowledge density (earned conviction), and the "content in inaction" principle (presence without noise).

None of those are things a skeleton provides. The skeleton — the webhook handling, the subprocess lifecycle, the TOTP auth, the Telegram API wiring — is genuinely grunt work. The soul is genuinely novel. If Hermes handles the skeleton and PS Bot provides the soul, the question is whether the skeleton is where the interesting coupling happens, or whether the skeleton is truly separable.

Here's what following that thread reveals: **the most interesting technical decisions in SPEC.md all live at the boundary between skeleton and soul.** The compaction metabolism (not a trigger, but a continuous cognitive habit) requires Claude to manage its own context budget as a first-class behavior. The emotional chronicle requires that the bot tracks its own states through interactions, not just Wisdom's. The earned assertiveness requires the memory graph topology to directly influence prosody parameters. These aren't layers you add on top of a skeleton — they require the skeleton to be built specifically to support them.

Which means: if you take Hermes's skeleton, you immediately start fighting it. Because Hermes's learning loop is designed for its architecture, not for a system where the LLM subprocess manages its own cognitive metabolism.

The learning loop thread specifically: Hermes's learning loop is probably more important than its multi-platform gateway, as the framing suggested following. The learning loop is the thing that makes Hermes Hermes — the daemon that improves itself. But PS Bot's learning mechanism is different. It's not "the agent gets better at tasks." It's "the memory graph gets denser, and from that density, the agent earns the right to speak more assertively." The learning is qualitative and tracked through a graph structure, not quantitative task performance. These are genuinely different loops. If Hermes's learning loop is what makes it valuable, and PS Bot's learning loop is fundamentally different, you're not inheriting the valuable part — you're inheriting everything except the valuable part.

The Convergence Vision thread is where things get structurally interesting. The four organs — PS Bot as voice, Associative Memory as mind, Companion as soul, Phantom as eyes — are only useful if they actually integrate. The integration surface is memory. If PS Bot uses Hermes's memory model (whatever that is), and Associative Memory uses a navigational graph architecture, and The Companion uses permission-as-consciousness over a different memory store, you have three separate memory systems that don't share a representation. The voice can't earn confidence from a mind it can't read. The soul can't modulate the voice's assertiveness if they're in different runtime environments.

So the foundation choice for PS Bot is actually the foundation choice for the Convergence Vision's memory integration layer. That's a bigger decision than it looks like from inside the PS Bot question alone.

---

## Paradox-Holder: "The tensions nobody wants to look at directly"

The tension that runs through everything is this: **PS Bot has two users and they need opposite things.**

Wisdom is the power-user case. He has a Digital Core — 20 skills, 19 rules, hooks, an ecosystem of customizations that took 13 days to build. He wants PS Bot to feel like an extension of that system, where the grain of Claude Code is preserved, where the memory model integrates with Associative Memory, where the confidence architecture modulates prosody. He's comfortable with complexity. He wants the interesting stuff.

Frank can sell it. Frank has MSA experience with billion-dollar companies, a network of warm leads, and the ability to move enterprise deals. But Frank is selling to clients who don't have a Digital Core. Who don't know what TOTP means. Who want to talk to their AI assistant without understanding what a subprocess lifecycle is. These users need something that looks like magic and never asks them to care about its internals.

These are not compatible design requirements. The "interesting stuff" for Wisdom — the continuous compaction metabolism, the confidence-modulated prosody, the graph-based earned assertiveness — is exactly the kind of thing that creates debugging surface for enterprise clients. The "voice IS the inner state" is poetic and technically interesting, but it's also the kind of emergent, context-dependent behavior that's almost impossible to guarantee for a client who paid $50K for a reliable assistant.

Custom build maximizes Wisdom's case. Hermes might give you a path to Frank's case. OpenClaw's plugin architecture might give you a way to serve both from one codebase. But nobody has actually demonstrated that the thing Wisdom needs (deep integration with Digital Core, graph-based confidence, PSSO-grounded behavior) and the thing Frank can sell (reliable, opinionated, doesn't require the client to think about its architecture) can live in the same product at v1.

The second unresolved tension: **"content in inaction" plus "proactively surfaces things."** When does silence become negligence? When does proactivity become noise?

This isn't just a product design question. It's a question about whose mental model you're in. For Wisdom, who built the system and knows exactly what it tracks and doesn't track, silence is companionable. He knows what the bot knows. He trusts its judgment about when to speak. For a business client who doesn't understand the system's internals, silence is mysterious. "Why didn't it tell me about that meeting conflict?" "Did it miss it, or decide not to say anything?" The interpretability of silence is completely different for the two user types.

The third tension: **the learning loop is the most exciting feature and the most dangerous one.** The confidence-modulated prosody — the voice that earns assertiveness as the memory graph densifies — is genuinely novel. Nobody has done this. The psycholinguistics research (Goupil et al. 2021, in the research files) validates the mechanism. But "novel" and "debuggable" are in tension. When a commercial client calls and says "the bot keeps hedging on things it should be confident about," how do you diagnose that? The memory graph topology determines confidence, but the graph is built from conversational history, which means the same behavior that makes it personally adaptive for Wisdom makes it inconsistently calibrated for clients who haven't built the same depth of interaction history.

The fourth tension, which is the most uncomfortable: **can you build the voice before the mind exists?**

The Convergence Vision's build order is Voice → Memory → Thought → Sight → Agency. PS Bot is voice. Associative Memory is mind. But the voice's most interesting properties — earned assertiveness, confidence-modulated prosody, knowing when to speak from what you know — all require the mind to already exist. Without the graph, there's no topology to derive confidence from. Without the memory, there's no earned conviction. You're building a voice that will eventually speak from a mind that doesn't exist yet, which means v1 PS Bot necessarily has placeholder confidence, placeholder assertiveness, placeholder memory architecture.

That's fine. The grounding note in the research files says it clearly: "v1 is a virtual assistant." But it means the foundation choice for PS Bot v1 is actually orthogonal to the foundation choice for the Convergence PS Bot. You could build v1 on anything, ship something useful, and then rebuild on the right foundation when Associative Memory is ready. The "foundation question" might be premature — not because the question is wrong, but because the thing you're building right now (a reliable pocket assistant that remembers stuff and answers from your phone) doesn't require the foundation to be perfect.

---

## Pattern-Spotter: "What this looks like from other domains"

The DAW analogy goes further than it first appears. You don't build your own DAW to make music — unless your music requires something no DAW supports. The question is whether PS Bot's music requires something no framework supports. And the answer from following the Thread-Follower's analysis is: probably yes, specifically the cross-modal memory integration. No framework currently contemplates a system where the voice's prosodic confidence is derived from a navigational graph that's shared with a separate mind-organ that uses a completely different runtime.

But — and this is the pattern-spotter's job — that doesn't mean you build the full custom DAW on day one. Musicians who build their own instruments first learn to play, then identify exactly what the existing instruments can't do, then build the specific missing piece. The pattern in creative tool development is: use existing tools until you find the precise irreducible gap, then build exactly that gap and nothing else.

Applied to PS Bot: the irreducible gap isn't the webhook handling. It isn't the Telegram API integration. It isn't even the subprocess lifecycle. Those exist in multiple good implementations already (claudegram has a very high reusability tool loop; chibi has the cleanest tool registration). The irreducible gap is the memory graph integration surface — the place where voice confidence reads from AM's graph topology.

That gap doesn't exist yet, because AM doesn't exist yet. So: build PS Bot using composable pieces from claudegram and similar (which the scouting research already identified), maintain clean separation at the memory interface, and design that interface to eventually accept the AM graph. This isn't "custom build from scratch" — it's "composition of well-scouted pieces with a clean seam where the novel stuff will go."

The OS architecture analogy: kernel vs userland. Which layer is PS Bot building at? PS Bot is userland. The kernel is the runtime environment — whether that's Hermes or Claude Code or a Python asyncio event loop. The question "which foundation" is really a question about which kernel. But in modern OS design, the right move when building novel userland software isn't to choose an existing kernel and accept all its constraints — it's to design your userland software cleanly, then make the minimal kernel choice that serves it.

The kernel PS Bot actually needs is: persistent Claude subprocess, async message handling, clean file-based state management, and a well-defined memory interface that can grow from a simple JSON file (v1) to an AM graph (v3). That kernel doesn't exist as a named open-source project — it's a composition. The Python asyncio event loop is the actual kernel. Everything above it is library.

The biological metaphor: extending vs engulfing. Is PS Bot extending Hermes (symbiosis) or engulfing it (absorption)? Neither, actually — the pattern that fits is more like parallel evolution. Hermes evolved for its ecological niche (self-improving daemon, multi-platform integration). PS Bot is evolving for a different niche (single-user PSSO-grounded cognitive extension). They share ancestry (both use LLMs as agents) but the pressures shaping them are different enough that one doesn't straightforwardly extend the other.

The Digital Core pattern is the most directly relevant. The Digital Core started as Claude Code customization — extending an existing system rather than building from scratch. What worked: the 20 skills and 19 rules layer efficiently on top of Claude Code's existing substrate. The hook system adds behavior without rebuilding the CLI. What didn't work (or hasn't been tested): the integration between Digital Core and other PS Software projects. The skills work beautifully within a single Claude Code session. They don't yet integrate with Associative Memory or The Companion. The pattern that worked was "extend the existing system." The pattern that hasn't been tested is "make the extended system integrate with adjacent projects."

PS Bot is the first PS Software project that explicitly needs to integrate with the rest. It's not extending a framework — it's connecting organs. That's a different design problem, and the Digital Core's architecture (layered extensions on a stable substrate) might not be the right model for it.

The PSSO three-layer model (Foundations / Methods / Domains) maps interestingly. If the foundation choice is the Foundations layer, then the framework choice constrains everything above. Methods — how PS Bot manages memory, how it modulates voice, how it handles the compaction metabolism — need to sit cleanly on whatever foundation is chosen. Domains — the PSSO-specific behaviors, the emotional chronicle, the earned assertiveness in context — need to emerge from the Methods layer without fighting the Foundations. The three-layer insight is: don't optimize the Foundations layer for the Domains layer. Optimize it for the Methods layer. The question isn't "which framework supports confidence-modulated prosody" — it's "which framework lets me build the memory management system that will eventually support confidence-modulated prosody."

---

## The Synthesis (Conversational, Not Conclusive)

Here's where all three agents' threads converge into something load-bearing.

The most useful reframe this play found: **the foundation choice is a memory interface choice, not a framework choice.** Every meaningful thing PS Bot wants to do eventually — the earned assertiveness, the confidence modulation, the knowing when to speak — runs through the memory layer. The voice layer (Telegram, webhooks, subprocess) is largely solved and composable from existing open-source pieces. The framework question is actually "how do I design my memory interface so it can grow from a simple JSON file today to an AM graph when that exists?"

If you accept that reframe, the Custom Build path wins on the current evidence — but not because custom build is inherently better. It wins because the SPEC.md already exists, the composable pieces are already scouted (claudegram's tool loop, chibi's tool registration, the BytesIO voice pattern from ChatGPT-Telegram-Bot), and the only part that requires a new framework is the memory integration surface, which is currently a blank interface that everything else needs to leave room for. The "custom build" isn't starting from zero — it's composing scouted pieces and deliberately leaving the memory seam open.

Hermes loses not because it's bad but because its most valuable property (the learning loop) conflicts with PS Bot's most valuable property (graph-topology-derived confidence). You'd be inheriting the skeleton while replacing the learning — which means you inherited the constraints without inheriting the benefits.

Claude Agent SDK is genuinely worth investigating as the subprocess management layer — it might provide better programmatic control over Claude's tool execution than raw subprocess. But it's not a "foundation" in the sense that changes the architecture — it's one module inside the custom build.

OpenClaw's SOUL.md is conceptually resonant (the naming alone is interesting), but the plugins/channels architecture optimizes for multi-tenant flexibility, which is the opposite of what PS Bot v1 needs (single-user, single machine, deeply integrated with one person's cognitive system).

The Frank commercial case is real but premature. The right move is probably to ship something that works for Wisdom first, let Frank test it with actual client conversations, and discover empirically what needs to change for commercial use. Building for commercial clients before you've built for the power user is building to the wrong spec.

---

## Live Questions (The Things Play Surfaced That Aren't Answered Yet)

**1. What is the actual memory interface?**
The synthesis points to "design a clean seam where AM will eventually plug in." But what does that seam look like technically? Is it an abstract Python class? A documented JSON schema? A set of tools Claude calls that have v1 (file-based) and v3 (graph-based) implementations? This question, if answered well, makes the foundation decision moot — you can swap anything underneath a well-defined interface.

**2. Is the Convergence Vision a build plan or a vision?**
The four-organ metaphor is compelling and directionally true. But Associative Memory, The Companion, and Phantom are all at different research/build maturities. If PS Bot waits for AM to exist before it can have earned confidence, it either ships a lobotomized version (confidence without graph backing) or it waits for AM. That tension needs a decision: is v1 PS Bot consciously incomplete (and labeled as such), or does it simulate earned confidence with a simple file-based proxy?

**3. Who is the actual first user — Wisdom or Frank's client?**
The two cases need fundamentally different things. This isn't a product design question — it's a resource allocation question. Building for Wisdom means building the Digital Core integration, the PSSO-grounded behaviors, the interesting novel stuff. Building for Frank's client means building reliability, opacity, and ease of onboarding. These should probably be sequenced, not parallelized. Decision needed: what is PS Bot v1, and what is PS Bot commercial?

**4. Does Claude Agent SDK change the subprocess story?**
The SPEC.md uses raw subprocess + stream-JSON. The Claude Agent SDK might provide a better programmatic interface for the same thing — programmatic session management, cleaner tool execution, possibly better support for the multi-agent coordination that the Convergence Vision eventually requires. This deserves a direct investigation before the build starts.

**5. The learning loop question that wasn't asked directly:**
Hermes's learning loop improves the agent at tasks. PS Bot's "learning" is graph densification. But is there a third kind of learning that hasn't been contemplated — where PS Bot learns Wisdom's communication patterns and PSSO framework specifically, not just facts and preferences? The emotional chronicle has a hint of this. The question is whether that's v1 or v3, and whether any existing framework has thought about it.

**6. The silence interpretability problem for commercial use:**
"Content in inaction" is a PSSO value that's load-bearing for the design. But it's currently unresolved whether this can be made interpretable to users who didn't build the system. A business client who experiences PS Bot's silence as mysterious (rather than companionable) might be solving a real problem. The answer might be: different silence contracts for different users. But that design work hasn't happened.

---

*Saved 2026-04-13. Full play from three agents. Raw — not summarized.*
