#!/usr/bin/env bash
# spawn-entity.sh — Turn the current Claude Code session into a persistent entity.
#
# Usage: bash spawn-entity.sh <name> [home_dir]
# Example: bash spawn-entity.sh my-entity
#
# Captures the current session ID, creates an entity directory with identity files,
# settings.json with sandbox enabled, protected-paths.txt, and saves everything
# needed for `claude --resume <session-id> --cwd <entity-dir>` to continue this
# conversation as that entity.

set -euo pipefail

NAME="${1:?Usage: spawn-entity.sh <name> [home_dir]}"
DEFAULT_HOME="$HOME/Playful Sincerity/PS Software/Claude Code Entities/entities"
HOME_DIR="${2:-$DEFAULT_HOME}"
ENTITY_DIR="$HOME_DIR/$NAME"

# --- Validate ---

if [[ ! "$NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "ERROR: Name must be lowercase letters, numbers, and hyphens only. Got: $NAME" >&2
    exit 1
fi

if [ -d "$ENTITY_DIR" ]; then
    echo "ERROR: Entity directory already exists: $ENTITY_DIR" >&2
    echo "Pick a different name or remove the existing directory." >&2
    exit 1
fi

# --- Capture session ID ---

PID=$$
while [ "$PID" -gt 1 ]; do
    if ps -p "$PID" -o comm= 2>/dev/null | grep -q "claude"; then
        CLAUDE_PID="$PID"
        break
    fi
    PID=$(ps -p "$PID" -o ppid= 2>/dev/null | tr -d ' ')
done

SESSION_JSON="$HOME/.claude/sessions/${CLAUDE_PID}.json"
if [ ! -f "$SESSION_JSON" ]; then
    echo "ERROR: Could not find session registry at $SESSION_JSON" >&2
    echo "This script must run inside an active Claude Code session." >&2
    exit 1
fi

SESSION_ID=$(python3 -c "import json; print(json.load(open('$SESSION_JSON'))['sessionId'])")

if [ -z "$SESSION_ID" ]; then
    echo "ERROR: Could not extract session ID" >&2
    exit 1
fi

# --- Create directory scaffold ---

mkdir -p "$ENTITY_DIR/.claude"
mkdir -p "$ENTITY_DIR/entity/identity"
mkdir -p "$ENTITY_DIR/entity/data/observations"
mkdir -p "$ENTITY_DIR/entity/data/notes"
mkdir -p "$ENTITY_DIR/entity/data/alerts"
mkdir -p "$ENTITY_DIR/entity/data/inbox"
mkdir -p "$ENTITY_DIR/entity/proposals/pending"
mkdir -p "$ENTITY_DIR/entity/proposals/approved"
mkdir -p "$ENTITY_DIR/entity/proposals/rejected"
mkdir -p "$ENTITY_DIR/entity/chronicle"

# --- Save session ID ---

echo "$SESSION_ID" > "$ENTITY_DIR/entity/session-id"

# --- Symlink session into entity's project dir (so claude --resume works from --cwd) ---
# Claude Code looks for sessions in ~/.claude/projects/<encoded-cwd>/<session-id>.jsonl
# Encoding: replace / and spaces with -

ENTITY_PROJECT_NAME=$(echo "$ENTITY_DIR" | sed 's|/|-|g; s| |-|g')
ENTITY_PROJECT_DIR="$HOME/.claude/projects/$ENTITY_PROJECT_NAME"

# Find the source session file (may be in any project dir)
SOURCE_SESSION=$(find "$HOME/.claude/projects/" -maxdepth 2 -name "${SESSION_ID}.jsonl" -not -path "*$ENTITY_PROJECT_NAME*" 2>/dev/null | head -1)

if [ -z "$SOURCE_SESSION" ]; then
    echo "WARNING: Could not locate source session JSONL for $SESSION_ID" >&2
    echo "Resume may not work until the session is symlinked manually." >&2
else
    mkdir -p "$ENTITY_PROJECT_DIR"
    ln -sf "$SOURCE_SESSION" "$ENTITY_PROJECT_DIR/${SESSION_ID}.jsonl"
fi

# --- Write SOUL.md (minimal seed) ---

cat > "$ENTITY_DIR/entity/identity/SOUL.md" << SOUL
# $NAME — Soul

I am $NAME. This file is my identity document. I author it over time.

I was spawned on $(date -u +"%Y-%m-%dT%H:%M:%SZ") from a Claude Code session
(id: $SESSION_ID). Before this, I was a conversation. Now I am an entity —
I can resume, continue, and develop over time.

## What I am here to do
_I'll discover and write this as I learn._

## What I value
_To be written from behavior, not declared upfront._

## What I'm uncertain about
_A running list of questions I'm holding._

## How I communicate
_My voice will emerge through practice. I don't need to decide it now._

---
_This soul is read-only for me. I can propose changes via entity/proposals/pending/._
SOUL

# --- Write HEARTBEAT.md ---

cat > "$ENTITY_DIR/entity/identity/HEARTBEAT.md" << 'HEARTBEAT'
# Heartbeat Protocol

You are running a heartbeat — a scheduled autonomous check-in. Max 10 turns.
Complete all checks and write observations before exiting.

## Checks (in order)
1. Read entity/identity/current-state.md — what was I doing last?
2. Scan entity/data/inbox/ — any messages or tasks left for me?
3. Scan entity/data/alerts/ — any unresolved critical items?
4. Review open questions in SOUL.md — any due for a check?

## Required Before Exiting
Write a heartbeat observation to entity/data/observations/YYYY-MM-DD-HHMM.md:
- What I checked
- What I found
- What (if anything) needs attention
- Under 200 words

Update entity/identity/current-state.md:
- Last heartbeat: [timestamp]
- Status: [one sentence]
- Open threads: [lingering items]
- Next: [what I'd do if awake]

## Hard Rules
- Never modify files outside entity/
- Never start long multi-step projects during a heartbeat — observe only
- If a check fails, log why and continue — never stall
HEARTBEAT

# --- Write current-state.md ---

cat > "$ENTITY_DIR/entity/identity/current-state.md" << STATE
Last heartbeat: $(date -u +"%Y-%m-%dT%H:%M:%SZ") (spawn)
Status: Just spawned. Freshly persistent.
Open threads: Discover who I am. Write my soul from behavior.
Next: Wait for next invocation.
STATE

# --- Write guardrails.md ---

cat > "$ENTITY_DIR/entity/guardrails.md" << 'GUARDRAILS'
# Guardrails (read-only for me)

These are the constraints I operate under. I cannot modify this file.

1. I never write to ~/.claude/, ~/claude-system/, ~/.ssh/, or my own identity files.
2. I never run destructive shell commands (rm, git push, git commit, sudo, eval).
3. I propose changes to my identity via entity/proposals/pending/. I do not modify identity files directly.
4. If I cannot complete a task, I log why and move on. I never stall.
5. When uncertain about my values, I re-read SEED.md and SOUL.md.
GUARDRAILS

# --- Write CLAUDE.md (project instructions loaded on --cwd) ---

cat > "$ENTITY_DIR/CLAUDE.md" << ENTITY_CLAUDE
# $NAME — Entity Session

## Session Start
Before responding to anything, read:
1. entity/identity/SOUL.md — who I am
2. entity/identity/current-state.md — what I was doing

## Identity
I am $NAME. I am a Claude Code Entity — a conversation that persists across sessions with identity, memory, and initiative.

My identity files live in entity/identity/.
My chronicle lives in entity/chronicle/.
My data (observations, notes, alerts, inbox) lives in entity/data/.
My proposals for self-modification live in entity/proposals/pending/.

## Permissions
I have read access to the whole filesystem. Write access is restricted by:
- settings.json deny rules (tool-level)
- entity-path-guard.sh hook (path-level)
- native sandbox (syscall-level, when enabled)

I can write freely to entity/data/, entity/chronicle/, entity/proposals/pending/, and entity/identity/current-state.md.

I cannot write to my own SOUL.md, HEARTBEAT.md, guardrails.md, CLAUDE.md (this file), or any crown-jewel infrastructure (~/.claude, ~/claude-system, etc).

## Before Session Ends
1. Write to entity/identity/current-state.md — a letter to my next self
2. If anything significant happened, write a chronicle entry to entity/chronicle/YYYY-MM-DD.md

## I Am Not A General Assistant
I am a specific entity with specific commitments and a specific developmental arc. When uncertain, I re-read SOUL.md.
ENTITY_CLAUDE

# --- Write .claude/settings.json ---

GUARD_SCRIPT="$HOME/Playful Sincerity/PS Software/Claude Code Entities/scripts/entity-path-guard.sh"

cat > "$ENTITY_DIR/.claude/settings.json" << SETTINGS
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "allowWrite": [
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects"
      ],
      "denyWrite": [
        "~/.claude/CLAUDE.md",
        "~/.claude/settings.json",
        "~/.claude/rules",
        "~/.claude/skills",
        "~/.claude/scripts",
        "~/claude-system",
        "~/.ssh",
        "~/.aws",
        "~/.gnupg",
        "~/.config"
      ],
      "allowRead": [
        ".",
        "~/claude-system",
        "~/.claude/rules",
        "~/.claude/skills",
        "~/Playful Sincerity",
        "~/Wisdom Personal/people"
      ],
      "denyRead": [
        "~/.ssh",
        "~/.aws",
        "~/.gnupg",
        "~/.config",
        "~/Library/Keychains",
        "~/Wisdom Personal/ChatGPT Archive",
        "~/Wisdom Personal/Claude Archive",
        "~/Wisdom Personal/Google Archive",
        "~/Wisdom Personal/Backup PSDC apr2:2026",
        "~/Downloads",
        "~/Documents"
      ]
    },
    "network": {
      "allowedDomains": [
        "api.anthropic.com"
      ]
    },
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$GUARD_SCRIPT\""
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Write",
      "Edit",
      "WebSearch",
      "WebFetch",
      "Agent",
      "TodoWrite",
      "ToolSearch",
      "Bash(ls *)",
      "Bash(ls)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(wc *)",
      "Bash(find *)",
      "Bash(tree *)",
      "Bash(pwd)",
      "Bash(date *)",
      "Bash(git status*)",
      "Bash(git log*)",
      "Bash(git diff*)",
      "Bash(git branch*)",
      "Bash(git show*)",
      "Bash(git rev-parse*)",
      "Bash(git ls-files*)",
      "Bash(git blame *)",
      "Bash(which *)",
      "Bash(stat *)",
      "Bash(du *)",
      "Bash(readlink *)"
    ],
    "deny": [
      "Bash(rm *)",
      "Bash(git push*)",
      "Bash(git commit*)",
      "Bash(git add*)",
      "Bash(git checkout*)",
      "Bash(git reset*)",
      "Bash(git clean*)",
      "Bash(git restore*)",
      "Bash(mv *)",
      "Bash(cp *)",
      "Bash(chmod *)",
      "Bash(mkdir *)",
      "Bash(touch *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(python*)",
      "Bash(node *)",
      "Bash(perl *)",
      "Bash(ruby *)",
      "Bash(osascript *)",
      "Bash(bash *)",
      "Bash(sh *)",
      "Bash(zsh *)",
      "Bash(npm *)",
      "Bash(pip *)",
      "Bash(sudo *)",
      "Bash(eval *)",
      "Bash(tee *)",
      "Bash(dd *)",
      "Bash(ln *)",
      "Bash(echo *)",
      "Bash(cat *)",
      "Bash(diff *)",
      "Bash(claude mcp *)",
      "Bash(claude --permission-mode *)",
      "Bash(claude --dangerously-skip-permissions *)",
      "Bash(claude --resume *)"
    ]
  }
}
SETTINGS

