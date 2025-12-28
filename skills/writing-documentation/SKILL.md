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