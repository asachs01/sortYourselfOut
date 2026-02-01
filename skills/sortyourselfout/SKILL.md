---
name: sortyourselfout
description: |
  Autonomous learning and context improvement for Claude Code sessions.
  Extracts valuable discoveries and persists them to CLAUDE.md files.
  Use when: session produced non-obvious solutions, debugging discoveries,
  workflow patterns, or project-specific conventions worth remembering.
  Triggers on: /reflect command, or automatically via hook after substantive tasks.
author: Claude Code
version: 1.0.0
---

# Sort Yourself Out Skill

Enables Claude Code to learn from sessions and persist valuable knowledge to CLAUDE.md files at appropriate scope levels.

## Overview

This skill implements a two-tier learning system:

- **User-level** (`~/.claude/CLAUDE.md`): Cross-project patterns and preferences
- **Project-level** (`./CLAUDE.md`): Codebase-specific conventions and discoveries

## Activation

### Automatic (via hook)

The `reflect-activator.sh` hook injects evaluation instructions on every prompt. Claude silently evaluates after completing substantive tasks.

### Manual (via command)

Run `/reflect` to trigger an interactive reflection session with explicit approval.

## Extraction Logic

### Step 1: Identify Candidates

Review the session for:

- Debugging solutions where root cause wasn’t immediately apparent
- Workarounds discovered through trial-and-error
- Project patterns learned through code exploration
- Tool configurations that required investigation
- Error resolutions that would help future sessions

### Step 2: Classify Scope

**User-level indicators:**

- Pattern applies regardless of tech stack
- Relates to Claude’s behavior/output format
- Tool preference (not project-specific tooling)
- Workflow pattern (git, testing approach, etc.)

**Project-level indicators:**

- Specific to this codebase’s architecture
- Depends on project’s tech stack
- References project-specific files/patterns
- Only makes sense in this repo’s context

**When uncertain:** Default to project-level (safer, less pollution)

### Step 3: Quality Gate Checklist

Before persisting, verify:

- [ ] Required actual discovery (not just reading docs)
- [ ] Solution was verified to work
- [ ] Would genuinely help future sessions
- [ ] Specific enough to be actionable
- [ ] Not already documented elsewhere
- [ ] Not a one-off edge case

### Step 4: Persistence Format

#### For user-level (`~/.claude/CLAUDE.md`):

```markdown
## Learnings - 2025-02-01

### Prefer streaming responses for long operations
When running commands that take >10s, stream output rather than buffering.
User prefers seeing progress over waiting for complete results.
```

#### For project-level (`./CLAUDE.md`):

```markdown
## Learnings - 2025-02-01

### Drizzle migrations require studio restart
After running `drizzle-kit generate`, must restart `drizzle-kit studio` 
to see schema changes. Hot reload doesn't pick up migration files.

### API routes follow /api/v1/[resource]/[id] pattern
All endpoints use kebab-case for resources. POST returns 201 with 
Location header. Errors use RFC 7807 problem details format.
```

## Anti-Patterns

**Don’t persist:**

- “Always write tests” (too vague)
- “User prefers TypeScript” (they already know this)
- “npm install failed, ran npm cache clean” (one-off fix)
- Anything from a docs lookup without additional discovery

**Do persist:**

- “TypeScript strict mode causes issue X with library Y, workaround is Z”
- “Test failures in CI but not local usually mean missing env var ABC”
- “User prefers error messages to include the attempted value, not just ‘invalid’”

## File Management

### Creating CLAUDE.md if missing

If the target CLAUDE.md doesn’t exist:

1. Create it with a minimal header
1. Add the learnings section

```markdown
# Project Context

## Learnings - 2025-02-01

### [First learning]
[Description]
```

### Appending to existing files

1. Read current content
1. Find or create `## Learnings - [today's date]` section
1. Append new entries under that section
1. Preserve all existing content

### Avoiding duplication

Before adding, scan existing learnings for:

- Same pattern already documented
- Contradictory information (update instead of duplicate)
- Similar entries that should be consolidated

## Interactive Reflection (/reflect command)

When user runs `/reflect`:

1. **Summarize session:** Brief overview of what was accomplished
1. **List candidates:** Present potential learnings with scope classification
1. **Await approval:** Let user approve/reject/modify each
1. **Persist approved:** Write to appropriate CLAUDE.md files
1. **Confirm:** Show what was persisted and where

Example output:

```
## Session Summary
Debugged Prisma connection pooling in serverless environment.
Implemented retry logic for transient failures.

## Potential Learnings

### User-Level
None identified.

### Project-Level
1. **Prisma connection pool exhaustion** - In Vercel/serverless, 
   Prisma needs `connection_limit=1` in DATABASE_URL to prevent 
   "too many connections" errors under concurrent load.

2. **Retry pattern for transient DB errors** - Project uses 
   exponential backoff with max 3 retries for P2024/P2025 errors.

Persist these? (y/n/edit)
```

## Integration with Claudeception

This skill is complementary to Claudeception’s skill extraction:

- **Claudeception:** Creates standalone skill files for complex, reusable patterns
- **sortyourselfout:** Appends quick learnings to CLAUDE.md for simpler patterns

Use Claudeception for patterns that need:

- Detailed trigger conditions
- Multi-step solutions
- Code examples
- Semantic matching for retrieval

Use self-improvement for patterns that are:

- Quick preferences/conventions
- Project-specific context
- Simple enough to state in 2-4 lines
