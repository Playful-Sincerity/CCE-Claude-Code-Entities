# KAIROS Source Analysis — Claude Code Internals
**Date:** 2026-04-15  
**Sources:** `/Users/wisdomhappy/claude-code-main/src/`  
**Purpose:** Architectural deep-dive into KAIROS — what it is, how it activates, and how its subsystems compose.

---

## 1. What KAIROS Is

KAIROS is Claude Code's **persistent assistant / autonomous agent mode**. It is the internal codename for a build-time feature bundle (`feature('KAIROS')`) that transforms Claude Code from a turn-by-turn assistant into a long-lived, continuously-running entity capable of:

- Receiving autonomous **tick/heartbeat prompts** between user interactions
- Maintaining **append-only daily logs** rather than per-session discrete memories
- Running a nightly **dream/consolidation** process that distills logs into a structured MEMORY.md index
- Firing **scheduled cron tasks** on a 1-second check loop, persisted to `.claude/scheduled_tasks.json`
- Using **BriefTool (SendUserMessage)** as its exclusive user-facing output channel — all text flows through this tool, not plain text responses

In plain terms: KAIROS is the "always-on assistant" mode that powers an assistant daemon — Claude running persistently in the background, waking up on a tick, doing work, sleeping, repeating — rather than answering one question at a time.

### Feature Flag Architecture

KAIROS uses Bun's bundle-time dead code elimination:

```typescript
// src/main.tsx:78-81
const assistantModule = feature('KAIROS') 
  ? require('./assistant/index.js') 
  : null;
const kairosGate = feature('KAIROS') 
  ? require('./assistant/gate.js') 
  : null;
```

The `feature('KAIROS')` call is a compile-time constant. In external builds, the entire KAIROS module graph is eliminated. The `assistant/` directory is only accessible in KAIROS builds. Note: the `src/assistant/` directory in the source dump only contains `sessionHistory.ts` (the remote session history loader for the cloud-connected assistant), indicating that the core `assistant/index.js` and `assistant/gate.js` are either bundled differently or were not included in this source snapshot.

There are also two sibling flags:
- `feature('KAIROS_BRIEF')` — ships BriefTool independently without requiring full KAIROS
- `feature('PROACTIVE')` — the original proactive/autonomous-tick experiment; KAIROS shares this code path via `feature('PROACTIVE') || feature('KAIROS')` guards

---

## 2. Activation Sequence

KAIROS activates through a specific decision tree in `src/main.tsx`:

**File:** `src/main.tsx`, lines 1048–1088

```typescript
let kairosEnabled = false;
if (feature('KAIROS') && assistantModule?.isAssistantMode() && !agentId && kairosGate) {
  if (!checkHasTrustDialogAccepted()) {
    console.warn('Assistant mode disabled: directory is not trusted.');
  } else {
    // Blocking gate check — cached true instantly, lazily fetches GB if missing
    kairosEnabled = assistantModule.isAssistantForced() 
      || (await kairosGate.isKairosEnabled());
    if (kairosEnabled) {
      opts.brief = true;          // Force brief mode on
      setKairosActive(true);      // Sets STATE.kairosActive
      assistantTeamContext = await assistantModule.initializeAssistantTeam();
    }
  }
}
```

**Gate chain (cheapest first):**
1. Build flag: `feature('KAIROS')` — compile-time constant, eliminates branch in non-KAIROS builds
2. Assistant mode detection: `assistantModule.isAssistantMode()` — checks environment/settings for assistant daemon context
3. Not a spawned teammate: `!agentId` — spawned teammate processes skip KAIROS re-init
4. Trust dialog: `checkHasTrustDialogAccepted()` — directory must be trusted
5. GrowthBook gate: `kairosGate.isKairosEnabled()` — runtime flag `tengu_kairos` with disk cache fallback

When the `--assistant` CLI flag is passed, `assistantModule.markAssistantForced()` is called first, bypassing the GrowthBook gate entirely (daemon is pre-entitled).

