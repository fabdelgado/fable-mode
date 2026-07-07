#!/usr/bin/env bash
# fable-mode installer
# Installs the fable-mode skill globally and adds the always-on rules to ~/.claude/CLAUDE.md
# Usage: curl -fsSL https://raw.githubusercontent.com/fabdelgado/fable-mode/main/install.sh | bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/fabdelgado/fable-mode/main"
SKILLS_DIR="$HOME/.claude/skills/fable-mode"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
MARKER="# Reasoning rules (always on — Fable Mode)"

echo "▸ Installing fable-mode skill to $SKILLS_DIR"
mkdir -p "$SKILLS_DIR"

# If running from a local clone, copy; otherwise download from GitHub
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo "")"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/skills/fable-mode/SKILL.md" ]; then
  cp "$SCRIPT_DIR/skills/fable-mode/SKILL.md" "$SKILLS_DIR/SKILL.md"
else
  curl -fsSL "$REPO_RAW/skills/fable-mode/SKILL.md" -o "$SKILLS_DIR/SKILL.md"
fi
echo "  ✓ Skill installed"

echo "▸ Adding always-on rules to $CLAUDE_MD"
mkdir -p "$(dirname "$CLAUDE_MD")"
if [ -f "$CLAUDE_MD" ] && grep -qF "$MARKER" "$CLAUDE_MD"; then
  echo "  ✓ Rules already present — skipping (idempotent)"
else
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/templates/CLAUDE-rules.md" ]; then
    RULES="$(cat "$SCRIPT_DIR/templates/CLAUDE-rules.md")"
  else
    RULES="$(curl -fsSL "$REPO_RAW/templates/CLAUDE-rules.md")"
  fi
  if [ -f "$CLAUDE_MD" ]; then
    printf '\n%s\n' "$RULES" >> "$CLAUDE_MD"
  else
    printf '%s\n' "$RULES" > "$CLAUDE_MD"
  fi
  echo "  ✓ Rules added"
fi

echo ""
echo "Done. fable-mode is installed:"
echo "  • Skill:   ~/.claude/skills/fable-mode/SKILL.md  (invoke with /fable-mode or say \"fable mode\")"
echo "  • Rules:   ~/.claude/CLAUDE.md                    (always on, every session)"
echo ""
echo "Open a NEW Claude Code session for the changes to take effect."
