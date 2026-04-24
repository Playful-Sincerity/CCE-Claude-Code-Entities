# Phase 2, Task B: Emergency Stop Scripts

**Estimated time:** 15 min
**Dependencies:** Phase 1 complete
**Parallel with:** Tasks A, C

## Goal

Build kill-switch scripts so Wisdom can stop entity autonomy fast if something weird is happening.

## Why

"Definitely want ability to have it stop if it gets out of control" — Wisdom, 2026-04-14.

Without this, if PD starts behaving weirdly at 3am, there's no quick way to halt it short of manually bootout-ing the launchd agent. Emergency stop must be one command.

## Scripts

### `scripts/pause-all-entities.sh`
Stops all entity heartbeats at once. The big red button.

```bash
#!/usr/bin/env bash
# pause-all-entities.sh — stop all entity heartbeats immediately
set -euo pipefail

echo "Pausing all entity heartbeats..."
count=0
for plist in ~/Library/LaunchAgents/com.ps.entity-*-heartbeat.plist; do
    [ -f "$plist" ] || continue
    name=$(basename "$plist" | sed 's/com.ps.entity-\(.*\)-heartbeat.plist/\1/')
    launchctl bootout gui/$(id -u) "$plist" 2>/dev/null && echo "  Paused: $name" && count=$((count+1))
done
echo ""
echo "Paused $count heartbeats. Plists remain on disk — resume with resume-all-entities.sh."
```

### `scripts/resume-all-entities.sh`
Restarts all paused heartbeats.

```bash
#!/usr/bin/env bash
# resume-all-entities.sh — restart all entity heartbeats
set -euo pipefail

echo "Resuming all entity heartbeats..."
count=0
for plist in ~/Library/LaunchAgents/com.ps.entity-*-heartbeat.plist; do
    [ -f "$plist" ] || continue
    name=$(basename "$plist" | sed 's/com.ps.entity-\(.*\)-heartbeat.plist/\1/')
    launchctl bootstrap gui/$(id -u) "$plist" 2>/dev/null && echo "  Resumed: $name" && count=$((count+1))
done
echo ""
echo "Resumed $count heartbeats."
```

### `scripts/kill-entity.sh <entity-name>`
Stops a single entity's heartbeat and any in-flight claude process associated with it.

```bash
#!/usr/bin/env bash
# kill-entity.sh <entity-name> — stop one entity's heartbeat and kill in-flight claude
set -euo pipefail

NAME="${1:?Usage: kill-entity.sh <entity-name>}"
PLIST="$HOME/Library/LaunchAgents/com.ps.entity-${NAME}-heartbeat.plist"

if [ -f "$PLIST" ]; then
    launchctl bootout gui/$(id -u) "$PLIST" 2>/dev/null && echo "Paused heartbeat: $NAME"
fi

# Find and kill any running claude processes for this entity
ENTITY_DIR=$(find "$HOME/Playful Sincerity" -type d -name "$NAME" -path "*entities*" 2>/dev/null | head -1)
if [ -n "$ENTITY_DIR" ]; then
    SESSION_ID=$(cat "$ENTITY_DIR/entity/session-id" 2>/dev/null || echo "")
    if [ -n "$SESSION_ID" ]; then
        # Find claude processes with this session-id
        PIDS=$(pgrep -f "claude.*$SESSION_ID" 2>/dev/null || echo "")
        if [ -n "$PIDS" ]; then
            echo "Killing in-flight claude processes: $PIDS"
            kill $PIDS 2>/dev/null || true
        fi
    fi
fi

echo "Entity $NAME stopped."
```

### `scripts/entity-status.sh`
Shows which entities have active heartbeats.

```bash
#!/usr/bin/env bash
# entity-status.sh — show all entity heartbeat status

echo "Entity Heartbeat Status"
echo "======================="
for plist in ~/Library/LaunchAgents/com.ps.entity-*-heartbeat.plist; do
    [ -f "$plist" ] || continue
    label=$(basename "$plist" .plist)
    name=$(echo "$label" | sed 's/com.ps.entity-\(.*\)-heartbeat/\1/')

    if launchctl print "gui/$(id -u)/$label" >/dev/null 2>&1; then
        last_exit=$(launchctl print "gui/$(id -u)/$label" 2>/dev/null | grep "last exit code" | awk '{print $NF}')
        echo "  $name  [LOADED]  last exit: ${last_exit:-unknown}"
    else
        echo "  $name  [PAUSED]"
    fi
done
```

## Optional but Valuable

### `/entity-stop` skill
One-line skill wrapper around `pause-all-entities.sh` for easy invocation from any Claude Code session:

```markdown
---
description: Emergency stop — pause all entity heartbeats immediately.
user-invocable: true
---

# /entity-stop — Emergency Stop

Run:
```bash
bash "/Users/wisdomhappy/Playful Sincerity/PS Software/Claude Code Entities/scripts/pause-all-entities.sh"
```
```

## Verification

1. Install a test entity with heartbeat
2. Run `pause-all-entities.sh` — verify heartbeat stops (check with `entity-status.sh`)
3. Run `resume-all-entities.sh` — verify heartbeat restarts
4. Run `kill-entity.sh test-entity-x` — verify single-entity kill works

## Deliverable

- `scripts/pause-all-entities.sh`
- `scripts/resume-all-entities.sh`
- `scripts/kill-entity.sh`
- `scripts/entity-status.sh`
- Optional: `~/.claude/skills/entity-stop.md`
