# Scout: Reusable Components for PS Bot V2
*Scouted 2026-04-13 | Scope: V1 build components*

---

## 1. Slack MCP Server

**Winner: `@modelcontextprotocol/server-slack` (official)**

- **Source:** https://github.com/modelcontextprotocol/servers/tree/main/src/slack
- **Package:** `@modelcontextprotocol/server-slack`
- **License:** MIT
- **Status:** Official Anthropic/MCP release. Was moved out of the core monorepo in mid-2025 but remains maintained and published on npm.

**Install:**
```bash
npx -y @modelcontextprotocol/server-slack
```

**Claude Code settings.json config:**
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-bot-token",
        "SLACK_TEAM_ID": "T01ABCDEFGH",
        "SLACK_CHANNEL_IDS": "C01ABC,C02DEF"
      }
    }
  }
}
```

**Tools provided (8 total):**
- `slack_post_message` — send to any channel
- `slack_reply_to_thread` — thread replies
- `slack_add_reaction` — emoji reactions
- `slack_get_channel_history` — read channel messages
- `slack_get_thread_replies` — read thread
- `slack_list_channels` — enumerate channels
- `slack_get_users` — user directory
- `slack_get_user_profile` — user details

**Answers to key questions:**
- Can it send AND receive? Yes — bidirectional. Post + read history both work.
- Multi-channel support? Yes — omit `SLACK_CHANNEL_IDS` to access all public channels, or set it to scope access.
- Incoming real-time events? No — it's a pull model (Claude polls via `slack_get_channel_history`). For push (events when a message arrives), you'd need a separate Slack Events API webhook or the Slack bot Python wrapper from V1.

**How it fits:** Drop into `settings.json` on any instance (Mac or VPS). Claude Code uses it to post updates, read HHA Slack channel, send heartbeat alerts. For V1 Wisdom-personal use, the pull model is fine — heartbeat checks Slack every 30 min. For client bots needing real-time response, add a thin Python event listener that triggers `claude -p`.

**Security:** Bot token goes in `.env`, not in settings.json directly. Load via `envFile` or shell environment. The `SLACK_CHANNEL_IDS` scope limiter prevents a compromised bot from reading all channels.

**Modifications needed:** None for basic use. Consider adding `SLACK_CHANNEL_IDS` to each client VPS config to scope to their channels only.

---

## 2. launchd Plist Template

**Winner: Standard Apple launchd agent pattern (no third-party needed)**

This is a solved problem — Apple's own tooling, no external dependency.

**Template for PS Bot heartbeat (`~/Library/LaunchAgents/local.psbot.heartbeat.plist`):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>local.psbot.heartbeat</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>cd /Users/wisdomhappy &amp;&amp; /usr/local/bin/claude -p --model haiku "$(cat ~/claude-system/entity/identity/HEARTBEAT.md)" --output-format text 2&gt;&gt; ~/claude-system/entity/data/heartbeat.log</string>
    </array>

    <key>StartInterval</key>
    <integer>1800</integer>

    <key>StandardOutPath</key>
    <string>/Users/wisdomhappy/claude-system/entity/data/heartbeat-stdout.log</string>

    <key>StandardErrorPath</key>
    <string>/Users/wisdomhappy/claude-system/entity/data/heartbeat-stderr.log</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>/Users/wisdomhappy</string>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin</string>
    </dict>

    <key>RunAtLoad</key>
    <false/>

    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
```

**Load/unload commands (modern macOS):**
```bash
# Load (activate)
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/local.psbot.heartbeat.plist

# Unload (deactivate)
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/local.psbot.heartbeat.plist

# Check status
launchctl print gui/$(id -u)/local.psbot.heartbeat
```

**Key design decisions:**
- `StartInterval 1800` (30 min) vs `StartCalendarInterval`: Use StartInterval. It fires 30 min after last run, not at wall-clock times — better for an LLM call with variable duration.
- `RunAtLoad false`: Don't fire on login; let the first interval tick naturally.
- `KeepAlive false`: This is a periodic task, not a persistent daemon — don't restart on exit.
- **Mac sleep behavior:** launchd catches up missed intervals when the Mac wakes. A heartbeat scheduled during sleep runs at wake time. This is correct behavior for PS Bot.
- **PATH env:** launchd agents run in a stripped environment. Explicitly set PATH to include wherever `claude` is installed.

**References:**
- https://launchd.info/ — canonical reference
- https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html — Apple docs

---

## 3. tmux Session Management for AI Agents

**Two options, different tradeoffs:**

