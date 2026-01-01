# Harness Plugin Backlog

> Bugs, deferred features, technical debt, and improvements identified during development.

## Bugs

| ID | Description | Related Feature | Status |
|----|-------------|-----------------|--------|
| BUG-001 | BACKLOG.md file was missing from repo despite being documented in CLAUDE.md | - | Fixed |

## Deferred Features

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| FEAT-011 | CLAUDE.md + rules integration | High | See details below |
| ~~FEAT-001~~ | ~~Merge conflict resolution skill~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-002~~ | ~~CI/CD failure debugging skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-003~~ | ~~Flaky test handling skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-004~~ | ~~Dependency update skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-005~~ | ~~Database migration skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-006~~ | ~~Legacy code adaptation skill~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-007~~ | ~~Performance optimization skill~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-008~~ | ~~Security review skill~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-009~~ | ~~Monorepo/multi-project skill~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~FEAT-010~~ | ~~Context exhaustion handling~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |

## Technical Debt

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~DEBT-001~~ | ~~Missing test prompts for 5 skills~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-002~~ | ~~Implicit skill dependencies not documented~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-003~~ | ~~No upstream changelog~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-004~~ | ~~Windows skill adaptations missing~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~DEBT-005~~ | ~~Integration matrix incomplete~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |

## Improvements

| ID | Description | Priority | Notes |
|----|-------------|----------|-------|
| ~~IMP-001~~ | ~~Add BACKLOG.md template to docs~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-002~~ | ~~Document TDD exceptions~~ | ~~High~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-003~~ | ~~Add research caching strategy~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-004~~ | ~~Clarify executing-plans vs subagent-driven-development selection~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-005~~ | ~~Add plan invalidation handling~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-006~~ | ~~Add rollback procedures~~ | ~~Medium~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-007~~ | ~~Resolve YAGNI vs "Track Everything" tension~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-008~~ | ~~Add log retention/artifact strategy~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |
| ~~IMP-009~~ | ~~Hybrid approach for mixed task dependencies~~ | ~~Low~~ | ~~Fixed 2024-12-28~~ |

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
| FEAT-007 | Performance optimization skill | 2024-12-28 | Created skills/performance-optimization/SKILL.md |
| FEAT-009 | Monorepo/multi-project skill | 2024-12-28 | Created skills/working-with-monorepos/SKILL.md |
| DEBT-003 | Upstream changelog | 2024-12-28 | Created docs/UPSTREAM-CHANGELOG.md |
| DEBT-004 | Windows guide | 2024-12-28 | Created docs/WINDOWS-GUIDE.md |
| IMP-003 | Research caching | 2024-12-28 | Added "Reusing Research" section to researching skill |
| IMP-007 | YAGNI clarification | 2024-12-28 | Added section to backlog-tracking skill |
| IMP-008 | Evidence preservation | 2024-12-28 | Added section to verification-before-completion skill |
| IMP-009 | Mixed dependencies | 2024-12-28 | Added section to subagent-driven-development skill |

---

## Feature Details

### FEAT-011: CLAUDE.md + Rules Integration

**Problem:** Research findings are siloed in `.harness/NNN-*/research.md` files. Patterns discovered during feature development don't persist at the project level. Each session starts without accumulated project knowledge.

**Solution:** Integrate harness with Claude's CLAUDE.md and `.claude/rules/` system to make research findings persistent and automatically scoped.

**Architecture:**
```
project/
├── .claude/
│   ├── CLAUDE.md                  # ~100-200 lines, project overview
│   │   └── @imports to rules
│   └── rules/
│       ├── conventions.md         # General code style (~100-500 lines)
│       ├── testing.md             # Test patterns
│       ├── api/
│       │   └── validation.md      # paths: src/api/**
│       └── frontend/
│           └── components.md      # paths: src/components/**
└── .harness/
    └── [existing structure]
```

**Why `.claude/CLAUDE.md`:**
- Keeps project root clean
- All Claude config in one place (CLAUDE.md + rules/ as siblings)
- Clear separation: `.claude/` = Claude config, `.harness/` = dev workflow

**Harness touchpoints:**

| Phase | Action |
|-------|--------|
| First `.harness/` init | Seed `.claude/CLAUDE.md` + `.claude/rules/conventions.md` if missing |
| Research phase | Determine scope of discoveries, create/update appropriate rule file |
| Feature completion | Prompt to consolidate learnings into rules |
| Code review | Reviewer validates against `.claude/rules/` |

**Key behaviors:**
- Rules files: ~100-500 lines each (as long as needed, focused on purpose)
- Path-scoped rules via frontmatter for domain-specific conventions
- `@` imports for composition (like skills reference sub-skills)
- Research findings promoted to rules, not buried in feature directories
- Prevents monolithic 1000+ line CLAUDE.md anti-pattern

**Skills affected:**
- `brainstorming` - Init CLAUDE.md + rules on first invocation
- `researching` - Prompt to add patterns to appropriate rule file
- `finishing-a-development-branch` - Consolidate learnings
- `code-reviewer` agent - Check against `.claude/rules/`

**Dependencies:** None (standalone feature)
