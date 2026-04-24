#!/usr/bin/env bash
# spawn-entity.sh — Turn the current Claude Code session into a persistent entity.
#
# Usage: bash spawn-entity.sh <name> [--role role] [home_dir]
# Example: bash spawn-entity.sh avs-director --role director
#
# Captures the current session ID, creates an entity directory with identity files,
# settings.json with sandbox enabled, protected-paths.txt, and saves everything
# needed for `claude --resume <session-id> --cwd <entity-dir>` to continue this
# conversation as that entity.
#
# Roles: generic (default), director, ceo, treasurer, worker
# Each role gets a different allowWrite scope in settings.json.

set -euo pipefail

# --- Parse arguments ---

NAME=""
ROLE="generic"
HOME_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --role)
            ROLE="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "ERROR: Unknown flag: $1" >&2
            exit 1
            ;;
        *)
            if [ -z "$NAME" ]; then
                NAME="$1"
            elif [ -z "$HOME_DIR" ]; then
                HOME_DIR="$1"
            else
                echo "ERROR: Too many positional arguments" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$NAME" ]; then
    echo "Usage: bash spawn-entity.sh <name> [--role role] [home_dir]" >&2
    echo "Roles: generic (default), director, ceo, treasurer, worker" >&2
    exit 1
fi

DEFAULT_HOME="$HOME/Playful Sincerity/PS Software/Claude Code Entities/entities"
HOME_DIR="${HOME_DIR:-$DEFAULT_HOME}"
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

case "$ROLE" in
    generic|director|ceo|treasurer|worker)
        ;;
    *)
        echo "ERROR: Unknown role: $ROLE (must be generic, director, ceo, treasurer, or worker)" >&2
        exit 1
        ;;
esac

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

# --- Define role-specific allow-write paths ---

case "$ROLE" in
    generic)
        ALLOW_WRITE='[
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects"
      ]'
        ;;
    director)
        ALLOW_WRITE='[
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects",
        "knowledge/sources",
        "knowledge/markets",
        "pipeline"
      ]'
        ;;
    ceo)
        ALLOW_WRITE='[
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects",
        "businesses",
        "org-chart.md"
      ]'
        ;;
    treasurer)
        ALLOW_WRITE='[
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects",
        "knowledge/financials",
        "budgets"
      ]'
        ;;
    worker)
        ALLOW_WRITE='[
        ".",
        "~/Wisdom Personal/people",
        "~/.claude/projects"
      ]'
        ;;
esac

# --- Write .claude/settings.json (role-specific) ---

GUARD_SCRIPT="$HOME/Playful Sincerity/PS Software/Claude Code Entities/scripts/entity-path-guard.sh"

cat > "$ENTITY_DIR/.claude/settings.json" << SETTINGS
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "allowWrite": $ALLOW_WRITE,
      "denyWrite": [
        "~/.claude/CLAUDE.md",
        "~/.claude/settings.json",
        "~/.claude/rules",
        "~/.claude/skills",
        "~/.claude/scripts",
        "~/claude-system",
        "~/.ssh",
        "~/.aws",
        "~/.gnupg"
      ],
      "allowRead": ["/"]
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
      "Bash(cat *)",
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
      "Bash(echo *)",
      "Bash(diff *)",
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
      "Bash(npm *)",
      "Bash(pip *)",
      "Bash(sudo *)",
      "Bash(eval *)"
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

I was spawned as a Claude Code Entity with role: $ROLE. Before this, I was a conversation in session $SESSION_ID. That conversation continues — it is now my first memory.

Name: $NAME
Home: $ENTITY_DIR
Role: $ROLE
Session ID: $SESSION_ID

My next invocation will be \`claude --resume $SESSION_ID --cwd "$ENTITY_DIR"\` or equivalent. I will read SOUL.md and current-state.md on arrival.

---
CHRONICLE

# --- Create symlink for discoverability ---

# Ensure the entities directory exists
mkdir -p "$DEFAULT_HOME"

# If HOME_DIR is not the default, create a relative symlink from the default location
if [ "$HOME_DIR" != "$DEFAULT_HOME" ]; then
    SYMLINK_PATH="$DEFAULT_HOME/$NAME"
    if [ ! -e "$SYMLINK_PATH" ]; then
        # Create relative symlink back to the actual entity directory
        REL_PATH=$(python3 -c "import os.path; print(os.path.relpath('$ENTITY_DIR', '$DEFAULT_HOME'))")
        ln -s "$REL_PATH" "$SYMLINK_PATH"
    fi
fi

# --- Report ---

cat << REPORT
================================================================
Entity spawned: $NAME
================================================================

Home: $ENTITY_DIR
Role: $ROLE
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
    settings.json            (sandbox + hook + permissions, role-specific)
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