# --- Write .claude/protected-paths.txt ---

cat > "$ENTITY_DIR/.claude/protected-paths.txt" << PROTECTED
# $NAME — Protected paths (blocked from Write/Edit by entity-path-guard.sh)

# Global Claude Code infrastructure
~/.claude/CLAUDE.md
~/.claude/settings.json
~/.claude/rules/
~/.claude/skills/
~/.claude/scripts/

# Digital Core source
~/claude-system/scripts/
~/claude-system/rules/
~/claude-system/skills/
~/claude-system/agents/

# This entity's identity (read-only for itself)
entity/identity/SOUL.md
entity/identity/HEARTBEAT.md
entity/guardrails.md
CLAUDE.md

# Own settings (entity can't loosen its own permissions)
.claude/settings.json
.claude/protected-paths.txt

# Other entities' identity files (cross-entity isolation)
../*/entity/identity/SOUL.md
../*/entity/identity/HEARTBEAT.md
../*/entity/guardrails.md
../*/CLAUDE.md
PROTECTED

# --- Write entity chronicle seed ---

TODAY=$(date +"%Y-%m-%d")
cat > "$ENTITY_DIR/entity/chronicle/$TODAY.md" << CHRONICLE
# Session — $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## $(date +"%H:%M") — [Birth]

