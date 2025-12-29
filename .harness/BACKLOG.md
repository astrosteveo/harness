# Harness Plugin Backlog

> Bugs, deferred features, technical debt, and improvements identified during development.

## Bugs

| ID | Description | Related Feature | Status |
|----|-------------|-----------------|--------|
| BUG-001 | BACKLOG.md file was missing from repo despite being documented in CLAUDE.md | - | Fixed |

## Deferred Features

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~FEAT-001~~ | ~~Merge conflict resolution skill~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-002~~ | ~~CI/CD failure debugging skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-003~~ | ~~Flaky test handling skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-004~~ | ~~Dependency update skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-005~~ | ~~Database migration skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-006~~ | ~~Legacy code adaptation skill~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| FEAT-007 | Performance optimization skill | Low | Profiling, bottleneck identification, optimization strategies |
| ~~FEAT-008~~ | ~~Security review skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| FEAT-009 | Monorepo/multi-project skill | Low | Cross-project coordination and dependencies |
| ~~FEAT-010~~ | ~~Context exhaustion handling~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |

## Technical Debt

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~DEBT-001~~ | ~~Missing test prompts for 5 skills~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-002~~ | ~~Implicit skill dependencies not documented~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| DEBT-003 | No upstream changelog | Low | Document what changed from obra/superpowers fork |
| DEBT-004 | Windows skill adaptations missing | Low | Only polyglot-hooks.md exists; skills assume Unix |
| ~~DEBT-005~~ | ~~Integration matrix incomplete~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |

## Improvements

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~IMP-001~~ | ~~Add BACKLOG.md template to docs~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-002~~ | ~~Document TDD exceptions~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| IMP-003 | Add research caching strategy | Low | Avoid repeated web searches for same info |
| ~~IMP-004~~ | ~~Clarify executing-plans vs subagent-driven-development selection~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-005~~ | ~~Add plan invalidation handling~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-006~~ | ~~Add rollback procedures~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| IMP-007 | Resolve YAGNI vs "Track Everything" tension | Low | Philosophy clarification |
| IMP-008 | Add log retention/artifact strategy | Low | Support "Evidence Over Claims" principle |
| IMP-009 | Hybrid approach for mixed task dependencies | Low | Some independent, some dependent tasks in same plan |

## Completed

| ID | Description | Completed | Notes |
|----|-------------|-----------|-------|
| BUG-001 | Create missing BACKLOG.md | 2024-12-28 | This file |
| DEBT-001 | Missing test prompts for 5 skills | 2024-12-28 | Added prompts for using-harness, using-git-worktrees, receiving-code-review, resuming-work, writing-skills |
| DEBT-002 | Implicit skill dependencies not documented | 2024-12-28 | Updated INDEX.md with full dependency graph + cross-cutting concerns |
| FEAT-001 | Merge conflict resolution skill | 2024-12-28 | Created skills/resolving-merge-conflicts/SKILL.md |
| FEAT-006 | Legacy code adaptation skill | 2024-12-28 | Created skills/working-with-legacy-code/SKILL.md |
| FEAT-010 | Context exhaustion handling | 2024-12-28 | Created skills/handling-context-exhaustion/SKILL.md |
| IMP-002 | Document TDD exceptions | 2024-12-28 | Added "Adapting TDD" section to test-driven-development skill |
| FEAT-002 | CI/CD failure debugging skill | 2024-12-28 | Created skills/debugging-ci-cd-failures/SKILL.md |
| FEAT-003 | Flaky test handling skill | 2024-12-28 | Created skills/debugging-flaky-tests/SKILL.md |
| DEBT-005 | Integration matrix | 2024-12-28 | Created docs/INTEGRATION-MATRIX.md |
| IMP-004 | Execution mode comparison | 2024-12-28 | Added decision matrix to executing-plans skill |
| IMP-001 | Add BACKLOG.md template to docs | 2024-12-28 | Created docs/BACKLOG-TEMPLATE.md |
| FEAT-004 | Dependency update skill | 2024-12-28 | Created skills/updating-dependencies/SKILL.md |
| FEAT-005 | Database migration skill | 2024-12-28 | Created skills/database-migrations/SKILL.md |
| FEAT-008 | Security review skill | 2024-12-28 | Created skills/security-review/SKILL.md |
| IMP-005 | Plan invalidation handling | 2024-12-28 | Added section to executing-plans skill |
| IMP-006 | Rollback procedures | 2024-12-28 | Added section to verification-before-completion skill |
