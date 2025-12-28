# Changelog

All notable changes to the harness plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.0.3] - 2025-12-26

### Changed
- Strengthened using-harness skill for explicit skill requests
- Updated "The Rule" to emphasize active invocation over passive checking
- Added reassurance that invoking a wrong skill is okay to reduce hesitation

### Added
- Explicit skill request tests in `tests/explicit-skill-requests/`

### Fixed
- Skill invocation now triggers "BEFORE any response or action"
- Added red flag detection for "I know what that means" rationalization

## [4.0.2] - 2025-12-23

### Changed
- Slash commands now user-only with `disable-model-invocation: true`

## [4.0.1] - 2025-12-23

### Fixed
- Clarified how to access skills in Claude Code (Skill tool vs Read tool)
- Added "How to Access Skills" section to using-harness
- Updated slash commands to use fully qualified skill names

### Added
- GitHub thread reply guidance to receiving-code-review
- Automation-over-documentation guidance to writing-skills

## [4.0.0] - 2025-12-17

### Added
- Two-stage code review in subagent-driven-development (spec compliance + code quality)
- Debugging techniques consolidated with tools in systematic-debugging
- Testing anti-patterns reference in test-driven-development
- Skill test infrastructure with three test frameworks
- DOT flowcharts as executable specifications
- Skill priority in using-harness (process skills before implementation)

### Changed
- Controller provides full task text to workers in subagent workflows
- Workers can ask clarifying questions before AND during work
- Self-review checklist before reporting completion
- Brainstorming trigger strengthened with imperative language

### Breaking Changes
- Skill consolidation: root-cause-tracing, defense-in-depth, condition-based-waiting bundled in systematic-debugging
- testing-skills-with-subagents bundled in writing-skills
- testing-anti-patterns bundled in test-driven-development
- sharing-skills removed (obsolete)

## [3.6.2] - 2025-12-03

### Fixed
- Linux compatibility: Fixed polyglot hook wrapper to use POSIX-compliant syntax

## [3.5.1] - 2025-11-24

### Changed
- OpenCode bootstrap refactor: switched from chat.message hook to session.created event

## [3.5.0] - 2025-11-23

### Added
- OpenCode support with native JavaScript plugin
- Shared core module (lib/skills-core.js) for code reuse with Codex

### Changed
- Refactored Codex implementation to use shared ES module
- Improved documentation with clearer problem/solution explanation

## [3.4.1] - 2025-10-31

### Changed
- Optimized harness bootstrap to eliminate redundant skill execution

## [3.4.0] - 2025-10-30

### Changed
- Simplified brainstorming skill to return to original conversational vision

## [3.3.1] - 2025-10-28

### Changed
- Updated brainstorming skill with autonomous recon before questioning
- Applied writing clarity improvements following Strunk's "Elements of Style"

### Fixed
- Clarified writing-skills guidance to point to correct agent-specific directories

## [3.3.0] - 2025-10-28

### Added
- Experimental Codex support with unified harness-codex script
- Namespaced skills: harness:skill-name format
- Personal skills override capability

## [3.2.3] - 2025-10-23

### Changed
- Updated using-harness to use Skill tool instead of Read tool

## [3.2.2] - 2025-10-21

### Changed
- Strengthened using-harness against agent rationalization
- Added MANDATORY FIRST RESPONSE PROTOCOL checklist
- Added Common Rationalizations section with 8 evasion patterns

## [3.2.1] - 2025-10-20

### Added
- Code reviewer agent included in plugin's agents/ directory

## [3.2.0] - 2025-10-18

### Added
- Design documentation in brainstorming workflow (Phase 4)

### Breaking Changes
- All internal skill references now use harness: namespace prefix

## [3.1.1] - 2025-10-17

### Fixed
- Command syntax in README updated to use namespaced syntax

## [3.1.0] - 2025-10-17

### Breaking Changes
- Skill names standardized to lowercase kebab-case

### Added
- Enhanced brainstorming skill with Quick Reference table
- Anthropic best practices integration in writing-skills

### Fixed
- Re-added missing command redirects (brainstorm.md, write-plan.md)

## [3.0.1] - 2025-10-16

### Changed
- Migrated to Anthropic's first-party skills system

## [2.0.2] - 2025-10-12

### Fixed
- False warning when local skills repo is ahead of upstream

## [2.0.1] - 2025-10-12

### Fixed
- Session-start hook execution in plugin context

## [2.0.0] - 2025-10-12

### Added
- Skills repository separation (moved to astrosteveo/harness-skills)
- Nine new skills: collision-zone-thinking, inversion-exercise, meta-pattern-recognition, scale-game, simplification-cascades, when-stuck, tracing-knowledge-lineages, preserving-productive-tensions
- Automatic clone and setup with initialize-skills.sh
- Auto-update on session start

### Breaking Changes
- Skills no longer live in the plugin (separate repository)
- Personal superpowers overlay system replaced with git branch workflow

### Changed
- Renamed using-skills (formerly getting-started)
- find-skills outputs full paths with /SKILL.md suffix

[Unreleased]: https://github.com/astrosteveo/harness/compare/v4.0.3...HEAD
[4.0.3]: https://github.com/astrosteveo/harness/compare/v4.0.2...v4.0.3
[4.0.2]: https://github.com/astrosteveo/harness/compare/v4.0.1...v4.0.2
[4.0.1]: https://github.com/astrosteveo/harness/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/astrosteveo/harness/compare/v3.6.2...v4.0.0
[3.6.2]: https://github.com/astrosteveo/harness/compare/v3.5.1...v3.6.2
[3.5.1]: https://github.com/astrosteveo/harness/compare/v3.5.0...v3.5.1
[3.5.0]: https://github.com/astrosteveo/harness/compare/v3.4.1...v3.5.0
[3.4.1]: https://github.com/astrosteveo/harness/compare/v3.4.0...v3.4.1
[3.4.0]: https://github.com/astrosteveo/harness/compare/v3.3.1...v3.4.0
[3.3.1]: https://github.com/astrosteveo/harness/compare/v3.3.0...v3.3.1
[3.3.0]: https://github.com/astrosteveo/harness/compare/v3.2.3...v3.3.0
[3.2.3]: https://github.com/astrosteveo/harness/compare/v3.2.2...v3.2.3
[3.2.2]: https://github.com/astrosteveo/harness/compare/v3.2.1...v3.2.2
[3.2.1]: https://github.com/astrosteveo/harness/compare/v3.2.0...v3.2.1
[3.2.0]: https://github.com/astrosteveo/harness/compare/v3.1.1...v3.2.0
[3.1.1]: https://github.com/astrosteveo/harness/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/astrosteveo/harness/compare/v3.0.1...v3.1.0
[3.0.1]: https://github.com/astrosteveo/harness/compare/v2.0.2...v3.0.1
[2.0.2]: https://github.com/astrosteveo/harness/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/astrosteveo/harness/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/astrosteveo/harness/releases/tag/v2.0.0
