# Upstream Changelog

This document tracks the relationship between Harness and its upstream project.

## Fork Information

Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent.

**Upstream URL:** `https://github.com/obra/superpowers.git`

## Key Enhancements in This Fork

### 1. Research-Driven Planning (`researching` skill)

The most significant addition. Before proposing approaches or writing implementation plans, Harness triggers web research to verify:
- Current library/framework versions
- Actual API signatures and method names
- Current best practices and patterns
- Deprecations to avoid

This prevents outdated training data from informing architectural decisions.

### 2. `.harness/` Directory Structure

Organized project documentation:
```
.harness/
├── BACKLOG.md                    # Bugs, deferred tasks, tech debt
├── 001-feature-name/
│   ├── requirements.md           # User story and acceptance criteria
│   ├── research.md               # Technology research findings
│   ├── design.md                 # Architecture decisions
│   └── plan.md                   # Implementation tasks
```

### 3. Backlog Tracking (`backlog-tracking` skill)

Structured tracking for:
- Bugs discovered during development
- Deferred features
- Technical debt
- Improvements for later

Each item gets a unique ID (BUG-001, FEAT-002) with references to related features.

### 4. Additional Skills

Skills added in this fork beyond the upstream set.

## Skill Origin Reference

### From Upstream (obra/superpowers)

- `brainstorming` - Socratic design refinement
- `writing-plans` - Implementation planning
- `test-driven-development` - RED-GREEN-REFACTOR cycle
- `systematic-debugging` - Root cause analysis
- `subagent-driven-development` - Per-task agents with review
- `requesting-code-review` - Pre-review checklist
- `receiving-code-review` - Responding to feedback
- `dispatching-parallel-agents` - Concurrent subagent workflows
- `using-git-worktrees` - Parallel development branches
- `finishing-a-development-branch` - Merge/PR decision workflow
- `using-harness` - Skills introduction (adapted from `using-superpowers`)
- `writing-skills` - Create new skills
- `verification-before-completion` - Evidence-first verification
- `executing-plans` - Batch execution with checkpoints

### Added in This Fork

- `researching` - Fetch current versions/APIs before planning
- `backlog-tracking` - Deferred items management
- `resuming-work` - Restore context after interruption
- `handling-context-exhaustion` - Checkpoint before context limits
- `resolving-merge-conflicts` - Systematic conflict resolution
- `working-with-legacy-code` - Adapting TDD for legacy systems
- `debugging-ci-cd-failures` - CI/CD pipeline troubleshooting
- `debugging-flaky-tests` - Flaky test investigation
- `updating-dependencies` - Dependency version management
- `database-migrations` - Safe schema and data changes
- `security-review` - Security-focused code review
- `writing-documentation` - Concise, value-adding docs only

## Syncing with Upstream

### Initial Setup

```bash
# Add upstream remote (one-time)
git remote add upstream git@github.com:obra/superpowers.git
```

### Fetching Updates

```bash
# Fetch upstream changes
git fetch upstream

# View upstream commits
git log upstream/main --oneline -20
```

### Applying Changes

**Option 1: Merge (includes all upstream commits)**
```bash
git checkout main
git merge upstream/main
# Resolve conflicts if any
git push origin main
```

**Option 2: Cherry-pick (selective commits)**
```bash
git checkout main
git cherry-pick <commit-hash>
git push origin main
```

**Option 3: Rebase (cleaner history)**
```bash
git checkout main
git rebase upstream/main
# Resolve conflicts if any
git push origin main --force-with-lease
```

### Conflict Resolution

Common conflict areas:
- `skills/using-harness/` (renamed from `using-superpowers`)
- Root `README.md` and `CLAUDE.md`
- Plugin configuration in `.claude-plugin/`

When resolving, preserve fork-specific enhancements while incorporating upstream improvements.

## Contribution Back to Upstream

If developing features that would benefit the broader community:
1. Open an issue on obra/superpowers to discuss
2. Submit a PR to upstream with the enhancement
3. Once merged, sync this fork to pick up the changes

## Changelog

Track significant syncs or divergences here:

| Date | Action | Notes |
|------|--------|-------|
| Initial | Fork created | Base from obra/superpowers |
| - | Added `researching` skill | Core enhancement for research-driven planning |
| - | Added `.harness/` structure | Organized project documentation |
| - | Added `backlog-tracking` | Deferred items management |
