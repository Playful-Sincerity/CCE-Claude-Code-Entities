#!/usr/bin/env bash
# dc-snapshot.sh — Create a timestamped snapshot of the full PS ecosystem
# Usage: bash dc-snapshot.sh [label]
# Example: bash dc-snapshot.sh pre-entity-test
# Output: ~/Digital-Core-Vault/ps-ecosystem_2026-04-14_2057_pre-entity-test.zip

set -euo pipefail

VAULT_DIR="$HOME/Digital-Core-Vault"
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
LABEL="${1:-}"

if [ -n "$LABEL" ]; then
    FILENAME="ps-ecosystem_${TIMESTAMP}_${LABEL}.zip"
else
    FILENAME="ps-ecosystem_${TIMESTAMP}.zip"
fi

mkdir -p "$VAULT_DIR"

echo "Creating full ecosystem snapshot → $VAULT_DIR/$FILENAME"
echo "Includes: claude-system, Playful Sincerity, Wisdom Personal, and supporting dirs"
echo "Estimated: ~8.5GB raw, compresses to ~2-3GB"
echo ""

zip -r -q "$VAULT_DIR/$FILENAME" \
    "$HOME/claude-system/" \
    "$HOME/claude-system-public/" \
    "$HOME/Playful Sincerity/" \
    "$HOME/Wisdom Personal/" \
    "$HOME/Ecosystem Map/" \
    "$HOME/remote-entries/" \
    "$HOME/happy-human-house/" \
    "$HOME/claude-code-main/" \
    "$HOME/.claude/projects/" \
    "$HOME/.claude/sessions/" \
    -x "*/node_modules/*" \
    -x "*/.git/*" \
    -x "*/venv/*" \
    -x "*/__pycache__/*" \
    -x "*.pyc"

SIZE=$(ls -lh "$VAULT_DIR/$FILENAME" | awk '{print $5}')
echo ""
echo "Done. $SIZE saved to $VAULT_DIR/$FILENAME"
echo ""
echo "Vault contents:"
ls -lh "$VAULT_DIR/"
