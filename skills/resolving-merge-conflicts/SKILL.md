---
name: resolving-merge-conflicts
description: "MUST invoke when encountering git merge, rebase, or cherry-pick conflicts."
---

# Resolving Merge Conflicts

## Overview

Merge conflicts are NOT emergencies. Rushing leads to lost code and subtle bugs.

**Core principle:** ALWAYS understand BOTH sides of the conflict before resolving. Blind resolution destroys work.

**Violating the letter of this process is violating the spirit of conflict resolution.**

## The Iron Law

```
NO RESOLUTION WITHOUT UNDERSTANDING BOTH SIDES FIRST
```

If you haven't completed Phase 1, you cannot resolve conflicts.

## When to Use

Use for ANY git conflict scenario:
- `git merge` conflicts
- `git rebase` conflicts
- `git cherry-pick` conflicts
- `git stash pop` conflicts
- `git pull` conflicts (merge or rebase)

**Use this ESPECIALLY when:**
- Multiple files have conflicts
- Conflicts are in complex logic
- You don't recognize one side of the conflict
- The conflict spans many lines
- Both sides modified the same functionality differently

**Don't skip when:**
- Conflict seems simple ("just take theirs")
- You're in a hurry
- Only one file is conflicted

## The Five Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Understand the Conflict

**BEFORE attempting ANY resolution:**

1. **Identify All Conflicted Files**
   ```bash
   git status
   # or
   git diff --name-only --diff-filter=U
   ```
   - List every file with conflicts
   - Don't start resolving until you see the full scope

2. **Understand the Context**
   - What operation caused this? (merge, rebase, cherry-pick)
   - What branches/commits are involved?
   - What feature or fix was each side implementing?

3. **Read Both Sides Completely**
   ```
   <<<<<<< HEAD (or OURS)
   Your current branch's version
   =======
   The incoming version
   >>>>>>> branch-name (or THEIRS)
   ```
   - Read the ENTIRE conflict marker section
   - Understand what HEAD was trying to do
   - Understand what THEIRS was trying to do
   - Don't skim - read every line

4. **Check the History**
   ```bash
   # See what changed on each side
   git log --oneline HEAD...MERGE_HEAD  # for merges
   git log --oneline --left-right HEAD...MERGE_HEAD

   # See the actual changes
   git diff HEAD...MERGE_HEAD -- path/to/file
   ```

### Phase 2: Classify the Conflict Pattern

**Identify the conflict type to choose the right resolution strategy:**

| Pattern | Description | Resolution Approach |
|---------|-------------|---------------------|
| **Same Line Edit** | Both sides modified the same line(s) | Combine intent or choose correct version |
| **Adjacent Edits** | Changes near each other trigger conflict | Usually can keep both, verify no semantic conflict |
| **Delete vs Modify** | One side deleted, other modified | Determine if deletion was intentional refactor |
| **Rename vs Modify** | One renamed file, other modified it | Apply changes to renamed file |
| **Function Moved** | Code was moved, other side changed original | Apply changes at new location |
| **Divergent Refactor** | Both sides refactored differently | Choose better approach or synthesize |

**For each conflicted file, note:**
- Which pattern applies
- What the semantic intent of each side was
- Whether the changes are complementary or contradictory

### Phase 3: Plan the Resolution

**Before touching any file:**

1. **Determine Correct Behavior**
   - What should the final code do?
   - Does it need BOTH changes?
   - Does one change supersede the other?
   - Is there a third way that's better?

2. **Consider Tests**
   ```bash
   # Find tests related to conflicted code
   git log --oneline -- tests/ | head -20
   # or search for test files
   find . -name "*test*" -type f | xargs grep "function_name"
   ```
   - Are there tests that verify the behavior?
   - Will tests tell us if resolution is correct?

3. **Decide on Strategy Per File**
   - Manual merge: combine both changes
   - Take ours: `git checkout --ours <file>`
   - Take theirs: `git checkout --theirs <file>`
   - Custom: write new code that satisfies both intents

### Phase 4: Execute Resolution

**One file at a time, systematically:**

1. **For Manual Resolution**
   - Edit the file, remove conflict markers
   - Combine changes logically
   - Ensure no duplicate code
   - Ensure no missing code
   - Stage when correct: `git add <file>`

2. **For Automated Resolution**
   ```bash
   # Take your version entirely
   git checkout --ours <file>
   git add <file>

   # Take their version entirely
   git checkout --theirs <file>
   git add <file>
   ```
   - ONLY use these when you've confirmed the entire file should come from one side

3. **For Complex Conflicts**
   ```bash
   # Use a merge tool
   git mergetool <file>

   # Or see all three versions
   git show :1:<file>  # Base (common ancestor)
   git show :2:<file>  # Ours (HEAD)
   git show :3:<file>  # Theirs (incoming)
   ```

4. **Track Progress**
   ```bash
   git status  # Shows remaining conflicts
   ```

### Phase 5: Verify Resolution

**NEVER complete without verification:**

