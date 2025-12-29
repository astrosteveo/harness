# Harness Plugin Backlog

> Bugs, deferred features, technical debt, and improvements identified during development.

## Bugs

| ID | Description | Related Feature | Status |
|----|-------------|-----------------|--------|
| BUG-001 | BACKLOG.md file was missing from repo despite being documented in CLAUDE.md | - | Fixed |

## Deferred Features

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| FEAT-001 | Merge conflict resolution skill | High | Common blocker with no guidance; should include git conflict patterns and resolution strategies |
| FEAT-002 | CI/CD failure debugging skill | Medium | Pipeline failures need different approach than local debugging |
| FEAT-003 | Flaky test handling skill | Medium | Extend systematic-debugging with flaky-specific patterns |
| FEAT-004 | Dependency update skill | Medium | Version bumps, security patches, breaking change handling |
| FEAT-005 | Database migration skill | Medium | Schema changes, rollback strategies, data migration |
| FEAT-006 | Legacy code adaptation skill | High | Guidance when TDD isn't feasible (no existing tests, external APIs) |
| FEAT-007 | Performance optimization skill | Low | Profiling, bottleneck identification, optimization strategies |
| FEAT-008 | Security review skill | Medium | Security-focused code review patterns |
| FEAT-009 | Monorepo/multi-project skill | Low | Cross-project coordination and dependencies |
| FEAT-010 | Context exhaustion handling | High | Different from session restart; mid-task context limits |

## Technical Debt

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~DEBT-001~~ | ~~Missing test prompts for 5 skills~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-002~~ | ~~Implicit skill dependencies not documented~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| DEBT-003 | No upstream changelog | Low | Document what changed from obra/superpowers fork |
| DEBT-004 | Windows skill adaptations missing | Low | Only polyglot-hooks.md exists; skills assume Unix |
| DEBT-005 | Integration matrix incomplete | Medium | No clear "what works where" for Claude Code vs Codex vs OpenCode |

## Improvements

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| IMP-001 | Add BACKLOG.md template to docs | Medium | Help users understand expected format |
| IMP-002 | Document TDD exceptions | High | When to adapt rigid TDD (integration tests, E2E, exploratory) |
| IMP-003 | Add research caching strategy | Low | Avoid repeated web searches for same info |
| IMP-004 | Clarify executing-plans vs subagent-driven-development selection | Medium | Decision matrix for which to choose |
| IMP-005 | Add plan invalidation handling | Medium | External changes during execution |
| IMP-006 | Add rollback procedures | Medium | Recovery after failed verification |
| IMP-007 | Resolve YAGNI vs "Track Everything" tension | Low | Philosophy clarification |
| IMP-008 | Add log retention/artifact strategy | Low | Support "Evidence Over Claims" principle |
| IMP-009 | Hybrid approach for mixed task dependencies | Low | Some independent, some dependent tasks in same plan |

## Completed

| ID | Description | Completed | Notes |
|----|-------------|-----------|-------|
| BUG-001 | Create missing BACKLOG.md | 2024-12-28 | This file |
| DEBT-001 | Missing test prompts for 5 skills | 2024-12-28 | Added prompts for using-harness, using-git-worktrees, receiving-code-review, resuming-work, writing-skills |
| DEBT-002 | Implicit skill dependencies not documented | 2024-12-28 | Updated INDEX.md with full dependency graph + cross-cutting concerns |
