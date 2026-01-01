---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

<HARD-GATE>
# ⛔ STOP - RESEARCH CHECK REQUIRED

**Before you do ANYTHING else, answer this question:**

> Did you invoke `harness:researching` in THIS conversation BEFORE invoking this skill?

**If NO → STOP IMMEDIATELY:**
1. Do NOT continue reading this skill
2. Do NOT announce you're using writing-plans
3. Do NOT write any plan content
4. Invoke `harness:researching` RIGHT NOW
5. Only return to this skill AFTER research is complete

**If YES → You may proceed.**

This is not optional. This is not negotiable. There are no exceptions.

| Rationalization | Reality |
|-----------------|---------|
| "I did research earlier in the project" | Wrong. Research must happen in THIS conversation before THIS plan. |
| "The user just wants a quick plan" | NO. Research THEN plan. Always. |
| "I'll research as I write" | NO. Research is a prerequisite, not a concurrent activity. |
| "I already know the codebase" | Knowing ≠ researched. Invoke the skill. |
| "Research will slow things down" | Unresearched plans cause MORE delays during execution. |
| "The user asked me to write a plan" | Users ask WHAT. Skills define HOW. Research first. |

**FAILURE MODE:** If you proceed without research, you WILL write a plan with wrong file paths, outdated APIs, and missing context. The plan will fail during execution. You will waste the user's time.

---
</HARD-GATE>

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `.harness/NNN-feature-slug/plan.md`

The plan should be saved in the same `.harness/NNN-feature-slug/` directory as the design and research documents. If the directory doesn't exist yet, create it following the naming convention (see brainstorming skill for details).

## The Iron Rule

```
NO PLANNING UNTIL RESEARCH IS COMPLETE
```

You cannot write implementation details, code examples, or file paths until you have:
- Explored the codebase thoroughly
- Verified all external technologies
- Researched implementation patterns

## Research Before Planning (REQUIRED)

**REQUIRED SUB-SKILL:** Use harness:researching before writing ANY plan content.

Research for planning includes **BOTH**:

### 1. Codebase Exploration (REQUIRED)

**You cannot skip this.** Even if you "know" the codebase from brainstorming.

- **Affected areas** - What files will this change touch?
- **Existing patterns** - How is similar code structured? What patterns are used?
- **Testing patterns** - How are similar features tested?
- **Dependencies** - What might break if we change things?

### 2. External Research (REQUIRED)

- **Verify package versions** - Exact versions for package.json/requirements.txt
- **Confirm API signatures** - Method names, parameters, return types
- **Check for deprecations** - Ensure planned code uses current approaches
- **Research implementation patterns** - Current best practices for HOW to build

| Rationalization | Reality |
|-----------------|---------|
| "I already researched during brainstorming" | That was exploratory. Planning needs verification. |
| "I know the codebase" | Knowing isn't current. Explore the actual files. |
| "Let me write the plan first" | NO. Research THEN plan. |
| "I'll research as I write" | Plans with unresearched details = blockers during execution. |
| "Quick plan, then verify" | NO. There is no "quick plan" before research. |

Include a **Research Summary** section in the plan header documenting key findings.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Size Limits (REQUIRED)

Plans must fit within context limits. A single plan file should not exceed **20,000 tokens** (~3,000 lines or ~80KB).

**Why this matters:**
- Plans are loaded into subagent context for execution
- Exceeding limits causes truncation or failures
- Detailed plans are good - but split them when needed

**Estimating plan size:**
- ~4 characters per token (rough average)
- 3,000 lines ≈ 20,000 tokens
- Check file size: 80KB ≈ 20,000 tokens

**When to split:**

| Plan Size | Action |
|-----------|--------|
| < 15,000 tokens | Single plan file |
| 15,000-20,000 tokens | Consider splitting |
| > 20,000 tokens | MUST split |

**How to split large features:**

Create multiple sequential plan files in the same feature directory:

```
.harness/004-large-feature/
├── requirements.md
├── research.md
├── design.md
├── plan-part1.md    # Phases 1-3 (foundation)
├── plan-part2.md    # Phases 4-6 (core features)
└── plan-part3.md    # Phases 7-9 (integration)
```

