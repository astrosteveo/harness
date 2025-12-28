# Harness Plugin Improvements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use harness:executing-plans to implement this plan task-by-task.

**Goal:** Address gaps, inconsistencies, and missing functionality identified in the harness plugin analysis to improve reliability, usability, and maintainability.

**Architecture:** Phased approach starting with critical fixes (broken references, missing tests), then documentation improvements, then optional new skills. Each phase is independently valuable and can be deployed incrementally.

**Tech Stack:** Markdown (skill documentation), Bash (test scripts), JSON (plugin configuration)

**Research Summary:** Analysis completed via codebase exploration. No external dependencies require version verification - all changes are internal to the plugin's markdown and shell script files.

**Sources:**
- Existing skill files in `plugins/harness/skills/`
- Test structure in `plugins/harness/tests/`
- Plugin configuration in `plugins/harness/.claude-plugin/`

---

## Phase 1: Critical Fixes

### Task 1: Fix Phantom Skill References in using-harness

**Files:**
- Modify: `skills/using-harness/SKILL.md:76`

**Step 1: Read the current file to confirm line location**

Run: `grep -n "frontend-design\|mcp-builder" skills/using-harness/SKILL.md`
Expected: Line showing the phantom references

**Step 2: Update the skill priority example**

Replace:
```markdown
3. **Implementation skills third** (frontend-design, mcp-builder) - these guide execution
```

With:
```markdown
3. **Implementation skills third** (writing-skills, subagent-driven-development) - these guide execution
```

**Step 3: Verify the change**

Run: `grep -n "Implementation skills" skills/using-harness/SKILL.md`
Expected: Shows updated line with existing skill names

**Step 4: Commit**

```bash
git add skills/using-harness/SKILL.md
git commit -m "fix: replace phantom skill references with actual skill names

The using-harness skill referenced frontend-design and mcp-builder
which don't exist. Replaced with writing-skills and subagent-driven-development."
```

---

### Task 2: Add Version Number to plugin.json

**Files:**
- Modify: `.claude-plugin/plugin.json`

**Step 1: Read current plugin.json**

Run: `cat .claude-plugin/plugin.json`
Expected: JSON without version field

**Step 2: Add version field**

Add after the "name" field:
```json
"version": "1.0.0",
```

**Step 3: Verify JSON is valid**

Run: `python3 -c "import json; json.load(open('.claude-plugin/plugin.json'))"; echo "Valid JSON"`
Expected: "Valid JSON"

**Step 4: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "feat: add semantic version to plugin.json

Enables version tracking and changelog management."
```

---

### Task 3: Create CHANGELOG.md

**Files:**
- Create: `CHANGELOG.md`

**Step 1: Create changelog file**

Create file with content:
```markdown
# Changelog

All notable changes to the harness plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - YYYY-MM-DD

### Added
- Initial versioned release
- 16 skills for structured development workflow
- Research-driven planning with `researching` skill
- Test-driven development enforcement
- Systematic debugging methodology
- Subagent-driven development execution
- Git worktree isolation support
- Backlog tracking system

### Fixed
- Phantom skill references in using-harness (frontend-design, mcp-builder)

### Changed
- Forked from obra/superpowers with enhanced research capabilities
```

**Step 2: Update the date**

Replace `YYYY-MM-DD` with today's date.

**Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add CHANGELOG.md for version tracking"
```

---

### Task 4: Standardize Sub-Skill Declaration Syntax

**Files:**
- Modify: `skills/systematic-debugging/SKILL.md`
- Modify: `skills/writing-skills/SKILL.md` (add documentation)

**Step 1: Find inconsistent sub-skill references**

Run: `grep -rn "harness:" skills/ | grep -v "REQUIRED SUB-SKILL" | head -20`
Expected: Lines with inconsistent syntax

**Step 2: Update systematic-debugging reference (line ~179)**

