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