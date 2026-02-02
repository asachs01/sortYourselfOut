#!/bin/bash

# Remote installer for sortyourselfout
# Usage: curl -fsSL https://raw.githubusercontent.com/asachs01/sortYourselfOut/main/install-remote.sh | bash

set -e

REPO_RAW="https://raw.githubusercontent.com/asachs01/sortYourselfOut/main"
CLAUDE_DIR="$HOME/.claude"

echo "Installing sortyourselfout skill..."

# Create directories
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills/sortyourselfout"
mkdir -p "$CLAUDE_DIR/commands"

# Download and install hook scripts
echo "Installing hook scripts..."
curl -fsSL "$REPO_RAW/hooks/reflect-activator.sh" -o "$CLAUDE_DIR/hooks/reflect-activator.sh"
chmod +x "$CLAUDE_DIR/hooks/reflect-activator.sh"

curl -fsSL "$REPO_RAW/hooks/claude-md-size-check.sh" -o "$CLAUDE_DIR/hooks/claude-md-size-check.sh"
chmod +x "$CLAUDE_DIR/hooks/claude-md-size-check.sh"

# Download and install skill
echo "Installing skill..."
curl -fsSL "$REPO_RAW/skills/sortyourselfout/SKILL.md" -o "$CLAUDE_DIR/skills/sortyourselfout/SKILL.md"

# Download and install slash commands
echo "Installing /reflect command..."
curl -fsSL "$REPO_RAW/commands/reflect.md" -o "$CLAUDE_DIR/commands/reflect.md"

echo "Installing /prune-claude-md command..."
curl -fsSL "$REPO_RAW/commands/prune-claude-md.md" -o "$CLAUDE_DIR/commands/prune-claude-md.md"

# Update settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Creating settings.json..."
    echo '{}' > "$SETTINGS_FILE"
fi

# Check if jq is available
if command -v jq &> /dev/null; then
    echo "Updating settings.json with hook configuration..."

    # Check if UserPromptSubmit hooks already exist
    if jq -e '.hooks.UserPromptSubmit' "$SETTINGS_FILE" > /dev/null 2>&1; then
        # Check if our hook is already there
        if jq -e '.hooks.UserPromptSubmit[] | select(.hooks[]?.command == "~/.claude/hooks/reflect-activator.sh")' "$SETTINGS_FILE" > /dev/null 2>&1; then
            echo "Hook already configured in settings.json"
        else
            echo "Warning: UserPromptSubmit hooks exist but ours is missing."
            echo "Please manually add this hook to your settings.json:"
            echo '  {"type": "command", "command": "~/.claude/hooks/reflect-activator.sh"}'
        fi
    else
        # Add the hook configuration
        jq '.hooks.UserPromptSubmit = [{"hooks": [{"type": "command", "command": "~/.claude/hooks/reflect-activator.sh"}]}]' \
            "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "Hook configuration added to settings.json"
    fi
else
    echo "Warning: jq not found. Please manually add this to $SETTINGS_FILE:"
    echo ''
    echo '{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/reflect-activator.sh"
          }
        ]
      }
    ]
  }
}'
    echo ''
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
