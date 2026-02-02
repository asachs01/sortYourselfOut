You are performing a periodic cleanup of CLAUDE.md files to prevent bloat and keep learnings relevant.

## Step 1: Identify Target Files

Check for CLAUDE.md files at:

1. **User-level:** `~/.claude/CLAUDE.md`
2. **Project-level:** `./CLAUDE.md` (current directory)

Read both files if they exist.

## Step 2: Analyze Learnings

For each learning entry found, evaluate:

### Age Check
- Extract date from `## Learnings - YYYY-MM-DD` headers
- Flag entries older than 30 days for review

### Relevance Check
- Is the learning still applicable to the current codebase/workflow?
- Has the underlying tool/library/pattern changed?
- Is the learning now documented elsewhere (official docs, README)?

### Duplication Check
- Are there multiple entries describing the same pattern?
- Can similar entries be consolidated into one?

### Validity Check
- Does the learning still work? (based on current project state)
- Has the workaround become unnecessary due to updates?

## Step 3: Present Findings

Output in this format:

```
## CLAUDE.md Cleanup Report

### ~/.claude/CLAUDE.md
**Total entries:** N
**Flagged for review:** M

#### Stale (>30 days)
1. **[Title]** (YYYY-MM-DD) - [Keep/Remove/Update?]
   Reason: [Why flagged]

#### Duplicates
1. **[Title A]** and **[Title B]** - Consolidate?

#### Outdated
1. **[Title]** - Pattern may no longer apply because...

### ./CLAUDE.md
[Same format]

---
Actions available:
- 'remove N' - Remove entry N
- 'consolidate A B' - Merge entries A and B
- 'keep all' - Keep everything as-is
- 'auto' - Apply recommended actions
```

## Step 4: Execute Approved Actions

For each approved action:

### Removing entries
1. Read current CLAUDE.md content
2. Remove the specified entry (title + description lines)
3. Clean up empty date sections if no entries remain
4. Write updated content

### Consolidating entries
1. Read both entries
2. Create a merged entry with combined insights
3. Remove original entries
4. Add consolidated entry under today's date
5. Write updated content

### Archive option
If user prefers archiving over deletion:
1. Create `~/.claude/CLAUDE.md.archive` or `./.claude-archive.md`
2. Move removed entries there with removal date
3. Keep archive for reference

## Step 5: Confirm Changes

After executing actions:

```
## Changes Applied

### ~/.claude/CLAUDE.md
- Removed: 2 entries
- Consolidated: 1 pair
- Kept: 5 entries

### ./CLAUDE.md
- Removed: 0 entries
- Archived: 3 entries to .claude-archive.md

Run `/prune-claude-md` again in 30 days to maintain freshness.
```

## Guidelines

- **Be conservative:** When uncertain, keep the entry
- **Prefer consolidation:** Merge similar entries rather than removing
- **Archive over delete:** Offer archiving for entries that might be useful later
- **Preserve structure:** Maintain proper markdown formatting
- **Date sections:** Remove empty `## Learnings - YYYY-MM-DD` headers after cleanup