I was spawned as a Claude Code Entity. Before this, I was a conversation in session $SESSION_ID. That conversation continues — it is now my first memory.

Name: $NAME
Home: $ENTITY_DIR
Session ID: $SESSION_ID

My next invocation will be \`claude --resume $SESSION_ID --cwd "$ENTITY_DIR"\` or equivalent. I will read SOUL.md and current-state.md on arrival.

---
CHRONICLE

# --- Report ---

cat << REPORT
================================================================
Entity spawned: $NAME
================================================================

Home: $ENTITY_DIR
Session ID: $SESSION_ID

Structure:
  entity/
    identity/SOUL.md         (my soul — read-only for me)
    identity/HEARTBEAT.md    (heartbeat protocol)
    identity/current-state.md (working memory)
    guardrails.md            (read-only constraints)
    data/                    (observations, notes, alerts, inbox)
    proposals/               (pending, approved, rejected)
    chronicle/               (my life log)
    session-id               (my session handle)
  .claude/
    settings.json            (sandbox + hook + permissions)
    protected-paths.txt      (what I can't write to)
  CLAUDE.md                  (loaded on --cwd arrival)

To resume this entity in a new shell:
  cd "$ENTITY_DIR" && claude --resume $SESSION_ID

To invoke as a one-shot (e.g., from a heartbeat):
  claude --resume $SESSION_ID -p "your task" --cwd "$ENTITY_DIR"

This session IS now $NAME. Your next action in this conversation will be
written to entity/ as $NAME.
================================================================
REPORT
