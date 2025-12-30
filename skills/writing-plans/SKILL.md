---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `.harness/NNN-feature-slug/plan.md`

The plan should be saved in the same `.harness/NNN-feature-slug/` directory as the design and research documents. If the directory doesn't exist yet, create it following the naming convention (see brainstorming skill for details).

## Thorough Research Before Planning (REQUIRED)

**REQUIRED SUB-SKILL:** Use harness:researching before writing any implementation details.

**This is NOT the same research as brainstorming.** Brainstorming research was exploratory - understanding what's possible. Planning research is thorough verification now that requirements are concrete.

**This is actually the IDEAL time for research** because:
- All ambiguities are resolved - you know exactly what questions to ask
- Requirements are concrete - research targets are specific, not exploratory
- New topics have emerged - Socratic discovery surfaced things you didn't know to research initially

| Rationalization | Reality |
|-----------------|---------|
| "I already researched during brainstorming" | That was exploratory. Now requirements are concrete - verify everything. |
| "Brainstorming research is sufficient" | Brainstorming explored possibilities. Planning needs exact versions, APIs, patterns. |
| "I'll research as I go" | Plans with unresearched details become blockers during execution. |

**What to research NOW:**
- **Verify package versions** - Exact versions for package.json/requirements.txt
- **Confirm API signatures** - Method names, parameters, return types
- **Check for deprecations** - Ensure planned code uses current approaches
- **Validate patterns** - Confirm design patterns match current recommendations
- **Research new topics** - Anything surfaced during brainstorming that wasn't initially researched
- **Deep dive on implementation details** - Now that you know WHAT to build, research HOW thoroughly

Include a **Research Summary** section in the plan header documenting key findings.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

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
- **Research first** - Verify versions and APIs before writing code examples
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits
- **Never assume from training data** - Always verify external library details

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
- Create PENDING_EXECUTION.md marker (see below)
- Display: "Marker created. Start new session to auto-resume."
- User starts new session, hook auto-invokes appropriate skill

**PENDING_EXECUTION.md marker format:**

```markdown
# Pending Execution

**Created:** [timestamp]
**Reason:** planning-complete
**Plan:** .harness/NNN-feature-slug/plan.md
**Checkpoint:** .harness/NNN-feature-slug/checkpoint.md
**Mode:** [autonomous|checkpoint]
**Progress:**
  - Phase 1: pending
  - Phase 2: pending
  ...
**Worktree:** [path]
```

Save marker to: `.harness/PENDING_EXECUTION.md`