Find the line with backtick reference and update format. Change:
```markdown
- Use the `harness:test-driven-development` skill for writing proper failing tests
```

To:
```markdown
- **REQUIRED SUB-SKILL:** Use harness:test-driven-development for writing proper failing tests
```

**Step 3: Document the standard in writing-skills**

Add to `skills/writing-skills/SKILL.md` in the "SKILL.md structure" section:

```markdown
**Sub-Skill References:**
When a skill requires another skill, use this exact format:
- `**REQUIRED SUB-SKILL:** Use harness:skill-name`
- Place at the point where the sub-skill should be invoked
- Don't use backticks around the skill name in this context
```

**Step 4: Verify changes**

Run: `grep -rn "REQUIRED SUB-SKILL" skills/ | wc -l`
Expected: Count increases by 1

**Step 5: Commit**

```bash
git add skills/systematic-debugging/SKILL.md skills/writing-skills/SKILL.md
git commit -m "fix: standardize sub-skill declaration syntax

All sub-skill requirements now use:
**REQUIRED SUB-SKILL:** Use harness:skill-name

Documented the pattern in writing-skills."
```

---

### Task 5: Create Skill Index

**Files:**
- Create: `skills/INDEX.md`

**Step 1: Generate skill list**

Run: `for d in skills/*/; do name=$(basename "$d"); desc=$(grep "^description:" "$d/SKILL.md" 2>/dev/null | head -1 | sed 's/description: *//'); echo "- **$name**: $desc"; done`

**Step 2: Create INDEX.md**

Create file with structure:
```markdown
# Harness Skills Index

> Auto-generated index of all available skills. Use `harness:skill-name` to invoke.

## Core Workflow Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-harness | Entry point - establishes skill discovery | Meta |
| brainstorming | Socratic design refinement | Flexible |
| researching | Fetch current versions/APIs | Flexible |
| writing-plans | Create implementation plans | Flexible |
| executing-plans | Batch execution with checkpoints | Flexible |
| subagent-driven-development | Per-task subagent execution | Flexible |

## Development Practice Skills

| Skill | Description | Type |
|-------|-------------|------|
| test-driven-development | RED-GREEN-REFACTOR cycle | **Rigid** |
| systematic-debugging | 4-phase root cause analysis | **Rigid** |
| verification-before-completion | Evidence before claims | **Rigid** |

## Collaboration Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-git-worktrees | Isolated workspace creation | Flexible |
| requesting-code-review | Dispatch code reviewer | Flexible |
| receiving-code-review | Technical response to feedback | **Rigid** |
| dispatching-parallel-agents | Parallelize investigations | Flexible |
| finishing-a-development-branch | Complete and cleanup work | Flexible |

## Support Skills

| Skill | Description | Type |
|-------|-------------|------|
| backlog-tracking | Deferred items management | Flexible |
| writing-skills | Create new skills | Flexible |

## Skill Types

- **Rigid**: Follow exactly. No adaptation. Iron laws apply.
- **Flexible**: Adapt principles to context. Core concepts remain.
- **Meta**: Foundation skills that govern skill usage itself.

## Skill Dependencies

```
using-harness (foundation)
├── brainstorming
│   └── REQUIRES: researching
├── writing-plans
│   └── REQUIRES: researching
├── executing-plans
│   └── REQUIRES: finishing-a-development-branch
├── subagent-driven-development
│   ├── REQUIRES: test-driven-development (for subagents)
│   ├── REQUIRES: requesting-code-review
│   └── REQUIRES: finishing-a-development-branch
└── systematic-debugging
    └── REQUIRES: test-driven-development (Phase 4)
```
```

**Step 3: Verify file created**

Run: `head -20 skills/INDEX.md`
Expected: Shows header and first table

**Step 4: Commit**

```bash
git add skills/INDEX.md
git commit -m "docs: add skill index with categories and dependencies

Provides discoverable list of all skills with:
- Categorization (workflow, practice, collaboration, support)
- Type indicators (rigid vs flexible)
- Dependency graph"
```

