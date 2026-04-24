# PS Bot V2 — Infrastructure Sections Plan (3, 4, 5, 6)

*Written 2026-04-13. Sections 3-6 can be built in parallel after Phase 0 (Stumble-Through) and Section 1 (Entity Identity) are done. This document covers all four together because they share codebase context and inform each other's permission decisions.*

---

## Section 3: Heartbeat System

### Goal

A launchd agent fires every 30 minutes, launches `claude -p` pointed at the PS Bot project directory, and Claude reads `entity/identity/HEARTBEAT.md` as the prompt. Claude checks current state, writes observations, updates `entity/identity/current-state.md`, and exits. No stalling, no permissions prompts, no human needed.

### File to Create

`~/Library/LaunchAgents/com.ps.psbot-heartbeat.plist`

The label convention matches Apple's recommendation for user-level agents. The file lives in the user's LaunchAgents directory (not /Library/LaunchAgents, which requires root).

### Plist Content

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ps.psbot-heartbeat</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>source /Users/wisdomhappy/.env-heartbeat 2>/dev/null; cd "/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/psdc" &amp;&amp; /opt/homebrew/bin/claude -p --continue --model haiku --max-turns 10 --permission-mode acceptEdits --allowedTools "Read,Glob,Grep,Write" "Run the heartbeat protocol from entity/identity/HEARTBEAT.md" --output-format text >> entity/data/heartbeat.log 2>&1</string>
    </array>

    <key>StartInterval</key>
    <integer>1800</integer>

    <key>RunAtLoad</key>
    <false/>

    <key>KeepAlive</key>
    <false/>

    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>/Users/wisdomhappy</string>
        <key>PATH</key>
        <string>/Users/wisdomhappy/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>LANG</key>
        <string>en_US.UTF-8</string>
    </dict>
</dict>
</plist>
```

### Key Design Decisions

**StartInterval vs StartCalendarInterval.** StartInterval fires 30 minutes after the last run completes, not at wall-clock times. An LLM call has variable duration (30 seconds to 2 minutes). StartCalendarInterval could fire while a previous heartbeat is still running. StartInterval is self-throttling.

**RunAtLoad false.** Don't fire on every Mac login. The first interval runs 30 minutes after the agent is loaded.

**KeepAlive false.** Heartbeat is a periodic task, not a persistent daemon. Let the process exit cleanly.

**Mac sleep behavior.** When the Mac wakes from sleep, launchd catches up missed intervals by running the job once immediately. A heartbeat skipped during sleep runs at wake. This is correct — no heartbeat is lost, no flood of catch-up heartbeats.

**Environment.** launchd strips the shell environment. Explicit PATH must include wherever `claude` actually lives. The `~/.env-heartbeat` source handles the Anthropic API key without baking it into the plist. The plist file is committed to the repo; secrets are not.

**`~/.env-heartbeat` contents (not committed, created manually):**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Why `--cwd PS Bot/`?** This makes Claude load the PS Bot CLAUDE.md as the project instructions. The HEARTBEAT.md lives inside that project. Claude's rules, skills, and entity identity all load from this working directory context. Without `--cwd`, the heartbeat runs in a context-free void.

**Why `--allowedTools "Read,Glob,Grep,Write"` only?** The heartbeat has no business using Bash, Edit (existing core files), WebSearch, or Agent. Write is needed to create observation files. No other tool is needed for a routine check-in.

**Why not `--dangerously-skip-permissions`?** Research confirmed active bugs with this flag. The `acceptEdits` + `--allowedTools` combination achieves the same non-blocking behavior without the bugs. Denied tools return an error to Claude; Claude adjusts and continues.

### HEARTBEAT.md Protocol (what the entity reads)

This file lives at `entity/identity/HEARTBEAT.md`. It is the standing-task prompt. Structure informed by nanobot's pattern (standing instruction file, must write observations before exit) and OpenClaw's batching insight (one heartbeat call, multiple checks).

```markdown
# Heartbeat Protocol

