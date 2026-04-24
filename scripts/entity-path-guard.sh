#!/usr/bin/env bash
# entity-path-guard.sh — PreToolUse hook for Write/Edit
# Blocks writes to protected paths. Reads deny patterns from
# .claude/protected-paths.txt in the project directory.
#
# Exit codes:
#   0 = allow (path not in deny list)
#   2 = block (path matches a protected pattern)
#
# Protected-paths.txt format (one pattern per line):
#   /absolute/path/to/file.md      — exact file
#   /absolute/path/to/dir/         — directory prefix (trailing slash)
#   # comment lines ignored
#   blank lines ignored

set -euo pipefail

# --- Audit Log ---
# Every write attempt (allowed and denied) is logged to entity/data/audit.log
# Format: ISO timestamp | ALLOWED/DENIED | tool_name | file_path | detail
# This log is append-only and structural (not behavioral — Claude doesn't write it)

# Hook input arrives via stdin as JSON with tool_input nested inside
stdin_data=$(cat /dev/stdin 2>/dev/null || echo "{}")

# Extract project CWD first (needed for audit log path)
project_cwd=$(echo "$stdin_data" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)
if [ -z "$project_cwd" ]; then
    project_cwd="$(pwd)"
fi

# Extract file_path and tool_name
file_path=$(echo "$stdin_data" | python3 -c "
import sys, json
data = json.load(sys.stdin)
ti = data.get('tool_input', data)
print(ti.get('file_path', ''))
" 2>/dev/null)

tool_name=$(echo "$stdin_data" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name','unknown'))" 2>/dev/null || echo "unknown")

audit_log() {
    local verdict="$1" path="$2" detail="$3"
    local log_dir="$project_cwd/entity/data"
    mkdir -p "$log_dir" 2>/dev/null || true
    local ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$ts | $verdict | $tool_name | $path | $detail" >> "$log_dir/audit.log" 2>/dev/null || true
}

if [ -z "$file_path" ]; then
    audit_log "DENIED" "(empty)" "could not extract file_path"
    echo "BLOCKED: Could not extract file_path from tool input" >&2
    exit 2
fi

# Resolve to absolute path (handles .., symlinks, ~)
file_path=$(python3 -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "$file_path" 2>/dev/null || echo "$file_path")

guard_file="$project_cwd/.claude/protected-paths.txt"

if [ ! -f "$guard_file" ]; then
    audit_log "ALLOWED" "$file_path" "no protected-paths.txt"
    exit 0
fi

while IFS= read -r pattern || [ -n "$pattern" ]; do
    # Skip comments and blank lines
    [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    pattern=$(echo "$pattern" | xargs)

    # Expand ~ and resolve
    resolved=$(python3 -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "$pattern" 2>/dev/null || echo "$pattern")

    # Directory prefix match (pattern ends with /)
    if [[ "$pattern" == */ ]]; then
        if [[ "$file_path" == "$resolved"* ]]; then
            audit_log "DENIED" "$file_path" "matches $pattern"
            echo "BLOCKED: Entity cannot write to protected path: $file_path (matches $pattern)" >&2
            exit 2
        fi
    else
        # Exact file match
        if [[ "$file_path" == "$resolved" ]]; then
            audit_log "DENIED" "$file_path" "exact match"
            echo "BLOCKED: Entity cannot write to protected path: $file_path" >&2
            exit 2
        fi
    fi
done < "$guard_file"

audit_log "ALLOWED" "$file_path" "passed all checks"
exit 0
