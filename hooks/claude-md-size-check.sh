#!/bin/bash

# claude-md-size-check.sh
# Hook that checks CLAUDE.md file sizes and warns when they exceed thresholds
#
# Install: cp this to ~/.claude/hooks/claude-md-size-check.sh
# Then add hook config to ~/.claude/settings.json

# Thresholds (in bytes)
USER_LEVEL_THRESHOLD=10000    # ~10KB for ~/.claude/CLAUDE.md
PROJECT_LEVEL_THRESHOLD=20000 # ~20KB for ./CLAUDE.md

# Check user-level CLAUDE.md
USER_CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if [ -f "$USER_CLAUDE_MD" ]; then
    USER_SIZE=$(wc -c < "$USER_CLAUDE_MD" 2>/dev/null | tr -d ' ')
    if [ "$USER_SIZE" -gt "$USER_LEVEL_THRESHOLD" ]; then
        cat <<EOF
WARNING: ~/.claude/CLAUDE.md is getting large (${USER_SIZE} bytes)

Consider running /prune-claude-md to:
- Review and consolidate old learnings
- Remove outdated or duplicate entries
- Archive stale patterns

A lean CLAUDE.md loads faster and provides more focused context.
EOF
    fi
fi

# Check project-level CLAUDE.md
PROJECT_CLAUDE_MD="./CLAUDE.md"
if [ -f "$PROJECT_CLAUDE_MD" ]; then
    PROJECT_SIZE=$(wc -c < "$PROJECT_CLAUDE_MD" 2>/dev/null | tr -d ' ')
    if [ "$PROJECT_SIZE" -gt "$PROJECT_LEVEL_THRESHOLD" ]; then
        cat <<EOF
WARNING: ./CLAUDE.md is getting large (${PROJECT_SIZE} bytes)

Consider running /prune-claude-md to consolidate learnings.
EOF
    fi
fi
