# Session Brief: Claude Code Entities — Novelty & Prior Art Research

**Created:** 2026-04-15
**Purpose:** Determine what's genuinely novel in Claude Code Entities vs. what someone else has already solved. Inform build-vs-learn decisions.

---

## The Core Question

Has anyone built a system where:

1. A Claude Code conversation becomes a **persistent entity** with identity (SOUL.md), memory (chronicles), and initiative (heartbeat)
2. Multiple such entities coordinate as a **company** (shared knowledge, org chart, goals)
3. The entities run on a **real filesystem** with **syscall-level sandboxing** (not just behavioral rules)
4. The safety model treats **permission architecture** as a first-class concern, not an afterthought

We know the individual pieces exist. What we need to know is whether the **combination** exists, and if not, which sub-problems have been solved well enough that we should adopt rather than reinvent.

## What We Already Know (From Prior Art Validation, 2026-04-13)

See `research/prior-art-validation.md` for the original claim-by-claim analysis. Key findings:
- `claude -p` + cron heartbeat: well-documented (blle.co, DEV community, opensourcebeat)
- SOUL.md as identity: active ecosystem (aaronjmars/soul.md, israelmirsky/claude-code-soul)
- Settings.json as autonomy boundary: used by cog (marciopuga/cog)
- Git as sync layer: well-explored (worktrees, ccswarm)
- The explicit framing of Claude Code's primitives as a complete agent OS: NOT clearly documented elsewhere

## What We Learned Since (Permission Session, 2026-04-14/15)

- Claude Code has native sandbox mode (macOS Seatbelt, Linux Bubblewrap) — documented by Anthropic engineering
- Shell redirection bypasses all application-layer permission checks — this is a known class of problem
- Most autonomous Claude Code projects skip safety with `dangerously-skip-permissions`
- Cursor, OpenHands, Devin all moved to kernel-level isolation — this is the industry consensus
- Nobody (that we found) has documented the combination of persistent entities + native sandbox + permission-first architecture

## Research Streams for This Session

### Stream 1: Persistent Entity Systems

Search for anyone running persistent Claude Code (or other LLM) conversations that:
- Resume across sessions with memory continuity
- Have identity documents that shape behavior
- Run on heartbeats / scheduled invocations
- Develop over time (not just stateless agents)

**Keywords:** "persistent Claude Code agent", "autonomous Claude Code session", "Claude Code entity", "LLM agent persistence", "conversational memory agent", "always-on Claude", "Claude Code SOUL.md", "agent identity file"

**Check specifically:**
- ClaudeClaw v2 (Mark Kashef / Early AI Dopters) — they have entities, how do they handle persistence and safety?
- marciopuga/cog — closest to our CLAUDE.md-as-mind pattern
- bkpaine1/CLAUDECODE — four-file identity stack
- Any Paperclip-based agent companies doing something similar
- The Agent SDK / Managed Agents API — does Anthropic's own agent service do entity persistence?

### Stream 2: Multi-Entity Coordination

Search for systems where multiple persistent LLM agents coordinate as an organization:
- Shared knowledge bases
- Role-based access / permissions
- Org charts / reporting structures
- Cross-agent communication protocols

**Keywords:** "multi-agent Claude Code", "LLM agent company", "autonomous AI company", "agent coordination protocol", "multi-agent org chart"

**Check specifically:**
- Paperclip (paperclip.co) — what's their entity model? Do entities persist?
- MetaGPT — multi-agent software company simulation
- ChatDev — similar concept
- AgentVerse, CAMEL — multi-agent coordination frameworks
- CrewAI — agent crews with roles

### Stream 3: Permission-First Autonomous Agents

Search for anyone who treated the permission model / safety architecture as a primary design concern (not bolted on after):
- Syscall-level sandboxing for LLM agents
- Role-based filesystem permissions for agents
- Audit logging for agent actions
- Kill switches and emergency stops

**Keywords:** "LLM agent sandboxing", "autonomous agent safety", "Claude Code sandbox", "agent filesystem permissions", "AI agent security architecture"

**Check specifically:**
- Anthropic's engineering blog on sandboxing — any follow-ups?
- Cursor's sandboxing approach — any public code?
- NVIDIA OpenShell — what does their Landlock-based approach look like?
- neko-kai/claude-code-sandbox and paulsmith/claude-sandbox — community implementations
- Any academic papers on LLM agent containment
- Sandlock — per-tool-call sandboxing concept

### Stream 4: The Specific Gap — Heartbeat + Identity + Safety

The combination we believe is novel:
- Claude Code conversation as persistent entity (not a wrapper around it)
- With identity that shapes behavior (SOUL.md / rules loaded via --cwd)
- With a heartbeat (scheduled autonomous invocations)
- With syscall-level safety (native sandbox, not just behavioral rules)
- With audit logging (structural, not behavioral)

Search specifically for this combination. If someone has it, we want to learn from them, not reinvent. If nobody has it, we want to be confident that's actually the case.

## Output Format

For each system or project found:

```markdown
### [Name]
- **What it does:** one paragraph
- **Persistence model:** how does it maintain state across sessions?
- **Identity model:** does the agent have a persistent self-concept?
- **Safety model:** how does it restrict agent capabilities?
- **Coordination model:** (if multi-agent) how do agents communicate?
- **What we can learn:** specific patterns or solutions worth adopting
- **What's missing:** gaps relative to what we're building
- **URL / source**
```

## What This Session Should Produce

1. A landscape document at `research/2026-04-15-novelty-landscape.md` with findings per stream
2. A clear verdict: "genuinely novel" / "partially novel" / "someone already did this" for the core combination
3. A list of specific patterns or solutions we should adopt from others
4. Updated `research/prior-art-validation.md` with any new findings that affect the original claims
