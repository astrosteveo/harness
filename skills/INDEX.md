# Harness Skills Index

> Auto-generated index of all available skills. Use `harness:skill-name` to invoke.

## Core Workflow Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-harness | Entry point - establishes skill discovery | Meta |
| brainstorming | Socratic design refinement | Flexible |
| researching | Fetch current versions/APIs | Flexible |
| writing-plans | Create implementation plans | Flexible |
| executing-plans | Batch execution with checkpoints | Flexible |
| subagent-driven-development | Per-task subagent execution | Flexible |

## Development Practice Skills

| Skill | Description | Type |
|-------|-------------|------|
| test-driven-development | RED-GREEN-REFACTOR cycle | **Rigid** |
| systematic-debugging | 4-phase root cause analysis | **Rigid** |
| verification-before-completion | Evidence before claims | **Rigid** |

## Collaboration Skills

| Skill | Description | Type |
|-------|-------------|------|
| using-git-worktrees | Isolated workspace creation | Flexible |
| requesting-code-review | Dispatch code reviewer | Flexible |
| receiving-code-review | Technical response to feedback | **Rigid** |
| dispatching-parallel-agents | Parallelize investigations | Flexible |
| finishing-a-development-branch | Complete and cleanup work | Flexible |

## Support Skills

| Skill | Description | Type |
|-------|-------------|------|
| backlog-tracking | Deferred items management | Flexible |
| writing-skills | Create new skills | Flexible |

## Skill Types

- **Rigid**: Follow exactly. No adaptation. Iron laws apply.
- **Flexible**: Adapt principles to context. Core concepts remain.
- **Meta**: Foundation skills that govern skill usage itself.

## Skill Dependencies

```
using-harness (foundation)
├── brainstorming
│   └── REQUIRES: researching
├── writing-plans
│   └── REQUIRES: researching
├── executing-plans
│   └── REQUIRES: finishing-a-development-branch
├── subagent-driven-development
│   ├── REQUIRES: test-driven-development (for subagents)
│   ├── REQUIRES: requesting-code-review
│   └── REQUIRES: finishing-a-development-branch
└── systematic-debugging
    └── REQUIRES: test-driven-development (Phase 4)
```