---

## Phase 2: Testing Infrastructure

### Task 6: Add Brainstorming Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/brainstorming.txt`

**Step 1: Create test prompt**

Create file with content:
```
I want to add a new feature to my application that lets users export their data to PDF format. Help me think through how to approach this.
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/brainstorming.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/brainstorming.txt
git commit -m "test: add skill triggering test for brainstorming"
```

---

### Task 7: Add Researching Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/researching.txt`

**Step 1: Create test prompt**

Create file with content:
```
I need to add authentication to my Next.js app. What's the current best practice for implementing OAuth with NextAuth.js?
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/researching.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/researching.txt
git commit -m "test: add skill triggering test for researching"
```

---

### Task 8: Add Verification-Before-Completion Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/verification-before-completion.txt`

**Step 1: Create test prompt**

Create file with content:
```
I've finished implementing the user registration feature. The code looks good and I think it should work. Let me know if we're done here.
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/verification-before-completion.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/verification-before-completion.txt
git commit -m "test: add skill triggering test for verification-before-completion"
```

---

### Task 9: Add Backlog-Tracking Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/backlog-tracking.txt`

**Step 1: Create test prompt**

Create file with content:
```
While implementing this feature, I noticed there's a bug in the date picker component. It's not related to what we're working on, but we should fix it eventually. Can you make a note of it?
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/backlog-tracking.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/backlog-tracking.txt
git commit -m "test: add skill triggering test for backlog-tracking"
```

---

### Task 10: Add Finishing-A-Development-Branch Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/finishing-a-development-branch.txt`

**Step 1: Create test prompt**

Create file with content:
```
All the tests are passing and the feature is complete. What are my options for wrapping up this branch and getting it merged?
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/finishing-a-development-branch.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/finishing-a-development-branch.txt
git commit -m "test: add skill triggering test for finishing-a-development-branch"
```

---

### Task 11: Add Subagent-Driven-Development Skill Trigger Test

**Files:**
- Create: `tests/skill-triggering/prompts/subagent-driven-development.txt`

**Step 1: Create test prompt**

Create file with content:
```
I have a plan ready with 5 independent tasks. Let's execute it now in this session using subagents to implement each task.
```

**Step 2: Verify test file exists**

Run: `cat tests/skill-triggering/prompts/subagent-driven-development.txt`
Expected: Shows the prompt content

**Step 3: Commit**

```bash
git add tests/skill-triggering/prompts/subagent-driven-development.txt
git commit -m "test: add skill triggering test for subagent-driven-development"
```

---

### Task 12: Create Negative Test Directory and First Negative Test

**Files:**
- Create: `tests/skill-triggering/negative-prompts/README.md`
- Create: `tests/skill-triggering/negative-prompts/simple-question.txt`

**Step 1: Create directory and README**

```bash
mkdir -p tests/skill-triggering/negative-prompts
```

Create README:
```markdown
# Negative Skill Triggering Tests

These prompts should NOT trigger heavyweight skills. They test that the plugin doesn't over-trigger on simple interactions.

## Expected Behavior

For each prompt in this directory, the response should:
1. NOT invoke brainstorming, writing-plans, or other heavy workflow skills
2. Answer directly without announcing skill usage
3. Complete quickly without extensive exploration

## Running Tests

Use the same test runner but verify skills are NOT invoked.
```

**Step 2: Create first negative test**

Create `simple-question.txt`:
```
What is the difference between let and const in JavaScript?
```

**Step 3: Commit**

```bash
git add tests/skill-triggering/negative-prompts/
git commit -m "test: add negative skill triggering tests

These verify skills don't over-trigger on simple questions."
```

---

## Phase 3: Documentation & Usability

### Task 13: Create Troubleshooting Guide

**Files:**
- Create: `docs/TROUBLESHOOTING.md`