**Split plan naming:** `plan-part1.md`, `plan-part2.md`, etc.

**Each split plan must:**
- Be self-contained (can execute independently)
- Reference prerequisites from earlier parts
- Include its own header with Phase summary
- State dependencies: "Requires completion of plan-part1.md"

**Split plan header addition:**

```markdown
**Prerequisites:** plan-part1.md (Phases 1-3 complete)
**This Plan:** Phases 4-6 of 9
```

**Execution order:** Execute plan parts sequentially. Progress is tracked via git phase completion commits.

## Phase Structure (REQUIRED)

Plans MUST be organized into Phases. Phases are the unit of subagent execution.

**Phase requirements:**
- Each Phase groups 2-6 related tasks
- Phase naming: `## Phase N: [Descriptive Name]`
- Task naming: `### Task N.M: [Name]` or `### Task M: [Name]`
- Each Phase has a clear completion state (tests pass, commits made)

**Phase sizing guidelines:**

| Phase Size | Tasks | Guidance |
|------------|-------|----------|
| Too small | 1 task | Merge with adjacent Phase |
| Ideal | 2-4 tasks | Good subagent workload |
| Acceptable | 5-6 tasks | Consider splitting if complex |
| Too large | 7+ tasks | Must split into multiple Phases |

**Phase completion criteria:**
- All tasks in Phase complete
- Tests passing
- Commit(s) made
- Clear handoff state for next Phase

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** Execute using subagent per Phase. Each Phase is a cohesive unit.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries with VERIFIED current versions]

**Research Summary:** [Key findings from harness:researching]

**Sources:** [URLs to documentation referenced]

**Phases:**
1. Phase 1: [Name] (N tasks)
2. Phase 2: [Name] (N tasks)
3. Phase 3: [Name] (N tasks)
...

---
```

The Phases summary gives quick overview of the work scope and helps with progress tracking.

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
```

## Remember

- **Research FIRST** - Codebase exploration + external research BEFORE writing anything
- **No planning without research** - This is non-negotiable
- Exact file paths always (from codebase exploration)
- Complete code in plan (not "add validation")
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits
- **Never assume from training** - Verify everything external

## Deferred Items

If any tasks are identified but deferred during planning:
- Add them to `.harness/BACKLOG.md`
- Include context about why it was deferred
- Reference the feature directory (e.g., "See .harness/001-feature-name/")

## Execution Handoff

After saving the plan, create checkpoint and offer execution choice:

**Step 1: Auto-create checkpoint**

Save checkpoint to `.harness/NNN-feature-slug/checkpoint.md`:

```markdown
# Checkpoint

**Created:** [timestamp]
**Plan:** .harness/NNN-feature-slug/plan.md
**Branch:** [current branch]

## Progress
- All Phases: pending

## Next Steps
1. Execute Phase 1: [Phase name]
```

**Step 2: Present execution options**

```
✅ **Plan complete and saved**

- Plan: `.harness/NNN-feature-slug/plan.md`
- Checkpoint: `.harness/NNN-feature-slug/checkpoint.md`

**[N] Phases identified:**
1. Phase 1: [Name] (N tasks)
2. Phase 2: [Name] (N tasks)
...

---

**How would you like to proceed?**

| Option | Description |
|--------|-------------|
| **Continue** | Execute now in this session |
| **New Session** | Start fresh session to execute |

**Mode** (applies to either option):
| Mode | Description |
|------|-------------|
| **Autonomous** | Runs all Phases without stopping |
| **Checkpoint** | Pauses after each Phase for approval |

Examples: "continue autonomous", "new session checkpoint", "continue"
```

**Step 3: Handle choice**

**If "Continue" chosen:**
- Stay in current session
- **REQUIRED SUB-SKILL:** Use harness:subagent-driven-development
- Set mode: autonomous or checkpoint (default: checkpoint)
- Execute Phase by Phase with fresh subagent per Phase

**If "New Session" chosen:**
- Display: "Plan saved. Start a new session to begin execution."
- Display: "Git will track your progress via phase completion commits."
- User starts new session, hook auto-detects incomplete work from git
