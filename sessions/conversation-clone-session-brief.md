# Session Brief: Conversation Clone — Agent Spawning from Conversation Context

## Goal

Design and implement a pattern where an agent can be spawned from an existing conversation's context. The agent reads the conversation's JSONL history and picks up where the conversation left off — or continues a specific thread from it.

## Context

Claude Code stores conversation histories as JSONL at `~/.claude/projects/` and `~/.claude/sessions/`. These contain full conversation turns, tool calls, and results.

The idea: instead of briefing a new agent from scratch, you point it at a conversation and say "continue this thread" or "you are a clone of this conversation — here's what was discussed, now go deeper on X."

## Use Cases

1. **Research continuation** — deep in a research session, want a sub-agent to continue a specific thread while you move to something else
2. **Context handoff** — finished a planning conversation, want an execution agent that has full context of what was decided
3. **Parallel exploration** — clone a conversation at a decision point, explore both options in parallel
4. **Entity memory seeding** — a new entity reads past conversations to build initial understanding

## What to Design

1. **How does the agent access the conversation?** Options:
   - Read the JSONL file directly (agent has file path)
   - Paste a conversation summary (manual, lossy)
   - A skill that extracts and formats conversation context for agent prompts

2. **What gets extracted?** The full JSONL is too large for a prompt. Need:
   - Key decisions made
   - Current state of the work
   - Specific thread to continue
   - Relevant file paths mentioned

3. **How is the clone invoked?** Options:
   - A rule: "when spawning an agent for continuation, read the parent conversation first"
   - A skill: `/clone-conversation <session-id> <thread-description>`
   - Manual: paste the session brief into the agent prompt

4. **How does the clone report back?** Write to a shared location (entity/data/, remote-entries/, or the original project directory)

## Research Directions

- How does the `/session-id` skill work? Can it find sessions by content?
- What's the JSONL structure? How to parse efficiently?
- `thejud/claude-history` — the parser found in plan-deep scouting
- Maximum context that can be injected into a `claude -p` prompt
- Whether Claude Code's `--resume` flag could serve this purpose directly

## Starting Point

Read:
- `~/Playful Sincerity/PS Software/Claude Code Entities/SPEC.md` (conversation access section)
- `~/Playful Sincerity/PS Software/Claude Code Entities/plan-section-behavioral.md` (conversation-access rule)
- `~/.claude/skills/session-id` (existing skill for finding sessions)

## Success Criteria

- A working pattern (skill, rule, or manual process) for spawning an agent from a conversation
- The agent demonstrates awareness of what was discussed in the source conversation
- The pattern is documented and repeatable
