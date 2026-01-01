# Changelog

All notable changes to Harness will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Note:** Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers).
> This changelog tracks changes made in this fork. See `docs/ATTRIBUTION.md` for upstream credits.

## [Unreleased]

## [0.7.0] - 2025-12-31

### Changed
- **Imperative skill descriptions** - All skill descriptions changed from passive "Use when..." to imperative "MUST invoke..." to force proactive skill invocation
  - `systematic-debugging` - "MUST invoke BEFORE any debugging action"
  - `test-driven-development` - "MUST invoke BEFORE writing ANY implementation code"
  - `verification-before-completion` - "MUST invoke BEFORE claiming ANYTHING is done"
  - All other skills updated with similar imperative language

### Added
- **receiving-corrections skill** - New skill for handling user corrections without sycophantic responses ("You're right!", apologies, performative agreement). Emphasizes brief acknowledgment and immediate action.

### Fixed
- **session-start.sh integer parsing** - Fixed bash arithmetic error when grep -c output contained newlines, causing `integer expected` errors

## [0.6.1] - 2025-12-31

### Added
- **Release process documentation** - CLAUDE.md now documents required version bump, changelog, tag, and release steps for every push to main
- **Fork-aware gh commands** - Documents that `--repo astrosteveo/harness` must be used with `gh release` and `gh pr` commands to avoid targeting upstream

## [0.6.0] - 2025-12-31

### Changed
- **Research-first discipline** - All three planning skills now enforce research before design with explicit Iron Rules:
  - `researching` - Rewritten to require BOTH codebase exploration AND external research
  - `brainstorming` - Added "NO DESIGNING UNTIL RESEARCH IS COMPLETE" Iron Rule
  - `writing-plans` - Added "NO PLANNING UNTIL RESEARCH IS COMPLETE" Iron Rule

### Added
- **Rationalization tables** - Each skill now includes tables countering common excuses for skipping research:
  - "I know this codebase" → "Knowing isn't current. Explore to verify."
  - "Let me propose something first" → "NO. Research THEN propose."
  - "It's just a button" → "Where does it go? What patterns exist? Verify first."
- **Codebase exploration as research** - `researching` skill now explicitly requires exploring existing patterns, related code, tests, and recent changes before any design work
- **Creative solutions requirement** - Research must include looking for alternative approaches, not just verifying known patterns

### Fixed
- **Micro task loophole** - Task sizing table now clarifies that micro tasks still require verifying location in codebase. "Micro" means abbreviated workflow, NOT skipping research entirely.

## [0.5.0] - 2025-12-30

### Changed
- **Git-based progress tracking** - Replaced `PENDING_EXECUTION.md` marker file with git commit trailers for progress tracking. Session start now scans git history for `phase(N): complete` commits to detect incomplete work.
- **Phase completion commits** - Each phase completion now creates a commit with `phase(N): complete` trailer, enabling progress tracking entirely through git history.
- **Plan abandonment** - Users can now abandon plans via `plan: abandoned` commit trailer, which stops session start prompts for that plan.

### Removed
- **PENDING_EXECUTION.md marker** - No longer created or used. All 6 skills updated to remove marker references:
  - `using-harness` - Now uses git-based detection instead of marker file
  - `subagent-driven-development` - Adds phase completion commit trailers
  - `executing-plans` - Adds phase completion commit trailers
  - `handling-context-exhaustion` - Removed marker creation step
  - `resuming-work` - Uses git-based detection instead of marker reading
  - `writing-plans` - Removed marker from execution handoff

### Added
- **End-to-end test suite** - New `tests/git-progress-tracking/` with comprehensive test script validating phase detection, abandonment, and multi-plan scenarios (7 assertions)

## [0.4.1] - 2025-12-30

### Added
- **Plan size limits** - `writing-plans` skill now enforces 20,000 token limit per plan file. Large features must be split into multiple sequential plan files (`plan-part1.md`, `plan-part2.md`, etc.)

### Fixed
- **Session-start hook marker detection** - Hook now actually reads `.harness/PENDING_EXECUTION.md` and injects contents into context. Previously only the skill described this behavior but the hook didn't implement it.

## [0.4.0] - 2025-12-30

### Added
- **PENDING_EXECUTION marker system** - Automatic resume capability for interrupted executions. When context exhaustion occurs or user pauses, a marker file is created at `.harness/PENDING_EXECUTION.md` that enables auto-resume in new sessions.
- **Session start marker detection** - `using-harness` skill now checks for pending execution markers at session start and offers to resume automatically.
- **Test prompts for phase-based execution:**
  - `pending-execution-marker-detection.txt` - Tests marker detection at session start
  - `context-exhaustion-marker-creation.txt` - Tests checkpoint and marker creation flow
  - `phase-level-execution.txt` - Tests Phase-level dispatch language

### Changed
- **Phase-based execution** - Subagent dispatch now operates at Phase level (2-6 tasks) instead of individual task level, reducing dispatch overhead while maintaining fresh context per Phase.
- **subagent-driven-development** - Updated to dispatch one subagent per Phase with spec + code quality review after each Phase completes.
- **executing-plans** - Aligned with Phase-level execution model.
- **handling-context-exhaustion** - Now creates PENDING_EXECUTION.md marker for automatic resume in new sessions.
- **resuming-work** - Integrated with marker system for seamless continuation.
- **writing-plans** - Plans now use Phase structure with explicit task grouping.

### Fixed
- Marker edge case handling in `using-harness` (missing plan file, corrupted marker, wrong worktree)

## [0.3.0] - 2025-12-30

### Added
- **Checkpoint execution mode** - New hybrid option that combines subagent-driven quality gates with human checkpoints after each task. Three execution modes now available:
  - **Autonomous** - Runs to completion with automated spec/code quality reviews
  - **Checkpoints** - Pauses after each task for human approval before proceeding
  - **Batch Review** - Separate session with human review every 3 tasks
- Test prompts for all three execution mode selections

### Changed
- **writing-plans** - Execution handoff now presents three clearly differentiated options with explicit descriptions of human involvement
- **subagent-driven-development** - Added checkpoint mode support with configurable human stops, updated flowchart and comparison tables
- **executing-plans** - Updated comparison table to show all three execution modes

### Fixed
- Test script `explicit-skill-requests/run-test.sh` now handles missing `timeout` command on macOS and includes required `--verbose` flag

## [0.2.0] - 2025-12-29

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

[Unreleased]: https://github.com/astrosteveo/harness/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/astrosteveo/harness/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/astrosteveo/harness/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/astrosteveo/harness/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/astrosteveo/harness/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/astrosteveo/harness/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/astrosteveo/harness/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/astrosteveo/harness/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/astrosteveo/harness/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/astrosteveo/harness/releases/tag/v0.1.0