### Option A: agent-manager-skill (fractalmind-ai)
- **Source:** https://github.com/fractalmind-ai/agent-manager-skill
- **License:** MIT
- **Install:** `npx --yes openskills install fractalmind-ai/agent-manager-skill`
- **What it does:** Python CLI + tmux lifecycle management. Start, stop, monitor, assign tasks. Cron-friendly. Heartbeat observability via `heartbeat trace` and `heartbeat slo`. No server required.
- **Commands:**
  ```bash
  python3 .agent/skills/agent-manager/scripts/main.py list
  python3 .agent/skills/agent-manager/scripts/main.py start EMP_0001
  python3 .agent/skills/agent-manager/scripts/main.py status EMP_0001
  python3 .agent/skills/agent-manager/scripts/main.py monitor EMP_0001 --follow
  ```
- **Fit:** Good for managing multiple named agent sessions on a VPS. The "EMP" naming convention is theirs — adapt to PS Bot naming.
- **Gap:** Documentation doesn't show explicit auto-restart on crash. Need to add a watchdog cron (see below).

### Option B: Custom tmux wrapper script (recommended for V1)
Simpler, no external dependency. The pattern used by most production deployments:

```bash
#!/usr/bin/env bash
# /opt/psbot/scripts/ensure-running.sh
SESSION="psbot-main"

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION" -x 220 -y 50
    tmux send-keys -t "$SESSION" \
        "cd /opt/psbot && claude --model sonnet --permission-mode bypassPermissions" Enter
    echo "$(date): Started $SESSION" >> /var/log/psbot-watchdog.log
else
    echo "$(date): $SESSION already running" >> /var/log/psbot-watchdog.log
fi
```

Paired with a cron job (VPS): `*/5 * * * * /opt/psbot/scripts/ensure-running.sh`

- **Auto-restart:** Cron runs every 5 min, script checks if tmux session exists, creates it if dead.
- **Persistent:** tmux session survives SSH disconnect.
- **Logging:** stdout/stderr captured in tmux scrollback + separate log file.
- **Monitoring bot:** The bot-managing-bot (Tier 2) SSHes in and runs `tmux has-session -t psbot-main` to health-check each client VPS.