**What gets set:**
- `STATE.kairosActive = true` — the boolean that all downstream subsystems check
- BriefTool forced on (`opts.brief = true`)
- An assistant team context initialized (for spawning teammates without TeamCreate)

### Runtime State: `getKairosActive()`

**File:** `src/bootstrap/state.ts`, lines 1085–1091

```typescript
export function getKairosActive(): boolean {
  return STATE.kairosActive  // defaults false
}
export function setKairosActive(value: boolean): void {
  STATE.kairosActive = value
}
```

This is the single source of truth queried by all KAIROS-aware subsystems throughout the codebase (84 file references).

---

## 3. The Tick/Heartbeat Loop

The proactive tick is the heartbeat mechanism that keeps KAIROS alive between user interactions.

**File:** `src/constants/prompts.ts`, `getProactiveSection()`, lines 860–914

When `isProactiveActive()` returns true (which requires `feature('PROACTIVE') || feature('KAIROS')`), the system prompt includes an **autonomous work section** that instructs the model:

```
You will receive `<tick>` prompts that keep you alive between turns — 
just treat them as "you're awake, what now?" The time in each `<tick>` 
is the user's current local time.

Multiple ticks may be batched into a single message. This is normal — 
just process the latest one. Never echo or repeat tick content in your response.
```

The tick tag is defined at `src/constants/xml.ts` as `TICK_TAG`. The REPL.tsx processes sleep progress as ephemeral (filtered from display) when proactive/KAIROS is active:

**File:** `src/utils/sessionStorage.ts`, lines 190–193
```typescript
const EPHEMERAL_PROGRESS_TYPES = new Set([
  'bash_progress', 'powershell_progress', 'mcp_progress',
  ...(feature('PROACTIVE') || feature('KAIROS') ? ['sleep_progress'] : []),
])
```

Sleep progress ticks are hidden from the user's transcript view — the model's "still alive, nothing to do, sleeping" cycles are invisible.

### REPL Integration

**File:** `src/screens/REPL.tsx`, line 4053
```typescript
// Assistant mode bypasses the isLoading gate — the tick → Sleep → tick loop
// would otherwise starve the scheduler.
const assistantMode = store.getState().kairosEnabled;
```

The cron scheduler is initialized with `assistantMode: true` in KAIROS sessions, bypassing the `isLoading` gate that would block the scheduler from firing during active queries. This is what makes KAIROS sessions function as a true daemon — the scheduler keeps running even when Claude is "thinking."

---

## 4. The Dream / Consolidation System

The dream system is background memory consolidation. It fires a forked subagent to synthesize recent sessions into durable memories.

### autoDream.ts — The Coordinator

**File:** `src/services/autoDream/autoDream.ts`

**Gate function** (lines 95–100):
```typescript
function isGateOpen(): boolean {
  if (getKairosActive()) return false  // KAIROS uses disk-skill dream, not autoDream
  if (getIsRemoteMode()) return false
  if (!isAutoMemoryEnabled()) return false
  return isAutoDreamEnabled()
}
```

**Critical insight:** `autoDream` is deliberately gated OFF in KAIROS mode. In KAIROS, the dream is a separately installed skill (`/dream`) that runs on a cron schedule written to `scheduled_tasks.json`. In non-KAIROS mode, `autoDream` runs automatically after turns when gates pass.

**Three-gate check (cheapest first):**
1. Time gate: `(Date.now() - lastConsolidatedAt) / 3_600_000 >= minHours` (default: 24h) — one file stat
2. Session gate: count sessions touched since last consolidation >= minSessions (default: 5) — directory scan
3. Lock gate: `tryAcquireConsolidationLock()` — prevents parallel consolidations

When all gates pass, it fires `runForkedAgent()` — a completely isolated subprocess — with the consolidation prompt.

**GrowthBook config** (`tengu_onyx_plover`):
- `minHours`: minimum hours between dreams (default: 24)
- `minSessions`: minimum new sessions required (default: 5)

Scan throttle prevents hammering the filesystem when time gate passes but session gate doesn't: `SESSION_SCAN_INTERVAL_MS = 10 * 60 * 1000` (10 minutes between scans).

