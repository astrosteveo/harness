---
name: backlog-tracking
description: "SHOULD invoke when bugs, deferred tasks, or future improvements are identified during development."
---

# Backlog Tracking

## Overview

Track bugs, deferred tasks, and future improvements in a centralized backlog. This ensures nothing is lost when items are discovered during brainstorming, planning, or implementation but aren't immediately actionable.

**Backlog location:** `.harness/BACKLOG.md`

## When To Use This Skill

**Add items to the backlog when:**
- A bug is discovered but fixing it is out of scope for the current task
- A feature idea emerges during brainstorming but is deferred
- A "nice to have" improvement is identified during code review
- Technical debt is noticed but not immediately addressed
- A task from a plan is intentionally skipped or deferred

**Do NOT use for:**
- Items that are part of the current plan (use the plan's task list)
- Issues that should be fixed immediately (just fix them)
- External issues that belong in a separate issue tracker

## Backlog Format

The backlog file uses a structured markdown format:

```markdown
# Project Backlog

> Items discovered during development that are deferred for future work.
> Review periodically and promote items to active plans.

---

## Bugs

### [BUG-001] Short description of the bug
- **Discovered:** YYYY-MM-DD
- **Context:** .harness/NNN-feature-slug/ (if related to a feature)
- **Severity:** Critical | High | Medium | Low
- **Description:** Detailed description of the bug
- **Reproduction:** Steps to reproduce (if known)
- **Notes:** Any additional context

---

## Deferred Features

### [FEAT-001] Short description of the feature
- **Discovered:** YYYY-MM-DD
- **Context:** .harness/NNN-feature-slug/ (if related to a feature)
- **Priority:** High | Medium | Low
- **Description:** What the feature should do
- **Rationale for deferral:** Why this was deferred
- **Dependencies:** Any prerequisites

---

## Technical Debt

### [DEBT-001] Short description of the debt
- **Discovered:** YYYY-MM-DD
- **Context:** File or directory affected
- **Impact:** How this affects the codebase
- **Suggested fix:** Proposed approach to address
- **Effort:** Small | Medium | Large

---

## Improvements

### [IMPROVE-001] Short description of the improvement
- **Discovered:** YYYY-MM-DD
- **Context:** .harness/NNN-feature-slug/ (if related to a feature)
- **Category:** Performance | UX | DX | Maintainability
- **Description:** What should be improved
- **Benefit:** Expected outcome

---

## Completed (Archive)

Items moved here when addressed. Include resolution date and reference to the fix.

### [BUG-001] Description - RESOLVED YYYY-MM-DD
- **Resolution:** How it was fixed
- **PR/Commit:** Reference to the fix
```

## Adding Items

When adding a new item:

1. **Determine the category** - Bug, Feature, Debt, or Improvement
2. **Assign a sequence ID** - e.g., BUG-001, FEAT-002
3. **Fill in the template** - Include all relevant fields
4. **Reference the context** - Link to the related .harness directory if applicable
5. **Commit the update** - Keep the backlog in version control

## Reviewing the Backlog

Periodically review the backlog to:

1. **Prioritize items** - Update priorities based on current project needs
2. **Promote to plans** - Move high-priority items into active implementation plans
3. **Archive completed** - Move resolved items to the Completed section
4. **Remove stale items** - Delete items that are no longer relevant

## Integration With Other Skills

### From Brainstorming
When features are identified but deferred:
```
"I'm adding this to the backlog as FEAT-XXX for future consideration."
```

### From Writing-Plans
When tasks are intentionally skipped:
```
"I'm deferring this task to the backlog as DEBT-XXX."
```

### From Implementation
When bugs are discovered:
```
"I've logged this bug as BUG-XXX in the backlog for later investigation."
```

## Key Principles

- **Capture everything** - Don't let ideas slip through the cracks
- **Context is crucial** - Always link to related features/files
- **Keep it current** - Update the backlog as items are addressed
- **Review regularly** - The backlog is only useful if it's maintained
- **Be specific** - Vague items are hard to act on later

## YAGNI and Tracking

YAGNI ("You Aren't Gonna Need It") applies to **building** features, not **tracking** them. Track ideas you defer, even ones you may never build—this documents the decision, not a commitment.

The backlog is a parking lot, not a promise. Items can sit indefinitely or be pruned entirely. Review periodically: promote what's valuable, delete what's stale.
