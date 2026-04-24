---
source_url: https://github.com/trusthandoff/agentcop
fetched_at: 2026-04-16 14:00
fetched_by: think-deep-github
project: Claude Code Entities
---

# trusthandoff/agentcop

**Stars:** 0 | **Language:** Python 96.7% | **Version:** v0.4.12 (Apr 10, 2026) | **License:** MIT | **Commits:** 87

## What It Claims

Universal cop for agent systems. AgentIdentity with behavioral baseline, trust scoring, and drift detection. Runtime Security Layer (4 enforcement layers), Reliability Engine (5 metrics), TrustChain (13 modules, Ed25519 signing, SHA-256 linking).

## What's Actually Implemented

Genuine code structure across: `src/agentcop`, `hooks/agentcop-monitor`, `skills/agentcop`, `plugins/agentcop-plugin`.

- **Reliability metrics shipped**: path entropy, tool variance, retry explosion, branch instability, token budget — with Prometheus export
- **TrustChain**: Ed25519 signing + SHA-256 linking per agent message (cryptographic)
- **AgentIdentity**: `SQLiteIdentityStore` for persistence, behavioral baseline, trust scoring

## What's Missing / Gap

Zero stars suggests it's either brand new or not discovered. Hook interceptor code for actual pre-generation gating not detailed in README. Behavioral baseline mechanism described but implementation not shown. No explicit provenance tagging (retrieved vs reasoned).

## Verdict

**Adapt.** The AgentIdentity + behavioral baseline + TrustChain pattern is directly relevant to value-drift detection. The cryptographic signing per message is interesting for audit trail. Low stars means it's unvetted — read the actual source before adopting any security-critical component.
