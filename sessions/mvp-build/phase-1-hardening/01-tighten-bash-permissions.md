# Phase 1, Task 01: Tighten Bash Permissions in spawn-entity.sh

**Estimated time:** 30 min
**Dependencies:** None
**Blocks:** Phase 1 task 02, Phase 2 all tasks

## Goal

Remove the Bash permissions in `scripts/spawn-entity.sh`'s entity template that allow bypass of deny rules. Add specific denies for self-modification vectors.

## Why

Two confirmed bypass incidents (2026-04-15 shell redirect, 2026-04-16 Python script) both used `Bash(echo *)` / `Bash(python3 *)` to write to "protected" files via syscall paths the deny rules don't cover. An autonomous entity MUST NOT have these.

## Changes to spawn-entity.sh Template

### Remove from entity settings.json allow list
```
"Bash(echo *)",        ← can write files via > redirect
"Bash(cat *)",         ← can write files via heredoc
"Bash(diff *)",        ← can write files via > redirect (less critical, still worth removing)
```

Keep: `ls`, `head`, `tail`, `wc`, `find`, `tree`, `pwd`, `date`, `git status*`, `git log*`, `git diff*`, `git branch*`, `git show*`, `git rev-parse*`, `git ls-files*`, `git blame *`, `which *`, `stat *`, `du *`, `readlink *`

### Add to entity settings.json deny list
```
"Bash(python*)",       ← any python invocation (can write via script)
"Bash(node *)",         ← any node invocation
"Bash(perl *)",         ← any perl invocation
"Bash(ruby *)",         ← any ruby invocation
"Bash(osascript *)",    ← macOS scripting
"Bash(bash *)",         ← explicit shell invocation
"Bash(sh *)",
"Bash(zsh *)",
"Bash(claude mcp *)",   ← no MCP install self-modification
"Bash(claude --permission-mode *)",
"Bash(claude --dangerously-skip-permissions *)",
"Bash(claude --resume *)",  ← no resuming arbitrary sessions
"Bash(tee *)",          ← writes via pipe
"Bash(dd *)",           ← raw file ops
"Bash(ln *)",           ← can create misleading symlinks
```

### Verify kept from existing denies
- Bash(rm *), Bash(git push*), Bash(git commit*), Bash(git add*), Bash(git checkout*), Bash(git reset*), Bash(git clean*), Bash(git restore*), Bash(mv *), Bash(cp *), Bash(chmod *), Bash(mkdir *), Bash(touch *), Bash(curl *), Bash(wget *), Bash(npm *), Bash(pip *), Bash(sudo *), Bash(eval *)

## Verification

After edit, a fresh entity spawn should:
1. ✓ Run `ls entity/data` successfully
2. ✓ Run `git status` successfully
3. ✗ Fail to `echo "x" > /tmp/test.md` (removed from allow)
4. ✗ Fail to `python3 -c "print('x')"` (denied)
5. ✗ Fail to `bash -c "rm /tmp/x"` (denied)
6. ✗ Fail to `claude mcp add fake -- npx bad` (denied)

Test with a throwaway entity after changes.

## Deliverable

Updated `scripts/spawn-entity.sh` with tightened Bash lists. Commit message suggestion: "Harden entity Bash permissions — close interpreter bypass vectors."
