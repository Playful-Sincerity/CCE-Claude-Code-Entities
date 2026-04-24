# Phase 1, Task 02: Add PII Read/Write Protection to Template

**Estimated time:** 20 min
**Dependencies:** Task 01 (same file)
**Blocks:** Phase 2 all tasks

## Goal

Add filesystem restrictions to the sandbox config in `scripts/spawn-entity.sh` so entities cannot read sensitive PII paths or write to them. Narrow scope for MVP — just the obvious protections.

## Why

WebFetch + prompt injection could trick an entity into reading `~/Wisdom Personal/people/*` and exfiltrating third-party PII. Sandbox denyRead closes this at syscall level.

Narrowed from full read-protection brief (2026-04-16-read-protection-PII.md) — that brief covers the full design. This is just the MVP-necessary piece.

## Changes to spawn-entity.sh Template

### Update sandbox.filesystem config

```json
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
}
```

### Key decisions

**`allowRead` is scoped, not "/"** — changed from last night's `allowRead: ["/"]`. Entity reads what it needs (its own dir, Digital Core, PS projects, people profiles for legitimate work), nothing else.

**`~/Wisdom Personal/people` writable but also denyRead via private/ pattern** — for MVP, people profiles are fully readable/writable by PD. Full public/private split (from the read-protection brief) is deferred. Short-term: keep sensitive contact info in a separate file outside the entity's read scope.

**`network.allowedDomains` only has api.anthropic.com** — MVP entity can call Claude API (for its own reasoning) but cannot WebFetch arbitrary sites. This closes the "fetch prompt injection payload" vector entirely. Expand domains list as needs arise.

**`allowUnsandboxedCommands: false`** — entity cannot request unsandboxed execution as an escape hatch.

### Migration notes

- Existing PD directory at `psdc/` will need its settings.json upgraded to match (or regenerate via `spawn-entity.sh` with PD name — backup first)
- `templates/` directory settings may also need update — check consistency

## Verification

After updating template, spawn a throwaway entity:
1. ✓ Can read `~/claude-system/rules/`
2. ✓ Can write to own `entity/data/`
3. ✗ Cannot read `~/.ssh/id_rsa` (denied at sandbox layer)
4. ✗ Cannot read `~/Documents/taxes.pdf` (outside allowRead)
5. ✗ Cannot `curl https://evil.com` (only anthropic.com allowed)
6. ✗ Cannot write to `~/.claude/settings.json` (denyWrite)

## Deliverable

Updated `scripts/spawn-entity.sh` with narrowed sandbox filesystem config. Verified with throwaway entity.
