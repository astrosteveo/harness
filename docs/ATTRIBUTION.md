# Attribution

Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent.

## Upstream Skills

The following skills originated from the upstream project:

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

## Syncing with Upstream

```bash
# Add upstream remote (one-time)
git remote add upstream git@github.com:obra/superpowers.git

# Fetch and merge upstream changes
git fetch upstream
git merge upstream/main
```
