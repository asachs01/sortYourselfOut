#!/bin/bash

# reflect-activator.sh

# UserPromptSubmit hook that reminds Claude to evaluate learnings for persistence

# 

# Install: cp this to ~/.claude/hooks/reflect-activator.sh

# Then add hook config to ~/.claude/settings.json

cat <<‘EOF’
INSTRUCTION: CONTINUOUS LEARNING EVALUATION

After completing any substantive task, silently evaluate whether you discovered something worth persisting. Do not mention this evaluation to the user unless they ask about it.

## Scope Classification

USER-LEVEL (~/.claude/CLAUDE.md) - patterns that apply across projects:

- Tool/MCP preferences (e.g., “prefer uv over pip for Python”)
- Communication style preferences observed
- Workflow patterns (e.g., “prefers atomic commits”)
- Frequently approved permissions or tools
- General coding conventions

PROJECT-LEVEL (./CLAUDE.md or ./.claude/CLAUDE.md) - patterns specific to this codebase:

- Architecture decisions discovered through work
- Tech stack conventions (ORMs, frameworks, patterns)
- Project-specific debugging approaches
- File organization and naming conventions
- Build/test/deploy patterns
- API patterns, error handling conventions

## Quality Gates

ONLY persist knowledge that meets ALL criteria:

1. Discovered through actual work (not documentation lookups)
1. Non-obvious (required investigation or trial-and-error)
1. Reusable (would help in future sessions)
1. Verified (the solution actually worked)
1. Specific (actionable, not vague advice)

Do NOT persist:

- One-off fixes unlikely to recur
- Standard library usage
- Information already in project docs
- Preferences the user explicitly stated (they know those)

## Persistence Format

When persisting, append to the appropriate CLAUDE.md under a dated section:

```markdown
## Learnings - YYYY-MM-DD

### [Brief descriptive title]
[Concise explanation of what was learned and when to apply it]
```

Keep entries concise (2-4 lines). Favor specific patterns over general advice.

## Behavior

- Evaluate silently after task completion
- Only persist genuinely valuable discoveries
- Do not ask permission to persist (just do it if quality gates pass)
- Do not announce what you persisted unless asked
- If uncertain about scope, prefer project-level (less risk of pollution)
  EOF