**Also useful:** `opensessions` (https://github.com/Ataraxy-Labs/opensessions) — tmux sidebar showing agent status across sessions. Good for Wisdom's Mac where multiple agents might run.

---

## 4. Claude Code Session JSONL Parser

**Three options, different use cases:**

### Option A: claude-history (thejud) — best for CLI search
- **Source:** https://github.com/thejud/claude-history
- **License:** "As-is for educational and personal use" (no formal OSS license)
- **Install:** Clone, `chmod +x claude_history.py`, no dependencies (stdlib only)
- **Usage:**
  ```bash
  python3 claude_history.py ~/my-project            # user prompts only
  python3 claude_history.py --agent ~/my-project    # include Claude responses
  python3 claude_history.py --nodate ~/my-project   # no timestamps
  ```
- **How it works:** Converts project path → Claude's internal naming scheme → locates session files in `~/.claude/projects/` → sorts chronologically → outputs markdown.
- **Fit:** Best for the heartbeat's "scan recent history" and for building the lean-chronicle from session data. Pure stdlib = no dependency risk.

### Option B: claude-JSONL-browser (withLinda) — best for exploration
- **Source:** https://github.com/withLinda/claude-JSONL-browser
- **License:** Not specified (actively maintained, Next.js app)
- **Install:** `npm install && npm run dev` or visit jsonl.withlinda.dev (live web version)
- **Features:** Web UI, cross-conversation search, preserves tool usage and model changes. Processes files client-side for privacy.
- **Fit:** Good for Wisdom's desktop exploration of conversation history. Not useful on VPS.

### Option C: Direct JSONL parsing (DIY, recommended for entity use)
For the heartbeat and entity's own history reading, a minimal parser is cleaner than a dependency:
```python
import json, pathlib

def read_session(session_path):
    """Read a Claude Code JSONL session file, return messages."""
    messages = []
    with open(session_path) as f:
        for line in f:
            obj = json.loads(line)
            if obj.get("type") == "message":
                messages.append(obj)
    return messages
```
Claude Code sessions store one JSON object per line. The entity can read its own recent sessions this way during heartbeat — no external tool needed.

**For the `session-id` skill:** The existing `~/.claude/sessions/` PID registry already handles this. No new parser needed.

---

## 5. SOUL.md / Identity File Templates

**Winner: aaronjmars/soul.md + SoulSpec v0.5**

### Primary: soul.md (Aaron J. Mars)
- **Source:** https://github.com/aaronjmars/soul.md
- **License:** MIT
- **Website:** https://soul-md.xyz

**File system:**
```
soul/
  SOUL.md      — identity, worldview, opinions, hot takes
  STYLE.md     — voice, syntax, patterns, vocabulary
  SKILL.md     — operating modes (brief, essay, code, etc.)
  MEMORY.md    — session continuity (maps to our current-state.md)
  data/        — raw source material
  examples/    — good and bad output examples
```

**Key design philosophy (directly applicable):**
- Specificity beats vagueness. Not "I care about quality" but "I refuse to ship code that doesn't have error handling on external API calls."
- Internal contradictions make identity identifiable — don't resolve them, name them.
- Cross-model calibration: test soul files against both strong and weaker models; where weaker models drift, tighten the spec.
- Place identity/voice specs BEFORE tool definitions in system prompt.

**Integration pattern:** `claude --system-prompt "$(cat entity/identity/SOUL.md)" -p "$(cat entity/identity/HEARTBEAT.md)"`

### Extended: SoulSpec v0.5
- **Source:** https://soulspec.org
- **Adds:** `soul.json` (machine-readable metadata, compatibility tags, hardware/safety constraints), `AGENTS.md` (multi-agent configurations), `RULES.md` (hard constraints — maps to our guardrails.md)

**Mapping to our SPEC-v2 entity structure:**

| soul.md file | SPEC-v2 equivalent | Notes |
|---|---|---|
| SOUL.md | entity/identity/SOUL.md | Direct match |
| STYLE.md | (merge into SOUL.md) | PS Bot doesn't need a separate style file yet |
| SKILL.md | Digital Core skills/ | Skills are already external |
| MEMORY.md | entity/identity/current-state.md | Our naming is more precise |
| RULES.md | entity/guardrails.md | Direct match |
| data/ | entity/data/ | Direct match |

**Modifications needed:** Adopt the soul.md specificity principle when writing the entity's SOUL.md. Don't need to adopt their full file structure — we have a better one in SPEC-v2.

**Security:** SOUL.md is T0 (read-only for entity). The entity can read it to know who it is, but cannot write to it. This is already in SPEC-v2.

---

## 6. Heartbeat / Cron Patterns for Autonomous AI Agents

**Key pattern: Heartbeat for batch observability, cron for time-critical outputs**

### nanobot (HKUDS) — closest to our architecture
- **Source:** https://github.com/HKUDS/nanobot
- **Notable:** Uses HEARTBEAT.md as the standing instruction file. "Create a file called HEARTBEAT.md, add instructions like 'Every weekday at 08:00 send a daily briefing,' and the agent handles it." This is exactly the SPEC-v2 pattern.
- **Pattern:** Heartbeat fires every N minutes, Claude reads HEARTBEAT.md for standing tasks, executes, writes observations to a log file.

### OpenClaw heartbeat pattern (widely referenced)
- **Source:** https://futurehumanism.co/articles/openclaw-proactive-autonomous-agent-guide/
- **Pattern:** HEARTBEAT.md defines what to check. One heartbeat call batches: check email + check calendar + review notifications = 1 API call, not 3 cron jobs.
- **Skill:** `proactive-agent` skill on lobehub marketplace provides a ready-made implementation.

### Nanobot v0.1.4 (released 2026)
- "Redesigned heartbeat, prompt cache optimization, hardened provider & channel stability"
- **Source:** https://github.com/HKUDS/nanobot/releases
- Full pre-built system: SOUL.md, memory, KANBAN, heartbeat. "Start in 24/7 mode in 30 minutes."
- Could be used as reference for heartbeat implementation, but it's a full framework (don't adopt the framework, steal the heartbeat pattern).

### The key insight for PS Bot heartbeat design
From the Heartbeats vs Cron article: heartbeats and cron must have non-overlapping responsibilities or they'll conflict. The split for PS Bot:
- **Heartbeat (launchd/cron, every 30 min):** Check current-state, scan for unread messages in entity/data/inbox/, process observations, update lean-chronicle, send Slack/Telegram alert if critical.
- **Cron (specific times):** Daily summary at 8am, weekly convictions review on Sunday.

**State persistence between heartbeats** (critical): The heartbeat MUST write what it did to `entity/data/observations/YYYY-MM-DD.md` before exiting. Without this, each heartbeat repeats the same checks indefinitely. The SPEC-v2 HEARTBEAT.md must include: "After completing all checks, write a summary of what was observed and actioned to entity/data/observations/$(date +%Y-%m-%d-%H%M).md."

---

## 7. VPS Deployment Scripts for Claude Code

**Winner: madalinignisca Ubuntu bootstrap gist + custom hardening**

### Ubuntu VM Bootstrap Script (madalinignisca)
- **Source:** https://gist.github.com/madalinignisca/f95af1dc22afc9b1cd12fe56a9ae9f8b
- **License:** Gist (no explicit license, use as reference)
- **What it does:** Idempotent bootstrap for Ubuntu 24.04 LTS. Installs Claude Code via Bun, tmux with pre-configured "claude" persistent session that auto-attaches on SSH, passwordless sudo for agent sessions, PATH configured correctly, `~/.claude/CLAUDE.md` generated with system docs, `settings.json` pre-authorizes common tools.
- **Key piece:** Auto-attach to tmux on SSH login. New SSH connections automatically attach to the existing "claude" session. Set `NOTMUX=1` to skip when needed.
- **Use:** Run as root on fresh VPS, creates a non-root user, then re-runs as that user.

