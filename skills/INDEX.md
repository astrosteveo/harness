# Harness Skills Index

10 core skills addressing Claude Code's main antipatterns.

## Skills Overview

| Skill | Purpose | Type |
|-------|---------|------|
| using-harness | Foundation - skill invocation, context management | **Rigid** |
| researching | Prevent stale training data | **Rigid** |
| brainstorming | Prevent jumping to code, includes planning | **Flexible** |
| test-driven-development | Prevent skipping tests | **Rigid** |
| systematic-debugging | Prevent random debugging | **Rigid** |
| verification-before-completion | Prevent premature "done", includes finishing | **Rigid** |
| backlog-tracking | Prevent forgotten work | **Flexible** |
| subagent-driven-development | Execute plans with fresh context per phase | **Rigid** |
| gamedev-brainstorming | Game development variant with GDD workflow | **Flexible** |
| writing-skills | Meta - for creating new skills | **Flexible** |

## Antipattern Coverage

| Antipattern | Skill |
|-------------|-------|
| Uses outdated APIs/versions | researching |
| Jumps straight to code | brainstorming |
| Skips writing tests | test-driven-development |
| Random debugging attempts | systematic-debugging |
| Claims "done" without evidence | verification-before-completion |
| Forgets deferred work | backlog-tracking |
| Context exhaustion | using-harness (context management section) |

## Skill Flow

```
Feature Request
    ↓
brainstorming (includes researching → design → plan)
    ↓
subagent-driven-development (executes plan)
    ↓
verification-before-completion (verify → finish options)
```

## Skill Types

**Rigid** - Follow exactly. These address behaviors that need discipline.

**Flexible** - Adapt principles to context. These provide frameworks.

## Integration

Skills reference each other:
- `brainstorming` → calls `researching`, outputs to `subagent-driven-development`
- `subagent-driven-development` → uses `test-driven-development` per task
- All skills → can defer items via `backlog-tracking`
- All work → ends with `verification-before-completion`