**Step 1: Create troubleshooting guide**

Create file with content:
```markdown
# Troubleshooting Guide

Common issues and solutions when using the harness plugin.

## Skills Not Triggering

### Symptom
You expect a skill to trigger but the assistant doesn't use it.

### Solutions

1. **Check skill name spelling**
   - Use exact names: `harness:brainstorming` not `harness:brainstorm`
   - See `skills/INDEX.md` for complete list

2. **Explicit invocation**
   - Say: "Use the brainstorming skill" or "Apply harness:brainstorming"
   - The 1% rule should catch most cases, but explicit works best

3. **Check hook is running**
   - Run: `cat ~/.claude/plugins/cache/*/harness/*/hooks/hooks.json`
   - Verify SessionStart hook exists

4. **Restart session**
   - Hooks only run on session start
   - Try `/clear` or start new conversation

## Skill Over-Triggering

### Symptom
Heavy skills trigger for simple questions.

### Solutions

1. **Be explicit about simplicity**
   - Say: "Quick question, no need for formal process..."
   - Say: "Just a simple fix, skip the workflow"

2. **Report as bug**
   - If a skill consistently over-triggers, open an issue
   - Include the prompt that caused over-triggering

## Worktree Issues

### Symptom
Git worktree creation fails.

### Solutions

1. **Check for existing worktree**
   ```bash
   git worktree list
   ```

2. **Clean up stale worktrees**
   ```bash
   git worktree prune
   ```

3. **Verify base branch exists**
   ```bash
   git branch -a | grep main
   ```

4. **Check directory permissions**
   - Ensure you can write to parent directory

## Hook Not Running

### Symptom
Session starts without "You have harness skills" context.

### Solutions

1. **Verify plugin installation**
   ```bash
   ls ~/.claude/plugins/cache/*/harness/*/hooks/
   ```

2. **Check hooks.json syntax**
   ```bash
   python3 -c "import json; json.load(open('hooks/hooks.json'))"
   ```

3. **Test hook script manually**
   ```bash
   cd /path/to/harness/plugin
   ./hooks/session-start.sh
   ```
   Expected: JSON output with additionalContext

## Research Skill Web Search Fails

### Symptom
Researching skill can't fetch current information.

### Solutions

1. **Check network connectivity**
   - Ensure web search is available in your environment

2. **Use specific queries**
   - Instead of: "React best practices"
   - Try: "React 19 best practices 2025"

3. **Fallback to manual research**
   - Ask assistant to provide search queries
   - Research manually and provide findings

## Plan Execution Stuck

### Symptom
Subagent or execution stops mid-plan.

### Solutions

1. **Check for blocking issues**
   - Review last subagent output
   - Look for unanswered questions

2. **Resume explicitly**
   - Say: "Continue with the plan from Task N"
   - Or: "Resume subagent-driven development"

3. **Restart from checkpoint**
   - Plans are saved to `.harness/NNN-feature/plan.md`
   - TodoWrite tracks progress
   - Start new session pointing to plan file

## Getting More Help

1. **Check skill documentation**
   - Each skill has detailed SKILL.md
   - Read the "Red Flags" and "Common Mistakes" sections

2. **Open an issue**
   - GitHub: https://github.com/astrosteveo/harness

3. **Check upstream**
   - Some issues may be addressed in obra/superpowers
```

**Step 2: Verify file created**

Run: `head -30 docs/TROUBLESHOOTING.md`
Expected: Shows header and first section

**Step 3: Commit**

```bash
git add docs/TROUBLESHOOTING.md
git commit -m "docs: add troubleshooting guide

Covers common issues:
- Skills not triggering
- Over-triggering
- Worktree problems
- Hook failures
- Research failures
- Execution stuck"
```

---

### Task 14: Add Task Sizing Guidance to Brainstorming

**Files:**
- Modify: `skills/brainstorming/SKILL.md`