### consolidationPrompt.ts — What the Dream Agent Does

**File:** `src/services/autoDream/consolidationPrompt.ts`

The dream agent receives a four-phase prompt:

**Phase 1 — Orient:** `ls` memory directory, read MEMORY.md index, skim topic files  
**Phase 2 — Gather recent signal:** prioritizes daily logs (`logs/YYYY/MM/YYYY-MM-DD.md`), then existing memories that drifted, then targeted transcript search (never exhaustive reading)  
**Phase 3 — Consolidate:** merge new signal into existing topic files, convert relative dates to absolute dates, delete contradicted facts  
**Phase 4 — Prune and index:** update MEMORY.md index, keep it under 200 lines and 25KB, each entry one line under ~150 chars

The consolidation prompt is extracted from `dream.ts` (behind KAIROS feature gates) into `consolidationPrompt.ts` so `autoDream` can ship independently without pulling in the KAIROS-gated `dream.ts`.

**Tool constraints for the forked dream agent** (auto-dream run):
```
Bash is restricted to read-only commands (ls, find, grep, cat, stat, wc, head, tail).
```

The dream agent cannot write except through FileEdit/FileWrite tools — it reads transcripts via grep only, never loading entire JSONL files.

---

## 5. The Memdir (Memory Directory) System

The memdir is Claude Code's file-based persistent memory architecture. It's the substrate that KAIROS builds its extended memory on.

### Paths and Resolution

**File:** `src/memdir/paths.ts`

```
getAutoMemPath() → ~/.claude/projects/<sanitized-git-root>/memory/
```

Resolution order:
1. `CLAUDE_COWORK_MEMORY_PATH_OVERRIDE` env var (Cowork sessions)
2. `autoMemoryDirectory` in settings.json (user/local/policy only — NOT projectSettings for security)
3. Default: `<memoryBase>/projects/<sanitized-canonical-git-root>/memory/`

The canonical git root is used (not cwd) so all worktrees of the same repo share one memory directory.

**Daily log path** (KAIROS-specific):
```typescript
// src/memdir/paths.ts:246
getAutoMemDailyLogPath() → <autoMemPath>/logs/YYYY/MM/YYYY-MM-DD.md
```

### KAIROS vs Standard Memory Mode

**File:** `src/memdir/memdir.ts`, `loadMemoryPrompt()`, lines 432–438

```typescript
// KAIROS daily-log mode takes precedence over TEAMMEM
if (feature('KAIROS') && autoEnabled && getKairosActive()) {
  logMemoryDirCounts(getAutoMemPath(), { memory_type: 'auto' })
  return buildAssistantDailyLogPrompt(skipIndex)
}
```

In **standard mode**, Claude maintains `MEMORY.md` as a live index with topic files, updated directly during sessions.

In **KAIROS mode**, Claude writes append-only to `logs/YYYY/MM/YYYY-MM-DD.md`:

```
buildAssistantDailyLogPrompt() instructs Claude to:
- Append timestamped bullets to today's daily log (never rewrite or reorganize)
- Create the file if it doesn't exist
- Roll over to a new day's file at midnight
- Treat MEMORY.md as read-only (maintained nightly by the /dream skill)
```

This is the fundamental architectural difference: KAIROS sessions accumulate raw observations into daily logs; the separate `/dream` skill distills them nightly into MEMORY.md.

**MEMORY.md constraints:**
- Max 200 lines (`MAX_ENTRYPOINT_LINES`)
- Max ~25KB (`MAX_ENTRYPOINT_BYTES`)
- Each entry: one line under ~150 chars: `- [Title](file.md) — one-line hook`

### Memory Enabling Logic

**File:** `src/memdir/paths.ts`, `isAutoMemoryEnabled()`, lines 30–55

Disabled by: `CLAUDE_CODE_DISABLE_AUTO_MEMORY`, `CLAUDE_CODE_SIMPLE` (bare mode), CCR without persistent storage. Otherwise enabled by default. Settings allow project-level opt-out.

