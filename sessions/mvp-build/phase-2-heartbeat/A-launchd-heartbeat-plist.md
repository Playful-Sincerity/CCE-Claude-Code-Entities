# Phase 2, Task A: Launchd Heartbeat Plist + Install Script

**Estimated time:** 45 min
**Dependencies:** Phase 1 complete
**Parallel with:** Tasks B, C

## Goal

Build a launchd plist template and install script so `spawn-entity.sh` can optionally install a heartbeat for a spawned entity. Test it fires correctly.

## Why

An entity with no heartbeat is a persistent conversation — useful, but not autonomous. The heartbeat is what makes the entity "think" on its own schedule.

## Design

### Plist template
`scripts/templates/heartbeat.plist.template` — launchd agent config with placeholder substitution:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ps.entity-{{ENTITY_NAME}}-heartbeat</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>cd "{{ENTITY_DIR}}" && /Users/wisdomhappy/.local/bin/claude --resume {{SESSION_ID}} -p "Run your heartbeat protocol from entity/identity/HEARTBEAT.md" --max-turns 50 --model haiku --output-format text >> "{{ENTITY_DIR}}/entity/data/heartbeat.log" 2>&1</string>
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

### Install script
`scripts/install-heartbeat.sh <entity-name>` that:
1. Reads entity's session-id
2. Generates plist from template with substitutions
3. Writes to `~/Library/LaunchAgents/com.ps.entity-<name>-heartbeat.plist`
4. Runs `launchctl bootstrap gui/$(id -u) <plist>`
5. Optionally kickstarts once to verify
6. Logs installation to entity/chronicle/

### Uninstall script
`scripts/uninstall-heartbeat.sh <entity-name>` that:
1. Runs `launchctl bootout gui/$(id -u) <plist>`
2. Removes the plist file
3. Logs removal

## Key Design Decisions

**`--max-turns 50`** — heartbeat resumes full session history so needs more turns than a one-shot. Observed this in testing — 15 wasn't enough.

**`--model haiku`** — heartbeat is a check-in, not deep work. Cheap.

**`StartInterval 1800`** — 30 minutes from last completion (self-throttling). Not StartCalendarInterval (could overlap).

**`RunAtLoad false`** — don't fire on every login. First heartbeat is 30 min after install.

**Log to entity/data/heartbeat.log** — raw output of every claude invocation. If entity hits errors, visible here.

## Verification

1. Install heartbeat for test entity
2. Kickstart once (`launchctl kickstart -k ...`)
3. Wait 90 seconds
4. Verify new observation file in `entity/data/observations/`
5. Verify current-state.md updated with new timestamp
6. Verify heartbeat.log shows claude output
7. Uninstall and verify plist removed

## Integration with spawn-entity.sh

After `spawn-entity.sh` completes, it currently prints:
> "To invoke as a one-shot..."

Add at the bottom:
> "To install automatic heartbeat (every 30 min):"
> "  bash scripts/install-heartbeat.sh {{ENTITY_NAME}}"

This makes heartbeat explicit, opt-in, easy to enable/disable.

## Deliverable

- `scripts/templates/heartbeat.plist.template`
- `scripts/install-heartbeat.sh`
- `scripts/uninstall-heartbeat.sh`
- Verified with throwaway test entity
