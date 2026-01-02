# Changelog

All notable changes to Harness will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Note:** Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers).
> This changelog tracks changes made in this fork. See `docs/ATTRIBUTION.md` for upstream credits.

## [Unreleased]

## [0.10.0] - 2026-01-01

### Changed
- **Consolidated 30 skills down to 10** - Removed edge-case and redundant skills, merged overlapping ones
- **Claude Code only** - Removed OpenCode and Codex integration (`.opencode/`, `.codex/`, `tests/opencode/`)
- **Removed checkpoint.md files** - Progress now tracked entirely via git commits with `phase(N): complete` trailers

### Removed
- **20 skills removed:**
  - Edge cases: `database-migrations`, `debugging-ci-cd-failures`, `debugging-flaky-tests`, `updating-dependencies`, `resolving-merge-conflicts`, `performance-optimization`, `security-review`, `working-with-legacy-code`, `working-with-monorepos`
  - Redundant: `receiving-code-review`, `receiving-corrections`, `requesting-code-review`, `dispatching-parallel-agents`, `using-git-worktrees`, `writing-documentation`
  - Merged: `writing-plans`, `executing-plans`, `handling-context-exhaustion`, `resuming-work`, `finishing-a-development-branch`

### Merged
- `writing-plans` → `brainstorming` (Step 5: Write Implementation Plan)
- `executing-plans` → `subagent-driven-development` (unified execution)
- `handling-context-exhaustion` + `resuming-work` → `using-harness` (Context Management section)
- `finishing-a-development-branch` → `verification-before-completion` (Finishing Work section)

### Remaining Skills (10)
1. `using-harness` - Foundation + context management
2. `brainstorming` - Design + planning
3. `researching` - Verify current APIs/versions
4. `test-driven-development` - RED-GREEN-REFACTOR
5. `systematic-debugging` - Root cause analysis
6. `verification-before-completion` - Evidence + finishing
7. `backlog-tracking` - Track deferred items
8. `subagent-driven-development` - Execute plans
9. `gamedev-brainstorming` - Game dev variant
10. `writing-skills` - Meta skill

## [0.9.0] - 2026-01-01

### Added
- **Gamedev mode** - New `gamedev-brainstorming` skill for game development projects. Replaces standard brainstorming with game-specific workflow:
  - Game Design Document (GDD) template saved to `.harness/NNN-game-name/gdd.md`
  - Three design approaches: Minimal Viable Game (MVG), Polished Core, Full Scope
  - Game-specific research: reference games, engine capabilities, platform requirements
  - Feel-first development: prioritizes core mechanic feel before features
  - Playtesting gates: built-in checkpoints for validating gameplay
- **GDD template** - Comprehensive Game Design Document structure covering:
  - Overview (high concept, genre, platform, core experience)
  - Gameplay (core loop, mechanics, progression)
  - Game World (setting, visual style, audio direction)
  - Technical (engine, performance targets, challenges)
  - Scope (MVP features, nice-to-have, out of scope)
  - References (games to study, documentation links)
- **Gamedev documentation** - CLAUDE.md updated with Gamedev Mode section and game-specific `.harness/` structure

## [0.8.0] - 2026-01-01

### Changed
- **Plan size limit reduced to 1,000 lines** - Hard gate in `writing-plans` now enforces 1,000 line maximum (down from 3,000). Plans exceeding this limit MUST defer scope to backlog. Multi-part plan splitting is no longer allowed as a workaround.
- **Confidence-based code review** - `code-reviewer` agent now uses 0-100 confidence scoring and only reports issues with confidence ≥80. Reduces review noise and focuses on issues that truly matter.
- **Efficient plan reading** - `subagent-driven-development` now parses plan once at start, extracts phases, and passes only relevant phase content (~300 lines) to each subagent instead of the entire plan. Reduces context cost from O(n²) to O(n).
- **Streamlined prompt templates** - Implementer and spec-reviewer prompts simplified with explicit context budgets (~300 and ~200 lines respectively).

### Added
- **Parallel exploration pattern** - `researching` skill now recommends dispatching 2-3 exploration agents in parallel with different focuses (patterns, dependencies, tests) for medium/large features. Prevents shallow exploration anti-pattern.
- **Multiple architecture options** - `brainstorming` skill now requires presenting exactly 3 architecture options (Minimal, Clean, Pragmatic) with explicit trade-offs before user chooses. Prevents single-path design anti-pattern.
- **Dashboard aggregation** - New `.harness/dashboard.md` system in `backlog-tracking` skill aggregates priority items from backlog (recommended next steps, priority bugs, quick wins, tech debt queue).
- **Session-start dashboard surfacing** - Hook now reads `dashboard.md` and displays top items at session start, making backlog actionable instead of a black hole.

### Fixed
- **Scope explosion anti-pattern** - 1,000 line limit with mandatory backlog deferral prevents plans that exceed context and fail mid-execution.
- **Review noise anti-pattern** - Confidence filtering prevents overwhelming developers with false positives and nitpicks.
- **Backlog black hole anti-pattern** - Dashboard surfacing ensures discovered issues don't disappear into the void.

## [0.7.1] - 2026-01-01

### Fixed
- **brainstorming skill going rogue** - Claude was asking questions about code state instead of researching. Fixed with:
  - Added "First Action (MANDATORY)" section: if requirements are clear, skip to research immediately
  - Added "SKIP THIS STEP" guidance when user has already explained the feature
  - Added table distinguishing bad questions (about code) vs good questions (about user intent)
- **researching skill not exploring immediately** - Claude was asking the user instead of searching the codebase. Fixed with:
  - Added "First Action (MANDATORY)" section: immediately start Glob/Grep/Read, don't ask user anything
  - Added red flags: "Let me ask the user about the code" → "NO. The codebase answers code questions."
- **using-harness skill allowing file reads before skill invocation** - Claude was reading code files before invoking brainstorming. Fixed with:
  - Added explicit red flags: "Let me just read InputHandler.ts" → "NO. Feature request = brainstorming skill FIRST"
  - Added "CRITICAL: Feature Request = Brainstorming First" section with non-negotiable rule

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

[Unreleased]: https://github.com/astrosteveo/harness/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/astrosteveo/harness/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/astrosteveo/harness/compare/v0.7.1...v0.8.0
[0.7.1]: https://github.com/astrosteveo/harness/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/astrosteveo/harness/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/astrosteveo/harness/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/astrosteveo/harness/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/astrosteveo/harness/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/astrosteveo/harness/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/astrosteveo/harness/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/astrosteveo/harness/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/astrosteveo/harness/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/astrosteveo/harness/releases/tag/v0.1.0
