# Writing Documentation Skill - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use harness:executing-plans to implement this plan task-by-task.

**Goal:** Create a discipline-enforcing skill that ensures documentation adds value and prevents Claude's verbosity anti-patterns.

**Architecture:** Single SKILL.md file following the writing-skills TDD approach - baseline test first, then write skill, then verify. Skill is discipline-enforcing (like TDD), so needs rationalization prevention and red flags.

**Tech Stack:** Markdown skill file, shell-based testing with subagents

**Research Summary:** (from .harness/002-writing-documentation/research.md)
- TSDoc for TypeScript, JSDoc for JavaScript (eslint-plugin-jsdoc v61.5.0)
- Google style for Python docstrings (Sphinx Napoleon compatible)
- OpenAPI 3.2.0 for API docs
- Google Developer Style Guide as reference standard

**Sources:**
- https://tsdoc.org/
- https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html
- https://developers.google.com/style

---

## Task 1: Create Baseline Test Prompt

**Files:**
- Create: `tests/skill-triggering/prompts/writing-documentation.txt`

**Step 1: Write test prompt**

Create a prompt that should trigger the skill - a documentation task that gives Claude opportunity to exhibit anti-patterns:

```
I need you to add JSDoc comments to this function:

function processUserData(userData, options) {
  const normalized = userData.map(u => ({
    id: u.id,
    name: u.name.trim(),
    active: options.includeInactive ? true : u.active
  }));
  return normalized.filter(u => u.active);
}

Please add comprehensive documentation.
```

**Step 2: Commit**

```bash
git add tests/skill-triggering/prompts/writing-documentation.txt
git commit -m "test: add writing-documentation skill trigger test"
```

---

## Task 2: Run Baseline Test (WITHOUT Skill)

**Purpose:** Document Claude's default documentation behavior to identify anti-patterns.

**Step 1: Run baseline manually**

Use the test prompt with a fresh Claude session WITHOUT the writing-documentation skill loaded. Document:
- What anti-patterns appear? (verbosity, obvious comments, qualifiers)
- What rationalizations does Claude use?
- What phrases indicate violations?

**Step 2: Record findings**

Save baseline observations to `.harness/002-writing-documentation/baseline.md`:
- Exact phrases Claude uses
- Anti-patterns observed
- Rationalizations given

**Step 3: Commit**

```bash
git add .harness/002-writing-documentation/baseline.md
git commit -m "test: document baseline documentation behavior"
```

---

## Task 3: Create SKILL.md Structure

**Files:**
- Create: `skills/writing-documentation/SKILL.md`

**Step 1: Create skill directory and file**

```bash
mkdir -p skills/writing-documentation
```

**Step 2: Write SKILL.md with frontmatter and overview**

```markdown
---
name: writing-documentation
description: Use when writing or updating any documentation - code comments, docstrings, README files, API docs, guides, or changelogs
---

# Writing Documentation

## Overview

Documentation adds value or gets deleted. Every comment must tell you something the code doesn't.

**Core principle:** If removing the documentation loses no information, remove it.

## The Iron Law

```
NO DOCUMENTATION THAT RESTATES THE OBVIOUS
```

Comments explain WHY, not WHAT. The code shows WHAT.
```

**Step 3: Commit skeleton**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add writing-documentation skill skeleton"
```

---

## Task 4: Add Anti-Patterns Section

**Files:**
- Modify: `skills/writing-documentation/SKILL.md`

**Step 1: Add anti-patterns table**

Add after Overview section:

```markdown
## Forbidden Anti-Patterns

| Pattern | Example | Fix |
|---------|---------|-----|
| Over-verbosity | "This function is responsible for facilitating..." | "Initializes..." |
| Stating obvious | `// increment counter` above `counter++` | Delete |
| Empty qualifiers | "(Authoritatively)", "(Notably)" | Remove |
| Unnecessary formality | "This method serves to provide..." | "Returns..." |
| Redundant types | `@param {string} name - The name string` | `@param name - Display name` |
| Filler phrases | "It's worth noting that..." | State the fact |
| Passive voice | "The file is read by..." | "Reads the file" |

**Before writing ANY documentation, check:** Does this add information the code doesn't provide?
```

**Step 2: Commit**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add anti-patterns section to writing-documentation"
```

---

## Task 5: Add Rationalization Prevention

**Files:**
- Modify: `skills/writing-documentation/SKILL.md`

**Step 1: Add rationalization table**