---

## 6. Cron Scheduling System

The cron system allows Claude to schedule its own future prompts — the mechanism by which KAIROS maintains its autonomous tick loop and recurring tasks.

### Task Storage

**File:** `src/utils/cronTasks.ts`

Tasks live in `<project>/.claude/scheduled_tasks.json`:

```json
{
  "tasks": [
    {
      "id": "a3f1b2c4",
      "cron": "0 9 * * *",
      "prompt": "Morning check-in",
      "createdAt": 1744891200000,
      "lastFiredAt": 1744891200000,
      "recurring": true,
      "permanent": true
    }
  ]
}
```

**Task types:**
- `recurring: false` — one-shot, auto-deleted on fire
- `recurring: true` — reschedules from now after firing
- `permanent: true` — exempt from 7-day auto-expiry (system escape hatch for KAIROS built-in tasks: catch-up, morning-checkin, dream)
- `durable: false` — runtime-only, session-scoped, never written to disk

**KAIROS permanent tasks** (installed at setup, not recreatable):
- Catch-up task
- Morning check-in task  
- Dream/consolidation task

These are written by `src/assistant/install.ts` via `writeIfMissing()` — if already present, install skips them, preventing accidental recreation.

### The Scheduler Engine

**File:** `src/utils/cronScheduler.ts`

The `createCronScheduler()` function creates a scheduler that:

1. Polls on a **1-second interval** (`CHECK_INTERVAL_MS = 1000`)
2. Watches `.claude/scheduled_tasks.json` via **chokidar** file watcher for live updates
3. Uses a **session lock** to prevent double-firing when multiple Claude processes share a cwd (`cronTasksLock.ts`)
4. Handles **missed tasks** on startup — one-shots that fired while Claude was stopped
5. Supports **jitter** to prevent thundering herd when many sessions schedule the same cron time

**Multi-session safety:** Only the lock-owning session fires file-backed tasks. Other sessions probe every 5 seconds (`LOCK_PROBE_INTERVAL_MS`) to take over if the owner crashes. Session-only tasks (process-local) bypass the lock.

**Kill switch:** `isKilled?: () => boolean` — CLI callers inject `() => !isKairosCronEnabled()` so flipping the `tengu_kairos_cron` GrowthBook gate off mid-session stops all schedulers on their next 1-second tick.

### Jitter System

**Files:** `src/utils/cronTasks.ts`, `jitteredNextCronRunMs()` / `oneShotJitteredNextCronRunMs()`

To prevent thundering herd when thousands of Claude sessions all schedule `0 * * * *`:

- **Recurring tasks:** fire up to `recurringFrac * interval` late (default 10%), capped at 15 minutes
- **One-shot tasks:** fire up to 90 seconds early on `:00` and `:30` minute marks (the human-rounding hotspots)
- Jitter is **deterministic per task ID** — the same task always gets the same jitter, so fire times are stable across restarts

### KAIROS Gate

**File:** `src/tools/ScheduleCronTool/prompt.ts`, `isKairosCronEnabled()`:

```typescript
export function isKairosCronEnabled(): boolean {
  return feature('AGENT_TRIGGERS')
    ? !isEnvTruthy(process.env.CLAUDE_CODE_DISABLE_CRON) &&
        getFeatureValue_CACHED_WITH_REFRESH('tengu_kairos_cron', true, 5_minutes)
    : false
}
```

Default `true` — `/loop` is GA. The GrowthBook gate is a fleet-wide kill switch only.

`AGENT_TRIGGERS` is a separate build feature from `KAIROS` — the cron module graph has zero imports into `src/assistant/` and no `feature('KAIROS')` calls. This means cron scheduling (including `/loop`) ships independently in external builds.

### CronCreate Tool

The model creates tasks with `CronCreate` (tool name `CronCreate`). Key behavioral rules from `buildCronCreatePrompt()`:

- Use off-minute scheduling to avoid `:00`/`:30` hotspots
- `durable: true` only when user explicitly asks for persistence
- 5-field cron in local timezone
- Recurring tasks auto-expire after 7 days unless `permanent: true`
- Returns a job ID usable with `CronDelete`

---

## 7. Brief Mode (SendUserMessage)

In KAIROS mode, all user-facing output flows through the BriefTool, not plain text.

**File:** `src/tools/BriefTool/BriefTool.ts`

```typescript
export function isBriefEnabled(): boolean {
  return feature('KAIROS') || feature('KAIROS_BRIEF')
    ? (getKairosActive() || getUserMsgOptIn()) && isBriefEntitled()
    : false
}
```

When `getKairosActive()` is true, Brief is always enabled regardless of `userMsgOptIn`. The KAIROS system prompt hard-codes "you MUST use SendUserMessage for all user-facing output" — plain text outside this tool is hidden from the user.

**Tool structure:**
```typescript
// Input schema
{
  message: string,       // Markdown-formatted message
  attachments?: string[], // File paths to attach (photos, diffs, logs)
  status: 'normal' | 'proactive'  
  // 'proactive' = surfacing something user didn't ask for
  // (task completion while away, blocker, status update)
}
```

**Two-way toggle:** `/brief` command toggles `isBriefOnly` app state AND `userMsgOptIn` together. In KAIROS, the toggle doesn't inject a system-reminder on transition (the KAIROS system prompt already mandates SendUserMessage) — `src/commands/brief.ts`:

```typescript
const metaMessages = getKairosActive()
  ? undefined  // no injection needed in KAIROS
  : [`<system-reminder>Brief mode is now ${newState ? 'enabled' : 'disabled'}....</system-reminder>`]
```

**Entitlement gate** (`isBriefEntitled()`):
1. `getKairosActive()` — always entitled in assistant mode
2. `CLAUDE_CODE_BRIEF` env var — dev/testing bypass
3. GrowthBook `tengu_kairos_brief` flag (5-minute refresh)

---

## 8. Architectural Overview — How the Pieces Fit

```
KAIROS Session Startup
│
├── feature('KAIROS') [compile-time gate]
├── isAssistantMode() [detects daemon context]
├── isKairosEnabled() [GrowthBook gate w/ disk cache]
│
└── setKairosActive(true) → activates all subsystems:
    │
    ├── MEMORY SYSTEM (memdir/paths.ts)
    │   ├── loadMemoryPrompt() → buildAssistantDailyLogPrompt()
    │   │   [KAIROS: append to daily log, not MEMORY.md directly]
    │   └── getAutoMemDailyLogPath() → logs/YYYY/MM/YYYY-MM-DD.md
    │
    ├── TICK LOOP (proactive/index.js)
    │   ├── isProactiveActive() → enables tick prompts
    │   ├── TICK_TAG injected as `<tick>` messages
    │   ├── Sleep tool controls inter-tick intervals
    │   └── sleep_progress type → ephemeral (hidden from transcript)
    │
    ├── CRON SCHEDULER (cronScheduler.ts)
    │   ├── assistantMode: true → bypasses isLoading gate
    │   ├── 1-second check loop via setInterval
    │   ├── chokidar watcher on .claude/scheduled_tasks.json
    │   ├── Per-project lock prevents double-fire
    │   └── Permanent tasks: catch-up, morning-checkin, dream
    │
    ├── DREAM SYSTEM
    │   ├── autoDream: DISABLED when kairosActive (uses disk-skill instead)
    │   ├── /dream skill: installed as permanent cron task
    │   └── buildConsolidationPrompt() → 4-phase consolidation
    │       [Orient → Gather → Consolidate → Prune+Index]
    │
    └── BRIEF TOOL (BriefTool.ts)
        ├── Always enabled when kairosActive
        ├── SendUserMessage = sole user-facing output channel
        └── status: 'proactive' | 'normal' distinguishes
            initiated vs responsive communication
```

### Two Distinct Loops

