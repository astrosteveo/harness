# Changelog

All notable changes to Harness will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Note:** Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers).
> This changelog tracks changes made in this fork. See `docs/ATTRIBUTION.md` for upstream credits.

## [Unreleased]

### Changed
- Simplified `docs/` to single `ATTRIBUTION.md` file
- **writing-plans** now explicitly distinguishes planning research from brainstorming research, preventing agents from skipping research with "I already researched during brainstorming" rationalization

## [0.1.0] - 2025-12-28

Initial release of the Harness fork with research-driven planning and expanded skill coverage.

### Added

**26 Skills** organized into four categories:

*Core Workflow (6):*
- `using-harness` - Skill discovery and usage patterns
- `brainstorming` - Socratic design refinement with research integration
- `researching` - Verify current versions, APIs, and best practices via web search
- `writing-plans` - Create detailed implementation plans
- `executing-plans` - Batch execution with review checkpoints
- `subagent-driven-development` - Per-task subagent execution with two-stage review

*Development Practice (12):*
- `test-driven-development` - RED-GREEN-REFACTOR cycle
- `working-with-legacy-code` - Characterization tests, strangler fig, finding seams
- `systematic-debugging` - 4-phase root cause analysis
- `debugging-ci-cd-failures` - CI-specific troubleshooting
- `debugging-flaky-tests` - Flaky test investigation with quarantine strategy
- `updating-dependencies` - Safe dependency update workflows
- `database-migrations` - Pre-flight checklist for schema changes
- `security-review` - OWASP-based security code review
- `performance-optimization` - Profile-first optimization
- `resolving-merge-conflicts` - Systematic 5-phase conflict resolution
- `verification-before-completion` - Evidence before claims
- `writing-documentation` - Concise, value-adding docs only

*Collaboration (7):*
- `using-git-worktrees` - Isolated workspace creation
- `requesting-code-review` - Dispatch code reviewer
- `receiving-code-review` - Technical response to feedback
- `dispatching-parallel-agents` - Parallelize investigations
- `working-with-monorepos` - Multi-package coordination
- `finishing-a-development-branch` - Complete and cleanup work
- `writing-skills` - Create new skills using TDD

*Support (3):*
- `backlog-tracking` - Deferred items management
- `resuming-work` - Restore context after interruption
- `handling-context-exhaustion` - Checkpoint before context limits

**Documentation:**
- `docs/INTEGRATION-MATRIX.md` - Platform comparison (Claude Code/Codex/OpenCode)
- `docs/BACKLOG-TEMPLATE.md` - Template for project backlogs
- `docs/UPSTREAM-CHANGELOG.md` - Fork differences from obra/superpowers
- `docs/WINDOWS-GUIDE.md` - Windows command translations
- `docs/CODE-REVIEW-ARCHITECTURE.md` - Review mechanisms
- `docs/TROUBLESHOOTING.md` - Common issues and solutions

**Infrastructure:**
- `.harness/` directory structure for project documentation
- `skills/INDEX.md` with complete dependency graph
- Test framework with 18 skill-triggering prompts
- Platform support for Claude Code, Codex, and OpenCode
- Session hooks for automatic skill injection

### Fork Enhancements

Key differences from upstream (obra/superpowers):
- **researching skill** - Prevents outdated training data from informing decisions
- **`.harness/` structure** - Organized project documentation (requirements, research, design, plan)
- **backlog-tracking** - Track bugs, deferred features, and tech debt
- **10 additional skills** - CI/CD, flaky tests, dependencies, migrations, security, performance, monorepos, context exhaustion, merge conflicts, legacy code

[Unreleased]: https://github.com/astrosteveo/harness/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/astrosteveo/harness/releases/tag/v0.1.0