Add after anti-patterns:

```markdown
## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Adding context for clarity" | If code is clear, comment adds noise |
| "Being thorough" | Thorough ≠ verbose |
| "User might not understand" | Write for intended audience |
| "Just being professional" | Professional = concise |
| "Documenting for completeness" | Undocumented > obvious-stating |
| "Minor addition" | Minor noise accumulates |
| "Style guide requires it" | Style guides assume useful docs |

## Red Flags - STOP

- Comment longer than code it describes
- Words: "facilitates", "serves to", "is responsible for"
- Qualifiers in parentheses
- Explaining WHAT instead of WHY
- Passive voice without reason
```

**Step 2: Commit**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add rationalization prevention to writing-documentation"
```

---

## Task 6: Add Language Standards Reference

**Files:**
- Modify: `skills/writing-documentation/SKILL.md`

**Step 1: Add language standards section**

```markdown
## Language Standards

Follow project conventions. When none exist:

| Language | Standard | Key Rule |
|----------|----------|----------|
| TypeScript | TSDoc | Don't duplicate types |
| JavaScript | JSDoc | Focus on WHY |
| Python | Google style | Type hints in signatures |
| Markdown | Google Dev Guide | Sentence case headings |
| API | OpenAPI 3.1+ | Include error responses |

**Always:** Check existing project style first. Consistency > theory.
```

**Step 2: Commit**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add language standards to writing-documentation"
```

---

## Task 7: Add Documentation TDD Integration

**Files:**
- Modify: `skills/writing-documentation/SKILL.md`

**Step 1: Add TDD integration section**

```markdown
## Documentation in TDD

```
RED:    Write docs with failing test
GREEN:  Implement, verify docs accurate
VERIFY: Doc linting passes
REFACTOR: Trim verbosity
```

**Verification by language:**
- TypeScript/JS: `eslint --plugin jsdoc`
- Python: `pytest --doctest-modules`
- Markdown: `markdownlint`

**Done means:**
- Public APIs documented
- Doc linting passes
- No anti-patterns present
```

**Step 2: Commit**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add TDD integration to writing-documentation"
```

---

## Task 8: Add Quick Reference

**Files:**
- Modify: `skills/writing-documentation/SKILL.md`

**Step 1: Add quick reference checklist**

```markdown
## Quick Reference

Before committing documentation:

- [ ] Does each comment add non-obvious information?
- [ ] No "facilitates", "serves to", "is responsible for"?
- [ ] No qualifiers in parentheses?
- [ ] Active voice used?
- [ ] Explains WHY, not WHAT?
- [ ] Follows project/language conventions?
- [ ] Doc linting passes?
```

**Step 2: Commit**

```bash
git add skills/writing-documentation/SKILL.md
git commit -m "feat: add quick reference to writing-documentation"
```

---

## Task 9: Verify Skill With Test

**Purpose:** Run the same test prompt WITH the skill and verify improvement.

**Step 1: Test with skill loaded**

Run the test prompt from Task 1 with writing-documentation skill loaded. Verify:
- Anti-patterns are avoided
- Documentation is concise
- WHY is explained, not WHAT

**Step 2: Compare to baseline**

Document improvements in `.harness/002-writing-documentation/verification.md`

**Step 3: Commit**

```bash
git add .harness/002-writing-documentation/verification.md
git commit -m "test: verify writing-documentation skill effectiveness"
```

---

## Task 10: Update Skill Index

**Files:**
- Modify: `skills/INDEX.md`

**Step 1: Add writing-documentation to index**

Add to appropriate category (Development Practice):

```markdown
| writing-documentation | Use when writing or updating any documentation | **Rigid** | None |
```

**Step 2: Commit**

```bash
git add skills/INDEX.md
git commit -m "docs: add writing-documentation to skill index"
```

---

## Task 11: Update run-all.sh

**Files:**
- Modify: `tests/skill-triggering/run-all.sh`

**Step 1: Add to SKILLS array**

Add `"writing-documentation"` to the SKILLS array.

**Step 2: Commit**

```bash
git add tests/skill-triggering/run-all.sh
git commit -m "test: add writing-documentation to skill tests"
```

---

## Task 12: Final Review and Push

**Step 1: Review all changes**

```bash
git log --oneline -12
git diff origin/main..HEAD --stat
```

**Step 2: Push to remote**

```bash
git push origin main
```

---

## Deferred Items

None identified - skill is self-contained.