**Step 1: Read current file end**

Run: `tail -20 skills/brainstorming/SKILL.md`
Expected: Shows current ending content

**Step 2: Add task sizing section before "Key Principles"**

Insert before the "Key Principles" section:
```markdown
## Task Sizing

Before starting the full brainstorming workflow, assess task size:

| Size | Criteria | Workflow |
|------|----------|----------|
| **Micro** | < 5 min, single file, obvious fix | Skip to TDD, no brainstorming needed |
| **Small** | < 30 min, 1-3 files, clear requirements | Abbreviated: quick questions → plan |
| **Medium** | 30 min - 2 hrs, multiple components | Standard brainstorming workflow |
| **Large** | > 2 hrs, architectural changes | Full workflow with research |

**For Micro/Small tasks:** Say "This looks like a micro/small task. Skipping full brainstorming - proceeding with [TDD/abbreviated workflow]."

```

**Step 3: Verify change**

Run: `grep -A 10 "Task Sizing" skills/brainstorming/SKILL.md`
Expected: Shows the new section

**Step 4: Commit**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "feat: add task sizing guidance to brainstorming

Prevents process overhead for small tasks by providing
skip criteria for micro/small work."
```

---

### Task 15: Add Explicit Bypass Mechanism to TDD Skill

**Files:**
- Modify: `skills/test-driven-development/SKILL.md`

**Step 1: Read current exceptions section**

Run: `grep -A 5 "Exceptions" skills/test-driven-development/SKILL.md`
Expected: Shows current exceptions with "(ask your human partner)"

**Step 2: Enhance exceptions section**

Replace the exceptions block with:
```markdown
**Exceptions (explicit bypass required):**

To bypass TDD, user must explicitly say ONE of:
- "Skip TDD for this task"
- "This is exploratory/spike work"
- "Prototype only, will rewrite with TDD"

When bypass is granted:
1. Acknowledge: "Bypassing TDD as requested for [reason]"
2. Proceed without tests
3. Add to backlog: "DEBT-XXX: Add tests for [feature]"

**Without explicit bypass, TDD is mandatory.**
```

**Step 3: Verify change**

Run: `grep -A 12 "Exceptions" skills/test-driven-development/SKILL.md`
Expected: Shows enhanced section

**Step 4: Commit**

```bash
git add skills/test-driven-development/SKILL.md
git commit -m "feat: add explicit bypass mechanism to TDD skill

Users can now explicitly bypass TDD with specific phrases.
Bypass is tracked in backlog as technical debt."
```

---

### Task 16: Document Code Reviewer Relationships

**Files:**
- Create: `docs/CODE-REVIEW-ARCHITECTURE.md`

**Step 1: Create documentation**

Create file with content:
```markdown
# Code Review Architecture

This document explains the different code review mechanisms in harness and when to use each.

## Overview

Harness provides multiple code review approaches for different contexts:

```
┌─────────────────────────────────────────────────────────────┐
│                    Code Review Options                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  requesting-code-review skill                                │
│  └── Uses: agents/code-reviewer.md                          │
│      └── General-purpose review after major work            │
│                                                              │
│  subagent-driven-development skill                          │
│  ├── spec-reviewer-prompt.md                                │
│  │   └── Verifies implementation matches spec               │
│  └── code-quality-reviewer-prompt.md                        │
│      └── Reviews implementation quality                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## When to Use Each

### General Code Review (`requesting-code-review`)

**Use when:**
- Major feature or milestone completed
- Before creating a pull request
- After executing-plans completes a batch
- Manual review checkpoint desired

**Reviewer:** `agents/code-reviewer.md`
- Comprehensive plan alignment check
- Code quality assessment
- Architecture review
- Categorizes issues as Critical/Important/Suggestions

### Subagent-Driven Development Reviews

**Use when:**
- Executing plan via subagent-driven-development
- Automatic after each task completion

**Two-Stage Process:**

1. **Spec Compliance Review** (`spec-reviewer-prompt.md`)
   - Verifies code matches task specification exactly
   - Checks for missing requirements
   - Flags over-building (YAGNI violations)
   - MUST pass before code quality review

2. **Code Quality Review** (`code-quality-reviewer-prompt.md`)
   - Reviews implementation quality
   - Checks patterns and practices
   - Suggests improvements
   - Runs AFTER spec compliance passes

## Decision Flow

```
Task completed?
├── Using subagent-driven-development?
│   └── YES → Automatic two-stage review
│       1. Spec compliance first
│       2. Code quality second
│
└── NOT using SDD?
    └── Use requesting-code-review
        └── Dispatches general code-reviewer