1. **Syntactic Verification**
   ```bash
   # Ensure code compiles/parses
   # Language-specific: npm run build, cargo check, etc.
   ```

2. **Run Tests**
   ```bash
   # Run ALL tests, not just ones you think are relevant
   npm test
   pytest
   cargo test
   # etc.
   ```

3. **Review the Final State**
   ```bash
   # See what you're about to commit
   git diff --cached

   # Verify no conflict markers remain
   git diff --cached | grep -E "^[+].*(<<<<|>>>>|====)" && echo "CONFLICT MARKERS REMAIN!"
   ```

4. **Complete the Operation**
   ```bash
   # For merge
   git commit  # Uses pre-prepared merge message

   # For rebase
   git rebase --continue

   # For cherry-pick
   git cherry-pick --continue
   ```

5. **Verify History**
   ```bash
   git log --oneline -5
   git show HEAD  # Review the merge/commit
   ```

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Just take theirs and move on"
- "I don't recognize this code but I'll keep my version"
- "Too many conflicts, let me abort and try again"
- "I'll just delete their changes"
- "This conflict doesn't make sense, probably a git bug"
- "Let me resolve all files with --ours to be safe"
- "I'll fix any bugs after the merge"

**ALL of these mean: STOP. Return to Phase 1.**

## Common Mistakes

| Mistake | Reality |
|---------|---------|
| "Take ours on everything" | You may lose important incoming changes |
| "Take theirs on everything" | You may lose your own important changes |
| "Conflict is in generated files, ignore it" | Generated files must be regenerated correctly |
| "Tests pass, so resolution is correct" | Tests may not cover the conflicting logic |
| "Just abort and re-do the work" | Understanding conflict teaches you about the codebase |
| "I'll manually resolve by deleting their code" | Their code exists for a reason - understand it |
| "Let IDE auto-resolve" | IDEs don't understand semantic intent |
| "Conflict markers are gone, I'm done" | Must verify syntax, tests, and review diff |

## Git Commands Reference

### Detection and Status
```bash
git status                              # Show all conflicted files
git diff --name-only --diff-filter=U    # List only conflicted files
git diff --check                        # Check for conflict markers
```

### Understanding Conflicts
```bash
git log --merge                         # Commits that introduced conflict
git log --left-right HEAD...MERGE_HEAD  # Show commits on each side
git diff HEAD...MERGE_HEAD -- <file>    # Diff between branches for file
git show :1:<file>                      # Base version (common ancestor)
git show :2:<file>                      # Ours (current branch)
git show :3:<file>                      # Theirs (incoming)
```

### Resolution Tools
```bash
git checkout --ours <file>              # Take current branch version
git checkout --theirs <file>            # Take incoming version
git checkout --merge <file>             # Reset to conflicted state
git mergetool                           # Open configured merge tool
git mergetool <file>                    # Open merge tool for specific file
```

### Completing Operations
```bash
git add <file>                          # Mark as resolved
git commit                              # Complete merge
git rebase --continue                   # Continue rebase
git cherry-pick --continue              # Continue cherry-pick
git merge --continue                    # Complete merge (Git 2.12+)
```

### Aborting (Last Resort)
```bash
git merge --abort                       # Abort merge
git rebase --abort                      # Abort rebase
git cherry-pick --abort                 # Abort cherry-pick
```

## When to Ask for Help

**Ask immediately if:**
- You don't understand what one side of the conflict was trying to do
- The conflict involves code written by someone else AND you can't determine intent
- The conflict is in configuration that affects production
- More than 10 files are conflicted and you're not sure of the overall strategy
- The conflict involves security-sensitive code
- You've resolved but tests fail in ways you don't understand

**Resolve independently if:**
- You understand both sides clearly
- The conflict is in code you own
- The resolution is obvious (typo fix vs substantial change)
- Tests exist and will verify the resolution
- You can explain why your resolution is correct

## Rebase-Specific Guidance

Rebase applies commits one at a time. Each conflict must be understood in context:

1. **Current Commit Context**
   ```bash
   git log -1  # Shows which commit is being applied
   ```

2. **Resolve for THIS Commit**
   - Resolution should make sense for this commit in isolation
   - Later commits may conflict again - that's expected

3. **Track Progress**
   ```bash
   git status  # Shows rebase progress (commit X of Y)
   ```

4. **If Hopelessly Lost**
   ```bash
   git rebase --abort  # Start over
   ```
   - Then reconsider: is rebase the right approach?
   - Consider `git merge` instead for complex histories

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Understand** | List files, read both sides, check history | Know what each side intended |
| **2. Classify** | Identify conflict pattern per file | Know which resolution strategy |
| **3. Plan** | Determine correct final behavior | Know the expected outcome |
| **4. Execute** | Resolve one file at a time | All files staged |
| **5. Verify** | Run tests, review diff, complete operation | Tests pass, no markers, committed |

## Related Skills

- **harness:systematic-debugging** - When resolution causes test failures
- **harness:verification-before-completion** - Verify resolution before claiming done
- **harness:test-driven-development** - Write tests for conflicted code if none exist
