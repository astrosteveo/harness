---
name: brainstorming
description: "MUST invoke before any creative work - creating features, building components, or adding functionality."
---

# Brainstorming Ideas Into Designs

## Overview

Turn ideas into fully formed designs through collaborative dialogue.

**The flow:**
1. Understand the idea (quick questions) - **SKIP if requirements are clear**
2. **RESEARCH** (codebase + external) - BEFORE designing
3. Propose approaches (informed by research)
4. Present design (in sections for validation)

## First Action (MANDATORY)

When this skill is invoked, immediately assess:

**Does the user's request already explain what they want?**
- YES → Skip to Step 2, invoke `harness:researching` immediately
- NO → Ask ONE clarifying question about user intent (not code state)

Most feature requests ARE clear enough. When in doubt, research first - you can always ask later if research reveals genuine ambiguity.

## The Iron Rule

```
NO DESIGNING UNTIL RESEARCH IS COMPLETE
```

You cannot propose approaches, architectures, or solutions until you have:
- Explored the codebase
- Researched external technologies
- Looked for creative solutions

## The Process

### Step 1: Understand the Idea

**SKIP THIS STEP if the user has already explained what they want clearly.** Go directly to Step 2 (Research).

Signs you can skip Step 1:
- User described the feature/behavior they want
- User gave examples or analogies (e.g., "like EVE Online")
- User explained what's wrong with current behavior
- You have enough info to know WHAT to research

**If you need more clarity:**
- Ask questions one at a time
- Prefer multiple choice questions
- Focus on: purpose, constraints, success criteria
- Don't go deep - just enough to know what to research

**CRITICAL: Step 1 questions are about USER INTENT only.**
- What the user wants (behavior, outcomes, preferences)
- NOT about current code state (research answers that)
- NOT about implementation details (design phase answers that)
- If the codebase can answer it, don't ask - research it

| Bad Question (asks about code) | Good Question (asks about intent) |
|--------------------------------|-----------------------------------|
| "What's the current state of movement?" | "Should this replace or augment existing controls?" |
| "Do you have an input handler?" | "What input devices should this support?" |
| "How is the ship controlled now?" | "Any accessibility requirements?" |

**This is NOT design.** You're gathering enough info to know what to research.

### Step 2: Research (REQUIRED)

**REQUIRED SUB-SKILL:** Use harness:researching

**This happens BEFORE proposing ANY approaches.**

Research includes:
1. **Codebase exploration** - How does similar functionality work? What patterns exist?
2. **External research** - What are current versions, APIs, best practices?
3. **Creative solutions** - What OTHER ways could we solve this?

**You cannot skip this.** See the researching skill for the full process.

| Rationalization | Reality |
|-----------------|---------|
| "I know this codebase" | Knowing isn't current. Explore to verify. |
| "Simple feature, no research needed" | Simple features still follow patterns. Find them. |
| "Let me propose something first" | NO. Research THEN propose. |
| "I'll research after I have a design" | Research after design = rework. Research first. |
| "Quick proposal, then research" | NO. There is no "quick proposal" before research. |

### Step 3: Propose Architecture Options (REQUIRED)

**Only AFTER research is complete.**

You MUST present **exactly 3 architecture options** with explicit trade-offs. This prevents Claude's anti-pattern of committing to the first reasonable idea without considering alternatives.

**The Three Options:**

| Option | Focus | When to Recommend |
|--------|-------|-------------------|
| **Minimal** | Smallest diff, maximum reuse | Tight deadline, low risk tolerance |
| **Clean** | Best architecture, maintainability | Long-term project, refactoring opportunity |
| **Pragmatic** | Balanced speed + quality | Most cases |

**Option Format:**

```markdown
## Architecture Options

### Option A: Minimal (Smallest Change)
**Approach:** [How it works]
**Files changed:** [List]
**Pros:** Fast, low risk, minimal testing
**Cons:** May accumulate tech debt, less elegant
**Effort:** Low

### Option B: Clean (Best Architecture)
**Approach:** [How it works]
**Files changed:** [List]
**Pros:** Maintainable, extensible, follows patterns
**Cons:** More effort, larger diff, more testing
**Effort:** High

### Option C: Pragmatic (Balanced)
**Approach:** [How it works]
**Files changed:** [List]
**Pros:** Good architecture without over-engineering
**Cons:** Some compromises
**Effort:** Medium

---

**Recommendation:** Option [X] because [specific reasons based on research]

Which approach would you like to proceed with?
```

**Requirements:**
- **Cite research findings** - "Based on exploring X, I found..."
- Lead with your recommendation but let user choose
- Explicitly note if research contradicts common assumptions
- Reference current versions and documentation URLs

**Anti-pattern: Single-path design**

| Rationalization | Reality |
|-----------------|---------|
| "The approach is obvious" | Present options anyway. User may see trade-offs differently. |
| "Only one way to do this" | There's always a minimal vs clean spectrum. |
| "Options will confuse them" | Options give agency. Single path removes choice. |
| "I'll mention alternatives briefly" | NO. Full analysis for each option. |

### Step 4: Present the Design

**Once approach is chosen:**
- Present design in sections of 200-300 words
- Ask after each section whether it looks right
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify

## Task Sizing

Before starting, assess task size:

| Size | Criteria | Workflow |
|------|----------|----------|
| **Micro** | < 5 min, single file, obvious fix | Verify location in codebase → TDD |
| **Small** | < 30 min, 1-3 files, clear requirements | Quick questions → research → plan |
| **Medium** | 30 min - 2 hrs, multiple components | Standard workflow |
| **Large** | > 2 hrs, architectural changes | Full workflow with thorough research |

**For Micro tasks:** You still verify WHERE in the codebase the change goes. "Micro" means abbreviated workflow, NOT skipping research entirely.

| Rationalization | Reality |
|-----------------|---------|
| "It's just a button" | Where does it go? What patterns exist? Verify first. |
| "Too simple to research" | Simple changes in wrong places cause bugs. Check first. |
| "Process theater" | 30 seconds to verify location prevents 30 minutes debugging. |

## After the Design

**Documentation Structure:**

All project documents are saved to `.harness/NNN-feature-slug/` where:
- `NNN` is a zero-padded sequence number (001, 002, etc.)
- `feature-slug` is a kebab-case name for the feature

**Save documents:**
- Research: `.harness/NNN-feature-slug/research.md` (from harness:researching)
- Requirements: `.harness/NNN-feature-slug/requirements.md`
- Design: `.harness/NNN-feature-slug/design.md`
- Plan: `.harness/NNN-feature-slug/plan.md` (from harness:writing-plans)

**Commit the design document to git after saving.**

**Deferred Items:**
If any features, bugs, or tasks are identified but deferred:
- Add them to `.harness/BACKLOG.md`
- Use the backlog format (see harness:backlog-tracking)

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use harness:using-git-worktrees to create isolated workspace
- Use harness:writing-plans to create detailed implementation plan

## Key Principles

- **Research before designing** - Always, no exceptions
- **Codebase exploration is research** - Don't skip it
- **External research is research** - Don't skip it either
- **One question at a time** - Don't overwhelm
- **Multiple choice preferred** - Easier to answer
- **YAGNI ruthlessly** - Remove unnecessary features
- **Explore alternatives** - Always propose 2-3 approaches
- **Cite sources** - Reference documentation URLs