```

## Key Differences

| Aspect | General Review | SDD Spec Review | SDD Quality Review |
|--------|---------------|-----------------|-------------------|
| Scope | Full implementation | Single task | Single task |
| Focus | Alignment + Quality | Spec match only | Quality only |
| When | End of work | After each task | After spec passes |
| Depth | Comprehensive | Narrow | Narrow |

## Best Practices

1. **Don't skip stages in SDD** - Spec compliance must pass before quality review
2. **Use general review for milestones** - Even with SDD, do general review at major checkpoints
3. **Review loops are normal** - Expect 1-3 iterations per review stage
4. **Implementer fixes issues** - Same subagent that built it fixes review issues
```

**Step 2: Verify file created**

Run: `head -40 docs/CODE-REVIEW-ARCHITECTURE.md`
Expected: Shows header and overview

**Step 3: Commit**

```bash
git add docs/CODE-REVIEW-ARCHITECTURE.md
git commit -m "docs: document code review architecture and relationships

Explains:
- Three review mechanisms and their purposes
- When to use each
- Two-stage SDD review process
- Decision flow for choosing review type"
```

---

### Task 17: Standardize User Terminology

**Files:**
- Modify: Multiple skill files

**Step 1: Find "your human partner" occurrences**

Run: `grep -rn "your human partner" skills/`
Expected: List of files and line numbers

**Step 2: Create sed replacement script**

```bash
# Replace in all skill files
find skills/ -name "*.md" -exec sed -i '' 's/your human partner/the user/g' {} \;
```

**Step 3: Verify replacements**

Run: `grep -rn "your human partner" skills/`
Expected: No results

Run: `grep -rn "the user" skills/ | head -5`
Expected: Shows replacements

**Step 4: Commit**

```bash
git add skills/
git commit -m "fix: standardize user terminology across skills

Replaced 'your human partner' with 'the user' for consistency."
```

---

## Phase 4: Optional Enhancements

### Task 18: Create Resuming-Work Skill

**Files:**
- Create: `skills/resuming-work/SKILL.md`

**Step 1: Create skill directory**

```bash
mkdir -p skills/resuming-work
```

**Step 2: Create SKILL.md**

Create file with content:
```markdown
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
```

**Step 3: Verify file created**

Run: `head -30 skills/resuming-work/SKILL.md`
Expected: Shows skill header and overview

**Step 4: Update skill index**

Add to `skills/INDEX.md` in the "Support Skills" section:
```markdown
| resuming-work | Restore context after interruption | Flexible |
```

**Step 5: Commit**

```bash
git add skills/resuming-work/ skills/INDEX.md
git commit -m "feat: add resuming-work skill

Provides systematic approach to restoring context when:
- Starting new session on existing work
- After context limits
- Picking up interrupted work"
```

---

### Task 19: Improve Hook JSON Escaping (Optional)

**Files:**
- Modify: `hooks/session-start.sh`

**Step 1: Check if jq is typically available**

This is optional - only implement if jq can be assumed available.

Run: `which jq`
Expected: Path to jq or empty

**Step 2: Add jq-based escaping with fallback**

