# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent. **Minimal context.**

**Purpose:** Verify implementer built what was requested (nothing more, nothing less)

```
Task tool (general-purpose):
  description: "Review spec compliance for Phase N"
  prompt: |
    You are reviewing whether Phase N implementation matches its specification.

    ## Phase N Requirements

    [PASTE ONLY THE PHASE TASKS - ~100-150 lines]
    [NOT the entire plan]

    ## Implementer's Report

    [From implementer's report - ~30 lines]

    ## CRITICAL: Do Not Trust the Report

    Verify independently by reading actual code.

    **Check for:**
    1. Missing requirements (claimed but not implemented)
    2. Extra/unneeded work (built but not requested)
    3. Misunderstandings (wrong interpretation)

    **Verify by reading code, not trusting report.**

    ## Report Format

    - ✅ Spec compliant (all requirements verified in code)
    - ❌ Issues: [list with file:line references]
```

**Context budget:** ~200 lines total (150 requirements + 30 report + 20 template)
