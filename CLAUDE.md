# Harness - Claude Code Plugin

This is a Claude Code plugin that provides a structured development workflow with research-driven planning, TDD implementation, and verified delivery.

## Project Overview

Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers), enhanced with research capabilities to prevent outdated training data from informing architectural decisions.

**Key Enhancement:** The `researching` skill ensures that before any planning or implementation, current library versions, API signatures, best practices, and design patterns are verified via web search rather than relying on potentially outdated training data.

## Repository Structure

```
harness/
├── .claude-plugin/          # Plugin metadata
│   ├── plugin.json          # Plugin name, version, author
│   └── marketplace.json     # Marketplace configuration
├── skills/                  # Core skill definitions
│   ├── brainstorming/       # Socratic design refinement
│   ├── researching/         # NEW: Fetch current versions/APIs
│   ├── writing-plans/       # Implementation planning
│   ├── executing-plans/     # Batch execution
│   ├── subagent-driven-development/  # Per-task subagents
│   ├── test-driven-development/      # RED-GREEN-REFACTOR
│   ├── systematic-debugging/         # Root cause analysis
│   ├── using-harness/       # Skills introduction
│   └── ...                  # Other collaboration skills
├── commands/                # CLI commands (brainstorm, write-plan, execute-plan)
├── hooks/                   # Session hooks (session-start.sh)
├── lib/                     # Shared utilities (skills-core.js)
├── .codex/                  # Codex integration
├── .opencode/               # OpenCode integration
├── docs/                    # Documentation and example plans
└── tests/                   # Test suites
```

## Key Files

- **skills/\*/SKILL.md** - Skill definitions with YAML frontmatter (name, description)
- **hooks/session-start.sh** - Injects using-harness skill on session start
- **lib/skills-core.js** - Shared functions for skill resolution
- **.claude-plugin/plugin.json** - Plugin metadata

## Skill Naming Convention

Skills are referenced with the `harness:` prefix:
- `harness:brainstorming`
- `harness:researching`
- `harness:writing-plans`
- `harness:executing-plans`

## The Researching Skill

The `researching` skill is invoked automatically by `brainstorming` and `writing-plans` to:

1. Identify external libraries, frameworks, or APIs in the task
2. Use web search to verify current versions and API signatures
3. Research current best practices and design patterns
4. Document findings in the plan with source URLs

**Key principle:** Never assume versions or APIs from training data.

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
