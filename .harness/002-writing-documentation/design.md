# Writing Documentation Skill - Design

## Overview

A discipline-enforcing skill that ensures documentation adds value, prevents Claude's verbosity anti-patterns, and integrates documentation into the TDD workflow.

## Skill Metadata

- **Name:** `writing-documentation`
- **Type:** Discipline-enforcing (rigid, like TDD)
- **Trigger:** Use when writing or updating any documentation - code comments, docstrings, README files, API docs, guides, or changelogs. Also use when reviewing existing documentation for quality issues.

## Core Principle

```
DOCUMENTATION ADDS VALUE OR GETS DELETED
```

If a comment doesn't tell you something the code doesn't already tell you, delete it.

## Anti-Patterns to Forbid

| Anti-Pattern | Example | Fix |
|--------------|---------|-----|
| Over-verbosity | "This function is responsible for facilitating the initialization process of..." | "Initializes..." |
| Stating the obvious | `// increment counter by 1` above `counter++` | Delete the comment |
| Empty qualifiers | "(Authoritatively)", "(Importantly)", "(Notably)" | Remove entirely |
| Unnecessary formality | "This method serves to provide..." | "Returns..." |
| Redundant type info | `@param {string} name - The name string` | `@param name - User's display name` |
| Filler phrases | "It's worth noting that...", "As mentioned above..." | Just state the fact |
| Passive voice overuse | "The file is read by the function" | "The function reads the file" |

## Documentation TDD Cycle

```
RED:    Write/update docs alongside failing test
GREEN:  Implement code, verify docs still accurate
VERIFY: Run doc linting + doc tests
REFACTOR: Trim verbosity, improve clarity
```

### Verification Commands

| Language | Doc Linting | Doc Testing |
|----------|-------------|-------------|
| TypeScript | `eslint --plugin jsdoc` | TypeDoc build |
| JavaScript | `eslint --plugin jsdoc` | JSDoc build |
| Python | `pydocstyle` | `pytest --doctest-modules` |
| Markdown | `markdownlint` | Link checker |
| OpenAPI | `spectral lint` | Schema validation |

### Definition of Done

- Public APIs documented
- Doc linting passes
- Code examples tested (where applicable)
- No anti-patterns present

## Language-Specific Standards

### TypeScript/JavaScript
- TSDoc for TypeScript, JSDoc for JavaScript
- Don't duplicate type information (TypeScript provides it)
- Focus on "why" and usage examples

### Python
- Google style (readable, Sphinx-compatible via Napoleon)
- Type hints in signatures, not docstrings
- Doctest examples for non-trivial functions

### Markdown
- Follow Google Developer Style Guide
- Sentence case headings
- One sentence per line (easier diffs)

### API Documentation
- OpenAPI 3.1+ for REST APIs
- Include request/response examples
- Document error responses

### General Rule
When in doubt, check the project's existing style. Consistency > theoretical best practice.

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Adding context for clarity" | If code is clear, comment adds noise |
| "Being thorough" | Thorough ≠ verbose. Be complete AND concise |
| "The user might not understand" | Write for intended audience |
| "Just being professional" | Professional = clear and concise |
| "Documenting for completeness" | Undocumented > obvious-stating |
| "It's a minor addition" | Minor additions = major noise |
| "Style guide says document all" | Assumes useful documentation |

## Red Flags - STOP and Revise

- Comment longer than the code it describes
- Words like "facilitates", "serves to", "is responsible for"
- Qualifiers in parentheses
- Explaining WHAT instead of WHY
- Passive voice without good reason

## Integration

| Skill | Relationship |
|-------|-------------|
| `test-driven-development` | Documentation is part of the cycle |
| `writing-skills` | No overlap - skills vs code/project docs |
| `writing-plans` | Plans may reference for doc tasks |
| `brainstorming` | Design docs follow writing principles |

Not a sub-skill - standalone skill that complements TDD.

## Research Sources

- [TSDoc](https://tsdoc.org/) - TypeScript documentation standard
- [eslint-plugin-jsdoc](https://github.com/gajus/eslint-plugin-jsdoc) - JSDoc linting (v61.5.0)
- [Sphinx Napoleon](https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html) - Google/NumPy docstring support
- [OpenAPI 3.2.0](https://spec.openapis.org/oas/v3.2.0.html) - API specification
- [Google Developer Style Guide](https://developers.google.com/style) - Technical writing reference
- [pytest doctest](https://docs.pytest.org/en/stable/how-to/doctest.html) - Documentation testing
