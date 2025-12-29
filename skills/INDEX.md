# Harness Skills Index

> Auto-generated index of all available skills. Use `harness:skill-name` to invoke.

## Core Workflow Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-harness | Entry point - establishes skill discovery | **Meta** |
| brainstorming | Socratic design refinement | **Flexible** |
| researching | Fetch current versions/APIs | **Flexible** |
| writing-plans | Create implementation plans | **Flexible** |
| executing-plans | Batch execution with checkpoints | **Flexible** |
| subagent-driven-development | Per-task subagent execution | **Flexible** |

## Development Practice Skills

| Skill | Description | Type |
|-------|-------------|------|
| test-driven-development | RED-GREEN-REFACTOR cycle | **Rigid** |
| working-with-legacy-code | Adapting TDD for legacy systems | **Flexible** |
| systematic-debugging | 4-phase root cause analysis | **Rigid** |
| debugging-ci-cd-failures | CI/CD pipeline troubleshooting | **Flexible** |
| debugging-flaky-tests | Flaky test investigation | **Rigid** |
| updating-dependencies | Dependency version management | **Flexible** |
| database-migrations | Safe schema and data changes | **Rigid** |
| security-review | Security-focused code review | **Rigid** |
| verification-before-completion | Evidence before claims | **Rigid** |
| writing-documentation | Concise, value-adding docs only | **Rigid** |

## Collaboration Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-git-worktrees | Isolated workspace creation | **Flexible** |
| resolving-merge-conflicts | Systematic conflict resolution | **Rigid** |
| requesting-code-review | Dispatch code reviewer | **Flexible** |
| receiving-code-review | Technical response to feedback | **Rigid** |
| dispatching-parallel-agents | Parallelize investigations | **Flexible** |
| finishing-a-development-branch | Complete and cleanup work | **Flexible** |

## Support Skills

| Skill | Description | Type |
|-------|-------------|------|
| backlog-tracking | Deferred items management | **Flexible** |
| resuming-work | Restore context after interruption | **Flexible** |
| handling-context-exhaustion | Checkpoint before context limits | **Flexible** |
| writing-skills | Create new skills | **Flexible** |

## Skill Types

- **Rigid**: Follow exactly. No adaptation. Iron laws apply.
- **Flexible**: Adapt principles to context. Core concepts remain.
- **Meta**: Foundation skills that govern skill usage itself.

## Skill Dependencies

```
using-harness (foundation)
├── brainstorming
│   ├── REQUIRES: researching
│   └── REQUIRES: using-git-worktrees (Phase 4, when implementation follows)
├── writing-plans
│   └── REQUIRES: researching
├── executing-plans
│   └── REQUIRES: finishing-a-development-branch
├── subagent-driven-development
│   ├── REQUIRES: test-driven-development (for subagents)
│   ├── REQUIRES: requesting-code-review
│   └── REQUIRES: finishing-a-development-branch
├── systematic-debugging
│   └── REQUIRES: test-driven-development (Phase 4)
├── debugging-ci-cd-failures
│   └── EXTENDS: systematic-debugging (CI-specific patterns)
├── debugging-flaky-tests
│   └── EXTENDS: systematic-debugging (flakiness patterns)
├── updating-dependencies
│   └── REQUIRES: researching (check changelogs/CVEs)
├── database-migrations
│   └── REQUIRES: verification-before-completion (pre-flight checks)
├── security-review
│   └── EXTENDS: requesting-code-review (security focus)
├── using-git-worktrees
│   └── REQUIRES: finishing-a-development-branch (cleanup)
├── resuming-work
│   └── AWARE OF: backlog-tracking (check for blockers)
├── handling-context-exhaustion
│   └── REQUIRES: resuming-work (for handoff format)
├── resolving-merge-conflicts
│   └── REQUIRES: verification-before-completion (after resolution)
├── working-with-legacy-code
│   └── ADAPTS: test-driven-development (different granularities)
└── writing-skills
    ├── REQUIRES: test-driven-development (TDD for skills)
    └── REQUIRES: verification-before-completion (before deployment)
```

## Cross-Cutting Concerns

Skills that should be considered during ANY development work:

| Skill | When to Consider |
|-------|------------------|
| backlog-tracking | When deferring bugs, features, or tech debt |
| verification-before-completion | Before claiming any work is done |
| researching | Before using external libraries or APIs |
