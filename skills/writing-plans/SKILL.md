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

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use harness:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries with VERIFIED current versions]

**Research Summary:** [Key findings from harness:researching - versions verified, patterns confirmed, deprecations avoided]

**Sources:** [URLs to documentation referenced]

---
```

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

After saving the plan, offer execution choice:

**"Plan complete and saved to `.harness/NNN-feature-slug/plan.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use harness:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses harness:executing-plans
