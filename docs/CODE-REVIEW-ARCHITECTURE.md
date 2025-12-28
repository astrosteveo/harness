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