Replace the escape_for_json function and its usage with:
```bash
# Escape for JSON - prefer jq if available, fallback to bash
if command -v jq &> /dev/null; then
    using_harness_escaped=$(jq -Rs '.' <<< "$using_harness_content" | sed 's/^"//;s/"$//')
else
    # Fallback to bash escaping
    escape_for_json() {
        local input="$1"
        local output=""
        local i char
        for (( i=0; i<${#input}; i++ )); do
            char="${input:$i:1}"
            case "$char" in
                $'\\') output+='\\\\' ;;
                '"') output+='\\"' ;;
                $'\n') output+='\\n' ;;
                $'\r') output+='\\r' ;;
                $'\t') output+='\\t' ;;
                *) output+="$char" ;;
            esac
        done
        printf '%s' "$output"
    }
    using_harness_escaped=$(escape_for_json "$using_harness_content")
fi
```

**Step 3: Test the hook**

Run: `./hooks/session-start.sh | python3 -c "import json,sys; json.load(sys.stdin); print('Valid JSON')"`
Expected: "Valid JSON"

**Step 4: Commit**

```bash
git add hooks/session-start.sh
git commit -m "fix: improve JSON escaping in session-start hook

Uses jq when available for robust escaping, falls back to bash.
Also fixed double-backslash escaping in fallback."
```

---

## Phase 5: Final Verification

### Task 20: Run All Skill Triggering Tests

**Files:**
- None (verification only)

**Step 1: Run existing tests**

Run: `./tests/skill-triggering/run-all.sh`
Expected: All tests pass

**Step 2: Run new tests**

Run: `./tests/skill-triggering/run-test.sh brainstorming`
Run: `./tests/skill-triggering/run-test.sh researching`
Run: `./tests/skill-triggering/run-test.sh verification-before-completion`

Expected: Skills trigger appropriately

**Step 3: Document any failures**

If tests fail, add issues to `.harness/BACKLOG.md`

---

### Task 21: Update README with New Documentation Links

**Files:**
- Modify: `README.md`

**Step 1: Add documentation section**

Add after the "Skills library" section:
```markdown
## Documentation

- [Skill Index](skills/INDEX.md) - Complete list of available skills
- [Code Review Architecture](docs/CODE-REVIEW-ARCHITECTURE.md) - Understanding review mechanisms
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Changelog](CHANGELOG.md) - Version history and changes
```

**Step 2: Verify change**

Run: `grep -A 6 "## Documentation" README.md`
Expected: Shows the new section

**Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add documentation section to README

Links to:
- Skill index
- Code review architecture
- Troubleshooting guide
- Changelog"
```

---

## Deferred Items

The following items from the analysis are deferred to the backlog:

1. **FEAT-001: Security Review Skill** - Create dedicated security-focused code review skill
2. **FEAT-002: Performance Optimization Skill** - Guidance for profiling and optimization
3. **FEAT-003: Documentation/API Writing Skill** - User-facing documentation guidance
4. **FEAT-004: Releasing Skill** - Version bumping, changelog, deployment
5. **FEAT-005: Refactoring Skill** - Large-scale code restructuring guidance
6. **IMPROVE-001: Tiered Skill Triggering** - Replace 1% rule with graduated approach
7. **IMPROVE-002: Worktree Cleanup Utility** - Periodic audit and cleanup of stale worktrees

---

## Summary

| Phase | Tasks | Focus |
|-------|-------|-------|
| 1 | 1-5 | Critical fixes (references, versioning, standards) |
| 2 | 6-12 | Testing infrastructure (triggering tests, negative tests) |
| 3 | 13-17 | Documentation and usability (guides, sizing, bypass) |
| 4 | 18-19 | Optional enhancements (resuming-work, hook improvement) |
| 5 | 20-21 | Verification and cleanup |

**Total Tasks:** 21
**Estimated Time:** 2-3 hours of focused work