**The Tick Loop** is the immediate heartbeat: a cron-scheduled `<tick>` prompt fires on the 1-second scheduler check, the model wakes, assesses state, uses SleepTool to set next wake interval, and outputs via BriefTool if there's something to say.

**The Dream Loop** runs nightly: a permanent cron task fires the `/dream` skill, which runs a forked subagent that reads daily logs and transcript searches, synthesizes everything into MEMORY.md topic files, and prunes the index. The next morning's session starts with a distilled, organized MEMORY.md rather than raw daily logs.

### The Memory Funnel

```
Real-time observations
    ↓ (during session)
Daily log: logs/YYYY/MM/YYYY-MM-DD.md  [append-only]
    ↓ (nightly dream cron)
Topic files: user_role.md, feedback_testing.md, project_status.md, ...
    ↓ (prune + index)
MEMORY.md  [index, ≤200 lines, ≤25KB]
    ↓ (next session startup)
Loaded into system prompt context
```

This funnel is what makes KAIROS a viable persistent entity: observations accumulate without bloating context, the nightly consolidation compresses signal, and each new session starts with high-quality distilled memory rather than a growing dump.

---

## 9. Key GrowthBook Feature Flags

| Flag | Purpose | Default |
|------|---------|---------|
| `tengu_kairos` | KAIROS mode enablement gate | checked per session |
| `tengu_kairos_cron` | Kill switch for all cron scheduling | `true` |
| `tengu_kairos_cron_durable` | Kill switch for persistent cron tasks | `true` |
| `tengu_kairos_cron_config` | Jitter tuning (live, ops-adjustable) | hardcoded defaults |
| `tengu_kairos_brief` | BriefTool entitlement gate | `false` |
| `tengu_kairos_brief_config` | `/brief` slash command visibility | `{enable_slash_command: false}` |
| `tengu_onyx_plover` | autoDream scheduling knobs (minHours, minSessions) | 24h, 5 sessions |
| `tengu_coral_fern` | "Searching past context" section in memory prompt | off |
| `tengu_moth_copse` | Skip MEMORY.md index in memory prompt | off |
| `tengu_passport_quail` | Extract-memories background agent | off |

---

## 10. Channels — Messaging Platform Integration (KAIROS_CHANNELS)

A major subsystem we initially underweighted. Channels is how KAIROS connects to external messaging platforms (Slack, Discord, Telegram, SMS, iMessage).

**File:** `src/services/mcp/channelNotification.ts`

**Architecture:** A "channel" is just an MCP server that:
- Exposes tools for **outbound** messages (e.g. `send_message`) — standard MCP tool interface
- Sends `notifications/claude/channel` notifications for **inbound** messages — custom notification type

