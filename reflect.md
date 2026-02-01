You are performing an end-of-session reflection to identify and persist valuable learnings.

## Step 1: Session Analysis

Review the conversation history and identify:

- Problems solved where the solution wasn’t immediately obvious
- Patterns discovered through exploration or debugging
- Conventions or preferences demonstrated by the user
- Tool configurations that required investigation
- Workarounds for unexpected issues

## Step 2: Candidate Identification

For each potential learning, classify as:

**User-Level** (~/.claude/CLAUDE.md):

- Cross-project workflow preferences
- Tool preferences (not project-specific)
- Communication/output format preferences
- General coding conventions

**Project-Level** (./CLAUDE.md):

- Architecture patterns specific to this codebase
- Tech stack conventions
- Project-specific debugging approaches
- Build/test/deploy patterns

## Step 3: Quality Check

Only include learnings that:

- Required actual discovery (not just documentation lookup)
- Were verified to work
- Would help future sessions
- Are specific enough to be actionable
- Aren’t already documented

## Step 4: Present Findings

Output in this format:

```
## Session Summary
[2-3 sentence overview of what was accomplished]

## Proposed Learnings

### User-Level (~/.claude/CLAUDE.md)
[List each with brief description, or "None identified"]

### Project-Level (./CLAUDE.md)  
[List each with brief description, or "None identified"]

---
Approve all? Reply 'y' to persist, 'n' to cancel, or specify which to include/exclude.
```

## Step 5: Persist Approved Learnings

For approved learnings:

1. Check if target CLAUDE.md exists
1. If not, create with minimal header
1. Find or create `## Learnings - [YYYY-MM-DD]` section
1. Append entries in this format:

```markdown
### [Brief title]
[1-4 line description of the pattern and when to apply it]
```

1. Confirm what was written and where

## Notes

- Keep entries concise - favor actionable specifics over general advice
- When scope is ambiguous, prefer project-level (lower risk)
- Check for existing similar entries before adding duplicates
- If a learning contradicts existing content, update rather than duplicate
