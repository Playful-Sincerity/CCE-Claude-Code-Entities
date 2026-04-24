# Think Deep: PS Bot Architecture Decision
*Generated 2026-04-13 | Phases: Research (GitHub, Web, Papers), Play, Structure, Stress Test | Depth: Deep*

---

## The Short Answer

Build a custom composition with the Claude CLI subprocess as the execution layer, not the Claude Agent SDK and not Hermes. The existing `psbot/` implementation (1,078 lines, persistent Claude CLI subprocess via stream-json) is the right foundation and is already partially built. The real decision is not "which framework" but "where to draw the memory interface seam" so that Associative Memory can eventually replace the v1 file-based store without rebuilding everything around it. Ship text-only for Wisdom first. Voice and commercial offering come after the text layer proves itself daily.

Confidence: 0.78. The challenger legitimately weakened several claims from the analyst phase. The custom build path is correct on architectural grounds, but the shipping risk is real and must be actively managed.

---

## What We Discovered

The most surprising finding was not about frameworks at all. It was that the question itself was partially a displacement activity. SPEC.md is already a complete architecture document with research citations, a lossless memory model, structured compaction as metabolism, and a clear build order. Two partial implementations already exist in the repo: `psbot/` (raw subprocess, 1,078 lines) and `psbot-sdk/` (direct Anthropic API, 1,210 lines). The foundation has been chosen twice already, in code. What is actually missing is not a decision but the discipline to finish one of them.

That said, the research produced genuinely useful findings that change the shape of the build, even if they confirm the direction.

**The memory insight is the real discovery.** Three independent research streams (academic papers, GitHub code analysis, and play synthesis) converged on the same conclusion: the foundation choice is actually a memory interface choice. Every meaningful future capability for PS Bot, from confidence-modulated prosody to Convergence integration to the commercial offering, routes through the memory layer. The framework that owns memory constrains everything downstream. This means PS Bot should own its memory explicitly, not inherit it from Hermes or any other framework. The v1 memory interface can be as simple as JSON files with a documented schema. But it must be a clean, explicit interface that can later accept the Associative Memory graph without requiring changes to the Telegram handler, the subprocess lifecycle, or the voice pipeline.

**Cross-modal voice+text persistent memory is genuinely novel.** No surveyed system, academic or production, unifies voice and text interactions in a single persistent memory store for a personal assistant. Moshi, the best real-time voice dialogue system, starts fresh every conversation. M3-Agent has entity-centric cross-modal memory but no voice. MemVerse aligns modalities but is research-stage. PS Bot's exact opportunity is the combination: persistent memory (solved separately by many systems) plus voice dialogue (solved separately by Moshi) plus cross-modal continuity (solved by nobody for this use case). This novelty is worth protecting in the architecture, which means not locking into a framework that forecloses it.

**Confidence calibration is broken at the LLM level, and this changes the voice architecture.** The Anthropomimetic Uncertainty paper (2025) demonstrates that RLHF actively penalizes hedging, making Claude systematically overconfident in its self-reported confidence. PS Bot cannot simply ask Claude "how confident are you?" and map that to prosody. A separate calibration layer is required, one that compares Claude's stated confidence against verifiable signals like retrieval quality, source recency, and contradictions in the memory graph. This is a non-trivial architectural component that didn't appear in SPEC.md and should be designed before the voice layer is built.

**GEPA is not a Hermes advantage.** The self-improvement loop that makes Hermes's marketing compelling is available to any Python project via DSPy (`dspy.GEPA`). The integration effort differs, but the capability is not locked to Hermes. More importantly, GEPA is irrelevant for v1 and probably v2 of PS Bot. It optimizes skill execution performance via execution trace analysis, which requires a stable set of skills being exercised regularly. PS Bot needs to exist and be used daily before self-improvement becomes meaningful.

