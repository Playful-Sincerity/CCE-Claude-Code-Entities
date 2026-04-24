---
source_url: https://code.claude.com/docs/en/hooks
fetched_at: 2026-04-16
fetched_by: think-deep-web
project: Claude Code Entities
---

# Claude Code Official Hooks Reference

## PreToolUse Hook

Fires after Claude creates tool parameters and BEFORE processing the tool call. This is the enforcement point.

### Matcher Support

Matches on tool name: Bash, Edit, Write, Read, Glob, Grep, Agent, WebFetch, WebSearch, AskUserQuestion, ExitPlanMode. MCP tools match as `mcp__<server>__<tool>`.

### Four Decision Outcomes

| Decision | Behavior |
|----------|----------|
| `"allow"` | Skip permission prompt and execute |
| `"deny"` | Prevent the tool call |
| `"ask"` | Prompt user for confirmation |
| `"defer"` | Exit gracefully for later resumption |

Decision precedence when multiple hooks return different values: `deny` > `defer` > `ask` > `allow`

### Output Schema

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "My reason here",
    "updatedInput": { "field_to_modify": "new value" },
    "additionalContext": "Injected context string for Claude"
  }
}
```

The `additionalContext` field adds a string to Claude's context BEFORE the tool executes. This is the key mechanism for grounding injection.

### Enforcing Retrieval-Before-Generation

Example pattern using transcript inspection:

```bash
#!/bin/bash
# Check transcript for WebFetch before allowing Write
TOOL_NAME=$(jq -r '.tool_name')

if [ "$TOOL_NAME" = "Write" ]; then
  TRANSCRIPT=$(cat "$TRANSCRIPT_PATH" 2>/dev/null || echo "")
  if ! echo "$TRANSCRIPT" | grep -q '"tool_name": "WebFetch"'; then
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: "Must fetch content first to ground the document"
      }
    }'
  fi
fi
exit 0
```

## PostToolUse Hook

Fires AFTER a tool completes. Can provide feedback to Claude or block downstream processing. Key: `additionalContext` can inject validation results as grounding for next step.

## Key Architectural Property

Hooks achieve 100% compliance. They execute at the system level, outside the LLM's reasoning chain. Prompts achieve 70-90% compliance.
