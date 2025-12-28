# Harness - Claude Code Plugin

This is a Claude Code plugin that provides a structured development workflow with research-driven planning, TDD implementation, and verified delivery.

## Project Overview

Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers), enhanced with research capabilities to prevent outdated training data from informing architectural decisions.

**Key Enhancements:**
- The `researching` skill ensures current library versions, API signatures, and best practices are verified via web search
- Structured `.harness/` directory for project documentation
- Backlog tracking for bugs and deferred tasks

## The .harness Directory Structure

All project documentation is organized in `.harness/`:

```
.harness/
├── BACKLOG.md                    # Bugs, deferred tasks, tech debt
├── 001-feature-name/
│   ├── requirements.md           # Initial requirements/user story
│   ├── research.md               # Technology research findings
│   ├── design.md                 # Architecture and design decisions
│   └── plan.md                   # Implementation plan with tasks
├── 002-another-feature/
│   ├── requirements.md
│   ├── research.md
│   ├── design.md
│   └── plan.md
└── ...
```

**Naming Convention:**
- `NNN` - Zero-padded sequence number (001, 002, 003...)
- `feature-name` - Kebab-case slug describing the feature

**Document Types:**
- `requirements.md` - Initial user requirements or story
- `research.md` - Technology research findings (versions, APIs, best practices)
- `design.md` - Architecture decisions and component design
- `plan.md` - Step-by-step implementation plan with TDD tasks

## Repository Structure

```
harness/
├── .claude-plugin/          # Plugin metadata
│   ├── plugin.json          # Plugin name, version, author
│   └── marketplace.json     # Marketplace configuration
├── skills/                  # Core skill definitions
│   ├── brainstorming/       # Socratic design refinement
│   ├── researching/         # Fetch current versions/APIs
│   ├── writing-plans/       # Implementation planning
│   ├── backlog-tracking/    # Bug and task deferral
│   ├── executing-plans/     # Batch execution
│   ├── subagent-driven-development/  # Per-task subagents
│   ├── test-driven-development/      # RED-GREEN-REFACTOR
│   ├── systematic-debugging/         # Root cause analysis
│   ├── using-harness/       # Skills introduction
│   └── ...                  # Other collaboration skills
├── commands/                # CLI commands
├── hooks/                   # Session hooks
├── lib/                     # Shared utilities
├── .codex/                  # Codex integration
├── .opencode/               # OpenCode integration
├── docs/                    # Plugin documentation
└── tests/                   # Test suites
```

## Key Skills

### Core Workflow
- `harness:brainstorming` - Socratic design refinement
- `harness:researching` - Verify current versions/APIs before planning
- `harness:writing-plans` - Create detailed implementation plans
- `harness:executing-plans` - Execute plans with checkpoints
- `harness:backlog-tracking` - Track deferred items

### Development
- `harness:test-driven-development` - RED-GREEN-REFACTOR cycle
- `harness:systematic-debugging` - 4-phase root cause analysis
- `harness:subagent-driven-development` - Per-task agents with review

## Backlog Tracking

The `.harness/BACKLOG.md` file tracks:
- **Bugs** - Discovered issues deferred for later
- **Deferred Features** - Ideas identified but not immediately implemented
- **Technical Debt** - Code improvements for later
- **Improvements** - Nice-to-have enhancements

Each item has a unique ID (e.g., BUG-001, FEAT-002) and references the related feature directory if applicable.

## Development Guidelines

When modifying this plugin:

1. **Skill changes** - Edit the SKILL.md file in the skill's directory
2. **New skills** - Create a new directory under `skills/` with SKILL.md
3. **Test changes** - Run tests in `tests/` directory
4. **Follow TDD** - Use the test-driven-development skill

## Skill File Format

```markdown
---
name: skill-name
description: When to use this skill and what it does
---

# Skill Title

## Overview
What this skill does...

## The Process
Step-by-step instructions...

## Key Principles
- Principle 1
- Principle 2
```

## Integration Points

- **Claude Code** - Native plugin system via .claude-plugin/
- **Codex** - Via .codex/harness-codex script
- **OpenCode** - Via .opencode/plugin/harness.js

## Upstream Sync

This is a fork of obra/superpowers. To sync with upstream:

```bash
git fetch upstream
git merge upstream/main  # or cherry-pick specific commits
git push origin main
```

The upstream remote should point to: `git@github.com:obra/superpowers.git`

## Testing

Tests are in the `tests/` directory:
- `tests/claude-code/` - Claude Code integration tests
- `tests/opencode/` - OpenCode integration tests
- `tests/skill-triggering/` - Skill activation tests

Run from the plugin directory:
```bash
./tests/skill-triggering/run-test.sh <skill-name>
```

## Philosophy

1. **Research First** - Verify current state before recommending
2. **TDD Always** - RED-GREEN-REFACTOR cycle
3. **Evidence Over Claims** - Verify before declaring success
4. **YAGNI** - Don't add what isn't needed
5. **DRY** - Don't repeat yourself
6. **Track Everything** - Use backlog for deferred items