**The challenger caught real weaknesses.** The strongest counter-argument was the shipping risk: custom builds are rabbithole magnets, and Wisdom has a documented tendency toward building interesting things rather than finishing useful ones. Hermes provides crash recovery, sentinel-object concurrency, and 18 platform adapters out of the box, maintained by 24 contributors. A custom build has one contributor who is also running HHA, producing events, managing multiple research projects, and learning Mandarin. The challenger estimated the Digital Core bridge to Hermes at 50-100 lines of context injection. That estimate is probably low (more like 200-400 lines to get rules, skills, hooks, and MCP working through Hermes's system prompt injection), but the maintenance burden comparison is legitimate. The mitigation is clear: treat the build as a series of independently shippable milestones, each delivering daily-use value, rather than architecting the full Convergence Vision in v1.

---

## The Landscape

### Requirements Matrix

| Requirement | Hermes Agent | Claude Agent SDK | OpenClaw | Custom Build |
|---|---|---|---|---|
| **Digital Core integration** (rules, skills, hooks, MCP) | Bridge needed (200-400 LOC) | Native (it IS Claude Code) | Reimplementation needed | Native (same filesystem, subprocess uses CLAUDE.md) |
| **Persistent subprocess** (no re-spawn per message) | Gateway daemon handles this | Session persistence (bug #809 for resumption) | Not applicable (TypeScript) | Already built in `psbot/claude_proc.py` |
| **Lossless memory** (nothing ever deleted) | SQLite WAL + memory plugins | No built-in memory | Flat files | Must build (SPEC.md designed, not implemented) |
| **Telegram integration** | Built-in adapter | No adapter (python-telegram-bot needed) | Built-in adapter | Already built in `psbot/bot.py` |
| **Multi-platform** (Telegram, Slack, WhatsApp) | 18 adapters ready | None built-in | 15+ adapters | One at a time (Telegram first) |
| **Proactive triggers** | Cron scheduler with crash safety | No scheduler | Heartbeat + cron | Must build (HEARTBEAT.md pattern to steal) |
| **Voice pipeline** (STT/TTS with prosody control) | edge-tts (basic) | None | None | Must build (independent of framework) |
| **Convergence memory seam** (AM, Companion, Phantom) | Memory provider system (partially closed) | No memory layer (maximally open) | Multi-tenant optimized | Explicitly designed open seam |
| **Crash recovery** (Mac sleep/wake) | Checkpoint restoration, validated | Unknown | Unknown | Must build |
| **Concurrency** (rapid messages) | Sentinel-object pattern, validated | Unknown | Event system | Must build |
| **Community / maintenance help** | 76K stars, 24 contributors | 6.3K stars, Anthropic-maintained | 356K stars | Solo developer |
| **Cost** | $5/month VPS or local | $36/month container (Managed Agents) or local | Local | Local |

### The Decision Axes

The matrix looks close between Hermes and Custom Build, which is why the analyst and challenger reached different conclusions. The decision turns on two axes:

**Axis 1: How much of the Digital Core must be live at runtime?**

If PS Bot just needs the *content* of CLAUDE.md, MEMORY.md, and skill files injected as context at session start, Hermes can do this with a bridge. Load the files, inject into system prompt, done. This is what SPEC.md already describes.

If PS Bot needs the *runtime behavior* of Claude Code (hooks firing on PreToolUse/PostToolUse, rules enforced by the Claude binary, MCP servers connected and dynamically managed), then only a Claude Code subprocess provides this natively.

The existing `psbot/claude_proc.py` proves that the runtime answer is already chosen: it launches `claude -p --input-format stream-json` with permission controls and tool allowlists. This IS Claude Code running, with all its Digital Core behaviors intact. The bridge question is answered in code.

**Axis 2: How much of Hermes's production engineering would you actually use?**

The sentinel-object concurrency pattern prevents race conditions when two messages arrive simultaneously. This is genuinely useful. But `psbot/claude_proc.py` already uses `asyncio.Lock()` for the same purpose (line 46, `self._lock = asyncio.Lock()`), which is simpler and sufficient for a single-user bot.

The crash recovery checkpoint system resumes background tasks after Mac sleep/wake. This is useful for a daemon that runs cron jobs. For a text bot where Wisdom sends messages and gets responses, the simpler pattern (process died, restart on next message, re-inject context) is what `psbot/claude_proc.py` already implements (lines 63-109: `_ensure_process` checks if the process is alive and relaunches if not).

The 18 platform adapters are impressive infrastructure. PS Bot needs exactly one: Telegram. It's already built.

The honest accounting: of Hermes's substantial engineering, the pieces PS Bot would actually use in v1 are the SQLite WAL pattern (worth stealing as a pattern, not as a dependency) and possibly the cron scheduler. Neither justifies adopting the full framework.

---

## Architecture Decision

**Custom Build with Claude CLI subprocess as execution layer.**

Not the Claude Agent SDK. Not raw Anthropic API. The Claude CLI binary itself, launched as a persistent subprocess with stream-json I/O. This is what `psbot/claude_proc.py` already implements, and it is the right choice.

Here is why, addressing the challenger's strongest arguments directly:

**On the Digital Core bridge cost:** The challenger estimated 50-100 lines to bridge Digital Core into Hermes via context injection. The actual work is larger because PS Bot doesn't just need the file contents; it needs Claude's behavioral runtime. When the Claude CLI loads CLAUDE.md, it doesn't just read text into context. It parses rules, applies them as behavioral constraints, fires hooks at lifecycle events, and connects to MCP servers listed in settings.json. Replicating this in Hermes would require either: (a) launching a Claude subprocess anyway (which means Hermes is just a gateway wrapper around what `psbot/` already does), or (b) manually reimplementing rule parsing, hook execution, and MCP connection management. Option (a) negates Hermes's value. Option (b) is far more than 50-100 lines and creates a parallel system that drifts from the real Digital Core.

**On the shipping risk:** This is the challenger's strongest point and it is correct. The mitigation is not architectural; it is operational. Each phase in the build plan below must deliver something Wisdom uses daily. If Phase 1 (text-only bot, basic memory) takes more than two weeks of focused work, something is wrong. The existing `psbot/` directory has 1,078 lines already written. The gap to "Wisdom can send a message from his phone and get an answer from his Digital Core" is smaller than the research phase implied.

**On the maintenance burden:** A custom build with one maintainer is a real risk. The mitigation is to minimize custom code by using well-maintained libraries for everything that is not PS Bot-specific. `python-telegram-bot` (same library Hermes uses) handles Telegram. SQLite handles persistence. The Claude CLI handles LLM interaction. The only truly custom code is: (1) the memory interface, (2) the compaction metabolism, (3) the proactive trigger system, and (4) eventually the confidence calibration layer. These are the novel parts. Everything else is library calls.

**On Managed Agents:** Claude Managed Agents (launched April 8, 2026) provides stateful persistent sessions at $0.05/hour. This is a viable hosting path for v2/commercial, not v1. For Wisdom's personal use, the bot runs locally on his Mac with zero infrastructure cost beyond API tokens. Managed Agents becomes relevant when Frank needs to deploy PS Bot instances for clients who don't have a Mac running at home.

### Adjusted Confidence Scores

Incorporating the challenger's critiques:

| Claim | Analyst Score | Challenger Adjustment | Synthesis Score | Reasoning |
|---|---|---|---|---|
| Memory interface is the real decision | 0.90 | Not challenged | 0.88 | Three-stream convergence is strong; slight reduction because "real decision" is a framing choice, not a fact |
| Digital Core alignment favors Claude subprocess | 0.92 | 0.65 | 0.82 | Challenger correctly noted bridge cost wasn't measured, but existing code in `psbot/claude_proc.py` demonstrates the runtime argument concretely |
| GEPA not a Hermes advantage | 0.95 | 0.75 | 0.82 | API availability is factual; integration equivalence is not proven; more importantly, GEPA is irrelevant for v1-v2 |
| Hermes learning loop incompatible | 0.87 | Challenged as comparing production to sketch | 0.70 | Challenger is right that AM doesn't exist yet; "incompatible" overstates "different" |
| Voice independent of framework | 0.93 | 0.80 | 0.85 | Daily.co warning is from a vendor; but the latency argument holds on first principles |
| Cross-modal memory genuinely novel | 0.88 | 0.60 | 0.75 | Survey was thorough but not exhaustive; "novel at product level" is defensible, "genuinely novel" in absolute terms is overclaimed |

---

## System Architecture Diagram

```
                          WISDOM'S MAC (local, always-on via launchd)
 ┌──────────────────────────────────────────────────────────────────────────────┐
 │                                                                              │
 │  ┌─────────────────┐     ┌──────────────────────────────────────────────┐   │
 │  │   Telegram API   │────▶│  PSBot Server (asyncio event loop)          │   │
 │  │  (via Cloudflare │◀────│                                              │   │
 │  │   Tunnel)        │     │  bot.py ─── message router                  │   │
 │  └─────────────────┘     │    │                                          │   │
 │                           │    ├── auth.py (allowlist + TOTP gate)       │   │
 │                           │    ├── injection.py (14-pattern scanner)     │   │
 │                           │    ├── formatting.py (Telegram chunking)     │   │
 │                           │    │                                          │   │
 │                           │    ▼                                          │   │
 │                           │  ┌──────────────────────────────────┐        │   │
 │                           │  │  ClaudeProcess (claude_proc.py)  │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  claude -p --input-format        │        │   │
 │                           │  │    stream-json --output-format   │        │   │
 │                           │  │    stream-json --model sonnet    │        │   │
 │                           │  │    --permission-mode acceptEdits │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  Persistent subprocess:          │        │   │
 │                           │  │  - Stays alive between messages  │        │   │
 │                           │  │  - Natively loads CLAUDE.md      │        │   │
 │                           │  │  - Fires hooks, follows rules    │        │   │
 │                           │  │  - Connects to MCP servers       │        │   │
 │                           │  │  - asyncio.Lock for concurrency  │        │   │
 │                           │  └──────────┬───────────────────────┘        │   │
 │                           │             │                                │   │
 │                           │             ▼                                │   │
 │                           │  ┌──────────────────────────────────┐        │   │
 │                           │  │  Memory Interface (memory.py)    │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  v1: JSON files + SQLite         │        │   │
 │                           │  │  v3: AM graph (clean seam)       │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  Tiers:                          │        │   │
 │                           │  │  - Context window (pinned)       │        │   │
 │                           │  │  - Ring buffer (last N turns)    │        │   │
 │                           │  │  - External store (never deleted)│        │   │
 │                           │  └──────────┬───────────────────────┘        │   │
 │                           │             │                                │   │
 │                           │             ▼                                │   │
 │                           │  ┌──────────────────────────────────┐        │   │
 │                           │  │  Persistent Storage              │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  data/state.md  (working memory) │        │   │
 │                           │  │  data/history/  (JSONL per day)  │        │   │
 │                           │  │  data/ideas/    (categorized .md)│        │   │
 │                           │  │  data/vectors.db (SQLite-vec)    │        │   │
 │                           │  └──────────────────────────────────┘        │   │
 │                           │                                              │   │
 │                           │  ┌──────────────────────────────────┐        │   │
 │                           │  │  Proactive Layer (v1.5+)         │        │   │
 │                           │  │                                  │        │   │
 │                           │  │  HEARTBEAT.md checked every 30m  │        │   │
 │                           │  │  Motivation scoring (8 heuristics│        │   │
 │                           │  │   from Inner Thoughts, CHI 2025) │        │   │
 │                           │  │  Content Inaction as default     │        │   │
 │                           │  └──────────────────────────────────┘        │   │
 │                           └──────────────────────────────────────────────┘   │
 │                                                                              │
 │  ┌──────────────────────────────────────────────────────────────────────┐   │
 │  │  Digital Core (read by Claude subprocess natively)                   │   │
 │  │                                                                      │   │
 │  │  ~/.claude/CLAUDE.md     — identity context                         │   │
 │  │  ~/.claude/rules/        — 19 behavioral rules                      │   │
 │  │  ~/.claude/skills/       — 20+ skills                               │   │
 │  │  ~/.claude/settings.json — hooks, MCP servers, permissions          │   │
 │  │  ~/.claude/projects/     — project-specific memory                  │   │
 │  └──────────────────────────────────────────────────────────────────────┘   │
 │                                                                              │
 │  ┌──────────────────────────────────────────────────────────────────────┐   │
 │  │  Voice Layer (v2+, independent module)                               │   │
 │  │                                                                      │   │
 │  │  Telegram voice note ──▶ Whisper (local) ──▶ text pipeline           │   │
 │  │                                                                      │   │
 │  │  v3: Full duplex voice                                               │   │
 │  │  STT (Deepgram/Cartesia) ──▶ Claude ──▶ Calibration Layer           │   │
 │  │    ──▶ NVSpeech tokens ──▶ Chatterbox Turbo TTS                     │   │
 │  │  Hardcoded tools (not MCP) for latency                              │   │
 │  └──────────────────────────────────────────────────────────────────────┘   │
 │                                                                              │
 │  ┌──────────────────────────────────────────────────────────────────────┐   │
 │  │  Convergence Seam (v3+, designed now, built later)                   │   │
 │  │                                                                      │   │
 │  │  Memory Interface ◄──── Associative Memory graph                    │   │
 │  │  Confidence Signal ◄──── AM graph topology density                  │   │
 │  │  Behavioral Rules  ◄──── Companion permission-as-consciousness     │   │
 │  │  Visual Context    ◄──── Phantom perception                        │   │
 │  └──────────────────────────────────────────────────────────────────────┘   │
 └──────────────────────────────────────────────────────────────────────────────┘
```

---

## Digital Core Integration Spec

### How PS Bot Reads from Digital Core

The Claude CLI subprocess natively loads the Digital Core because it IS Claude Code. When `claude_proc.py` launches `claude -p --input-format stream-json`, the binary:

1. Reads `~/.claude/CLAUDE.md` and all project-level CLAUDE.md files (based on `--cwd`)
2. Loads all rules from `~/.claude/rules/` and enforces them as behavioral constraints
3. Loads skills from `~/.claude/skills/` (available via slash commands in the conversation)
4. Connects to MCP servers defined in `~/.claude/settings.json`
5. Fires hooks at lifecycle events (PreToolUse, PostToolUse, UserPromptSubmit, Stop)
6. Reads project-specific memory from `~/.claude/projects/`

No bridge code is needed. The integration is free.

### How PS Bot Writes Back to Digital Core

PS Bot should not write to most Digital Core files. The permission model:

| Target | Permission | Mechanism | Rationale |
|---|---|---|---|
| `~/remote-entries/` | **Append-only** | Direct file write | Ideas, reflections, people captured remotely |
| `data/history/` | **Append-only** | JSONL logging per day | Raw conversation archive |
| `data/state.md` | **Read + overwrite** | Claude manages via tools | Working memory, rewritten on compaction |
| `data/ideas/` | **Append-only** | `/idea` command handler | Categorized idea capture |
| `~/.claude/projects/.../memory/` | **Add + update own** | Claude's native memory system | Facts learned in conversation |
| `~/Wisdom Personal/people/` | **Add + update** | People profiles rule | New people or updated info |
| `chronicle/` | **Append-only** | Semantic logging rule | Session chronicles |
| `~/.claude/CLAUDE.md` | **Read-only** | Never write | Identity context, desk-edit only |
| `~/.claude/rules/` | **Read-only** | Never write | Behavioral rules, need explicit approval |
| `~/.claude/skills/` | **Read-only** | Never write | Skills, desk-edit only |
| `~/.claude/settings.json` | **Read-only** | Never write | Config, desk-edit only |
| `~/claude-system/` | **Read-only** | Never write | Core infrastructure |

### Sync Mechanism

The Digital Core lives on disk. The Claude subprocess reads it at launch. For long-running sessions:

- **Rules and CLAUDE.md:** Read once at subprocess launch. If Wisdom edits rules at his desk, the bot picks them up on next subprocess restart (which happens after idle timeout or manual `/clear`).
- **Memory files:** Read dynamically via Claude's native memory tools.
- **Remote entries:** Written directly to `~/remote-entries/YYYY-MM-DD/`. Wisdom's desk sessions read these naturally.
- **No git, no pull, no rsync.** Everything is on the same filesystem. The simplicity is the feature.

### The `--cwd` Question

The Claude subprocess should run with `--cwd` set to the PS Bot project directory (`~/Playful Sincerity/PS Software/PS Bot/`). This means it loads the PS Bot project-specific CLAUDE.md, which defines the remote entry behavior, Telegram-specific formatting rules, and bot-specific constraints. The global CLAUDE.md (ecosystem context) loads automatically as well.

---

## Voice Integration Plan

### Principle: Text First, Voice as Independent Module

Voice is architecturally independent of the text layer. SPEC.md is right about this: voice notes come in as audio, get transcribed to text, enter the same pipeline, and responses go out as text. The interesting voice work (confidence-modulated prosody, full-duplex dialogue) is a separate module that plugs into the memory interface, not into the Telegram handler.

### Phase 1: Voice Notes In (v1.5)

```
Telegram voice note ──▶ download OGG ──▶ ffmpeg ──▶ WAV
                     ──▶ Whisper (local, base/small model)
                     ──▶ transcript text ──▶ same message pipeline
                     ──▶ response as text
```

This is already specified in SPEC.md and requires only `openai-whisper` plus `ffmpeg`. No API calls. No data leaving the machine. Implementation: approximately 80-120 lines of Python wrapping the Whisper model and the audio format conversion.

### Phase 2: Voice Responses Out (v2)

```
Claude response text ──▶ TTS (Chatterbox Turbo, local)
                     ──▶ OGG audio ──▶ Telegram voice message
```

Local TTS, no API dependency. Chatterbox Turbo provides voice cloning and prosody control. This phase adds outbound voice without the confidence calibration layer.

### Phase 3: Confidence-Modulated Prosody (v3, requires AM)

```
Claude response ──▶ Confidence Calibration Layer
                     │
                     ├── Compare stated confidence vs. retrieval quality
                     ├── Check source recency in memory graph
                     ├── Detect contradictions in knowledge base
                     │
                     ▼
                 Calibrated confidence score (0-1)
                     │
                     ▼
                 Prosody Parameter Mapping
                     │
                     ├── Score 0.0-0.3: pause (1-4s) + "um" token + rising intonation (+8-13 semitones)
                     ├── Score 0.3-0.6: shorter pause + level intonation + moderate speech rate
                     ├── Score 0.6-0.8: no pause + falling intonation + confident rate
                     ├── Score 0.8-1.0: emphatic falling intonation + firm rate + no hedging
                     │
                     ▼
                 NVSpeech paralinguistic tokens inserted into TTS input
                     │
                     ▼
                 Chatterbox Turbo renders audio with prosodic markers
```

This phase depends on:
1. The Associative Memory graph existing and providing topology-derived confidence
2. The calibration layer being designed (compensating for RLHF-induced overconfidence)
3. NVSpeech integration with Chatterbox Turbo being validated

These dependencies are v3 work. Designing the memory interface seam now (Phase 1 of the build plan) ensures the seam exists when this phase arrives.

### Voice Architecture Split: MCP vs. Hardcoded

Daily.co's explicit recommendation (from practitioners building production voice agents): "Skip MCP unless specifically required; hard-code tools instead." Tool calls double LLM latency; MCP adds another layer on top of that. For voice, where the target is under 800ms end-to-end:

- **Text/async operations:** Use MCP. The latency is acceptable and the flexibility is valuable.
- **Voice pipeline:** Hardcode tools. STT, TTS, and prosody mapping run as direct Python function calls, not through MCP server round-trips.

This creates a split architecture that is explicit in the codebase: `tools/` for hardcoded voice tools, MCP servers for everything else.

---

## Frank's User Journey

Frank is a salesman, not a technologist. His interaction with PS Bot, and eventually his clients' interaction with a PS Bot instance, must be invisible infrastructure. Here are the specific scenarios mapped to architecture components:

### Scenario 1: Frank Logs a Sales Call

**What Frank does:** Opens Telegram, sends a voice note: "Just got off a call with Eric at Zoox. He's interested in the institutional memory consulting package. Wants a proposal by Friday. Budget probably 50-80K for a pilot."

**What PS Bot does:**
1. Voice note received by `bot.py` message handler
2. Audio downloaded, transcribed by Whisper (v1.5+ for voice; before that, Frank types)
3. Transcript enters the Claude subprocess
4. Claude, following Digital Core rules, recognizes this as remote entry material
5. Files to `~/remote-entries/YYYY-MM-DD/eric-zoox-call.md` with frontmatter
6. Updates Eric Jennings's people profile if new info
7. Responds: "Captured. Eric at Zoox wants a proposal by Friday, $50-80K pilot range. Filed and updated Eric's profile."

**Architecture components involved:** `bot.py` (Telegram handler), `voice.py` (Whisper transcription), `claude_proc.py` (subprocess), Digital Core rules (remote-entry-filing.md, people-profiles.md), filesystem writes.

### Scenario 2: Frank Asks a Pipeline Question

**What Frank does:** Types: "What's our pipeline looking like? Any hot leads?"

**What PS Bot does:**
1. Message enters Claude subprocess
2. Claude has access to MCP tools, can read files, search the filesystem
3. Reads HHA pipeline data from the relevant directories
4. Summarizes: active prospects, stages, last contact dates, next actions
5. Formats as a clean Telegram message (under 4096 chars, markdown)

**Architecture components involved:** `bot.py`, `claude_proc.py`, MCP file tools, formatting.py (Telegram chunk splitting).

### Scenario 3: Frank Wants to Draft an Outreach Message

**What Frank does:** Types: "Draft a follow-up to Vince about the medical AI workflow we discussed. Keep it warm but specific."

**What PS Bot does:**
1. Claude reads Vince's people profile and any previous outreach history
2. Draws on HHA brand voice and outreach framing rules
3. Drafts a message
4. Sends it as a Telegram message for Frank to review, copy, and send himself
5. PS Bot does NOT send the message directly to Vince (that's a human decision)

**Architecture components involved:** `bot.py`, `claude_proc.py`, people profiles, HHA-specific context.

### The Commercial Pivot (v2+)

For Frank's clients (not Frank himself), the architecture changes:

- **Multi-instance:** Each client gets their own PS Bot instance with their own memory store, their own identity context, their own tool permissions. This is where Managed Agents (stateful containers at $0.05/hour) becomes relevant.
- **Simplified onboarding:** No Digital Core, no CLAUDE.md with 19 rules. A condensed identity document (like OpenClaw's SOUL.md pattern) that captures the client's business context.
- **Reliability contract:** The commercial instance uses a conservative configuration: fewer tools, no bash access, no experimental features. Silence is explained via a brief "participation contract" shown during onboarding.
- **Billing:** Per-seat monthly subscription ($50-100/month/user), which covers container hosting ($36/month) plus API tokens plus margin.

This is v2+ architecture. Building it into v1 would compromise both the power-user experience (too constrained) and the commercial experience (too complex). The sequencing matters.

---

## Phase 1 Build Plan

### What Exists Already

Two partial implementations, each approaching the problem differently:

- **`psbot/`** (1,078 lines): Persistent Claude CLI subprocess via stream-json. Has: bot.py (303 lines, Telegram handler with command routing), claude_proc.py (253 lines, subprocess lifecycle with lock, stderr drain, init event parsing), auth.py (59 lines, TOTP + allowlist), injection.py (138 lines, 14-pattern prompt injection scanner), config.py, formatting.py, model_router.py, streaming.py.

- **`psbot-sdk/`** (1,210 lines): Direct Anthropic API via `AsyncAnthropic`. Has: conversation.py (273 lines, message history, system prompt building, tool use loop), bot.py (238 lines, Telegram handler), tools.py (136 lines, save/update_state/run_bash), history.py (67 lines, JSONL logging), state.py (84 lines, state document read/write), plus shared auth.py, injection.py, formatting.py.

**The right path:** Consolidate on `psbot/` (the CLI subprocess approach). It provides native Digital Core integration, which is the primary architectural requirement. The `psbot-sdk/` approach (direct Anthropic API) loses all Digital Core runtime behavior. The useful pieces from `psbot-sdk/` to port: the tool definitions from `tools.py`, the state management from `state.py`, and the conversation history logging from `history.py`. These are small, self-contained modules.

### Build Phases

**Phase 0: Consolidate and Ship MVP (Target: 1-2 weeks)**

Goal: Wisdom can send a text message from Telegram and get an answer from his Digital Core.

1. Verify `psbot/` works end-to-end: send message, get response, Telegram formatting correct
2. Port `state.py` and `history.py` from `psbot-sdk/` into `psbot/` (state document + conversation logging)
3. Add tool exposure: give the Claude subprocess the `save()`, `update_state()`, and `run_bash()` tools via allowed-tools configuration
4. Set up Cloudflare Tunnel for webhook delivery
5. Create launchd plist for auto-start on boot
6. Write the `/idea`, `/status`, `/clear`, `/compact` command handlers (partially done in bot.py)

Verification: Wisdom uses PS Bot daily for at least one week. Ideas captured, questions answered, subprocess persists between messages, recovers from Mac sleep.

**Phase 1: Memory Interface (Target: 1 week after Phase 0)**

Goal: Define and implement the memory interface that v3 will swap to AM.

1. Define `MemoryInterface` abstract class:
   - `read_context() -> str` (return relevant context for current query)
   - `write_interaction(role, content, metadata) -> None` (store a turn)
   - `retrieve(query, k=5) -> list[Memory]` (semantic search)
   - `compact(budget_tokens) -> str` (produce a compressed state document)
2. Implement `FileMemory(MemoryInterface)` as v1: JSON files for structured data, JSONL for history, state.md for working memory
3. Later: implement `GraphMemory(MemoryInterface)` when AM exists. Same interface, different backend.

Verification: Memory interface is tested with both a flat-file backend and a mock graph backend. The interface contract is documented.

**Phase 2: Proactive Triggers (Target: 1 week after Phase 1)**

Goal: PS Bot surfaces relevant information without being asked.

1. Implement HEARTBEAT.md: a markdown file checked every 30 minutes by a background asyncio task
2. When tasks are listed in HEARTBEAT.md, the Claude subprocess executes them and delivers results to Telegram
3. Implement motivation scoring from Inner Thoughts (CHI 2025): 8 heuristics evaluated via a lightweight LLM call before deciding to speak
4. Content Inaction as default: threshold set high initially, tuned based on experience

Verification: PS Bot sends at least one proactive message per day that Wisdom finds useful. Noise rate (unwanted proactive messages) below 20%.

**Phase 3: Voice Notes In (Target: 1 week after Phase 2)**

Goal: Wisdom can send voice notes and get text responses.

1. Add Whisper (local, `base` or `small` model) for transcription
2. Handle Telegram voice note format (OGG Opus): download, convert via ffmpeg, transcribe
3. Transcript enters the same text pipeline
4. Response delivered as text (voice out comes later)

Verification: Voice note transcribed and answered correctly. Latency under 10 seconds for a 30-second voice note on Mac hardware.

**Phase 4: Compaction Metabolism (Target: ongoing refinement)**

Goal: Context never fills up and conversations never lose coherence.

This is already designed in SPEC.md. Implementation:

1. Claude actively externalizes to `state.md` during conversation (continuous, not threshold-triggered)
2. At 85% token budget: save state, kill subprocess, restart with fresh context injected from state.md + last 5 messages
3. Ring buffer of last 15 turns always in context
4. State document structured by section (active projects, open threads, recent ideas, key decisions, current focus)

Verification: A conversation that runs for 100+ turns maintains coherence across compaction boundaries. State document accurately reflects what was discussed.

### What Is Explicitly Deferred

- Voice responses out (TTS): Phase 3+ work, after voice-in is proven useful
- Confidence-modulated prosody: Requires AM (v3)
- Multi-platform (Slack, WhatsApp): After Telegram is stable
- Commercial deployment: After Wisdom uses it daily for 30+ days
- GEPA self-improvement: After skills are stable enough to optimize
- Managed Agents hosting: After commercial offering is designed

---

## Commercial Offering Spec

### Positioning

PS Bot for commercial clients is not a general-purpose chatbot. It is a **persistent AI assistant that knows your business deeply** because it accumulates context over time, across voice and text, and uses that context to proactively surface relevant information. The value proposition is integration depth, not interface novelty. The product failures of 2025 (Dot, Humane, Rabbit) all tried to compete on novelty. PS Bot competes on knowing you better than any alternative.

### What Frank Can Sell (v2+)

**Product: Intelligent Business Assistant**

- Personal AI assistant deployed for a team or individual
- Learns business context over time through natural conversation
- Proactive: surfaces relevant information, drafts follow-ups, logs calls
- Voice + text interaction via existing messaging apps (Telegram, Slack, WhatsApp)
- Privacy-first: client data stays on their infrastructure or in dedicated containers

**Pricing Model:**

| Tier | Price | Includes |
|---|---|---|
| Solo | $79/month | 1 user, 1 platform, text-only, 500 messages/month |
| Team | $199/month | Up to 5 users, shared memory, 2,000 messages/month |
| Enterprise | $499+/month | Custom deployment, voice, dedicated container, custom tools |
| Workshop/Audit | $3,000-$8,000 one-time | Day-long audit of team workflows, PS Bot trial, execution proposal |

The workshop-first GTM (from HHA strategy) applies: lead with a day-long audit workshop, demonstrate PS Bot live, upsell the subscription. Frank has past experience with this format.

### Deployment Model

**Personal / Solo:** Managed Agent container ($36/month infrastructure) plus API tokens (~$20-50/month at moderate usage). Margin: ~$20/month on Solo tier. Not sustainable at small scale.

**Team / Enterprise:** Dedicated container or VPS. Infrastructure cost scales sub-linearly (one container serves multiple users). At $499/month Enterprise with $50/month infrastructure cost, margin improves.

**The real margin is in setup and customization.** The assistant itself is a recurring-revenue base. The high-margin work is: (1) the initial workshop/audit, (2) custom tool development (connecting PS Bot to client-specific systems), and (3) ongoing optimization.

### The Apprentice Model

PS Bot commercial instances follow the "apprentice" model: they start knowing nothing about the client, learn through conversation over the first 2-4 weeks, and become increasingly useful as context accumulates. This is a feature, not a bug. The onboarding conversation explicitly says:

"I'm your new assistant. I don't know your business yet, but I learn fast. The more you talk to me, the more useful I become. In two weeks, I'll know your pipeline, your contacts, your preferences, and your patterns."

This sets expectations correctly (don't expect magic on day one) and creates a retention hook (switching costs increase as the memory graph densifies).

---

## Open Threads

### Must Resolve Before Building

1. **Which implementation to consolidate on.** This document recommends `psbot/` (CLI subprocess). The `psbot-sdk/` approach has useful modules to port. A focused 2-hour session should merge the best of `psbot-sdk/` into `psbot/` and archive `psbot-sdk/`.

2. **Cloudflare Tunnel vs. ngrok.** SPEC.md notes Cloudflare is free and more stable. Confirm that Cloudflare Tunnel works with the Telegram webhook URL pattern and that it survives Mac sleep/wake.

3. **Whisper model size.** `base` is fast but less accurate. `small` is better for voice notes with ambient noise. Test on actual voice notes Wisdom records.

### Worth Exploring Further

4. **The memory interface contract in code.** The abstract class described in Phase 1 needs to be written and tested with both backends before building anything else on top of it. This is a 30-minute focused design session that prevents months of misalignment.

5. **Agent SDK's session-resumption bug (issue #809).** The existing `psbot/` approach sidesteps this entirely by using the Claude CLI directly, not the Agent SDK. But if the Agent SDK later offers features that the raw CLI does not (programmatic hook registration, fork/delete session control), this bug matters. Worth monitoring.

6. **Managed Agents as commercial hosting.** Claude Managed Agents (April 8, 2026) provides stateful persistent sessions at $0.05/hour. For commercial deployment, this could replace the "run a VPS" model entirely. Anthropic handles infrastructure; PS Bot becomes a configuration + memory layer on top. Worth evaluating once the commercial offering is designed.

7. **The silence interpretability problem.** Content Inaction (silence as default) works for Wisdom, who built the system and understands it. For commercial clients, silence is mysterious. The Inner Thoughts motivation scoring system provides the mechanism (score above threshold = speak), but the "participation contract" (what the client is told about when and why the bot speaks or stays silent) needs to be designed before commercial launch.

8. **The calibration layer design.** RLHF makes Claude systematically overconfident. Before voice Phase 3, a calibration approach must be designed: comparing stated confidence against retrieval quality, source recency, and memory graph topology. This is novel work with no existing reference implementation.

9. **Whether the existing `psbot/` code actually works.** The challenger identified this blind spot: the research produced a thorough analysis of external frameworks while potentially ignoring evidence in the repo. The first action item is: run `psbot/`, send it a message, and observe what happens.

---

## Sources & Methodology

### Research Streams

Five parallel research streams ran, each producing a detailed output saved as a separate agent file:

| Stream | Agent Output | Key Contribution |
|---|---|---|
| **GitHub Research** | [`agents/research-github.md`](agents/research-github.md) | Deep code-level analysis of Hermes Agent (76K stars), Claude Agent SDK (6.3K stars), OpenClaw (356K stars), plus nanobot (39K stars) and claude-code-telegram (2.4K stars) as discovered alternatives. Identified sentinel-object pattern, HEARTBEAT.md, skill system similarities. |
| **Web Research** | [`agents/research-web.md`](agents/research-web.md) | Surveyed competing AI assistants (Dot shutdown, Kin memory, Limitless acquisition), voice production stacks (Pipecat, Vapi, LiveKit, ElevenLabs, Hume EVI), MCP ecosystem coverage, Managed Agents launch, commercial deployment models. Critical finding: Daily.co's "skip MCP for voice" recommendation. |
| **Papers Research** | [`agents/research-papers.md`](agents/research-papers.md) | 18+ academic papers across cross-modal memory (M3-Agent, Memoria, MemVerse), confidence prosody (NVSpeech, Anthropomimetic Uncertainty), self-improvement (GEPA, ARIA), and proactive agents (Inner Thoughts). Key findings: cross-modal memory is genuinely novel; RLHF breaks confidence calibration; GEPA available via DSPy. |
| **Play Synthesis** | [`agents/play-synthesis.md`](agents/play-synthesis.md) | Three play agents (Thread-Follower, Paradox-Holder, Pattern-Spotter) explored tensions. Central reframe: "the foundation choice is a memory interface choice." Surfaced the two-user paradox, the "can you build voice before mind" question, and the displacement hypothesis (SPEC.md is already good; what's missing is shipping). |
| **Structure + Challenge** | [`agents/structure.md`](agents/structure.md), [`agents/challenger.md`](agents/challenger.md) | Analyst organized findings into insight map, frameworks, decision landscape, assumptions. Challenger identified unsupported claims (Digital Core bridge cost unmeasured, learning loop "incompatibility" tested against a sketch), missing perspectives (solo maintainer burden, shipping risk, Managed Agents as distinct option), and contradictions (memory as key criterion vs. SDK recommended on Digital Core grounds). |

### How Play Contributed

The play phase produced the session's most generative insight: the displacement hypothesis. The Thread-Follower noticed that SPEC.md is already architecturally complete with research citations, and that two partial implementations already exist. The "which framework?" question was partially masking "why haven't I shipped this?" The Paradox-Holder held the two-user tension (Wisdom vs. Frank's clients) without resolving it, which led to the sequencing recommendation. The Pattern-Spotter applied the musician/DAW analogy: build the irreducible gap (memory interface seam), not the full custom instrument.

### What the Challenger Caught

The challenger's most valuable contribution was the steel-manned Hermes case: "the Digital Core bridge is probably 50-100 lines; in exchange, you get crash recovery, concurrency, crash-safe cron, and a 76K-star community maintaining it, for a solo developer who has competing priorities and a documented tendency toward rabbitholes." This forced the synthesis to engage with the shipping risk directly rather than hand-waving it. The adjusted confidence scores throughout this document reflect the challenger's calibration work.

The challenger also identified a critical blind spot: the existing `psbot/` and `psbot-sdk/` implementations were never examined by the research streams. This synthesis partially addressed this by reading the code, but the first real action item remains: run the existing code and see what happens.

---

*This document is the deliverable from a Think Deep session on PS Bot's architecture decision. All claims are traceable to the agent output files in `agents/`. The recommendation is actionable today: consolidate on `psbot/`, run it, ship Phase 0 in two weeks.*