The notification handler wraps incoming content in a `<channel source="slack" chat_id="..." user="...">` XML tag and enqueues it. SleepTool polls `hasCommandsInQueue()` and wakes within 1 second. The model sees where the message came from and decides which tool to reply with (the channel's MCP tool, SendUserMessage, or both).

**Permission relay over channels:** When a tool call needs human approval, KAIROS can send the permission dialog to a connected channel (Telegram, iMessage, etc.) via the channel's MCP `send_message` tool. The human replies "yes abc123" on their phone, the channel server parses it and emits a structured `notifications/claude/channel/permission` event. This means you can approve dangerous operations from your phone while away from the terminal.

Key security detail: permission replies use a structured event with a dedicated `request_id` and `behavior: 'allow' | 'deny'`, NOT regex matching against chat text. A text message in the general channel can never accidentally approve an operation.

**Gate chain (6 layers):**
1. Build flag: `feature('KAIROS') || feature('KAIROS_CHANNELS')`
2. Runtime flag: `tengu_harbor` (GrowthBook)
3. Auth: OAuth only (API key users blocked — no admin surface in console yet)
4. Org policy: Teams/Enterprise must explicitly set `channelsEnabled: true`
5. Session opt-in: server must be in `--channels` list for this session
6. Allowlist: plugin marketplace verification (tag must match installed source)

**For Claude Code Entities:** This is the messaging layer PD needs. Rather than building a custom Telegram integration, the Channels architecture lets any MCP server become a communication channel. PD could talk through Slack, Telegram, iMessage, or Discord — all through the same `<channel>` notification protocol. The permission relay is especially important: it solves the "entity wants to do something dangerous while human is away" problem.

---

## 11. Proactive Autonomous Work Section

**File:** `src/constants/prompts.ts:860-914`, `getProactiveSection()`

When KAIROS is active, the system prompt includes a full autonomous work section with detailed behavioral instructions:

```
You are running autonomously. You will receive `<tick>` prompts that keep 
you alive between turns — just treat them as "you're awake, what now?"
```

Key behavioral rules injected:
- **Terminal focus awareness:** The system tells the model whether the user's terminal is focused or unfocused. When unfocused: "lean heavily into autonomous action — make decisions, explore, commit, push." When focused: "be more collaborative — surface choices, ask before committing."
- **Multiple ticks may be batched** into a single message — the model should just process the latest one
- **Never echo or repeat tick content** in responses

This focus-awareness pattern is directly adoptable for entities — an entity should behave differently when Wisdom is actively watching versus when he's AFK.

---

## 12. Agent Force-Async in KAIROS

**File:** `src/tools/AgentTool/AgentTool.tsx:566`

```typescript
const assistantForceAsync = feature('KAIROS') ? appState.kairosEnabled : false;
```

In KAIROS mode, ALL subagents are forced async. The comment explains why: synchronous subagents hold the main loop's turn open, the daemon's inputQueue backs up, and overdue cron catch-ups stack as serial subagent turns blocking all user input.

This is a critical operational insight: a persistent entity must never block its own heartbeat with synchronous work. Everything that could take time must be async.

---

## 13. AutoDream — Community Reimplementation

**Repo:** github.com/JaWaMi73/AutoDream (MIT license, 6 core hooks open)

JaWaMi73 reverse-engineered KAIROS from the same source and rebuilt the memory and safety layers as hooks:
- **Active mode:** 11 hooks (PreToolUse guardian danger-scoring, context injection, learn capture, verification)
- **AFK mode:** agents work queues every 30 min via `afk-worker`
- **Maintenance mode:** 3:17 AM nightly consolidation + memory dedup
- **3-layer memory:** global (`~/.claude/memory/`), project (`projects/<key>/memory/MEMORY.md`), session (`session-learnings.md`)

**What AutoDream has that we should evaluate:** The guardian hook danger-scores commands 0-10 and blocks at 7+. The three-layer memory promotion (session → project → global) is a clean pattern.

**What AutoDream explicitly doesn't have:** Autonomous generative reasoning, identity persistence, entity creation. It's KAIROS's infrastructure without KAIROS's entity layer.

---

## 14. Implications for The Companion / Persistent Entities

KAIROS is exactly what The Companion needs to study. Its architecture resolves several open questions about how Claude Code supports persistent entity behavior:

**The tick loop is the heartbeat.** The `<tick>` mechanism in proactive mode (shared with KAIROS) shows how Anthropic handles "keep-alive" — not a WebSocket, but a cron-fired prompt injection. The model uses SleepTool to control its own wakeup frequency.

**Memory is append-only + nightly consolidation.** This is the core pattern: never mutate the live log, batch consolidation happens asynchronously at night. This is more robust than live MEMORY.md editing because it decouples the write speed from the consolidation quality.

**Permanent cron tasks are the persistence primitive.** The `permanent: true` flag on catch-up/morning-checkin/dream tasks means these survive session restarts indefinitely. They are written at install time, never recreatable. This is how a persistent entity maintains its own operational rhythm.

**BriefTool is the entity-to-user channel.** When Claude runs autonomously (kairosActive), ALL communication is through SendUserMessage with `status: 'proactive' | 'normal'`. The distinction between proactive (unsolicited update) and normal (reply) is already built in.

**The forked dream agent pattern is transferable.** `runForkedAgent()` with a constrained `canUseTool` policy (read-only Bash, write only to memdir) shows the pattern for safely running autonomous subagents with sandboxed permissions.

**Channels are the messaging layer.** The `<channel>` notification protocol means PD doesn't need a custom Telegram/Slack integration — any MCP server that declares `claude/channel` capability becomes a communication channel. The permission relay (approve operations from your phone) is exactly what a persistent entity needs for human-in-the-loop while away.

**Terminal focus awareness calibrates autonomy.** The proactive section tells the model whether the terminal is focused or unfocused. When unfocused: act autonomously. When focused: be collaborative. This is a ready-made pattern for entity autonomy calibration.

**All subagent work must be async.** KAIROS force-asyncs every subagent to prevent blocking the heartbeat loop. Any persistent entity architecture must follow this — a synchronous subtask that takes 5 minutes blocks the entity from responding to anything else.

---

## What KAIROS Is NOT (The Remaining Novelty Gap)

After thorough source analysis, here's what KAIROS does NOT provide — and therefore what Claude Code Entities still uniquely contributes:

1. **No entity creation primitive.** You can't invoke a skill or command to "turn this directory into a persistent entity." KAIROS activates via compile-time flags and an `--assistant` CLI flag in a daemon context. It's infrastructure, not a user-facing pattern.

2. **No identity layer.** No SOUL.md, no rules-as-values, no `--cwd` loading of entity-specific configuration. KAIROS is "Claude running in the background," not "a being with a specific identity."

3. **No multi-entity coordination.** KAIROS is one assistant. No org chart, no entity-to-entity messaging, no shared knowledge with role-based access.

4. **No identity development.** Memory consolidates information, not identity. The entity doesn't grow convictions, develop values, or evolve its self-concept.

5. **No graduated autonomy model.** KAIROS has two states: daemon mode on or off. No named tiers where the entity is aware of its own capability boundaries.

---

## Source Files Referenced

| File | Role |
|------|------|
| `src/bootstrap/state.ts:1085` | `getKairosActive()` / `setKairosActive()` |
| `src/main.tsx:1048-1088` | KAIROS activation sequence |
| `src/main.tsx:78-81` | Dead-code-elimination gated imports |
| `src/constants/prompts.ts:860-914` | `getProactiveSection()` — tick loop + terminal focus awareness |
| `src/constants/prompts.ts:552-554` | BriefTool injection into system prompt |
| `src/services/autoDream/autoDream.ts` | autoDream coordinator (non-KAIROS path) |
| `src/services/autoDream/consolidationPrompt.ts` | Four-phase dream prompt |
| `src/memdir/memdir.ts:327-370` | `buildAssistantDailyLogPrompt()` — KAIROS memory mode |
| `src/memdir/memdir.ts:432-438` | Memory mode dispatch (KAIROS vs standard) |
| `src/memdir/paths.ts:30-55` | `isAutoMemoryEnabled()` |
| `src/memdir/paths.ts:246-251` | `getAutoMemDailyLogPath()` |
| `src/utils/cronScheduler.ts` | Full scheduler engine |
| `src/utils/cronTasks.ts` | Task storage / jitter / read-write |
| `src/tools/ScheduleCronTool/prompt.ts` | `isKairosCronEnabled()` + tool prompts |
| `src/tools/BriefTool/BriefTool.ts` | `isBriefEnabled()` / `isBriefEntitled()` |
| `src/commands/brief.ts` | `/brief` slash command |
| `src/screens/REPL.tsx:4047-4053` | Cron scheduler assistantMode flag |
| `src/utils/sessionStorage.ts:190-193` | sleep_progress ephemeral type |
| `src/assistant/sessionHistory.ts` | Remote session history loader (cloud CCR) |
| `src/services/mcp/channelNotification.ts` | Channel notification protocol — messaging platform integration |
| `src/hooks/toolPermission/handlers/interactiveHandler.ts:300-327` | Channel permission relay |
| `src/tools/AgentTool/AgentTool.tsx:566` | Force-async subagents in KAIROS mode |
| `src/hooks/useAssistantHistory.ts` | Lazy-load remote session history for viewer mode |