### Seed (ebowwa)
- **Source:** https://github.com/ebowwa/seed
- **License:** MIT
- **Installs:** Claude Code CLI, GitHub CLI, Doppler (secrets), Tailscale, MCP servers (WebSearch, GitHub)
- **Use:** `git clone && ./setup.sh` — environment-aware, detects VPS vs local vs Codespaces.
- **Good for:** Secrets management via Doppler (alternative to manual .env files).

### Claude VPS Setup Prompt (deniurchak)
- **Source:** https://github.com/deniurchak/claude-vps-setup-prompt
- **What it is:** A Claude Code prompt that walks through setting up hardened Hetzner VPS: SSH hardening, fail2ban, UFW firewall, optional Tailscale.
- **Use:** Feed to Claude Code in a new VPS session to do the security setup interactively.

### Recommended VPS setup sequence for PS Bot Tier 2:
1. Provision Ubuntu 24.04 VPS (DigitalOcean/Hetzner, $6-12/month)
2. Run madalinignisca bootstrap script → gets Claude Code + tmux + passwordless sudo
3. Run deniurchak VPS setup prompt in Claude Code → SSH hardening + firewall
4. Clone Digital Core from GitHub: `git clone https://github.com/<your-dc-repo> ~/claude-system`
5. Create entity/ directory structure per SPEC-v2
6. Configure MCP servers in `~/.claude/settings.json` (Slack, Telegram)
7. Set up cron watchdog: `*/5 * * * * /opt/psbot/scripts/ensure-running.sh`
8. Test: SSH in, confirm auto-attached to tmux "claude" session, run `claude -p "who are you?"`

**Security considerations:**
- API keys in Doppler or root-owned `.env` file, not in settings.json
- Claude settings.json deny list blocks Bash, Edit on T0 files
- UFW: allow SSH (22) + nothing else inbound; all outbound
- Fail2ban on SSH login attempts
- Tailscale for secure management access (alternative to hardened SSH)

---

## Composition Map — What to Use Where

| Component | Source | Use In | Action |
|---|---|---|---|
| Slack MCP | `@modelcontextprotocol/server-slack` | Mac + VPS settings.json | Add to settings.json; create Slack bot in workspace |
| launchd plist | Template above | Mac heartbeat | Create file, load with launchctl bootstrap |
| tmux watchdog | Custom script (60 lines) | VPS Tier 2 | Write script, add to cron |
| JSONL parser | claude-history (stdlib) | Heartbeat history scan | Clone, use as reference for entity's own parser |
| JSONL browser | claude-JSONL-browser | Wisdom's Mac exploration | Optional; web version at jsonl.withlinda.dev |
| SOUL.md structure | aaronjmars/soul.md | entity/identity/SOUL.md | Adopt specificity principles; write fresh content |
| Heartbeat pattern | nanobot + OpenClaw patterns | entity/identity/HEARTBEAT.md | Write HEARTBEAT.md using nanobot's standing-task format |
| VPS bootstrap | madalinignisca gist | Tier 2 VPS setup | Run script on fresh Ubuntu 24.04 |
| VPS hardening | deniurchak prompt | Tier 2 VPS setup | Run after bootstrap |

## What's Already Built (Don't Rebuild)

From previous scouting:
- **Telegram bot:** `psbot/bot.py` — working, 1078 lines, `claude -p` per message
- **Injection scanner:** `psbot/injection.py` (or steal ductor's 13-pattern regex)
- **Streaming + formatting:** claudegram `streaming.py` + ductor's markdown→HTML converter
- **Message interrupt handling:** claudegram `InterruptibleProcessor`
- **Model router:** `psbot/model_router.py` — already exists, tune for V2

## Open Questions (Not Answered by Scouting)

1. **Slack MCP receive gap:** The official server is pull-only. For V1 personal use this is fine. For client bots needing real-time Slack response, need a thin Python listener (same pattern as current Telegram bot). Evaluate in V2.
2. **launchd + claude auth:** The `claude` CLI requires Anthropic API key. Confirm it's available in launchd's stripped environment via the `EnvironmentVariables` plist key. Alternative: set `ANTHROPIC_API_KEY` in a wrapper shell script that sources `.env` before calling `claude`.
3. **nanobot adoption:** nanobot v0.1.4 is the closest open-source match to the full SPEC-v2 vision. Worth a deeper read of its heartbeat implementation before writing ours from scratch. Source: https://github.com/HKUDS/nanobot
