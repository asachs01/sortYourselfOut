# sortyourselfout

A Claude Code skill for autonomous learning - extracts valuable discoveries from sessions and persists them to CLAUDE.md files.

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Prompt                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              UserPromptSubmit Hook Fires                         │
│         (reflect-activator.sh outputs to stdout)                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│         Claude sees injected <system-reminder>                   │
│     with instructions to evaluate learnings after tasks          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Claude completes task                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              Claude silently evaluates:                          │
│     "Did I discover something worth persisting?"                 │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌──────────────────────┐        ┌──────────────────────┐
│   Quality gates      │        │   Nothing worth      │
│   passed → persist   │        │   persisting → done  │
└──────────────────────┘        └──────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Classify scope:                               │
│                                                                  │
│   User-level?              │    Project-level?                   │
│   ~/.claude/CLAUDE.md      │    ./CLAUDE.md                      │
│                            │                                     │
│   • Cross-project patterns │    • Codebase architecture          │
│   • Tool preferences       │    • Tech stack conventions         │
│   • Workflow habits        │    • Project-specific debugging     │
└─────────────────────────────────────────────────────────────────┘
```

## Installation

### Quick Install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/asachs01/sortYourselfOut/main/install-remote.sh | bash
```

### Clone & Install

```bash
git clone https://github.com/asachs01/sortYourselfOut.git ~/.claude/sortyourselfout
cd ~/.claude/sortyourselfout
./install.sh
```

### Manual Install

```bash
# Create directories
mkdir -p ~/.claude/{hooks,skills/sortyourselfout,commands}

# Copy files
cp hooks/reflect-activator.sh ~/.claude/hooks/
cp skills/sortyourselfout/SKILL.md ~/.claude/skills/sortyourselfout/
cp commands/reflect.md ~/.claude/commands/

# Make hook executable
chmod +x ~/.claude/hooks/reflect-activator.sh

# Add to settings.json (merge if you have existing hooks)
# See settings.example.json
```

## Usage

### Automatic Mode

Just work normally. After completing substantive tasks, Claude silently evaluates whether anything is worth persisting. You won’t see any output unless Claude writes to a CLAUDE.md file.

### Manual Mode

Run `/reflect` at any point to trigger interactive reflection with approval:

### Cleanup Mode

Run `/prune-claude-md` periodically to prevent bloat - it reviews learnings older than 30 days, consolidates duplicates, and archives stale entries.

## Available Commands

| Command | Mode | Best For |
|---------|------|----------|
| `/reflect` | Interactive | End of meaningful sessions - shows summary and asks for approval |
| `/prune-claude-md` | Interactive | Periodic cleanup of old learnings |
| (automatic) | Silent | Background learning capture after substantive tasks |

## Example /reflect Output

```
> /reflect

## Session Summary
Debugged WebSocket reconnection logic and fixed race condition in auth flow.

## Proposed Learnings

### User-Level (~/.claude/CLAUDE.md)
None identified.

### Project-Level (./CLAUDE.md)
1. **WebSocket reconnect needs auth token refresh** - The WS client must 
   call refreshToken() before reconnect attempts, not after. Token expires 
   during disconnect window.

2. **Race condition pattern in useAuth hook** - Multiple components mounting 
   simultaneously can trigger duplicate auth checks. Use refs to track 
   in-flight requests.

---
Approve all? Reply 'y' to persist, 'n' to cancel, or specify which to include/exclude.
```

## Two-Tier System

|Scope  |File                 |Persisted When                    |
|-------|---------------------|----------------------------------|
|User   |`~/.claude/CLAUDE.md`|Pattern applies across any project|
|Project|`./CLAUDE.md`        |Pattern specific to this codebase |

### User-Level Examples

```markdown
## Learnings - 2025-02-01

### Prefer streaming for long operations
When running commands >10s, stream output rather than buffer.
Progress visibility preferred over clean output.

### uv over pip for Python
Use `uv pip install` instead of `pip install`. Faster and handles 
resolution better.
```

### Project-Level Examples

```markdown
## Learnings - 2025-02-01

### Drizzle migrations need studio restart
After `drizzle-kit generate`, restart `drizzle-kit studio` to see 
schema changes. Hot reload doesn't pick up new migration files.

### Feature flags in env, not config
Feature flags use NEXT_PUBLIC_FF_* env vars, not the config/features.ts 
file. The config file is generated at build time from env.
```

## Quality Gates

Learnings are only persisted if they:

1. **Required discovery** - Not just reading documentation
2. **Were verified** - The solution actually worked
3. **Are reusable** - Would help in future sessions
4. **Are specific** - Actionable, not vague advice
5. **Aren't documented** - Not already in project docs

### Stricter User-Level Gates

User-level learnings (`~/.claude/CLAUDE.md`) affect ALL future sessions, so they must also:

- Apply regardless of tech stack (truly language/framework agnostic)
- Not be tied to any specific project structure
- Help in >50% of future projects
- Be a workflow, preference, or tool pattern (not code-specific)

## Bloat Protection

Several mechanisms prevent CLAUDE.md from growing unbounded:

1. **Strict quality gates** - Filters out noise before persistence
2. **Stricter user-level gates** - Extra filtering for global learnings
3. **Deduplication** - Scans for existing similar entries
4. **Size warnings** - Hook warns when files exceed thresholds
5. **Prune command** - `/prune-claude-md` reviews old entries for cleanup

## Integration with Claudeception

This system is complementary to [Claudeception](https://github.com/blader/Claudeception):

|System          |Output                   |Best For                                            |
|----------------|-------------------------|----------------------------------------------------|
|sortyourselfout |CLAUDE.md entries        |Quick patterns, preferences, conventions            |
|Claudeception   |Standalone SKILL.md files|Complex patterns needing detailed triggers, examples|

Use both together - Claudeception for sophisticated skills, sortyourselfout for lightweight context.

## Files

```
~/.claude/
├── CLAUDE.md                          # User-level learnings
├── hooks/
│   ├── reflect-activator.sh           # Continuous learning hook
│   └── claude-md-size-check.sh        # Size warning hook
├── skills/
│   └── sortyourselfout/
│       └── SKILL.md                   # Extraction logic
├── commands/
│   ├── reflect.md                     # /reflect slash command
│   └── prune-claude-md.md             # /prune-claude-md command
└── settings.json                      # Hook configuration

./
└── CLAUDE.md                          # Project-level learnings
```

## Customization

### Adjusting Quality Gates

Edit `~/.claude/skills/sortyourselfout/SKILL.md` to change what gets persisted.

### Changing Persistence Format

Edit both the SKILL.md and the hook script to use a different format for learnings.

### Disabling Automatic Mode

Remove the hook from `~/.claude/settings.json` but keep the `/reflect` command for manual use.

## Troubleshooting

**Learnings not being persisted:**

- Check hook is in settings.json
- Verify hook script is executable
- Restart Claude Code after changes

**Too many learnings being persisted:**

- Tighten quality gates in SKILL.md
- Switch to manual-only mode

**Wrong scope classification:**

- The skill defaults to project-level when uncertain
- Edit SKILL.md to adjust classification rules

## Credits

Inspired by:

- [Claudeception](https://github.com/blader/Claudeception) - Skill extraction pattern
- [reflection.md gist](https://gist.github.com/a-c-m/f4cead5ca125d2eaad073dfd71efbcfc) - Interactive reflection approach
- [Voyager](https://arxiv.org/abs/2305.16291) - Skill library research
