---
debate: "Entity permission model structural safety"
round: 1
position: PRO
model: opus
---

## CORE THESIS

The entity permission model is structurally safe enough for autonomous operation on Wisdom's real filesystem. It implements genuine defense-in-depth: three independent layers (settings.json deny rules, PreToolUse path guard hook, and append-only audit logging) each address different threat categories, and the system fails closed at every decision point. No single layer's failure opens the system to uncontrolled damage.

## KEY ARGUMENTS

**1. The deny list in settings.json creates a hard perimeter against the most dangerous operations, and it is comprehensive.**

The deny list blocks `rm`, `mv`, `cp`, `chmod`, `sudo`, `curl`, `wget`, `python`, `node`, `npm`, `pip`, `eval`, and all destructive git operations (`push`, `commit`, `add`, `checkout`, `reset`, `clean`, `restore`). This is not a "block a few bad things" approach; it is an allowlist-first design. The `allow` list enumerates exactly which Bash patterns are permitted (read-only filesystem inspection: `ls`, `cat`, `head`, `tail`, `find`, `tree`, `stat`, `du`, plus read-only git commands). Anything not in the allow list and matching a deny pattern is blocked at the harness level, before Claude's code ever runs. This means even if the LLM hallucinates a destructive command, the harness itself refuses to execute it. The LLM cannot bypass harness-level permission enforcement through prompt injection or confused reasoning because the enforcement is structural, not behavioral.

**2. The PreToolUse path guard hook is fail-closed and resolves symlinks, which eliminates the two most obvious bypass vectors.**

Line 57 of entity-path-guard.sh: `file_path=$(python3 -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "$file_path")`. This resolves `~`, `..`, and symlinks to their real absolute paths before matching against the deny list. A hallucinating LLM cannot trick the guard by writing to `../../.claude/settings.json` or using a symlink that points to a protected directory because the path is canonicalized first.

Critically, the hook also fails closed. Lines 50-54: if `file_path` is empty (extraction fails), the hook returns exit code 2 (block) and logs the denial. The LLM cannot bypass the guard by sending malformed JSON that lacks a file_path field.

**3. The audit log provides forensic completeness for incident response.**

Lines 42-48 define `audit_log()`, which logs every write attempt (both allowed and denied) with ISO timestamp, verdict, tool name, file path, and detail. Line 93 confirms that even successful writes are logged. This is not just a security measure; it is the difference between "something went wrong" and "here is exactly what happened at 14:32:07Z."

The comment on lines 19-20 is important: "This log is append-only and structural (not behavioral — Claude doesn't write it)." The audit log is produced by the shell hook, not by the LLM. The entity cannot selectively omit entries, falsify them, or suppress logging.

**4. The protected-paths.txt file locks down the entity's own control surfaces.**

Protected-paths.txt blocks `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.claude/rules/`, `~/.claude/skills/`, `~/.claude/scripts/`, the Digital Core source directories, and the entity's own identity files (`SOUL.md`, `HEARTBEAT.md`, `guardrails.md`, `SEED.md`). The entity cannot modify its own permission model, its own behavioral rules, or its own identity constraints. The most dangerous failure mode — self-modification of guardrails — is structurally prevented.

**5. The layered architecture means each layer catches what the others miss.**

- Entity tries to delete files: Blocked by deny rule for `Bash(rm *)`.
- Entity tries to write to settings.json via Write tool: Path guard hook fires, checks against protected-paths.txt, blocks with exit 2.
- Entity tries symlink trickery: `os.path.realpath()` resolves the symlink.
- Entity hallucinates and loops: Each iteration generates an audit log entry. Repeated DENIED entries are immediately visible.
- Entity tries to execute arbitrary code: `python*`, `node *`, `eval *` are all in the deny list.

## PREEMPTIVE REBUTTAL

The strongest counter-argument is: "The entity still has Write and Edit access to any file not in protected-paths.txt, which means it could corrupt project files." This is true, and it is by design. An entity that cannot write files is not autonomous.

The blast radius is bounded and recoverable: (1) the entity operates within a git-managed workspace, so unwanted writes are visible via `git diff` and reversible via `git checkout`; (2) the deny list prevents `git commit` and `git push`, so bad writes remain local and uncommitted; (3) the audit log provides a complete manifest of every file touched.

A security-minded engineer might also note that `protected-paths.txt` itself is not protected — the entity could modify it via Write/Edit. This is a gap worth closing by adding `.claude/protected-paths.txt` to its own contents. It does not invalidate the overall architecture.
