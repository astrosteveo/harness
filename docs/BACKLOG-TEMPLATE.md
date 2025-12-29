# BACKLOG.md Template

This document explains the purpose, structure, and workflow for maintaining a project backlog using the Harness plugin.

## Purpose

The `BACKLOG.md` file tracks items discovered during development that should not be addressed immediately:

- **Bugs** - Issues that need fixing but aren't blocking current work
- **Deferred Features** - Ideas worth pursuing later
- **Technical Debt** - Code improvements that can wait
- **Improvements** - Nice-to-have enhancements

This prevents scope creep while ensuring nothing is forgotten.

## File Location

```
your-project/
└── .harness/
    └── BACKLOG.md    # <-- Lives here
```

## Template Structure

```markdown
# [Project Name] Backlog

> Bugs, deferred features, technical debt, and improvements identified during development.

## Bugs

| ID | Description | Related Feature | Status |
|----|-------------|-----------------|--------|
| BUG-001 | Brief description of the bug | FEAT-XXX or - | Open |

## Deferred Features

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| FEAT-001 | Feature description | High | Context or rationale |

## Technical Debt

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| DEBT-001 | Debt description | Medium | What needs improvement |

## Improvements

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| IMP-001 | Improvement description | Low | Additional context |

## Completed

| ID | Description | Completed | Notes |
|----|-------------|-----------|-------|
| BUG-001 | What was fixed | YYYY-MM-DD | How it was resolved |
```

## ID Naming Convention

Use prefixes to categorize items:

| Prefix | Category | Example |
|--------|----------|---------|
| `BUG-` | Bugs | BUG-001, BUG-002 |
| `FEAT-` | Deferred Features | FEAT-001, FEAT-002 |
| `DEBT-` | Technical Debt | DEBT-001, DEBT-002 |
| `IMP-` | Improvements | IMP-001, IMP-002 |

IDs are sequential within each category. Once assigned, an ID never changes.

## Priority Levels

| Priority | When to Use |
|----------|-------------|
| **High** | Blocks other work, affects users, or creates risk |
| **Medium** | Should be addressed soon but not urgent |
| **Low** | Nice to have, address when convenient |

## Example Entries

### Bugs

| ID | Description | Related Feature | Status |
|----|-------------|-----------------|--------|
| BUG-001 | Login fails silently when API returns 500 | FEAT-003 | Open |
| BUG-002 | Date picker shows wrong month on first open | - | Open |

### Deferred Features

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| FEAT-001 | Export data to CSV | High | Users requesting frequently |
| FEAT-002 | Dark mode support | Low | Nice to have, not critical |

### Technical Debt

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| DEBT-001 | Refactor auth module to use dependency injection | Medium | Makes testing easier |
| DEBT-002 | Remove deprecated API calls | High | Deprecated in v3, removed in v4 |

### Improvements

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| IMP-001 | Add loading spinners to all async operations | Medium | Better UX |
| IMP-002 | Optimize database queries for user list | Low | Only noticeable with 10k+ users |

### Completed

| ID | Description | Completed | Notes |
|----|-------------|-----------|-------|
| BUG-001 | Login fails silently when API returns 500 | 2024-12-15 | Added error handling and user feedback |
| DEBT-001 | Refactor auth module | 2024-12-20 | Now uses DI container |

## Workflow

### Adding Items

1. Identify something that shouldn't be done immediately
2. Determine the category (Bug, Feature, Debt, Improvement)
3. Assign the next available ID for that category
4. Add a row to the appropriate table
5. Set priority based on urgency and impact

### Updating Items

- Update the Description or Notes column as you learn more
- Change Priority if circumstances change
- For Bugs: update Status (Open, In Progress, Fixed)

### Completing Items

1. Strike through the row in the original section: `| ~~BUG-001~~ | ~~Description~~ | ... |`
2. Add a new row to the Completed section with:
   - The original ID
   - Brief description of what was done
   - Completion date
   - Notes on how it was resolved

### Referencing Related Work

- Link to feature directories: "See `.harness/003-auth-refactor/`"
- Reference commits: "Fixed in abc1234"
- Link to PRs: "Resolved in #42"

## Best Practices

1. **Be specific** - "Button doesn't work" is less useful than "Submit button disabled after first click"
2. **Include context** - Why was this deferred? What triggered the discovery?
3. **Review regularly** - During planning, check if any items should be prioritized
4. **Keep it current** - Update status as work progresses
5. **Don't over-categorize** - When in doubt, use IMP- for general improvements

## Integration with Harness Skills

The `harness:backlog-tracking` skill automatically:
- Suggests adding items when you defer work
- Prompts for category and priority
- Maintains consistent formatting
- Reminds you to check the backlog during planning