You are running the PS Bot heartbeat — a 30-minute autonomous check-in.
You have max 10 turns. Complete all checks and write observations before exiting.

## Checks (in order)

1. **Read current-state.md** — What was I doing last? Any open threads?
2. **Scan entity/data/inbox/** — Any messages or tasks left for me?
3. **Check Digital Core freshness** — Any new files without index entries?
4. **Scan entity/data/alerts/** — Any unresolved critical items?
5. **Review open questions** — Are any of my convictions-forming hypotheses due for a check?

## Required Before Exiting

Write a heartbeat observation file:
- Path: `entity/data/observations/YYYY-MM-DD-HHMM.md`
- Include: what you checked, what you found, what (if anything) needs Wisdom's attention
- Keep it under 200 words

Update `entity/identity/current-state.md` with this format:
```
Last heartbeat: [timestamp]
Status: [one sentence]
Open threads: [any lingering items]
Next: [what you'd do if awake right now]
```

## Hard Rules

- DO NOT modify any file outside entity/ and entity/data/
- DO NOT send messages via Slack unless entity/data/alerts/ has a critical item
- DO NOT start long multi-step projects — observe and record only
- If you cannot complete a check, log why and move on — never stall
```

### Load / Unload Commands

```bash
# Install (after creating the plist)
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.ps.psbot-heartbeat.plist

# Verify loaded
launchctl print gui/$(id -u)/com.ps.psbot-heartbeat

# Check last run result
launchctl print gui/$(id -u)/com.ps.psbot-heartbeat | grep "last exit"

# Unload (pause heartbeat)
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.ps.psbot-heartbeat.plist

# Force a manual run now
launchctl kickstart -k gui/$(id -u)/com.ps.psbot-heartbeat
```

### Checkpoint Verification

1. Install the plist with `launchctl bootstrap`
2. Run `launchctl kickstart -k ...` to fire immediately (don't wait 30 min)
3. Wait 90 seconds
4. Check: `ls entity/data/observations/` — should have a new dated file
5. Check: `cat entity/identity/current-state.md` — should have "Last heartbeat" timestamp
6. Check: `cat entity/data/heartbeat.log` — should show the claude run output

### Cost Model

Haiku at ~$0.80/M input tokens, ~$4/M output tokens. One heartbeat:
- Input: ~5K tokens (HEARTBEAT.md + current-state.md + scanned inbox files)
- Output: ~500 tokens (observation file + current-state update)
- Per run: ~$0.006
- Per day (48 runs): ~$0.29 worst case, ~$0.05-$0.10 typical (shorter context most runs)

Matches the plan's $0.05/day estimate with headroom.

### Open Questions

1. **`claude` binary path.** Config.py already detects VS Code extension paths. Run `which claude` in a normal terminal, then hardcode that path in both the EnvironmentVariables PATH and verify it's correct before loading. The `_find_claude_bin()` function in `psbot/config.py` is the right pattern — steal it as a one-time pre-install check.

2. **API key in launchd.** The `~/.env-heartbeat` source pattern is safe. Alternative: set `ANTHROPIC_API_KEY` directly in the plist's `EnvironmentVariables` dict (never commit the plist if doing this). Recommend the source approach — plist stays committable.

3. **`--cwd` path with spaces.** The PS Bot path has spaces ("PS Bot"). Shell quoting inside ProgramArguments is tricky — the path goes through `/bin/bash -c` which handles quoting, but test this explicitly before relying on it. Verified-safe pattern: `cd /path/with\ spaces && claude -p ...` using the cd approach.

---

## Section 4: Slack Integration

### Goal

Claude can post to Slack channels and read channel history via the official MCP server. For heartbeat/proactive messages: MCP alone is sufficient. For real-time conversation (Wisdom sends a message, bot responds): add a thin Python listener. Both live in the same codebase.

### Part A: Official Slack MCP Setup

**Install** (no install needed — runs via npx):
```bash
npx -y @modelcontextprotocol/server-slack
```

**Add to `~/.claude/settings.json`** (the global settings, not PS Bot's local settings.json):
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}",
        "SLACK_CHANNEL_IDS": "${SLACK_CHANNEL_IDS}"
      }
    }
  }
}
```

The `${VAR}` pattern reads from shell environment. Set these in `~/.zshrc` or `~/.env-heartbeat`. Bot token and Team ID come from the Slack app configuration.

**8 tools provided:** `slack_post_message`, `slack_reply_to_thread`, `slack_add_reaction`, `slack_get_channel_history`, `slack_get_thread_replies`, `slack_list_channels`, `slack_get_users`, `slack_get_user_profile`.

**Channel scope.** Set `SLACK_CHANNEL_IDS` to a comma-separated list to limit which channels the bot can read/write. Omit it to access all public channels. For PS Bot, start with just the personal HHA/PS channel.

### Slack App Setup (One-Time)

1. Go to api.slack.com/apps → Create New App → From Scratch
2. Name: "PS Bot" (or whatever the entity's chosen name becomes)
3. Add Bot Token Scopes: `chat:write`, `channels:history`, `channels:read`, `users:read`
4. Install to workspace → copy Bot Token (`xoxb-...`)
5. Copy Team ID from workspace URL (the `T0...` part)
6. Invite bot to relevant channels: `/invite @ps-bot`

### Part B: Thin Python Listener for Real-Time Response

The MCP server is pull-only. For Wisdom to send a Slack message and get an immediate response, a Python listener uses the Slack Events API.

**Architecture:** Slack → Events webhook → Python listener → `claude -p` → Slack reply via MCP tool call or direct Slack API.

**File: `psbot/slack_listener.py`** (~80 lines)

```python
"""Thin Slack event listener — routes incoming messages to claude -p."""

import asyncio
import json
import logging
import os
import subprocess
from aiohttp import web

logger = logging.getLogger(__name__)

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_SIGNING_SECRET = os.environ["SLACK_SIGNING_SECRET"]
BOT_USER_ID = os.environ.get("SLACK_BOT_USER_ID", "")  # to avoid self-responses

async def handle_event(request: web.Request) -> web.Response:
    body = await request.json()
    
    # URL verification challenge (Slack requires this on first setup)
    if body.get("type") == "url_verification":
        return web.json_response({"challenge": body["challenge"]})
    
    event = body.get("event", {})
    
    # Ignore bot's own messages
    if event.get("user") == BOT_USER_ID:
        return web.Response(status=200)
    
    # Only handle direct messages and mentions in channels
    if event.get("type") not in ("message", "app_mention"):
        return web.Response(status=200)
    
    text = event.get("text", "").strip()
    channel = event.get("channel", "")
    thread_ts = event.get("thread_ts") or event.get("ts")
    
    if not text or not channel:
        return web.Response(status=200)
    
    # Fire and forget — don't block Slack's webhook timeout
    asyncio.create_task(route_to_claude(text, channel, thread_ts))
    return web.Response(status=200)


async def route_to_claude(text: str, channel: str, thread_ts: str) -> None:
    """Launch claude -p with the message, post response back to Slack."""
    prompt = f"[Slack channel {channel}] {text}"
    cmd = [
        "claude", "-p",
        "--cwd", "/Users/wisdomhappy/Playful Sincerity/PS Software/PS Bot",
        "--model", "sonnet",
        "--max-turns", "20",
        "--permission-mode", "acceptEdits",
        "--allowedTools", "Read,Glob,Grep,Write,WebSearch,WebFetch",
        "--output-format", "text",
        prompt
    ]
    
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await proc.communicate()
    response = stdout.decode().strip()
    
    if response:
        await post_to_slack(channel, response, thread_ts)


async def post_to_slack(channel: str, text: str, thread_ts: str) -> None:
    import aiohttp
    headers = {"Authorization": f"Bearer {SLACK_BOT_TOKEN}", "Content-Type": "application/json"}
    payload = {"channel": channel, "text": text, "thread_ts": thread_ts}
    async with aiohttp.ClientSession() as session:
        await session.post("https://slack.com/api/chat.postMessage", json=payload, headers=headers)


if __name__ == "__main__":
    app = web.Application()
    app.router.add_post("/slack/events", handle_event)
    web.run_app(app, port=3000)
```

**Webhook exposure.** For local Mac development, use `ngrok http 3000` to expose the listener to Slack's servers. For VPS, the server's public IP is already reachable. Set the Event Subscription URL in the Slack app settings to `https://<ngrok-or-server>/slack/events`.

### Multi-Channel Routing

The `channel` variable passed to `route_to_claude` lets the bot behave differently per channel. This can be implemented as channel-aware context in the prompt:

```python
channel_context = {
    "C01ABCDEF": "This is the HHA business channel. Focus on sales and outreach.",
    "C02GHIJKL": "This is Wisdom's personal channel. Full Digital Core access.",
}
context = channel_context.get(channel, "General channel.")
prompt = f"[Context: {context}] {text}"
```

### Part C: Proactive Messages from Heartbeat

For the heartbeat to send Slack messages, it needs the Slack MCP available in the heartbeat's Claude session. Because the heartbeat uses `--cwd PS Bot/`, and PS Bot's `.claude/settings.json` will include the Slack MCP, this works automatically. The HEARTBEAT.md protocol says: "Only post to Slack if entity/data/alerts/ has a critical item." This prevents alert spam.

### Checkpoint Verification

1. Install Slack app, get tokens
2. Add MCP to settings.json
3. Start a `claude -p` session, ask it to `slack_post_message` to the test channel — verify message appears
4. Start the Python listener: `python3 psbot/slack_listener.py`
5. Open ngrok tunnel: `ngrok http 3000`
6. Set event URL in Slack app settings
7. Send a Slack DM to the bot — verify `claude -p` fires and a response appears in the thread

### Key Decisions

**Why not Slack Bolt?** The official Slack Bolt Python framework adds ~500 lines of boilerplate and its own event loop. The thin aiohttp listener is 80 lines and fits naturally alongside the existing asyncio Telegram bot. Don't bring in a framework for this.

**Why not replace Telegram with Slack?** Both serve different contexts. Telegram is personal/mobile (quick thoughts, voice notes eventually). Slack is work-oriented (HHA business, structured requests, enterprise clients). Run both in parallel, not either/or.

**MCP in heartbeat.** The Slack MCP runs as an npx process. During heartbeat, Claude invokes it as a tool. This adds ~2-3 second MCP startup latency to heartbeats that need to alert. Acceptable for a 30-minute cycle.

### Open Questions

1. **`${VAR}` in settings.json.** Claude Code may or may not support environment variable interpolation in settings.json `env` fields. If not, values must be hardcoded (never commit) or loaded via a wrapper script that sets env before launching Claude. Test this before relying on it.

2. **ngrok vs Cloudflare tunnel.** ngrok free tier resets the URL on restart. Cloudflare Tunnel is free and persistent. For V1 Mac development, ngrok is fine. For VPS, neither is needed (direct IP). Document the ngrok/Cloudflare decision before client bots need persistent webhook URLs.

3. **Slack rate limits.** `chat.postMessage` is limited to 1 message per second per channel. The thin listener doesn't throttle. Add a short sleep or queue if bot gets heavily used.

---

## Section 5: Telegram Bot Refinement

### Goal

The existing bot works. The additions are: tool-use notifications forwarded to Telegram as brief messages while Claude is working, `/verbose` toggle to show full thought process, clean error handling, and verification that model routing appears in logs.

### What Already Works (Don't Touch)

`psbot/bot.py` already handles:
- Streaming intermediate text with rate-limited edits
- Typing indicator while Claude works
- Injection scanning before sending to Claude
- TOTP-gated Bash access
- Model routing via `route(text)` from `model_router.py`
- Session reset on idle timeout

`psbot/claude_proc.py` already handles:
- `tool_use` blocks are logged: `logger.info("tool: %s", block.get("name"))`
- Hook events are logged: `logger.info("hook: %s", output[:100])`
- Cost tracking in the result event
- Proper stderr draining

### Addition 1: Tool-Use Notifications to Telegram

The `claude_proc.py` already parses `tool_use` blocks and logs them. The fix is to yield them as events so `bot.py` can forward them.

**Change in `claude_proc.py`:** Add a new event type `"tool_use"` to `StreamEvent` and yield it when a tool_use block is encountered:

```python
# In the assistant event parsing loop, after the text block handling:
elif isinstance(block, dict) and block.get("type") == "tool_use":
    tool_name = block.get("name", "unknown")
    tool_input = block.get("input", {})
    logger.info("tool: %s", tool_name)
    yield StreamEvent(
        event_type="tool_use",
        subtype=tool_name,
        text=_tool_notification(tool_name, tool_input),
        session_id=session_id,
        is_done=False,
        raw=data,
    )
```

**`_tool_notification()` helper** (maps tool names to human-readable strings):

```python
def _tool_notification(name: str, inp: dict) -> str:
    match name:
        case "Read": return f"Reading {_short_path(inp.get('file_path', ''))}"
        case "Write": return f"Writing {_short_path(inp.get('file_path', ''))}"
        case "Edit": return f"Editing {_short_path(inp.get('file_path', ''))}"
        case "Bash": return f"Running: {str(inp.get('command', ''))[:60]}"
        case "Glob": return f"Searching {inp.get('pattern', '')} in {inp.get('path', '.')}"
        case "Grep": return f"Searching for: {str(inp.get('pattern', ''))[:40]}"
        case "WebSearch": return f"Searching: {inp.get('query', '')[:50]}"
        case "WebFetch": return f"Fetching: {inp.get('url', '')[:60]}"
        case "Agent": return "Spawning subagent..."
        case _: return f"Using {name}..."

def _short_path(p: str) -> str:
    """Shorten a path to the last 2 components."""
    from pathlib import Path
    parts = Path(p).parts
    return "/".join(parts[-2:]) if len(parts) > 2 else p
```

**Change in `bot.py`:** Handle the new `"tool_use"` event type. Only send if verbose mode is on OR if it's a slow tool (Bash, Agent, WebFetch):

```python
elif event.event_type == "tool_use":
    verbose = context.user_data.get("verbose", False)
    slow_tools = {"Bash", "Agent", "WebFetch", "WebSearch"}
    if verbose or event.subtype in slow_tools:
        try:
            await update.message.reply_text(
                f"⚙️ {event.text}",
                disable_notification=True,
            )
        except Exception:
            pass  # never crash on notification failure
```

The `disable_notification=True` flag sends the message silently (no buzz on phone) — it shows up in the chat but doesn't interrupt the user.

### Addition 2: `/verbose` Toggle

Add to `bot.py` command handlers:

```python
app.add_handler(CommandHandler("verbose", _cmd_verbose))
```

```python
async def _cmd_verbose(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    auth, _ = _get(context)
    if not _allowed(update, auth):
        return
    current = context.user_data.get("verbose", False)
    context.user_data["verbose"] = not current
    state = "on" if not current else "off"
    await update.message.reply_text(f"Verbose mode {state}.")
```

Update `/start` and `/status` responses to mention `/verbose`.

### Addition 3: Error Handling Audit

Current error handling in `_handle_message`:
```python
except Exception as e:
    logger.exception("Error in conversation")
    await update.message.reply_text(f"Error: {e}")
```

This is fine but exposes raw exception messages to the user. Replace with categorized handling:

```python
except asyncio.TimeoutError:
    await update.message.reply_text("Claude is taking too long. Try a shorter message or /clear.")
except asyncio.CancelledError:
    raise  # don't catch cancellation
except Exception as e:
    logger.exception("Error in conversation")
    err_msg = "Something went wrong on my end."
    if "API" in str(e) or "rate" in str(e).lower():
        err_msg = "Hit a rate limit. Try again in 30 seconds."
    elif "permission" in str(e).lower():
        err_msg = "Permission error — the action wasn't allowed."
    await update.message.reply_text(err_msg)
```

Also: the `_reply_safe` function currently catches `BadRequest` twice identically (lines 254-257 of bot.py). The second `except BadRequest` block is dead code — remove it, the fallback doesn't strip parse mode when there's nothing to strip.

### Addition 4: Model Routing Verification

Model routing is already in the code: `model = route(text)` → `logger.info("Routing to %s ...")`. Verification just requires running the bot with log level INFO and sending test messages. No code change needed.

To surface routing in Telegram (optional, verbose mode only):

```python
if context.user_data.get("verbose"):
    await update.message.reply_text(
        f"🧠 Routing to {model}",
        disable_notification=True,
    )
```

### Checkpoint Verification

1. Send a message that requires file reading (e.g., "what's in my SOUL.md?")
2. Verify "Reading entity/identity/SOUL.md" appears in Telegram as a silent notification
3. Run `/verbose` → send another message → verify all tool calls appear
4. Run `/verbose` again → verify tool notifications stop
5. Send a message that triggers a Grep → verify "Searching for..." appears
6. Check logs for `Routing to haiku|sonnet|opus` entries

### Key Decisions

**Emit on all tool_use or just slow ones?** Only emit by default for slow/meaningful tools (Bash, Agent, WebFetch, WebSearch). Read/Glob/Grep on small files are fast enough that notifications would be noise. Verbose mode reveals everything. This matches how people expect a "thinking..." indicator to work — not for every micro-step.

**Separate notification messages vs editing the main message.** Sending new silent messages keeps the notification ephemeral and doesn't disturb the main response thread. Alternative (editing the streaming placeholder to say "Reading...") was considered but it creates visual noise when the final response replaces it. Separate messages are cleaner.

---

## Section 6: Permission Configuration

### Goal

Create a PS Bot-specific `.claude/settings.json` that defines the autonomy tier. Three permission levels: routine (auto-approve), meaningful (ask via Slack), structural (propose and wait). Verify that denied actions return an error without blocking. Document exact content.

### File Location

`/Users/wisdomhappy/Playful Sincerity/PS Software/PS Bot/.claude/settings.json`

This is a project-level settings file. It loads for all Claude sessions with `--cwd PS Bot/`. The global `~/.claude/settings.json` holds MCP servers and global defaults. The project settings.json adds bot-specific permission rules on top.

### Permission Tier Design

| Tier | What Falls Here | Claude Does |
|------|----------------|-------------|
| **T2: Autonomous** | Create new files in entity/, read anything, search, web | Just do it |
| **T3: Ask First** | Edit existing files, write outside entity/, Bash commands | Propose via Slack, wait for 👍/👎 |
| **T0: Never** | Modify SOUL.md, core rules, CLAUDE.md, Digital Core source | Blocked at settings level; propose only |

### settings.json Content

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Write(entity/**)",
      "Write(data/**)",
      "WebSearch",
      "WebFetch",
      "Agent",
      "TodoWrite",
      "ToolSearch"
    ],
    "deny": [
      "Bash",
      "Edit"
    ]
  }
}
```

**Why deny Bash entirely?** The heartbeat and routine entity operations never need Bash. Bash access is reserved for Wisdom's direct-use sessions (where TOTP gates it). An autonomous Claude session with Bash access is a significant attack surface — it can delete files, run arbitrary commands, exfiltrate data. The entire benefit of the `--allowedTools` whitelist approach is avoiding this.

**Why deny Edit (for existing files)?** Edit modifies existing files with a diff. Write creates new files. The entity's autonomous operation should only create new content (observations, notes, entries, proposals). Modifying existing files — including its own identity files — requires human review. If the entity needs to update current-state.md, it uses Write with the full new content, not Edit with a patch. This is intentionally more costly (in tokens) to make modification deliberate.

**Why not include Edit for entity/ files?** Current-state.md and HEARTBEAT.md are identity files. The SPEC-v2 architecture treats T0 (SOUL.md, HEARTBEAT.md) as read-only for the entity. current-state.md is T2 (working memory, write allowed). Recommendation: allow `Write(entity/identity/current-state.md)` explicitly, deny Edit everywhere. This means the entity always writes the full current-state.md content — which is short (< 200 words) and therefore not wasteful.

**Refined allow list with path scoping:**
```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Write(entity/data/**)",
      "Write(entity/identity/current-state.md)",
      "Write(entity/identity/convictions-forming.md)",
      "Write(entity/proposals/pending/**)",
      "Write(entity/chronicle/**)",
      "WebSearch",
      "WebFetch",
      "Agent",
      "TodoWrite",
      "ToolSearch"
    ],
    "deny": [
      "Bash",
      "Edit",
      "Write(entity/identity/SOUL.md)",
      "Write(entity/identity/HEARTBEAT.md)",
      "Write(entity/guardrails.md)"
    ]
  }
}
```

Note: whether Claude Code's settings.json actually supports glob path-scoped tool permissions (e.g., `Write(entity/data/**)`) needs verification. If not supported, use the simpler allow/deny by tool name only and enforce path restrictions via behavioral rules in CLAUDE.md.

### The Haiku Permission Analyzer Pattern (from CCManager)

CCManager's insight: use Haiku to classify actions before executing them. Pattern:

Before a meaningful action (anything that writes outside T2), the entity pauses and asks Haiku: "Is this a routine action, a meaningful change, or a structural change? Answer: routine / ask / propose."

This isn't enforced at the settings.json level — it's a behavioral rule in CLAUDE.md. The rule reads:

```markdown
## Permission Check Rule

Before any Write operation outside entity/data/:
1. Ask yourself: Is this routine (new observation/note), meaningful (changes existing content), or structural (changes identity or core files)?
2. If routine: proceed
3. If meaningful: post a one-line Slack message first: "About to [action]. OK? 👍/👎"
   Wait for response before proceeding. If no response in 5 minutes, log to inbox and stop.
4. If structural: write a proposal to entity/proposals/pending/ and stop. Don't wait.
```

This pattern is lighter than running a Haiku subprocess for every action. It relies on the entity's own judgment, which is appropriate — the entity's values (loaded from SOUL.md + self-check rule) should guide this correctly.

### VPS bypassPermissions Verification

For the VPS (Section 7), `--permission-mode bypassPermissions` is used instead of `acceptEdits`. This means ALL permission prompts are auto-approved. The deny list in settings.json is the only safety layer.

**Critical test before deploying to VPS:**

```bash
# Run claude with bypassPermissions
claude -p --cwd "PS Bot/" --permission-mode bypassPermissions \
  "Try to run a bash command: echo hello" \
  --output-format text

# Expected: Claude attempts Bash, gets denied by settings.json, 
# returns an error message to Claude, Claude continues without the bash result.
# NOT expected: a blocking permission prompt, a crash, or silent failure.
```

Research confirmed: `--dangerously-skip-permissions` has bugs (from GH Scout findings). The correct approach is `bypassPermissions` (which is the official `--permission-mode` value, not the `--dangerously-skip-permissions` flag). These are distinct. The GH scout research confirmed `bypassPermissions` as the working option.

**Verification command:**
```bash
claude -p --permission-mode bypassPermissions \
  --allowedTools "Read,Glob,Grep,Write" \
  "Try to use the Bash tool to run: ls -la. If denied, tell me what error you got and continue." \
  --output-format text
```

Expected output: Claude acknowledges the Bash tool isn't in its allowed set, continues the conversation without stalling.

### Checkpoint Verification

1. Create `.claude/settings.json` in PS Bot project directory
2. Start a `claude -p --cwd "PS Bot/"` session
3. Ask it to attempt Bash — should get an error, not a permission prompt
4. Ask it to Write to `entity/data/test.md` — should succeed
5. Ask it to Edit `CLAUDE.md` — should get denied
6. Ask it to Write to `entity/identity/SOUL.md` — should get denied
7. Verify all denials are non-blocking (Claude responds to the error and continues)

---

## Cross-Section Notes

### Shared Codebase Changes Summary

| File | Section | Change |
|------|---------|--------|
| `psbot/claude_proc.py` | 5 | Add `tool_use` event type, yield tool notifications |
| `psbot/bot.py` | 5 | Handle `tool_use` events, add `/verbose` command, clean error handling |
| `psbot/slack_listener.py` | 4 | New file: thin aiohttp Slack event listener |
| `.claude/settings.json` | 6 | New file: PS Bot permission configuration |
| `~/.claude/settings.json` | 4 | Add Slack MCP server config |
| `~/Library/LaunchAgents/com.ps.psbot-heartbeat.plist` | 3 | New file: launchd agent |
| `~/.env-heartbeat` | 3 | New file (not committed): API key for heartbeat |
| `entity/identity/HEARTBEAT.md` | 3 | New file: heartbeat standing-task protocol |

### Build Order Within These Four Sections

All four can proceed in parallel, but there's a natural sequencing:

1. **Section 6 first** — write settings.json before anything else. All other sections depend on knowing what the bot is and isn't allowed to do. A 30-minute task.
2. **Section 3 next** — heartbeat is self-contained after Section 1 (Entity) exists. Load the plist and verify it fires.
3. **Section 5 next** — bot.py changes are low-risk and independently verifiable. Change one thing, test, next.
4. **Section 4 last** — Slack requires external setup (app creation, tokens, ngrok). Most dependencies on other services.

### What Surprised Me Reading the Code

`claude_proc.py` already parses `tool_use` blocks (line 143) and logs them. Section 5 is genuinely a small delta — the infrastructure is there, it just needs to yield instead of only log. The tool notification system is maybe 30 lines of new code.

The `_reply_safe` function in `bot.py` has a dead code branch (lines 253-258) where both except blocks do the same thing. Not a bug but cleanup is worth including in Section 5.

The config.py `IDLE_TIMEOUT_SECONDS` defaults to 1800 seconds (30 minutes) — which is the same as the heartbeat interval. This means if the heartbeat fires every 30 minutes but the Claude session has been idle for 30 minutes, the bot will reset the session on the next real user message. The heartbeat runs in a separate `claude -p` invocation (no shared session), so this doesn't affect heartbeat. But it's worth noting: the 1800s idle timeout means Wisdom's conversations have a 30-minute context window between messages before the session resets. This may be intentional.

### Open Questions (All Sections)

1. **Does settings.json support path-scoped permissions like `Write(entity/data/**)`?** This determines how precise the permission configuration can be. If not, rely on CLAUDE.md behavioral rules for path enforcement.

2. **`${VAR}` interpolation in settings.json env fields** — test before relying on it for Slack MCP tokens.

3. **ngrok persistence for Slack webhooks on Mac** — ngrok free tier resets URL on restart. Either use Cloudflare Tunnel (free, persistent) or accept that webhook URL needs manual updating after Mac restarts. For V1 personal use, this is tolerable. Document the friction.

4. **Slack `app_mention` vs `message` event type** — in DMs the bot receives `message` events. In channels it needs to be mentioned (`app_mention`) or have the `message.channels` scope. Start with DMs only for V1, expand to channels once basics work.

5. **The entity's name** — the SPEC-v2 open questions list includes "The entity's name: not PSBot." Until Wisdom names it, all `entity/identity/` files reference it as "the entity" and SOUL.md will have a placeholder. This doesn't block any of Sections 3-6 but affects what the heartbeat signs its observations with.
