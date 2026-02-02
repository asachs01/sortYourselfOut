#!/bin/bash

# install.sh - Install sortyourselfout skill for Claude Code
#
# This script installs:
# - Hook script for automatic reflection triggers
# - Skill file for extraction logic
# - Slash command for manual reflection
# - Updates settings.json with hook configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing sortyourselfout skill..."

# Create directories
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills/sortyourselfout"
mkdir -p "$CLAUDE_DIR/commands"

# Install hook scripts
echo "Installing hook scripts..."
cp "$SCRIPT_DIR/hooks/reflect-activator.sh" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/reflect-activator.sh"

cp "$SCRIPT_DIR/hooks/claude-md-size-check.sh" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/claude-md-size-check.sh"

# Install skill
echo "Installing skill..."
cp "$SCRIPT_DIR/skills/sortyourselfout/SKILL.md" "$CLAUDE_DIR/skills/sortyourselfout/"

# Install slash commands
echo "Installing /reflect command..."
cp "$SCRIPT_DIR/commands/reflect.md" "$CLAUDE_DIR/commands/"

echo "Installing /prune-claude-md command..."
cp "$SCRIPT_DIR/commands/prune-claude-md.md" "$CLAUDE_DIR/commands/"

# Update settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Creating settings.json..."
    echo '{}' > "$SETTINGS_FILE"
fi

# Check if jq is available
if command -v jq &> /dev/null; then
    echo "Updating settings.json with hook configuration..."

    # Check if hooks already exist
    if jq -e '.hooks.UserPromptSubmit' "$SETTINGS_FILE" > /dev/null 2>&1; then
        echo "Warning: UserPromptSubmit hooks already exist in settings.json"
        echo "Please manually merge the hook configuration:"
        echo ""
        cat "$SCRIPT_DIR/settings.example.json"
        echo ""
    else
        # Add the hook configuration
        jq '.hooks.UserPromptSubmit = [{"hooks": [{"type": "command", "command": "~/.claude/hooks/reflect-activator.sh"}]}]' \
            "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "Hook configuration added to settings.json"
    fi
else
    echo "Warning: jq not found. Please manually add this to $SETTINGS_FILE:"
    echo ""
    cat "$SCRIPT_DIR/settings.example.json"
    echo ""
fi

# Create user-level CLAUDE.md if it doesn't exist
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Creating ~/.claude/CLAUDE.md..."
    cat > "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDEMD'
# User Preferences

<!-- This file contains cross-project preferences and learnings -->
<!-- Claude will append learnings discovered during sessions -->

## General Preferences

<!-- Add your preferences here, or let Claude learn them over time -->
CLAUDEMD
fi

echo ""
echo "Installation complete!"
echo ""
echo "Files installed:"
echo "  ~/.claude/hooks/reflect-activator.sh     (continuous learning hook)"
echo "  ~/.claude/hooks/claude-md-size-check.sh  (size warning hook)"
echo "  ~/.claude/skills/sortyourselfout/SKILL.md  (extraction logic)"
echo "  ~/.claude/commands/reflect.md            (/reflect command)"
echo "  ~/.claude/commands/prune-claude-md.md    (/prune-claude-md command)"
echo ""
echo "Usage:"
echo "  - Automatic: Claude will silently evaluate learnings after tasks"
echo "  - Manual: Run /reflect for interactive reflection with approval"
echo "  - Cleanup: Run /prune-claude-md to review and consolidate old learnings"
echo ""
echo "Note: Restart Claude Code for changes to take effect."
