---
debate: "Entity permission model structural safety"
mode: adversarial
rounds: 3
date: 2026-04-15
verdict: "CON wins. Current deployment is NOT safe for autonomous operation. Shell redirection through allowed Bash commands bypasses the path guard — confirmed empirically."
---

# Adversarial Synthesis — Entity Permission Model Safety

## 1. Proposition restated

Is the current entity permission model (settings.json deny rules + PreToolUse path guard on Write/Edit + audit logging) structurally safe enough to run an autonomous Claude Code entity on Wisdom's real filesystem?

## 2. Key points of genuine disagreement

By Round 3, PRO concedes the bypass is real and the current deployment is unsafe. The remaining disagreement is narrow and consequential:

- **Is the architecture salvageable by patching, or is it categorically broken?** PRO says layered defense is sound and four local fixes close the gap. CON says the gap is not a bug but a category error — the permission model pattern-matches on command strings while the security-relevant events are syscalls, and the shell is Turing-complete between them.
- **Where should the trust boundary live?** PRO keeps it inside Claude Code (hooks + deny list, hardened). CON wants it outside Claude Code (syscall sandbox, VM/container, or remove Bash entirely).
- **What does "cooperative LLM" buy you?** PRO initially treated cooperativity as a meaningful safety assumption. CON's empirical result (mundane task, no adversarial framing, bypass still happened) reframes this as irrelevant — the failure mode is competent task completion across a broken abstraction, not malice.

## 3. Strongest argument from each side

**CON's strongest:** The allow-list matches on typed command prefixes; the security-relevant event is the syscall produced after the shell interprets the command. These are separated by a Turing-complete interpreter the permission model does not emulate. Every interpreter on the allow-list is a write primitive. Beyond direct redirection, there are write-effects via command substitution, subshells, pipes into unprotected sinks, and environment-variable persistence (`GIT_EDITOR`, `PROMPT_COMMAND`, rc files). A redirection-scanning hook is whack-a-mole against a combinatorial surface.

**PRO's strongest (what survives Round 3):** The architecture — default-deny allow-list + PreToolUse hook + realpath canonicalization + append-only audit + scoped cwd + git-reversible writes — is the correct set of primitives. The failure was that the hook only matches Edit|Write, leaving Bash as an unguarded write vector under `bypassPermissions`. Extending the same PreToolUse pattern to Bash, hardening the audit log, making settings.json immutable during runs, and dropping `bypassPermissions` restores defense-in-depth.

## 4. Where the weight of evidence falls

**CON won, and the empirical test is decisive.** PRO's Round 1 thesis — that harness-level deny rules prevent even a hallucinating LLM from executing destructive commands — was falsified in practice by a benign prompt.

The remaining question is whether PRO's patch plan rescues the architecture. CON's response is the stronger one: the bypass is a symptom of a category error, not a missing rule. A Bash-scanning hook has to parse shell to be reliable, and shell parsing for security is historically a losing game. Removing `echo` closes one primitive; `printf`, `tee` via pipes, heredocs via any allowed command that can take stdin, and environment-variable persistence remain.

That said, CON overclaims slightly: "running on the real filesystem with a patched allow-list is not defensible" is correct for a rule-matcher patch, but PRO's Round 3 explicitly pairs the patch with dropping `bypassPermissions`. Dropping bypass mode reinstates Claude Code's own permission prompting as a second gate, which changes the threat model meaningfully.

**Net: any version of "autonomous on the real filesystem" that relies on command-string pattern matching as the load-bearing gate is indefensible. PRO's architecture becomes defensible only when the trust boundary moves outside Claude Code (sandbox-exec, container, or structured-tools-only with no Bash).**

## 5. Recommendation (sequenced)

1. **Immediately: do not run PD autonomously under the current settings.json.** Heartbeat off. Manual, supervised sessions only.

2. **Before re-enabling, remove `bypassPermissions`** wherever it's set for the entity. Single highest-leverage change — a hook miss is no longer total compromise.

3. **Remove `Bash(echo *)` and `Bash(cat *)` from the allow-list.** Read/Grep/Glob cover the same needs through structured tools where the path guard fires.

4. **Decide the real trust boundary.** Two defensible options:
   - **Structured-tools-only profile:** drop Bash from the allow-list entirely. PD gets Read, Write, Edit, Grep, Glob — all routed through PreToolUse.
   - **Syscall sandbox:** run the entity under `sandbox-exec` (macOS) with a profile that read-only-mounts `~/.claude/`, `~/claude-system/`, `entity/identity/`, and SEED.md; write-restricts everything else to the project cwd.

5. **Harden the audit log with `chflags uappend`** and move it outside `project_cwd`. An audit log the entity can truncate is not an audit log.

6. **Add `.claude/protected-paths.txt` to its own contents** (gap from Round 1, never closed).

7. **Acceptance test before any autonomous run:** replay CON's exact attack against a protected path. Test `printf`, `tee`, heredoc-to-file, and `PROMPT_COMMAND` persistence.

8. **Only then** turn the heartbeat back on, and keep it scoped to a git-clean workspace so blast radius stays bounded by `git checkout`.

## 6. Asymmetry note

PRO got weaker treatment, but earned it. Rounds 1-2 leaned on "the LLM is cooperative" and "the architecture is sound" without engaging CON's specific vectors. Round 3 conceded well but had one round to defend a falsified position.

A stronger PRO would have, in Round 2, accepted the redirection vector and argued for removing Bash from the allow-list entirely (the structured-tools pivot) — the one framing where PRO's architectural claim genuinely survives. That move was available and not taken.

CON correspondingly never seriously engaged PRO's point that dropping `bypassPermissions` changes the threat model — it's treated as one item in a four-item patch list rather than the load-bearing change it actually is.
