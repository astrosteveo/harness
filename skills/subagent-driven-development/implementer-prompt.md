# Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent. **Pass minimal context.**

```
Task tool (general-purpose):
  description: "Implement Phase N: [phase name]"
  prompt: |
    You are implementing Phase N: [phase name]

    ## Project Context (minimal)

    **Goal:** [One sentence from plan header]
    **Architecture:** [2-3 sentences from plan header]

    ## Phase N Tasks

    [PASTE ONLY THIS PHASE'S CONTENT - ~100-250 lines max]
    [Do NOT paste the entire plan]
    [Do NOT make subagent read the plan file]

    ## Before You Begin

    If you have questions about:
    - The requirements or acceptance criteria
    - The approach or implementation strategy
    - Dependencies or assumptions

    **Ask them now.** Raise concerns before starting work.

    ## Your Job

    For each task in this phase:
    1. Write failing test (TDD)
    2. Implement minimal code to pass
    3. Refactor if needed
    4. Commit with descriptive message
    5. Move to next task

    After all tasks:
    6. Self-review (see below)
    7. Report back

    Work from: [directory]

    ## Self-Review Checklist

    **Completeness:** All tasks done? Requirements met? Edge cases handled?
    **Quality:** Clean code? Clear names? Maintainable?
    **Discipline:** YAGNI? Only what was requested? Follows patterns?
    **Testing:** Tests verify behavior? TDD followed? Comprehensive?

    Fix issues before reporting.

    ## Report Format

    - Tasks completed: [list]
    - Tests: [pass/fail count]
    - Files changed: [list]
    - Commits: [list of SHAs]
    - Issues/concerns: [if any]
```

**Context budget:** ~300 lines total (20 header + 250 phase + 30 template)
