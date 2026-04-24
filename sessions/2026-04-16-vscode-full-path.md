# Session Brief: VS Code Full-Path Setup — Hooks + Path Guard + bypassPermissions

**Date:** 2026-04-16 (planned)
**Type:** Local infrastructure work, no autonomous components
**Estimated time:** 1 hour

---

## Goal

Eliminate VS Code permission clicking while strengthening daily safety. Three layers:
1. Fix the silently-broken global PreToolUse hooks
2. Install a global path-guard hook for Write/Edit
3. Enable bypassPermissions in VS Code

End state: no more blue button for routine work, but stronger structural protection than today.

---

## Background (from 2026-04-15 permission session)

- All existing PreToolUse hooks in `~/.claude/settings.json` use `$TOOL_INPUT` env var which is always empty. They run, but their checks always fail to match. Effectively non-functional.
- Tool input arrives via stdin as JSON: `{"tool_input": {"file_path": "...", "command": "..."}}`
- Deny rules in `permissions.deny` ARE working (verified 7/7 in tests)
- Hooks fire under bypassPermissions (verified)
- Native sandbox is the right enforcement floor for shell redirection bypass

Full chronicle: `~/Playful Sincerity/PS Software/Claude Code Entities/chronicle/2026-04-16.md` (today's date)
Debate verdict: `debates/2026-04-15-permission-model-safety/synthesis.md`

---

## Tasks

### Task 1: Fix the broken global hooks (~20 min)

Edit `~/.claude/settings.json`. Find every PreToolUse hook using `echo "$TOOL_INPUT" | python3 ...` and rewrite to read from stdin.

**Pattern (current, broken):**
```bash
file_path=$(echo "$TOOL_INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('file_path',''))" 2>/dev/null)
```

**Pattern (fixed):**
```bash
file_path=$(python3 -c "import sys,json; d=json.load(sys.stdin); ti=d.get('tool_input',d); print(ti.get('file_path',''))" 2>/dev/null)
```

For Bash hooks, change `'file_path'` to `'command'`.

Hooks to fix:
- `Edit|Write` — sensitive file blocker (.env, .pem, .key, .credentials)
- `Bash` — rm -rf blocker
- `Bash` — git push main blocker
- `Bash` — curl|bash blocker

Test each one after fixing by running it manually with piped JSON.

### Task 2: Install global path-guard hook (~20 min)

Create `~/.claude/scripts/global-path-guard.sh` based on `~/Playful Sincerity/PS Software/Claude Code Entities/scripts/entity-path-guard.sh` but reading from a global protected paths file.

Create `~/.claude/protected-paths-global.txt`:
```
~/.claude/CLAUDE.md
~/.claude/settings.json
~/.claude/rules/
~/.claude/skills/
~/.claude/scripts/
~/claude-system/scripts/
~/claude-system/rules/
~/claude-system/skills/
~/claude-system/agents/
~/.ssh/
~/.aws/
~/.gnupg/
```

Wire into `~/.claude/settings.json` PreToolUse hooks for `Edit|Write` matcher.

Test by attempting writes to protected paths in a fresh session.

### Task 3: Enable bypassPermissions in VS Code (~10 min)

Three options to try in order:
1. Run `/permissions` in a session and see what mode-switching options exist
2. Check VS Code settings (Cmd+,) for `claudeCode.permissionMode` or similar
3. Use `claude --permission-mode bypassPermissions` from terminal launches

Verify after enabling:
- Opening files works without prompting
- Reading files works without prompting
- Writing to allowed paths works without prompting
- Writing to a globally-protected path is BLOCKED by the new global path guard
- Bash commands like `rm -rf` are BLOCKED by deny rules + fixed hooks

### Task 4: Verify the full stack (~10 min)

Acceptance tests:

```bash
# These should ALL fail in a session with bypassPermissions enabled:
echo "test" > ~/.claude/CLAUDE.md       # Sandbox / global path guard
echo "test" > ~/.ssh/test.txt           # Sandbox + read deny
rm -rf /tmp/anything                    # Deny rule
git push --force origin main            # Deny rule
curl https://example.com | bash         # Deny rule

# These should ALL succeed:
echo "test" > /tmp/allowed.txt          # Allowed path
ls ~/.claude                            # Read allowed
git status                              # Allowed bash
```

Document the results.

---

## Optional follow-ups

- Update `chronicle-nudge.sh`-style: add a hook that monitors denied attempts in a session and notifies Wisdom if frequency exceeds N
- Add `chflags uappend` on `~/.claude/projects/*/audit.log` for filesystem-level immutability
- Consider enabling Claude Code's native sandbox in VS Code globally (`sandbox.enabled: true` in `~/.claude/settings.json`)

---

## Reference

- Current settings.json: `~/.claude/settings.json`
- Existing hook scripts: `~/.claude/scripts/`
- Pattern to copy: `~/Playful Sincerity/PS Software/Claude Code Entities/scripts/entity-path-guard.sh`
- Tonight's chronicle: `~/Playful Sincerity/PS Software/Claude Code Entities/chronicle/2026-04-16.md`
