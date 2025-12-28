---
name: resuming-work
description: Use when starting work on a task that was previously in progress, after context loss, or at the beginning of a new session on existing work
---

# Resuming Work

## Overview

Systematically restore context and continue work that was interrupted, whether by session end, context limits, or breaks between work periods.

**Announce at start:** "Using resuming-work to restore context and continue."

## When to Use

- Starting a new session on existing work
- After context window limit reached
- Returning from a break on in-progress work
- Picking up where another agent left off

## The Process

### Step 1: Locate Project Artifacts

Check for existing context:

```bash
# Find .harness directory
ls -la .harness/

# Find most recent feature directory
ls -lt .harness/ | head -5

# Check for in-progress plans
find .harness -name "plan.md" -exec grep -l "in_progress\|pending" {} \;
```

### Step 2: Read Context Documents

For the relevant feature directory, read in order:
1. `requirements.md` - What we're building
2. `research.md` - Technology decisions made
3. `design.md` - Architecture chosen
4. `plan.md` - Tasks and progress

### Step 3: Check Git State

```bash
# Current branch
git branch --show-current

# Recent commits (what was done)
git log --oneline -10

# Uncommitted changes (in-progress work)
git status
git diff --stat
```

### Step 4: Check Backlog

```bash
# Any items added during previous work
cat .harness/BACKLOG.md
```

### Step 5: Summarize and Confirm

Report to user:
- **Feature:** [name from requirements]
- **Progress:** [X of Y tasks complete from plan]
- **Last completed:** [Task name and brief description]
- **Next task:** [Task name]
- **Uncommitted work:** [Yes/No, brief description]
- **Blockers found:** [Any from backlog or notes]

Ask: "Ready to continue with [next task]?"

## Key Principles

- **Read before acting** - Fully restore context before making changes
- **Verify git state** - Don't lose uncommitted work
- **Check for blockers** - Previous session may have hit issues
- **Confirm with user** - Ensure alignment before proceeding

## Common Mistakes

| Mistake | Prevention |
|---------|------------|
| Starting fresh when work exists | Always check .harness/ first |
| Missing uncommitted changes | Check git status before anything |
| Ignoring backlog items | Review BACKLOG.md for blockers |
| Assuming context | Read all documents, don't assume |
